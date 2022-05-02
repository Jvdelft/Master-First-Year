#define END_Y 1

void setup() {
  Serial.begin(9600);
  pinMode(END_Y, INPUT_PULLUP);
}

void loop() {
  Serial.println(digitalRead(END_Y));
}
