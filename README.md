# 🏠 SmartGuard – حارس المنزل الذكي  
### نظام إنذار تسرب الغاز بتقنية إنترنت الأشياء (IoT)  

[![Build Android APK](https://github.com/yourusername/smartguard-android/actions/workflows/build.yml/badge.svg)](https://github.com/yourusername/smartguard-android/actions/workflows/build.yml)

---

## 📖 عن المشروع (About)

**SmartGuard** هو حل متكامل لمراقبة تسرب الغاز في المنازل والمكاتب. يتكون من:
- **وحدة استشعار** تعتمد على NodeMCU (ESP8266) وحساس MQ-x.
- **تطبيق Android** حديث (بدون WebView) يعرض القراءات لحظياً عبر Firebase.
- **إشعارات فورية** (محلية وسحابية FCM) عند تجاوز الحدود الآمنة.
- **دعم 12 لغة** (العربية، الإنجليزية، الفرنسية، الألمانية، اليابانية، الصينية، الإيطالية، البرتغالية، الهندية، الإسبانية، الفارسية، الكورية).
- **أتمتة كاملة** باستخدام GitHub Actions لبناء التطبيق ونشر APKs تلقائياً.

---

## 🧠 الميزات الرئيسية (Features)

✅ قراءة قيمة الغاز من حساس MQ-2 / MQ-5.  
✅ رفع البيانات إلى **Firebase Realtime Database** كل ثانيتين.  
✅ مؤشرات ضوئية (LED أخضر/أصفر/أحمر) وجرس إنذار حسب مستوى الخطر:  
- **طبيعي** (<300) → LED أخضر  
- **تحذير** (300-600) → LED أصفر  
- **خطر** (>600) → LED أحمر + جرس  

✅ تطبيق Android بمعمارية **MVVM** + **Coroutines** + **Flow**.  
✅ إشعارات محلية فورية عند تغيير الحالة.  
✅ إشعارات عبر **FCM** تعمل حتى لو كان التطبيق مغلقاً.  
✅ تغيير اللغة ديناميكياً دون إعادة تشغيل النشاط (12 لغة).  
✅ واجهة Material Design مع بطاقات (CardView) ووضع ليلي.  
✅ صفحة ويب بسيطة مدمجة داخل NodeMCU لعرض القيمة عبر المتصفح.  
✅ تخزين عنوان IP العام والخاص في قاعدة البيانات.  
✅ **GitHub Actions** لبناء APK تلقائياً عند كل push أو يدوياً.

---

## 🧱 المكونات المطلوبة (Hardware Requirements)

| القطعة | الكمية |
|--------|--------|
| NodeMCU ESP8266 | 1 |
| حساس غاز MQ-2 أو MQ-5 | 1 |
| مقاومة 10kΩ (إذا كان الحساس بنوع المقارن LM393 لا تحتاج) | حسب الحاجة |
| LED أخضر، أصفر، أحمر | 1 لكل لون |
| جرس إنذار (Buzzer) 5V | 1 |
| مقاومات 220Ω (للمصابيح) | 3 |
| لوحة تجارب (Breadboard) وأسلاك | 1 |

**توصيل الدائرة:**
- دبوس A0 → حساس الغاز
- D1 → LED أخضر (طرف طويل عبر مقاومة 220Ω إلى GND)
- D2 → LED أصفر
- D3 → LED أحمر
- D4 → جرس إنذار (طرف موجب، السالب إلى GND)

---

## 🔧 إعداد البرمجيات (Software Setup)

### 1. Firebase
- أنشئ مشروعاً على [Firebase Console](https://console.firebase.google.com/).
- فعّل **Realtime Database** و **Cloud Messaging**.
- أضف تطبيق Android باسم الحزمة `com.devbelmel.smartguard`.
- حمّل ملف `google-services.json` وضعه في مجلد `app/` (يمكنك رفعه عبر GitHub Actions باستخدام Secrets).

### 2. NodeMCU
- ثبّت Arduino IDE وأضف لوحة ESP8266.
- ثبّت المكتبات:
  - `FirebaseESP8266` by Mobizt
  - `ArduinoJson`
- عدّل بيانات WiFi و Firebase في الكود الموجود في مجلد `nodemcu/`.
- ارفع الكود إلى اللوحة.

### 3. تطبيق Android
- استنسخ المستودع:
  ```bash
  git clone https://github.com/yourusername/smartguard-android.git
