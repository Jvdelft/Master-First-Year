#include <Adafruit_FONA.h>
#define SIM7600
#define FONA_PWRKEY 12                              //Pins for the serial communication and the power.
#define FONA_RST 20
#define FONA_TX 7
#define FONA_RX 8
                                                    //Declaring all the variables and the servers.
#define MQTT_SERVER      "tcp://78.129.106.132"
#define MQTT_SERVERPORT  1883
#define MQTT_USERNAME    "jvdelft"
#define MQTT_KEY         "test"
#define MQTT_TOPICSTATE  "State"
#define MQTT_TOPICSUB    "switch"
#define MQTT_TOPICSUB2   "Led"
char* Subtopics[2] = {MQTT_TOPICSUB, MQTT_TOPICSUB2};     
#define FTP_SERVER      "195.144.107.198"
#define FTP_USERNAME    "demo"
#define FTP_PASSWORD    "password"
#define FTP_PORT        21

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))      //Function to get the number of elements in an array.

int LED1 = 11;
int LED2 = 10;                                          //All the leds for testing
int LED3 = 9;
int LED4 = 6;
int LED5 = 5;
int LED6 = 4;
int LED7 = 3;
int LED8 = 2;

int Leds[8] = {LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8}; 

char replybuffer[50];                   //Char array to store the received messages
char Switch;
#include <SoftwareSerial.h>
SoftwareSerial fonaSS = SoftwareSerial(FONA_TX, FONA_RX);                         //Initating the serial communication between the Arduino
SoftwareSerial *fonaSerial = &fonaSS;                                             //and the 4G shield.
Adafruit_FONA_LTE fona = Adafruit_FONA_LTE();

char prevMessage[10] = "          ";            //Char array to store the last message received by Matlab.

/*
typedef union{                            
  float number;
  uint8_t bytes[4];
} FLOATUNION_t;

FLOATUNION_t myValue1;
FLOATUNION_t myValue2;
FLOATUNION_t myValue3;                        //Functions to transfer numbers with Matlab.

float getFloat(){
  int cont = 0;
  FLOATUNION_t f;
  while(cont < 4){
    f.bytes[cont] = Serial.read();
    cont++;
  }
  return f.number;
}*/

void setup() {
  Serial.begin(57600);
  pinMode(FONA_PWRKEY, OUTPUT);           //Starting everything, turning on the shield.
  pinMode(13, OUTPUT);
  for(int i = 0; i<sizeof(Leds); i++){
    pinMode(Leds[i], OUTPUT);
  }
  fona.powerOn(FONA_PWRKEY);              
  fonaSS.begin(115200);
  fonaSS.println("AT+IPR=57600");           //Testing the communication by switching from the
  delay(300);                               //default baudrate to 57600.
  fonaSS.begin(57600);
  fonaSS.println("AT+CPIN=0000");           //Unlocking the sim card with the pin code.
  if(!fona.begin(fonaSS)){
    Serial.println(F("Could not find FONA"));         //Starting the shield
    while (1);
  }
  Serial.println(F("FONA is OK"));
  fona.setFunctionality(1);
  fona.setNetworkSettings(F("internet.proximus.be"));       //Set the APN for proximus network
  while (!netStatus()){
    Serial.println(F("Failed to connect to cell network, retrying..."));    //Connecting to the network.
    delay(2000);
    }
    // read the RSSI
  uint8_t n = fona.getRSSI();
  int8_t r;

  Serial.print(F("RSSI = ")); Serial.print(n); Serial.print(": ");          //Checking the strength of the network.
  if (n == 0) r = -115;
  if (n == 1) r = -111;
  if (n == 31) r = -52;
  if ((n >= 2) && (n <= 30)) {
    r = map(n, 2, 30, -110, -54);
  }
  Serial.print(r); Serial.println(F(" dBm"));
  fonaSS.println(F("AT+CGSOCKCONT=1,\"IP\",\"internet.proximus.be\""));           //Enabling the data transfer
  delay(250);
  fonaSS.println("AT+NETOPEN");
  MQTTStart(MQTT_USERNAME,MQTT_SERVER, MQTT_USERNAME, MQTT_KEY);              //Starting of the MQTT connection and connecting to the server
  delay(1000);                                     
  while(!MQTTSub()){delay(500);}                                              //Subscribing to all needed topics
 
}

void loop() {
  MQTTReceived();                                   //Checking if we received anything from Matlab or from the MQTT server.
  SerialReceived();
}



