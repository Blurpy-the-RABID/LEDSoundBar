class BriteCtrl {
  // This class is used to create a colored background brightness control.  It achieves this by creating a colored rectangle that's the size of the
  //Display Area, and it modifies its opacity based on the input it gets.
  color bkgRedHue; // This will store the value for Red in RGB mode, or Hue in HSB mode.
  color bkgGrnSat; // This will store the value for Green in RGB mode, or Saturation in HSB mode.
  color bkgBluBrite; // This will store the value for Blue in RGB mode, or Brightness in HSB mode.
  float minAlpha; // Determines the lowest Alpha value allowed for this BriteCtrl object.  Set between 0.0 & 1.0.
  float maxAlpha; // Determines the highest Alpha value allowed for this BriteCtrl object.  Set between 0.0 & 1.0.
  float currentAlpha; // Tracks the current Alpha value for the current frame.  Set between 0.0 & 1.0.
  float newAlpha;
  float targetAlpha; // Used to calculate what the Alpha value should be set to for the next frame.  Set between 0.0 & 1.0.
  float alphaStep; // The value at which currentAlpha will be adjusted on each frame during the current cycleLength.  Set between 0.0 & 1.0.
  int cycleLength; // This variable will keep the count of how many frames are within one brightness adjustment cycle.
  boolean reverseModeOn; // Used to toggle whether this BriteCtrl object will fluctuate from dark to bright (false) or from bright to dark (true).
  String cMode = "RGB"; // This is to either be set to RGB or HSB, which will be used to specify the colorMode() for this object.  Default is RGB.
  int colorScale = 255; // This will specify the numerical scale that the colorMode() for this object will be set to.  Default is 255.
  
  // Define class constructor.
  BriteCtrl(color bkRed, color bkGreen, color bkBlue, float brightest, float darkest, int cycleDuration, String modeColor, int scaleColor, boolean briteToDark) {
    bkgRedHue = bkRed;
    bkgGrnSat = bkGreen;
    bkgBluBrite = bkBlue;
    minAlpha = brightest;
    maxAlpha = darkest;
    currentAlpha = maxAlpha;
    targetAlpha = minAlpha;
    cycleLength = cycleDuration;
    reverseModeOn = briteToDark;
    cMode = modeColor;
    colorScale = scaleColor;
  }
  
  // This function will display this Brightness Controller object.
  void display() {
    currentAlpha += alphaStep;
    
    // If reverseModeOn is set to false, we need to reverse its value so that it's set to go from dark to bright.
    if (reverseModeOn == false) {
      // Reverse the value of currentAlpha and store it in newAlpha.
      newAlpha = (currentAlpha - 1);
      newAlpha = (newAlpha * (-1));
      
      // Ensure that newAlpha stays between minAlpha and maxAlpha.
      if (newAlpha < minAlpha) {
        newAlpha = minAlpha;
      }
      
      if (newAlpha > maxAlpha) {
        newAlpha = maxAlpha; 
      }
      
      // Set the color & alpha values to fill().
      fill(bkgRedHue, bkgGrnSat, bkgBluBrite, (newAlpha * colorScale));
    }
    
    // Otherwise, we go from bright to dark.
    else {
      // Ensure that currentAlpha stays between minAlpha and maxAlpha.
      if (currentAlpha < minAlpha) {
        currentAlpha = minAlpha;
      }
      
      if (currentAlpha > maxAlpha) {
        currentAlpha = maxAlpha; 
      }
      
      // Set the color & alpha values to fill().
      fill(bkgRedHue, bkgGrnSat, bkgBluBrite, (currentAlpha * colorScale));
    }
    
    // Draw the Brightness Controller object.
    rect(0, 0, width, height);
  }
  
  // This function will refresh the Brightness Controller object's Alpha value.
  void refresh(float newAlpha) {
    targetAlpha = newAlpha;
    alphaStep = ((targetAlpha - currentAlpha) / cycleLength); 
  }
}
