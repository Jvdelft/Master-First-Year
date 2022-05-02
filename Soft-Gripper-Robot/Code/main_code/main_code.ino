#include <Servo.h>

#define START_BUTTON 13
#define Y_STEP 12
#define Y_DIR  11
#define Z_STEP 10
#define Z_DIR 9
#define COLOR_S0 8
#define COLOR_S1 7
#define GRIPPER 6
#define COLOR_LED 5
#define COLOR_OUT 4
#define COLOR_S3 3
#define COLOR_S2 2
#define END_Y A5
#define END_Z A4
#define FRUIT_CHOICE A1
#define DISTANCE_SENSOR A0
#define Y_ENABLE A2

int step = 5;

int fruitSelected;
float fruit1Max = 340; //adjust if needed
float fruit2Max = 680; //adjust if needed

float objectStart;
float objectEnd;
bool objectFound = 0;
float groundDistance;
float distanceError = 10; //Find maximum error when detecting table in mm

float yPos;
float yMax = 2300; //Change to real max in steps or convert stepToPos and put mm here
float yGoal;
float stepToPosY = 1; //Maybe change to the distance in mm per step (if change put yPos in float) change it if sensor not centered anymore
float sensorOffset = 200; //offset of the distance sensor in steps
float scanOffset = 650;
float colorReadPos = 80; // pos to go to read color

float zPos;
int zGoal = 1000;
float stepToPosZ = 0.01; //2mm per revolution and 200 step per revolution (check if true)
float zSafeDistance = 80; //Find distance in mm that is good for grabbing
float dropDistance = 90; //Distance from the ground to drop the fruit from
int zObjectTransport = 5; //Find height in mm that is good for transport

Servo gripper; 
float gripperAngleClosed = 105; //find angle when closed
float gripperAngleOpen = 55; //find angle when open

int objectRed;
int objectGreen;
int objectBlue;
int objectRGB[3] = {0,0,0};
int redMin = 40; 
int redMax = 1299; 
int greenMin = 48; 
int greenMax = 1009; 
int blueMin = 35; 
int blueMax = 1009; 
int redPW = 0;
int greenPW = 0;
int bluePW = 0;
int colorError = 20;

int fruitColors[3][3] = { // 2-dim array with 3 fruit choice and with 3 limit value for RGB(0-255)
  {246 , 250 , 231}, // RGB limit value fruit 1 (Apple limit)
  {143, 74, 102}, // RGB limit value fruit 2 (Peach limit)
  {234, 191, 212}, // RGB limit value fruit 3 (Strawberry limit)
};

int yBins[2] = { (colorReadPos+100) , (yMax-colorReadPos)}; //pos right bin, pos left bin in steps 
bool bin = 1; //0 = right Bin, 1 = left Bin




void setup() {
  Serial.begin(9600);
  pinMode(Y_STEP, OUTPUT);
  pinMode(Y_DIR, OUTPUT);
  pinMode(Z_STEP, OUTPUT);
  pinMode(Z_DIR, OUTPUT);
  pinMode(COLOR_S0, OUTPUT);
  pinMode(COLOR_S1, OUTPUT);
  pinMode(COLOR_LED,OUTPUT);
  pinMode(COLOR_S2, OUTPUT);
  pinMode(COLOR_S3, OUTPUT);
  pinMode(Y_ENABLE, OUTPUT);
  
  pinMode(START_BUTTON, INPUT_PULLUP);
  pinMode(COLOR_OUT, INPUT);
  pinMode(END_Y, INPUT_PULLUP);
  pinMode(END_Z, INPUT_PULLUP);
  pinMode(DISTANCE_SENSOR, INPUT);
  pinMode(FRUIT_CHOICE, INPUT);
  
  // Set Pulse Width scaling to 20%
  digitalWrite(COLOR_S0,HIGH);
  digitalWrite(COLOR_S1,LOW);

  gripper.attach(GRIPPER);
  digitalWrite(Y_ENABLE,HIGH);
}

void loop() {
  if(step ==5){
    if(!digitalRead(START_BUTTON)){
      step = 0;
    }
  }
  if(step==0){
    
    Serial.println("Reseting");
    reset();
    Serial.println("Reseted");
    Serial.print("Fruit Selected : ");
    Serial.println(fruitSelected);
    step = 1;
  }
  
  //STEP 1 : Detection by scanning with Y + distance sensor
  if(step==1){
    grab(0);
    detecting();
    
  }
  //STEP 2 : Grabbing with Z + valve
  if(step==2){
    goToObjectY();
    grab(0);
    goToObjectZ();
    grab(1);
    step = 3;
  }
  
  //STEP 3 : Color detection with color sensor
  if(step==3){
    liftObject(1);
    gotoSensor();
    detectColor();
    sorting();
    step = 4;
  }
  
  //STEP 4 : Sorting with Y
  if(step==4){
    goToBin();
    liftObject(0);
    grab(0);
    reset();
    step = 5;
  }
  if(step == 6){
    transportMode();
    step = 5;
  }
  
}




