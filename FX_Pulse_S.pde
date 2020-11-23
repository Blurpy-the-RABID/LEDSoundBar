// This class will generate a Smooth Pulse object, which will dart from one end of the LED Bar to the opposite end.  The size of the pulse, its gradient colors, the 
// initial direction of travel, and the speed of its movement will be based on the BPM value provided.  The triggering element will also be set in the constructor. 
class FX_Pulse_S {
  float bpm; // Specifies the Beats Per Minute, which will determine how fast the Pulse object will move.
  float cycleLength; // Specifies the length of a single cycle (frames per cycle).
  
  color pulse_colorA; // Specifies the Pulse's first gradient color.
  color pulse_colorB; // Specifies the Pulse's second gradient color.
  float colorA_h, colorA_s, colorA_b, colorA_a; // Color A's hue, saturation, brightness, and alpha values, respectively.
  
  int startX; // Specifies the starting X position coordinate of the Pulse object.
  int startY; // Specifies the starting Y position coordinate of the Pulse object.
  int endX; // Specifies the ending X position coordinate of the Pulse object.
  int endY; // Specifies the ending Y position coordinate of the Pulse object.
  int xIncr; // Specifies the length along the X axis that the Pulse will move in one cycle.
  int yIncr; // Specifies the length along the Y axis that the Pulse will move in one cycle.
  int currentXPos; // Specifies the Pulse object's current X position coordinate.
  int currentYPos; // Specifies the Pulse object's current Y position coordinate.
  
  float sizeX; // Specifies how long the Pulse object will be.
  float sizeY; // Specifies how tall the Pulse object should be.
  
  boolean moveLeftToRight; // Specifies if the Pulse is moving Left to Right (True) or Right to Left (False).
  boolean inMotion; // Specifies if the Pulse object is currently supposed to be moving or not.
//  int pathLength; // Specifies how many pixels make up the Pulse object's path of travel.
//  int speed; // Specifies how far the Pulse object will move during each frame refresh.
  
  // Define class constructor.
  FX_Pulse_S(float beatsPerMin, color pColorA, color pColorB, int xStart, int yStart, int xEnd, int yEnd, float pWidth, float pHeight, boolean LtoR) {
    bpm = beatsPerMin;
    cycleLength = (3600 / bpm);
    pulse_colorA = pColorA;
    pulse_colorB = pColorB;
    colorA_h = hue(pulse_colorA);
    colorA_s = saturation(pulse_colorA);
    colorA_b = brightness(pulse_colorA);
    colorA_a = alpha(pulse_colorA);
    
    startX = xStart;
    startY = yStart;
    endX = xEnd;
    endY = yEnd;
    sizeX = pWidth;
    sizeY = pHeight;
    moveLeftToRight = LtoR;
    inMotion = false;
    
    // Set currentX/YPos variables to be equal to the startX/Y variables.
    currentXPos = startX;
    currentYPos = startY;
    
    // Set the values for xIncr and yIncr.
    xIncr = (abs(startX - endX) / int(cycleLength));
    yIncr = (abs(startY - endY) / int(cycleLength));
  }
  
  // This function will redefine the startX/Y and endX/Y variable values.
  void redefineStartEndPts(int newStartX, int newStartY, int newEndX, int newEndY) {
    startX = newStartX;
    startY = newStartY;
    endX = newEndX;
    endY = newEndY;
  }
  
  // This function will redefine the cycleLength variable's value.
  void redefineBPM(float newBPM, float newSizeX) {
    bpm = newBPM;
    cycleLength = (3600 / bpm);
    xIncr = (abs(startX - endX) / int(cycleLength));
    yIncr = (abs(startY - endY) / int(cycleLength));
    sizeX = newSizeX;
  }
  
