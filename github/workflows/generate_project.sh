#!/bin/bash

echo "🔧 Starting Android structure generation..."

# إنشاء المجلدات الأساسية
mkdir -p android/app/src/main/java/com/example/app
mkdir -p android/app/src/main/res

# =========================
# settings.gradle
# =========================
cat > android/settings.gradle <<EOF
include ':app'
EOF

# =========================
# root build.gradle
# =========================
cat > android/build.gradle <<EOF
buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id 'com.android.application' version '8.2.0' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.0' apply false
}
EOF

# =========================
# app build.gradle
# =========================
cat > android/app/build.gradle <<EOF
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace "com.example.app"
    compileSdk 34

    defaultConfig {
        applicationId "com.example.app"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
}
EOF

# =========================
# إنشاء Gradle Wrapper (إذا موجود Gradle)
# =========================
cd android || exit 1

if command -v gradle >/dev/null 2>&1; then
    echo "📦 Generating Gradle wrapper..."
    gradle wrapper
else
    echo "⚠️ Gradle not installed in runner"
fi

cd ..

# =========================
# عرض النتيجة
# =========================
echo "📁 Final structure:"
find android -type f

echo "✅ Android structure generated successfully!"