void reset(){
  //Turns backwards until buttons are touched 
  grab(0);
  while(digitalRead(END_Z)){
    moveZ(1);
  }
  zPos = 0;
  digitalWrite(Y_ENABLE,LOW);
  while(digitalRead(END_Y)){
    moveY(0);
  }
  yPos =0;
  digitalWrite(Y_ENABLE,HIGH);
  objectStart = 0;
  objectEnd = 0;
  groundDistance = 0;
  objectRed = 0;
  objectBlue = 0;
  objectGreen = 0;
  objectFound = 0;
  bin = 1;
  digitalWrite(COLOR_LED,LOW);
  if(analogRead(FRUIT_CHOICE) < fruit1Max){
    fruitSelected = 0;
  }
  else if(analogRead(FRUIT_CHOICE) > fruit1Max && analogRead(FRUIT_CHOICE) < fruit2Max){
    fruitSelected = 1;
  }
  else{
    fruitSelected = 2;
  }
}

void detecting(){
  digitalWrite(Y_ENABLE,LOW);
  while(objectEnd == 0 && yPos < yMax){
    moveY(1);
    if(yPos > scanOffset){
      float tot  = 0;
      for( int x = 0; x<=9; x+=1){
        int instantDistance = detectDist();
        tot +=instantDistance;
        moveY(1);
      }
      tot = tot/10;
      if(yPos == (scanOffset + 11)){
        groundDistance = detectDist();
        Serial.print("Ground Distance : ");
        Serial.println(groundDistance);
        }
    /*Serial.print(yPos);
    Serial.print(" : ");
    Serial.println(tot);*/
    if(tot < (groundDistance - distanceError) && !objectFound){
      objectStart = (yPos - sensorOffset);
      objectFound = 1;
    }
    if(objectFound){
      if(tot < zGoal){
        zGoal = tot;
      }
    }
    if(tot> (groundDistance - distanceError) && objectFound){
      objectEnd = (yPos - sensorOffset);
      Serial.print("Object height is : ");
      Serial.println((groundDistance-zGoal));
      break;
    }
    }
   
  }
  digitalWrite(Y_ENABLE,HIGH);
  if(objectEnd == 0 || !objectFound){
    for(int x = 0; x<100;x+=1){
      moveY(0);
    }
    Serial.println("No object found");
    step = 6;
  }
  else{
    step = 2;
  }
}

void goToObjectY(){
  digitalWrite(Y_ENABLE,LOW);
  yGoal = (objectEnd + objectStart)/2;
  //Serial.println(yGoal);
  bool direction = 0;
  if(yPos < yGoal){
    direction = 1; //shouldn't happen but just in case)
  }
  while(abs(yPos-yGoal)>1){
    moveY(direction);
  }
  digitalWrite(Y_ENABLE,HIGH);
}

void goToObjectZ(){
  while(zPos<(groundDistance - zSafeDistance)){
    moveZ(0);
    /*Serial.print(zPos);
    Serial.print(" : ");
    Serial.println(zGoal);*/
  }
}

void moveY(bool direction){ // 1 = forwards, 0 = backwards (adjust delays for less speed)
  digitalWrite(Y_DIR,direction);
  digitalWrite(Y_STEP, HIGH);
  delayMicroseconds(1000);
  digitalWrite(Y_STEP, LOW);
  delayMicroseconds(1000);
  if(direction){
    yPos += stepToPosY;
  }
  else{
    yPos-=stepToPosY;
  }
  //Serial.println(yPos);
  
}

void moveZ(bool direction){ // 1 = up, 0 = down (adjust delays for less speed)
  digitalWrite(Z_DIR,direction);
  digitalWrite(Z_STEP, HIGH);
  delayMicroseconds(2000);      
  digitalWrite(Z_STEP, LOW);
  delayMicroseconds(2000);
  if(direction){
    zPos -= stepToPosZ;
  }
  else{
    zPos +=stepToPosZ;
  }
}

int detectDist(){
  int analogdata = analogRead(DISTANCE_SENSOR);
  float volts = analogdata*0.0048828125;
  return 230*pow(volts,-1);//found from datasheet graph
}