bool netStatus() {
  int n = fona.getNetworkStatus();
  
  Serial.print(F("Network status ")); Serial.print(n); Serial.print(F(": "));               //Getting the strength of the network.
  if (n == 0) Serial.println(F("Not registered"));
  if (n == 1) Serial.println(F("Registered (home)"));
  if (n == 2) Serial.println(F("Not registered (searching)"));
  if (n == 3) Serial.println(F("Denied"));
  if (n == 4) Serial.println(F("Unknown"));
  if (n == 5) Serial.println(F("Registered roaming"));

  if (!(n == 1 || n == 5)) return false;
  else return true;
}
  
bool MQTTStart(char* Name, char* server, char* username, char* key){              //Starting the MQTT connection with the server.
  char ConnectionCommand[200];
  char IdentificationCommand[50];
  sprintf(ConnectionCommand, "AT+CMQTTCONNECT=0,\"%s\",90,1,\"%s\", \"%s\"", server, username, key);
  sprintf(IdentificationCommand, "AT+CMQTTACCQ=0, \"%s\"", Name);
  if(!fona.sendCheckReply("AT+CMQTTSTART","+CMQTTSTART: 0",2000)){return false;}          //Enabling the MQTT connection
  if(!fona.sendCheckReply(IdentificationCommand,"OK",2000)){return false;}                //Setting the name the server will see for the shield
  if(!fona.sendCheckReply(ConnectionCommand,"OK",2000)){return false;}                    //Connecting to the server using the username and the password
  return true;
}

void MQTTDisconnect(){                                                //Disconnecting from the MQTT server.
  if(!fona.sendCheckReply("AT+CMQTTDISC","OK",2000)){return;}
  if(!fona.sendCheckReply("AT+CMQTTSTOP","OK",2000)){return;}   //Disabling the MQTT connection
  return;
}

void MQTTSend(char* topic, char* message){              //Send something to a topic on the MQTT server.
  char TopicCommand[20];
  char MessageLengthCommand[20];
  sprintf(TopicCommand,"AT+CMQTTTOPIC=0,%i",strlen(topic));               //Building the topic and message command lines
  sprintf(MessageLengthCommand,"AT+CMQTTPAYLOAD=0,%i",strlen(message));
  fona.sendCheckReply(TopicCommand,"OK",10);
  fonaSS.write(topic);                                                    //Giving the topic
  delay(4);
  fona.sendCheckReply(MessageLengthCommand,"OK",10);
  fonaSS.write(message);                                                  //Giving the message
  delay(4);
  fona.sendCheckReply("AT+CMQTTPUB=0,1,60","OK",10);                      //Publishing
  return;
}

bool MQTTSub(void){            //Subscribe to a specific topic.
  char testMessage[12] = "Hello World!";
  int allWellSubs = 0;
  for(int i = 0; i < ARRAY_SIZE(Subtopics); i++){
    char* subtopic = Subtopics[i];
    char SubTopicCommand[25];
    char TopicCommand[25];
    bool isItWellSub = false;
    sprintf(SubTopicCommand, "AT+CMQTTSUB=0,%i,1,1",strlen(subtopic));
    fona.sendCheckReply(SubTopicCommand,"OK",20);                         //Sending the topic to subscribe to
    fonaSS.write(subtopic);
    fona.sendCheckReply("AT+CMQTTSUB=0","OK",10);                         //Subscribing to the topic
    delay(25);
    MQTTSend(subtopic, "Hello World!");                                   //Sending a test message
    delay(10);
    for(int i = 0; i < 10; i++){                                                    //Verifying that we received what we sent to the server
      MQTTReceived(); 
      Serial.println(replybuffer);                                                  //So checking if we are well subscribed.
      if(replybuffer[0] == testMessage[0] && replybuffer[8] == testMessage[8]){
        isItWellSub = true;
        break;
      }
    }
    if(isItWellSub){
      allWellSubs++;                   //Checking if all subscriptions were successful
    }
  }
  if(allWellSubs == ARRAY_SIZE(Subtopics)){
    return true;
  }
  return false;
}


