import processing.serial.*;

Serial myPort; // Defines Object Serial
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;

void setup() {
  size(1920,1080); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  smooth();
  myPort = new Serial(this, "COM5", 9600); // Starts the serial communication
  myPort.bufferUntil('.'); // Reads the data from the serial port up to the character '.'
}

void draw() {
  fill(98, 245, 31);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0, 4);
  rect(0, 0, width,1010);

  fill(98, 245, 31); // green color
  // calls the functions for drawing the radar
  drawRadar();
  drawLine();
  drawObject();
  drawText();

  // Update angle for motion
  iAngle = (iAngle + 1) % 180;
}

void serialEvent(Serial myPort) {
  // Simulate radar data
  //////////
  data = myPort.readStringUntil('.');

  data = data.substring(0,data.length()-1);

 

  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"

  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port

  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
//////
/*
  angle = nf(random(0, 180), 0, 2); // Generate a random angle between 0 and 180 degrees
  distance = nf(random(0, 40), 0, 2); // Generate a random distance between 0 and 40 cm
  */
  // Convert the angle and distance to integers
  iAngle = int(angle);
  iDistance = int(distance);
}


void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates to a new location
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  // Draws the arc lines
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  // Draws the angle lines
  line(-width / 2, 0, width / 2, 0);
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30)));
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60)));
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90)));
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120)));
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150)));
  line((-width / 2) * cos(radians(30)), 0, width / 2, 0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height - height * 0.074); // moves the starting coordinates to a new location
  strokeWeight(9);
  
  if (iDistance < 40) {
    stroke(255, 10, 10); // red color if an object is within range
  } else {
    stroke(98, 245, 31); // green color if no object is within range
  }
  
  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); // covers the distance from the sensor from cm to pixels
  
  // Limiting the range to 40 cm
  if (iDistance < 40) {
    // draws the object according to the angle and the distance
    line(
      pixsDistance * cos(radians(iAngle)),
      -pixsDistance * sin(radians(iAngle)),
      (width - width * 0.505) * cos(radians(iAngle)),
      -(width - width * 0.505) * sin(radians(iAngle))
    );
  }
  
  popMatrix();
}


void drawLine() {
  pushMatrix();
  strokeWeight(9);
  
  if (iDistance <= 35) {
    stroke(255, 0, 0); // Red color
  } else {
    stroke(30, 250, 60); // Green color
  }
  
  translate(width/2, height - height * 0.074); // moves the starting coordinates to a new location
  rotate(radians(-iAngle)); // rotate the line based on the angle
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance > 40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  fill(0, 0, 0);
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);
  text("10cm", width - width * 0.3854, height - height * 0.083);
  text("20cm", width - width * 0.281, height - height * 0.083);
  text("30cm", width - width * 0.177, height - height * 0.083);
  text("40cm", width - width * 0.0729, height - height * 0.083);
  textSize(40);
  text("Object Detection", width - width * 0.875, height - height * 0.0277);
  textSize(25);
  text("Angle: " + iAngle + "°", width - width * 0.875, height - height * 0.0277);
  text("Distance: ", width - width * 0.49, height - height * 0.0277);
  if (iDistance < 40) {
    text(" " + iDistance + " cm", width - width * 0.35, height - height * 0.0277);
  } else {
    text("Out of Range ", width - width * 0.35, height - height * 0.0277);
  }
  textSize(25);
  fill(98, 245, 60);
  translate((width - width * 0.4994) + width * 0.031, 0);
  rotate(-90);
  text("Object " + noObject, 0, 0);
  popMatrix();
}
