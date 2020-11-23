// This class will generate a Pulse object, which will dart from one end of the LED Bar to the opposite end.  The size of the pulse, its color, the initial direction of
// travel, and the speed of its movement will be based on the BPM value provided.  The triggering element will also be set in the constructor. 
class FX_Pulse {
  float bpm; // Specifies the Beats Per Minute, which will determine how fast the Pulse object will move.
  float cycleLength; // Specifies the length of a single cycle (frames per cycle). 
  color pulse_color; // Specifies the Pulse's fill color.
  int startX; // Specifies the starting X position coordinate of the Pulse object.
  int startY; // Specifies the starting Y position coordinate of the Pulse object.
  int endX; // Specifies the ending X position coordinate of the Pulse object.
  int endY; // Specifies the ending Y position coordinate of the Pulse object.
  int xIncr; // Specifies the length along the X axis that the Pulse will move in one cycle.
  int yIncr; // Specifies the length along the Y axis that the Pulse will move in one cycle.
  float sizeX; // Specifies how long the Pulse object will be.
  float sizeY; // Specifies how tall the Pulse object should be.
  int currentXPos; // Specifies the Pulse object's current X position coordinate.
  int currentYPos; // Specifies the Pulse object's current Y position coordinate.
  boolean moveLeftToRight; // Specifies if the Pulse is moving Left to Right (True) or Right to Left (False).
  boolean inMotion; // Specifies if the Pulse object is currently supposed to be moving or not.
//  int pathLength; // Specifies how many pixels make up the Pulse object's path of travel.
//  int speed; // Specifies how far the Pulse object will move during each frame refresh.
  
  // Define class constructor.
  FX_Pulse(float beatsPerMin, color pColor, int xStart, int yStart, int xEnd, int yEnd, float pWidth, float pHeight, boolean LtoR) {
    bpm = beatsPerMin;
    cycleLength = (3600 / bpm);
    pulse_color = pColor;
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
  
  // This function will redefine the pulse_color variable of the Pulse object.
  void redefineColor(color newColor) {
    pulse_color = newColor;
  }
  
  // This function will display the Pulse object.
  void display() {
    noStroke();
    fill(pulse_color);
    rect(currentXPos, currentYPos, sizeX, sizeY);
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
