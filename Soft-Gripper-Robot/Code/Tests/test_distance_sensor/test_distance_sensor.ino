#define DISTANCE_SENSOR A0

void setup() {
  Serial.begin(9600);
}

void loop() {
  float volts = analogRead(DISTANCE_SENSOR)*5/1024;
  int distance = 130*pow(volts,-1);//found from datasheet graph
  delay(1000);
  if(distance<300){
    Serial.println(distance);
  }
}