  // This function will redefine the pulse_colorA/B variables of the Pulse object.  The alpha color will always be set to 0% by default.
  void redefineColor(color newColorA, color newColorB) {
    colorA_h = hue(newColorA);
    colorA_s = saturation(newColorA);
    colorA_b = brightness(newColorA);
    colorA_a = 0;
    
    pulse_colorA = color(colorA_h, colorA_s, colorA_b, colorA_a);
    pulse_colorB = newColorB;
  }
  
  
  void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
    // This function will create a gradient.
    noFill();
    strokeWeight(1);
  
    if (axis == Y_AXIS) {  // Top to bottom gradient
      for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }  
    else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = x; i <= x+w; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
  
  // This function will display the Smooth Pulse object, which is essentially a horizontal gradient.
  void display() {
    noStroke();
    noFill();
    strokeWeight(1);
    
    // This will create the first half of the Smooth Pulse.
    for (int i = currentXPos; i <= currentXPos + (sizeX / 2); i++) {
      float inter = map(i, currentXPos, currentXPos + (sizeX / 2), 0, 1);
      color c = lerpColor(pulse_colorA, pulse_colorB, inter);
      stroke(c);
      line(i, currentYPos, i, currentYPos + sizeY);
    }
    
    // This will create the second half of the Smooth Pulse.
    for (int i = int(currentXPos + (sizeX / 2)); i <= currentXPos + sizeX; i++) {
      float inter = map(i, (currentXPos + (sizeX / 2)), currentXPos + sizeX, 0, 1);
      color c = lerpColor(pulse_colorB, pulse_colorA, inter);
      stroke(c);
      line(i, currentYPos, i, currentYPos + sizeY);
    }
  }
  
  // This function will activate the Pulse object by toggling on its inMotion variable.
  void activate() {
    inMotion = true;
  }
  
  // This function will update the Pulse object's current position values as long as the inMotion variable is set to True.
  // NOTE:  This function should be executed every frame within the draw() loop.
  void refresh() {
    if (inMotion == true) {
      
      // If startX's value is smaller than endX's value, we move things like like so.
      if (startX < endX) {
        if (moveLeftToRight == true) {
          currentXPos = currentXPos + xIncr;
          if (currentXPos > endX) {
            currentXPos = endX;
            inMotion = false;
            moveLeftToRight = false;
          }
        }
      
        else if (moveLeftToRight == false) {
          currentXPos = currentXPos - xIncr;
          if (currentXPos < startX) {
            currentXPos = startX;
            inMotion = false;
            moveLeftToRight = true;
          }
        }
      }
      
      else if (startX > endX) {
        if (moveLeftToRight == true) {
          currentXPos = currentXPos + xIncr;
          if (currentXPos > startX) {
            currentXPos = startX;
            inMotion = false;
            moveLeftToRight = false;
          }
        }
        
        else if (moveLeftToRight == false) {
          currentXPos = currentXPos - xIncr;
          if (currentXPos < endX) {
            currentXPos = endX;
            inMotion = false;
            moveLeftToRight = true;
          }
        }
      }
      
      // Now to do the same thing as above for the Y axis.
      if (startY < endY) {
        if (moveLeftToRight == true) {
          currentYPos = currentYPos + yIncr;
          if (currentYPos > endY) {
            currentXPos = endY;
            inMotion = false;
            moveLeftToRight = false;
          }
        }
      
        else if (moveLeftToRight == false) {
          currentYPos = currentYPos - yIncr;
          if (currentYPos < startY) {
            currentXPos = startY;
            inMotion = false;
            moveLeftToRight = true;
          }
        }
      }
      
      else if (startY > endY) {
        if (moveLeftToRight == true) {
          currentYPos = currentYPos + yIncr;
          if (currentYPos > startY) {
            currentYPos = startY;
            inMotion = false;
            moveLeftToRight = false;
          }
        }
        
        else if (moveLeftToRight == false) {
          currentYPos = currentYPos - yIncr;
          if (currentYPos < endY) {
            currentYPos = endY;
            inMotion = false;
            moveLeftToRight = true;
          }
        }
      }
    }
  }
}
