#define Y_STEP 12
#define Y_DIR  11
#define DISTANCE 3200
int StepCounter = 0;
int Reverse = 1;

void setup() {
  Serial.begin(9600);
  pinMode(Y_STEP, OUTPUT);
  pinMode(Y_DIR, OUTPUT);
  digitalWrite(Y_STEP, LOW);
  digitalWrite(Y_DIR, LOW);
}

void loop() {
  digitalWrite(Y_STEP, HIGH);
  delay(1);         
  digitalWrite(Y_STEP, LOW);
  delay(1);     
  StepCounter+=1;
  if(StepCounter == DISTANCE){
    StepCounter = 0;
    if(Reverse){
      digitalWrite(Y_DIR,HIGH);
      Reverse = 0;
    }
    else{
      digitalWrite(Y_DIR,LOW);
      Reverse = 1;
      }
  }
}
