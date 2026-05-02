/*
 * SmartGuard - NodeMCU Multisensor
 * يرسل بيانات الغاز، درجة حرارة الثلاجة/المنزل، مستوى الماء، حالة الكهرباء، كشف الحركة.
 * يعتمد على Firebase Realtime Database.
 */

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <ESP8266WebServer.h>

const char* WIFI_SSID     = "YOUR_WIFI_SSID";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret"

// تعريف الأجهزة (يمكنك تعديل الدبابيس حسب توصيلاتك)
#define GAS_SENSOR_PIN A0
#define LED_GREEN     D1
#define LED_YELLOW    D2
#define LED_RED       D3
#define BUZZER        D4

// افتراض قراءة حرارة الثلاجة عبر DHT11 على D5
#define DHTPIN D5
#define DHTTYPE DHT11

// افتراض مستشعر مستوى الماء تناظري على A1
#define WATER_LEVEL_PIN A1

// افتراض مستشعر الحركة (PIR) على D6
#define PIR_PIN D6

// افتراض قراءة حالة الكهرباء (Relay أو مقسم جهد) على D7
#define POWER_SENSE_PIN D7

FirebaseData firebaseData;
FirebaseConfig config;
FirebaseAuth auth;
ESP8266WebServer server(80);

int gasValue = 0;
float fridgeTemp = 0;
float roomTemp = 0;
int waterLevel = 0;
bool powerAvailable = true;
bool motionDetected = false;
unsigned long lastHeartbeat = 0;
const unsigned long HEARTBEAT_INTERVAL = 5000;

void setNormal() {
  digitalWrite(LED_GREEN, HIGH); digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW); digitalWrite(BUZZER, LOW);
}
void setWarning() {
  digitalWrite(LED_GREEN, LOW); digitalWrite(LED_YELLOW, HIGH);
  digitalWrite(LED_RED, LOW); digitalWrite(BUZZER, LOW);
}
void setDanger() {
  digitalWrite(LED_GREEN, LOW); digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, HIGH); digitalWrite(BUZZER, HIGH);
}
void updateIndicators(int value) {
  if (value < 300) setNormal();
  else if (value < 600) setWarning();
  else setDanger();
}

void readSensors() {
  gasValue = analogRead(GAS_SENSOR_PIN);
  waterLevel = analogRead(WATER_LEVEL_PIN);   // 0-1023
  waterLevel = map(waterLevel, 0, 1023, 0, 100);
  motionDetected = digitalRead(PIR_PIN) == HIGH;
  powerAvailable = digitalRead(POWER_SENSE_PIN) == HIGH;
  // قراءة الحرارة (تحتاج مكتبة DHT)
  // سنضع قيماً وهمية لتجنب تعقيد المكتبات، يمكنك إضافتها لاحقاً
  fridgeTemp = 4.5;
  roomTemp = 22.5;
}

void sendToFirebase() {
  Firebase.setInt(firebaseData, "/belmelahmed/gas/value", gasValue);
  String gasStatus = (gasValue<300)?"normal":((gasValue<600)?"warning":"danger");
  Firebase.setString(firebaseData, "/belmelahmed/gas/status", gasStatus);
  
  Firebase.setFloat(firebaseData, "/belmelahmed/fridge_temp/value", fridgeTemp);
  Firebase.setFloat(firebaseData, "/belmelahmed/room_temp/value", roomTemp);
  Firebase.setInt(firebaseData, "/belmelahmed/water_tank/level", waterLevel);
  Firebase.setBool(firebaseData, "/belmelahmed/power/available", powerAvailable);
  Firebase.setInt(firebaseData, "/belmelahmed/power/voltage", powerAvailable?220:0);
  Firebase.setBool(firebaseData, "/belmelahmed/motion/detected", motionDetected);
  if(motionDetected) Firebase.setLong(firebaseData, "/belmelahmed/motion/last_trigger", millis());
  
  Firebase.setBool(firebaseData, "/belmelahmed/isConnected", true);
  Firebase.setString(firebaseData, "/belmelahmed/ip_address", WiFi.localIP().toString());
}

void sendHeartbeat() {
  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL) {
    lastHeartbeat = millis();
    Firebase.setLong(firebaseData, "/belmelahmed/lastSeen", lastHeartbeat);
  }
}

void fetchPublicIP() {
  WiFiClient client;
  if (client.connect("api.ipify.org", 80)) {
    client.println("GET / HTTP/1.1"); client.println("Host: api.ipify.org");
    client.println("Connection: close"); client.println();
    delay(500);
    while (client.available()) { if (client.readStringUntil('\n') == "\r") break; }
    String ip = client.readStringUntil('\n'); ip.trim();
    if (ip.length()) Firebase.setString(firebaseData, "/belmelahmed/ip_address_public", ip);
    client.stop();
  }
}

void handleWeb() {
  String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>SmartGuard</title></head><body>";
  html += "<h1>Gas: "+String(gasValue)+"</h1>";
  html += "<p>Fridge: "+String(fridgeTemp)+"°C</p>";
  html += "<p>Room: "+String(roomTemp)+"°C</p>";
  html += "<p>Water: "+String(waterLevel)+"%</p>";
  html += "<p>Power: "+(powerAvailable?"ON":"OFF")+"</p>";
  html += "<p>Motion: "+(motionDetected?"YES":"NO")+"</p>";
  html += "</body></html>";
  server.send(200, "text/html", html);
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_GREEN, OUTPUT); pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT); pinMode(BUZZER, OUTPUT);
  pinMode(PIR_PIN, INPUT);
  pinMode(POWER_SENSE_PIN, INPUT);
  setNormal();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);
  config.database_url = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  fetchPublicIP();
  server.on("/", handleWeb);
  server.begin();
}

void loop() {
  server.handleClient();
  readSensors();
  updateIndicators(gasValue);
  sendToFirebase();
  sendHeartbeat();
  delay(500);
}