void MQTTReceived(){                            //Checking if we received anything and if so processing the info depending on the topic and the message.
  String s = fonaSS.readStringUntil('\n');
  int newMessage = 0;
  const char startReceivedMessage[13] = "+CMQTTRXSTART";      //Starting transmission message
  char topic[5];
  for (int k = 0;k<13;k++){
    if((char) s[k] == startReceivedMessage[k]){         //Checking if we received the starting message
      newMessage++;
    }
  }
  if (newMessage > 12){
    String line;
    for (int i = 0; i < 4; i++){                //Extracting the topic and the message from the full msg received.   
      line = fonaSS.readStringUntil('\n');
      if(i == 1){
        line.toCharArray(topic, sizeof(line));
      }
      if(i == 3){
        s = line;
      }
    }
    if((s.length()-1) == 1){
      Switch = (char) s[0];
    }
    else{
      for(int k = 0; k<sizeof(replybuffer); k++){       //Emptying the replybuffer before storing the new message.
        replybuffer[k] = NULL;
      }
      s.toCharArray(replybuffer, s.length());           //Casting the new message in the array
    }
    switch (topic[0]){        
      case 's':   
        if(Switch == 48 || Switch == 49){               //If the topic is starting with 's' (switch), turning on or off the built-in led
          digitalWrite(13,(Switch-48));
          Switch = '\n';
        }
      break;

      case 'L':
        if(Switch >47){
          for(int i = 0; i < Switch-47; i++){         //Turning on the specified number of leds
            digitalWrite(Leds[8-i], HIGH);
          }
          Switch = '\n';
        }
        else if(replybuffer[0] == 'R'){               //Turning on the red led
          digitalWrite(LED1, HIGH);
        }
        else if(replybuffer[0] == 'B'){               //Turning on the blue led
          digitalWrite(LED2, HIGH);
        }
        else if(replybuffer[0] == 'G'){               //Turning on the green led
          digitalWrite(LED3, HIGH);    
          }
        else{
            for(int i = 0; i < ARRAY_SIZE(Leds); i++){      //Turning off all leds
              digitalWrite(Leds[i], LOW);
            }
          }
      break;
      default:
        Serial.println(topic);
        Serial.println("Invalid topic");       //If the topic is not right
      break;
    }
  }
}

void SerialReceived(){                //Checking if we received the specific header from Matlab and if so processing the information.
  while(Serial.available()){
    char header[3] = "";
    if ((header[0] = Serial.read()) == 'n'){ 
      for(int i = 1; i < sizeof(header); i++){
        header[i] = Serial.read();
      }
    }
    if(header[0] == 'n' && header[1] == 'e' && header[2] == 'w'){
        char msgReceived[10] = "          ";
        int index = 0;
        char c;
        while(Serial.available() && index<10 && (c = Serial.read()) != '\n'){           //Putting the new message in a char array
          if(c != 0){
            msgReceived[index] = c;
            index++;
          }
        }
        if(index != 0){
          for(int i = index; i < strlen(msgReceived); i++){               //Emptying the characters after the message
            msgReceived[i] = NULL;
          }
          int msgLength = strlen(msgReceived);
          int prevMsgLength = strlen(prevMessage);
          for(int i = 0; i < max(prevMsgLength,msgLength); i++){          //Putting the new message in the previous one
            if(prevMsgLength<=msgLength){
              prevMessage[i] = msgReceived[i]; 
            }
            else{
              if(i<msgLength){
                prevMessage[i] = msgReceived[i];
              }
              else{
                prevMessage[i] = ' ';                                     //Adding space at the end so that Matlab can receive it (10 char message)
              }
            }
          }
          MQTTSend(MQTT_TOPICSTATE,msgReceived);                      //Sending the received message to the server
          }
        Serial.write("S");
        Serial.write(prevMessage);                          //Sending the received message to Matlab
        Serial.write('\n');
      }
  }
}


bool FTPConnect(char* server,int port, char* username, char* password){           //Connect to the FTP server.
  char FTPConnectionCommand[150];
  sprintf(FTPConnectionCommand, "AT+CFTPSLOGIN=\"%s\",%i,\"%s\", \"%s\",0", server, port, username, password);
  if(!fona.sendCheckReply("AT+CFTPSSTART","OK",2000)){return false;}
  delay(200);
  if(!fona.sendCheckReply(FTPConnectionCommand,"OK",2000)){return false;}
  delay(2500);
  return true;
}

bool FTPDisconnect(){                                                     //Disconnecting from the FTP server.
  if(!fona.sendCheckReply("AT+CFTPSLOGOUT","OK",2000)){return false;}
  if(!fona.sendCheckReply("AT+CFTPSSTOP","OK",2000)){return false;}
  return true;
}

bool FTPGet(char* dir, char* fileName){                           //Get a file on the FTP server.
  char FTPGetCommand[50];
  sprintf(FTPGetCommand,"AT+CFTPSGET=\"%s%s\"", dir, fileName);
  fona.sendCheckReply(FTPGetCommand,"OK",1000);
  return true;
}
