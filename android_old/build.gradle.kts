plugins {
    id("com.android_old.application")
    id("kotlin-android_old")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fooddelivery"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.fooddelivery"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    ndkVersion = "27.0.12077973"
}

flutter {
    source = "../.."
}
