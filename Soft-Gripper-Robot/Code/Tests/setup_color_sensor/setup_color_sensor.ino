// code to calibrate the color sensor, use value obtained in color sensor code
//get redMin, greenMin and blueMin by sensing white object and taking lowest for each PW
//get redMax, greenMax and blueMax by sensing black object and taking highest for each PW

#define COLOR_S0 6
#define COLOR_S1 5
#define COLOR_OUT 4
#define COLOR_S2 3
#define COLOR_S3 2

int redPW = 0;
int greenPW = 0;
int bluePW = 0;

void setup() {
  pinMode(COLOR_S0, OUTPUT);
  pinMode(COLOR_S1, OUTPUT);
  pinMode(COLOR_S2, OUTPUT);
  pinMode(COLOR_S3, OUTPUT);
  pinMode(COLOR_OUT, INPUT);
  
  // Set Pulse Width scaling to 20%
  digitalWrite(COLOR_S0,HIGH);
  digitalWrite(COLOR_S1,LOW);
  
  Serial.begin(9600);
  
}

void loop() {
  // Read Red Pulse Width
  redPW = getRedPW();
  // Delay to stabilize sensor
  delay(200);
  
  // Read Green Pulse Width
  greenPW = getGreenPW();
  // Delay to stabilize sensor
  delay(200);
  
  // Read Blue Pulse Width
  bluePW = getBluePW();
  // Delay to stabilize sensor
  delay(200);
  
  Serial.print("Red PW = ");
  Serial.print(redPW);
  Serial.print(" - Green PW = ");
  Serial.print(greenPW);
  Serial.print(" - Blue PW = ");
  Serial.println(bluePW);
}

// Function to read Red Pulse Widths
int getRedPW() {
 
  // Set sensor to read Red only
  digitalWrite(COLOR_S2,LOW);
  digitalWrite(COLOR_S3,LOW);
  
  int PW;
  // Read the output Pulse Width
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
 
}
 
// Function to read Green Pulse Widths
int getGreenPW() {
 
  // Set sensor to read Green only
  digitalWrite(COLOR_S2,HIGH);
  digitalWrite(COLOR_S3,HIGH);
  
  int PW;
  // Read the output Pulse Width
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
 
}
 
// Function to read Blue Pulse Widths
int getBluePW() {
 
  // Set sensor to read Blue only
  digitalWrite(COLOR_S2,LOW);
  digitalWrite(COLOR_S3,HIGH);
  
  int PW;
  // Read the output Pulse Width
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
 
}
