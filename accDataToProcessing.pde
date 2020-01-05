/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
float xAcc, yAcc, zAcc;
float mapX, mapY;
float  prevXAcc, prevYAcc, prevZAcc;
float lerpX, lerpY;
float smoothing = 0.99;
void setup() 
{
  size(800, 800);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  println(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,

    val = myPort.readStringUntil('\n');         // read it and store it in val
          //println();

  }
  background(255);             // Set background to white
  if (val == null) {              // If the serial value is 0,
    fill(0);   
    // set fill to blackr
  } else {                       // If the serial value is not 0,
    fill(204);                 // set fill to light gray
    if(val.length() < 20){
    if (val.charAt(0) == 'X') {
      xAcc = (float) Float.valueOf(val.substring(1)).floatValue();
    } 
    if (val.charAt(0) == 'Y') {
      yAcc = (float) Float.valueOf(val.substring(1)).floatValue();
    }
    if (val.charAt(0) == 'Z') {
      zAcc = (float) Float.valueOf(val.substring(1)).floatValue();
    }
    //for (int i = 0; i < val.length(); i++) {
    //}
    println(xAcc + " :: " +yAcc + " :: "+zAcc);
    }
  }
  
  mapX = map(xAcc, -1000, 1000, 200, width-200);
  mapY = map(yAcc, -1000, 1000, 200, height-200);
  lerpX = lerp(mapX, prevXAcc, smoothing);
  lerpY = lerp(mapY, prevYAcc, smoothing);
  rect(lerpX, lerpY, 10, 10);
  prevXAcc = lerpX;
  prevYAcc = lerpY;
}

/*

 // Wiring / Arduino Code
 // Code for sensing a switch status and writing the value to the serial port.
 
 int switchPin = 4;                       // Switch connected to pin 4
 
 void setup() {
 pinMode(switchPin, INPUT);             // Set pin 0 as an input
 Serial.begin(9600);                    // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (digitalRead(switchPin) == HIGH) {  // If switch is ON,
 Serial.write(1);               // send 1 to Processing
 } else {                               // If the switch is not ON,
 Serial.write(0);               // send 0 to Processing
 }
 delay(100);                            // Wait 100 milliseconds
 }
 
 */
