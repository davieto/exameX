plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 🔧 Força Gradle/Kotlin/Java a usarem Java 17
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    kotlinOptions {
        jvmTarget = "17"
    }
}

android {
    namespace = "com.example.examex"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.examex"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Signing with the debug key for now so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

//  Copia o APK do caminho real para onde o Flutter espera
tasks.whenTaskAdded {
    if (name == "packageDebug") {
        doLast {
            val fromApk = "$buildDir/outputs/apk/debug/app-debug.apk"
            val toDir = file("$rootDir/../build/app/outputs/flutter-apk")
            toDir.mkdirs()
            copy {
                from(fromApk)
                into(toDir)
            }
        }
    }
}