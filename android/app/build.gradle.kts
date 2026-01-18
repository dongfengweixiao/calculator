import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.github.dongfengweixiao.calculator"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "io.github.dongfengweixiao.calculator"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    sourceSets {
        named("main") {
            jniLibs.srcDir("src/jniLibs")
        }
    }
}

flutter {
    source = "../.."
}

// Task: Automatically copy libc++_shared.so from the NDK directory.
tasks.register("copyNdkLibs") {
    val jniLibsDir = file("src/main/jniLibs")

    doFirst {
        // Clean up the previously copied files first
        val abis = listOf("armeabi-v7a", "arm64-v8a", "riscv64", "x86", "x86_64")
        abis.forEach { abi ->
            val libcxx = file("${jniLibsDir}/${abi}/libc++_shared.so")
            if (libcxx.exists()) {
                libcxx.delete()
                val abiDir = file("${jniLibsDir}/${abi}")
                if (abiDir.listFiles()?.isEmpty() == true) {
                    abiDir.delete()
                }
            }
        }
        if (jniLibsDir.listFiles()?.isEmpty() == true) {
            jniLibsDir.delete()
        }

        // ABI name to NDK directory name mapping
        val abiToLibDir = mapOf(
            "armeabi-v7a" to "arm-linux-androideabi",
            "arm64-v8a" to "aarch64-linux-android",
            "x86" to "i686-linux-android",
            "x86_64" to "x86_64-linux-android",
            "riscv64" to "riscv64-linux-android"
        )

        // Get the NDK directory: prioritize environment variables, then ANDROID_NDK_HOME, and finally local.properties
        val ndkDir: String? = System.getenv("ANDROID_NDK_HOME")
            ?: System.getenv("NDK_HOME")
            ?: run {
                val propsFile = rootProject.file("local.properties")
                println("Looking for local.properties at: ${propsFile.absolutePath}, exists: ${propsFile.exists()}")
                if (propsFile.exists()) {
                    val properties = Properties()
                    propsFile.inputStream().use { properties.load(it) }
                    val ndkPath = properties.getProperty("ndk.dir")
                    println("Found ndk.dir in local.properties: ${ndkPath}")
                    ndkPath
                } else null
            }

        if (ndkDir == null || !file(ndkDir).exists()) {
            println("Warning: NDK directory not found. Please set ANDROID_NDK_HOME environment variable or configure ndk.dir in local.properties")
            return@doFirst
        }

        val ndkDirFile = file(ndkDir)
        println("Using NDK: ${ndkDirFile.absolutePath}")

        // Find the correct toolchain path
        val toolchainDir = file("${ndkDirFile}/toolchains/llvm/prebuilt")
            .listFiles()?.firstOrNull {
                it.name.contains("linux") || it.name.contains("darwin") || it.name.contains("windows")
            }

        if (toolchainDir == null) {
            println("Warning: Cannot find NDK toolchain directory")
            return@doFirst
        }

        abis.forEach { abi ->
            val libDir = abiToLibDir[abi] ?: abi
            val sourceDir = file("${toolchainDir}/sysroot/usr/lib/${libDir}")
            val targetDir = file("${jniLibsDir}/${abi}")

            val libcxx = file("${sourceDir}/libc++_shared.so")
            if (libcxx.exists()) {
                targetDir.mkdirs()
                copy {
                    from(libcxx)
                    into(targetDir)
                    println("Copied libc++_shared.so for $abi")
                }
            } else {
                println("Warning: libc++_shared.so not found for $abi at ${libcxx.absolutePath}")
            }
        }
    }
}

// Task: Clean up copied NDK library files
tasks.register("cleanCopiedNdkLibs") {
    val jniLibsDir = file("src/main/jniLibs")

    doLast {
        if (jniLibsDir.exists()) {
            val abis = listOf("armeabi-v7a", "arm64-v8a", "riscv64", "x86", "x86_64")
            var deletedCount = 0

            abis.forEach { abi ->
                val libcxx = file("${jniLibsDir}/${abi}/libc++_shared.so")
                if (libcxx.exists()) {
                    libcxx.delete()
                    println("Deleted: ${libcxx.absolutePath}")
                    deletedCount++

                    // If the directory is empty, delete it.
                    val abiDir = file("${jniLibsDir}/${abi}")
                    if (abiDir.listFiles()?.isEmpty() == true) {
                        abiDir.delete()
                        println("Deleted empty directory: ${abiDir.absolutePath}")
                    }
                }
            }

            // If the jniLibs directory is empty, remove it.
            if (jniLibsDir.listFiles()?.isEmpty() == true) {
                jniLibsDir.delete()
                println("Deleted empty jniLibs directory: ${jniLibsDir.absolutePath}")
            }

            if (deletedCount > 0) {
                println("Cleaned $deletedCount copied NDK library file(s)")
            }
        }
    }
}

// Make sure the clean task also removes the duplicated NDK libraries.
tasks.named("clean") {
    dependsOn("cleanCopiedNdkLibs")
}

// Ensure that it is executed before the pre-build task
tasks.named("preBuild") {
    dependsOn("copyNdkLibs")
}
