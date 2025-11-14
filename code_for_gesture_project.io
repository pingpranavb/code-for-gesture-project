#include <Wire.h>
#include <Servo.h>
#include "RevEng_PAJ7620.h"

Servo myServo;

// Servo positions
const int SERVO_OFF = 60;    
const int SERVO_ON  = 120;   

RevEng_PAJ7620 gestureSensor;

void setup() {
  Serial.begin(9600);
  myServo.attach(9);
  myServo.write(SERVO_OFF);  // start OFF
  Wire.begin();

  Serial.println("Initializing gesture sensor...");
  while (!gestureSensor.begin()) {
    Serial.println("Gesture sensor not detected! Retrying in 1s...");
    delay(1000);
  }
  delay(500); // sensor stabilization
  Serial.println("Gesture sensor detected and stabilized!");
}

void loop() {
  Gesture g = gestureSensor.readGesture();  // read gesture

  if (g == GES_RIGHT) {
    Serial.println("Gesture: RIGHT → Switching ON for 2s");
    moveServoTemporary(SERVO_ON);
  } 
  else if (g == GES_LEFT) {
    Serial.println("Gesture: LEFT → Switching OFF for 2s");
    moveServoTemporary(SERVO_OFF);
  }

  delay(200);  // prevent flooding
}

// Moves servo to position for 2 seconds, then detaches to save power
void moveServoTemporary(int angle) {
  myServo.attach(9);      // ensure servo is attached
  myServo.write(angle);   // move to desired position
  delay(500);            // wait 2 seconds
  myServo.detach();       // stop sending signal to save power
}
