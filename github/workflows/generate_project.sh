#!/bin/bash

echo "📦 Moving app folder into android structure..."

# إنشاء مجلد android إذا غير موجود
mkdir -p android

# نقل app إلى android/app
if [ -d "app" ]; then
  mv app android/app
  echo "✅ app moved to android/app"
else
  echo "❌ app folder not found in root"
  exit 1
fi

# إنشاء الملفات الأساسية إذا غير موجودة

cat > android/settings.gradle <<EOF
include ':app'
EOF

cat > android/build.gradle <<EOF
plugins {
    id 'com.android.application' version '8.2.0' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.0' apply false
}
EOF

echo "📁 Final structure:"
ls -R android

echo "✅ Done"