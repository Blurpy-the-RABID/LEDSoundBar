class Beat_Bar {
// This class will generate a rect() object that will pulse to the new dimensional values that it's given every cycle, and will then smoothly shrink back to its
// default size for the current cycle.  The concept is to create a bar that pulses with the bass of the incoming audio.
// NOTE:  This class is an experimental WIP, and may end up being abandoned if deemed not worthwhile to pursue further.
  
  // Define Class Parameters:
  color fillColor; // Used to define the Beat_Bar's fill color.
  int xCoord, yCoord; // Used to define the Beat_Bar's X & Y coordinates.
  int xMinDim, xMaxDim, yMinDim, yMaxDim; // Used to define the minimum & maximum X & Y dimensions of the Beat_Bar object.
  int xDim, yDim; // Used to define the current X & Y dimensions of the Beat_Bar object.
  float newXDim, oldXDim, newYDim, oldYDim; // Defines the new cycle's x/yDim and the last cycle's x/yDim values.
  float xIncr, yIncr; // Used to define what the X & Y increment sizes should be based on the current cycle length.
  float cycleLength; // Used to define the increments that currentColor//s color values will be advanced every Update() cycle. Entered in BPM
  boolean reverseDims = false; // Used to define whether or not the Beat_Bar will render itself in reverse; default is off (false).
  
  // Define Constructor.
  Beat_Bar (color colorFill, int xLoc, int yLoc, int xMin, int yMin, int xMax, int yMax, float lengthCycle, boolean reversed) {
    fillColor = colorFill;
    xCoord = xLoc;
    yCoord = yLoc;
    xMinDim = xMin; // -1
    yMinDim = yMin; // 30
    xMaxDim = xMax; // ((width / 2) * (-1))
    yMaxDim = yMax; // 60
    xDim = xMin;
    oldXDim = 0;
    newXDim = xDim;
    yDim = yMin;
    oldYDim = 0;
    newYDim = yDim;
    cycleLength = lengthCycle; // 25
    reverseDims = reversed;
    
    xIncr = abs((xMinDim - newXDim) / cycleLength);
    yIncr = abs((yMinDim - newYDim) / cycleLength);
  }
  
  // This method will render the Beat_Bar on the screen.
  void render() {
    if (reverseDims == true) {
      xDim += (xIncr);
      if (xDim >= xMinDim) {
        xDim = (xMinDim);
      }
      
      if (xDim <= xMaxDim) {
        xDim = (xMaxDim);
      }
      
      yDim += (yIncr);
      if (yDim >= yMinDim) {
        yDim = yMinDim;
      }
      
      if (yDim <= yMaxDim) {
        yDim = yMaxDim;
      }
      
      fill(fillColor);
      rect(xCoord, yCoord, xDim, yDim);
      noFill();
    }
    
    else {
      xDim -= xIncr;
      if (xDim <= xMinDim) {
        xDim = xMinDim;
      }
      
      yDim -= yIncr;
      if (yDim <= yMinDim) {
        yDim = yMinDim;
      }
      
      fill(fillColor);
      rect(xCoord, yCoord, xDim, yDim);
      noFill();
    }
  }
  
  // This method will update the values of oldXDim, newXDim, oldYDim, and newYDim.
  void updateDims(float newSizeX, float newSizeY) {
    oldXDim = xDim;
    oldYDim = yDim;
    newXDim = newSizeX;
    newYDim = newSizeY;
    
    if (reverseDims == true) {
      if (newXDim < xMaxDim) {
        newXDim = xMaxDim;
      }
      
      else if (newXDim > xMinDim) {
        newXDim = xMinDim;
      }
      
      newYDim = int(newSizeY);
      if (newYDim < yMaxDim) {
        newYDim = yMaxDim;
      }
      
      else if (newYDim > yMinDim) {
        newYDim = yMinDim;
      }
      
      if (xDim > newXDim) {
        xDim = int(newXDim);
      }
      
      if (yDim > newYDim) {
        yDim = int(newYDim);
      }
    }
    
    else {
      if (newXDim > xMaxDim) {
        newXDim = xMaxDim;
      }
      
      else if (newXDim < xMinDim) {
        newXDim = xMinDim;
      }
      
      newYDim = int(newSizeY);
      if (newYDim > yMaxDim) {
        newYDim = yMaxDim;
      }
      
      else if (newYDim < yMinDim) {
        newYDim = yMinDim;
      }
      
      if (xDim < newXDim) {
        xDim = int(newXDim);
      }
      
      if (yDim < newYDim) {
        yDim = int(newYDim);
      }
    }
  }
  
  // This function will redefine the cycleLength, xIncr, & yIncr parameters.
  void redefineCycleLength(float newCycleLength) {
    cycleLength = newCycleLength;
    xIncr = abs((xMinDim - newXDim) / cycleLength);
    yIncr = abs((yMinDim - newYDim) / cycleLength);
  }
  
  // This method will redefine the color value for the fillColor parameter. 
  void redefineColor(color newColor) {
    fillColor = newColor;
  }
  
  // This function will return the current color value for the fillColor parameter.
  color getColor() {
    return fillColor;
  }
  
  // Returns the current value of xDim.
  int returnXDim() {
    return xDim;
  }
}
