// This class will generate a rect() object that will blink between two specified colors in tune with the provided cycleLength.
class Blinker_Square {
  color offColor, onColor; // Used to define the colors used when the Blinker_Square object is in an On/Off state.
  int xCoord, yCoord; // Used to define the Blinker_Square's X & Y coordinates.
  int xDim, yDim; // Used to define the X & Y dimensions of the Blinker_Square object.
  
  boolean blinkerOn = false; // Used to toggle the Blinker_Square On/Off.
  boolean reverseModeOn = false; // Used to reverse the On/Off states.
  
  // This allows the User to specify if they wish to delay the frame range when blinkerOn is set to true.  For example, if the User sets this variable to
  // 1, then the Blinker_Square object will skip the first increment of frames 
  int renderDelay = 1;
  
  int currentFrCnt = 0; // Used to track the current frame count.
  float cycleLength; // Used to define the increments that currentColor//s color values will be advanced every Update() cycle. Entered in frames per second.
  float blinkPercent; // Used to specify the percentage of the cycleLength time that the Blinker_Square will be in the On state.  Entered as a decimal between 0.0 and 1.0.
  float blinkLength; // Used to define the number of frames per cycle that the Blinker_Square is to be in the On state.
  
  // Define Constructor.
  Blinker_Square (color colorOff, color colorOn, int coordX, int coordY, int dimX, int dimY, float lengthCycle, float percentBlink, int delayRender, boolean reverseMode) {
    offColor = colorOff;
    onColor = colorOn;
    xCoord = coordX;
    yCoord = coordY;
    xDim = dimX;
    yDim = dimY;
    cycleLength = lengthCycle;
    blinkPercent = percentBlink;
    renderDelay = delayRender; // 2
    reverseModeOn = reverseMode;
    blinkLength = (cycleLength * blinkPercent); // Calculate blinkLength. (56 * 0.25 = 14)
  }
  
  // This function will update the currentFrCnt parameter based on the provided frameCount value.
  void update(int frameCnt) {
    if (currentFrCnt < frameCnt) {
      currentFrCnt++;
    }
    
    if (currentFrCnt >= cycleLength) {
      currentFrCnt = 0;
    }
  }
  
  // This function will draw the Blinker_Square object on the screen if blinkerOn is set to true. 
  void render() {
    // These variables will determine when the first and last frames that the Blinker_Square should be visible should be based on what was provided for
    // the renderDelay parameter.
    float firstFrame, lastFrame;
    lastFrame = (renderDelay * blinkLength); // 1 * 14 = 14; 2 * 14 = 28
    // Ensure that lastFrame isn't set to an invalid frame number.
    if (lastFrame > cycleLength) {
      lastFrame = cycleLength;
    }
    
    firstFrame = (lastFrame - blinkLength); // 14 - 14 = 0; 28 - 14 = 14
    
    if (reverseModeOn == false) {
      if ((currentFrCnt >= firstFrame) && (currentFrCnt <= lastFrame)) {
        blinkerOn = true;
      }
      else if ((currentFrCnt < firstFrame) || (currentFrCnt > lastFrame)) {
        blinkerOn = false;
      }
    }
    // This will reverse when blinkerOn is set to true.
    else if (reverseModeOn == true) {
      if ((currentFrCnt < firstFrame) && (currentFrCnt > lastFrame)) {
        blinkerOn = true;
      }
      else if ((currentFrCnt >= firstFrame) || (currentFrCnt <= lastFrame)) {
        blinkerOn = false;
      }
    }
    
    // Render the Blinker_Square object.
    if (blinkerOn == true) {
      fill(onColor);
      rect(xCoord, yCoord, xDim, yDim);
      noFill();
    }
    else if (blinkerOn == false) {
      fill(offColor);
      rect(xCoord, yCoord, xDim, yDim);
      noFill();
    }
  }
  
  // This function will redefine the Blinker_Square's rect() parameters.
  void redefineBlinkerDims(int coordX, int coordY, int dimX, int dimY) {
    xCoord = coordX;
    yCoord = coordY;
    xDim = dimX;
    yDim = dimY;
  }
  
  // This function will redefine the cycleLength and blinkLength parameters.
  void redefineCycleLength(float newCycleLength) {
    cycleLength = newCycleLength;
    blinkLength = (cycleLength * blinkPercent);
  }
  
  // This function will redefine the blinkPercent and blinkLength parameters.
  void redefineBlinkPercent(float newBlinkPercent) {
    blinkPercent = newBlinkPercent;
    blinkLength = (cycleLength * blinkPercent);
  }
  
  // This function will redefine the offColor parameter.
  void redefineOffColor(color newOffColor) {
    offColor = newOffColor;
  }
  
  // This function will redefine the onColor parameter.
  void redefineOnColor(color newOnColor) {
    onColor = newOnColor;
  }
  
  // This method will return the current offColor parameter's value.
  color returnOffColor() {
    return offColor;
  }
  
  // This method will return the current onColor parameter's value.
  color returnOnColor() {
    return onColor;
  }
  
  // This method will return the current value for the blinkerOn parameter.
  boolean returnBlinkerOn() {
    return blinkerOn;
  }
  
  // This method will return the current value for the cycleLength parameter.
  float returnCycleLength() {
    return cycleLength;
  }
  
  // This method will return the current value for the blinkPercent parameter.
  float returnBlinkPercent() {
    return blinkPercent;
  }
  
  // This method will return the current value for the blinkLength parameter.
  float returnBlinkLength() {
    return blinkLength;
  }
  
  // This method will return the current value for the renderDelay parameter.
  int returnRenderDelay() {
    return renderDelay;
  }
}
