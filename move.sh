#!/bin/bash

echo "Moving files..."

mv android/app/app/* android/app/

# حذف المجلد الفارغ (اختياري)
rm -rf android/app/app

echo "Done ✅"