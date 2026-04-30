/*
 * SmartGuard - Gas Leak Detector - NodeMCU ESP8266
 * استخدام Firebase Realtime Database
 */

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <ESP8266WebServer.h>

const char* WIFI_SSID     = "YOUR_WIFI_SSID";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret"

#define GAS_SENSOR_PIN A0
#define LED_GREEN     D1
#define LED_YELLOW    D2
#define LED_RED       D3
#define BUZZER        D4

FirebaseData firebaseData;
FirebaseConfig config;
FirebaseAuth auth;
ESP8266WebServer server(80);
int gasValue = 0;
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
void readGasSensor() { gasValue = analogRead(GAS_SENSOR_PIN); }
void sendToFirebase() {
  Firebase.setInt(firebaseData, "/belmelahmed/gasValue", gasValue);
  Firebase.setBool(firebaseData, "/belmelahmed/isConnected", true);
  Firebase.setString(firebaseData, "/belmelahmed/ip_address", WiFi.localIP().toString());
}
void sendHeartbeat() {
  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL) {
    lastHeartbeat = millis();
    Firebase.setInt(firebaseData, "/belmelahmed/lastSeen", lastHeartbeat);
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
  String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'><meta http-equiv='refresh' content='2'><title>Gas Monitor</title>";
  html += "<style>body{font-family:Arial;text-align:center;margin-top:50px;}</style></head><body>";
  html += "<h1>SmartGuard - Gas Detector</h1><h2>Value: <span style='color:";
  if(gasValue<300) html+="green"; else if(gasValue<600) html+="orange"; else html+="red";
  html += "'>" + String(gasValue) + "</span></h2></body></html>";
  server.send(200, "text/html", html);
}
void setup() {
  Serial.begin(115200);
  pinMode(LED_GREEN, OUTPUT); pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT); pinMode(BUZZER, OUTPUT);
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
  readGasSensor();
  updateIndicators(gasValue);
  sendToFirebase();
  sendHeartbeat();
  delay(500);
}