void grab(bool grabbing){ //grabbing = 1 = close gripper, grabbing = 0 = open gripper
  if(grabbing){
    gripper.write(gripperAngleClosed);
  }
  else{
    gripper.write(gripperAngleOpen);
  }
}

void liftObject(bool direction){
  while(zPos>zObjectTransport && direction){
    moveZ(direction);
  }
  while(zPos<(groundDistance - dropDistance) && !direction){
    moveZ(direction);
  }
}

void gotoSensor(){
  int direction = ((yPos - colorReadPos) < 0);
  digitalWrite(Y_ENABLE,LOW);
  while(abs(yPos - colorReadPos) > 1){
    moveY(direction);
  }
  yPos = 0;
  digitalWrite(Y_ENABLE,HIGH);
}

void detectColor(){

  digitalWrite(COLOR_LED,HIGH);
  // Read Red Pulse Width
  redPW = getRedPW();
  //255 because RGB is up to 255 and inverse because pulse width 
  objectRed = map(redPW, redMin,redMax,255,0);
  objectRGB[0] = objectRed;
  // Delay to stabilize sensor
  delay(200);
  
  // Read Green Pulse Width
  greenPW = getGreenPW();
  //255 because RGB is up to 255 and inverse because pulse width 
  objectGreen = map(greenPW, greenMin,greenMax,255,0);
  objectRGB[1] = objectGreen;
  // Delay to stabilize sensor
  delay(200);
  
  // Read Blue Pulse Width
  bluePW = getBluePW();
  //255 because RGB is up to 255 and inverse because pulse width 
  objectBlue = map(bluePW, blueMin,blueMax,255,0);
  objectRGB[2] = objectBlue;
  // Delay to stabilize sensor
  delay(200);
  digitalWrite(COLOR_LED,LOW);

  Serial.print("R : ");
  Serial.print(objectRGB[0]);
  Serial.print(",G : ");
  Serial.print(objectRGB[1]);
  Serial.print(",B : ");
  Serial.println(objectRGB[2]);
}

int getRedPW() {
  // Set sensor to read Red only
  digitalWrite(COLOR_S2,LOW);
  digitalWrite(COLOR_S3,LOW);
  int PW;
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
}
int getGreenPW() {
  // Set sensor to read Green only
  digitalWrite(COLOR_S2,HIGH);
  digitalWrite(COLOR_S3,HIGH);
  int PW;
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
}
int getBluePW() {
  // Set sensor to read Blue only
  digitalWrite(COLOR_S2,LOW);
  digitalWrite(COLOR_S3,HIGH);
  int PW;
  PW = pulseIn(COLOR_OUT, LOW);
  return PW;
}

void sorting(){
  bool red =0;
  bool green = 0;
  bool blue=0;
  //check red
  Serial.print("R : ");
  Serial.print(objectRGB[0]);
  Serial.print(", Goal : ");
  Serial.println(fruitColors[fruitSelected][0]);
  if((objectRGB[0] > (fruitColors[fruitSelected][0]-colorError)) && (objectRGB[0] < (fruitColors[fruitSelected][0]+colorError))){
    red = 1;
  }
  //check green
  Serial.print("G : ");
  Serial.print(objectRGB[1]);
  Serial.print(", Goal : ");
  Serial.println(fruitColors[fruitSelected][1]);
  if((objectRGB[1] > (fruitColors[fruitSelected][1]-colorError)) && (objectRGB[1] < (fruitColors[fruitSelected][1]+colorError))){
    green = 1;
  }
  //check blue
  
  Serial.print("B : ");
  Serial.print(objectRGB[2]);
  Serial.print(", Goal : ");
  Serial.println(fruitColors[fruitSelected][2]);
  if((objectRGB[2] > (fruitColors[fruitSelected][2]-colorError)) && (objectRGB[2] < (fruitColors[fruitSelected][2]+colorError))){
    blue = 1;
  }
  if(red && green && blue){
    Serial.println("right color");
    bin = 0;
  }
}

void goToBin(){
  //Serial.println("going to bin");
  digitalWrite(Y_ENABLE,LOW);
  while(abs(yPos-yBins[bin])>1){
    moveY(1);
  }
  digitalWrite(Y_ENABLE,HIGH);
}

void transportMode(){
  digitalWrite(Y_ENABLE,LOW);
  while(abs(yPos-yMax)>1){
    moveY(1);
  }
  digitalWrite(Y_ENABLE,HIGH);
  int distance = detectDist();
  while(zPos<(distance - dropDistance)){
    moveZ(0);
  }
}
