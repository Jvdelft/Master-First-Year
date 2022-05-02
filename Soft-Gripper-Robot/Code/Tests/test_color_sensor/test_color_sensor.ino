#define COLOR_S0 6
#define COLOR_S1 5
#define COLOR_OUT 4
#define COLOR_S2 3
#define COLOR_S3 2

//get these from setp_color_sensor
int redMin = 0; 
int redMax = 0; 
int greenMin = 0; 
int greenMax = 0; 
int blueMin = 0; 
int blueMax = 0; 

int redPW = 0;
int greenPW = 0;
int bluePW = 0;

int redValue;
int greenValue;
int blueValue;

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
  //255 because RGB is up to 255 and inverse because pulse width 
  redValue = map(redPW, redMin,redMax,255,0);
  // Delay to stabilize sensor
  delay(200);
  
  // Read Green Pulse Width
  greenPW = getGreenPW();
  //255 because RGB is up to 255 and inverse because pulse width 
  greenValue = map(greenPW, greenMin,greenMax,255,0);
  // Delay to stabilize sensor
  delay(200);
  
  // Read Blue Pulse Width
  bluePW = getBluePW();
  //255 because RGB is up to 255 and inverse because pulse width 
  blueValue = map(bluePW, blueMin,blueMax,255,0);
  // Delay to stabilize sensor
  delay(200);
  
  Serial.print("Red = ");
  Serial.print(redValue);
  Serial.print(" - Green = ");
  Serial.print(greenValue);
  Serial.print(" - Blue = ");
  Serial.println(blueValue);
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
