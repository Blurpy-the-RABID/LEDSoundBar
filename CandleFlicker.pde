// This class will produce a Rect() object that will flicker its opacity at a randomized rate, imitating the flickering brightness of a candle flame.
class CandleFlicker {
  // This CandleFlicker object will have the following parameters:
  int clrMode; // This will dictate the colorMode() of this CandleFlicker object; can be set to RGB or HSB.
  float colorRange; // Sets the range for all color elements.
  float c1, c2, c3; //Sets the color values for the Red/Green/Blue or Hue/Saturation/Brightness parameters of colorMode().
  float minAlpha, maxAlpha, currentAlpha, targetAlpha, alphaIncr; // These values will control the opacity variations of the CandleFlicker object.
  float cycleLength, minCycle, maxCycle, currentFrame; // This will be used to specify how long a refresh cycle is, which will aid in calculating the value of alphaIncr.
//  color flickerColor; // This will be the color that the CandleFlicker object will use when it is most opaque.
  float pt1a, pt1b, rectWidth, rectHeight; // Used to define the location of the Rect() object that's drawn within the Display Window. 
  
  // Define class constructor.
  CandleFlicker(int modeColor, float rangeColor, float clr1, float clr2, float clr3, float minA, float maxA,  
  float pt1, float pt2, float rWidth, float rHeight, float lengthCycle) {
    clrMode = modeColor;
    colorRange = rangeColor;
    c1 = clr1;
    c2 = clr2;
    c3 = clr3;
    minAlpha = minA;
    maxAlpha = maxA;
    //flickerColor = color(c1, c2, c3, 100);
    pt1a = pt1;
    pt1b = pt2;
    rectWidth = rWidth;
    rectHeight = rHeight;
    
    minCycle = (lengthCycle * 0.5); // minCycle will always be set to half of what lengthCycle is specified as.
    maxCycle = (lengthCycle * 1.5); // maxCycle will always be set to 1.5 of what lengthCycle is specified as.
    cycleLength = int(random(minCycle, maxCycle));
    currentFrame = 0;
    
    // Set the value of currentAlpha using the random() function.
    currentAlpha = random(minAlpha, maxAlpha);
    targetAlpha = random(minAlpha, maxAlpha); // Randomly generate a targetAlpha value to change the currentAlpha value to over the next refresh cycle.
    
    // Calculate the increment at which currentAlpha should be adjusted every time the display() function is executed.
    alphaIncr = abs((targetAlpha - currentAlpha) / cycleLength);
  }
  
  // This function will redefine the cycleLength variable's value.
  void redefineCycleLength(float newMinCycle) {
    minCycle = (newMinCycle * 0.5); // minCycle will always be set to half of what lengthCycle is specified as.
    maxCycle = (newMinCycle * 1.5);
    cycleLength = int(random(minCycle, maxCycle));
  }
  
  // This function will redefine the color values for the c1, c2, and c3 parameters.
  void redefineColor(color newColor) {
    if (clrMode == RGB) {
      c1 = red(newColor);
      c2 = green(newColor);
      c3 = blue(newColor);
    }
    
    else if (clrMode == HSB) {
      c1 = hue(newColor);
      c2 = saturation(newColor);
      c3 = brightness(newColor);
    }
  }
  
  // This function will draw the CandleFlicker object within the Display Window.
  void display() {
    noFill();
    colorMode(clrMode, colorRange); // Re-establish the colorMode so that outside colorMode() settings don't interfere with this object's appearance.
    
    // Adjust currentAlpha by one increment towards targetAlpha.
    if(currentAlpha < targetAlpha) {
      currentAlpha += alphaIncr; // Change currentAlpha's value by the last established value of alphaIncr.
    }
    
    else if(currentAlpha > targetAlpha) {
      currentAlpha -= alphaIncr; // Change currentAlpha's value by the last established value of alphaIncr.
    }
    
    if(currentAlpha > maxAlpha) {
      currentAlpha = maxAlpha;
    }
    
    if(currentAlpha < minAlpha) {
      currentAlpha = minAlpha;
    }
    
    flickerColor = color(c1, c2, c3, currentAlpha); // Set the color values for flickerColor.
    fill(flickerColor); // Set the current fill color based on the above calculations.
    rect(pt1a, pt1b, rectWidth, rectHeight); // Display the CandleFlicker Rect() object.
    currentFrame++; // Advance currentFrame. 
    
    // Once we reach the end of the cycle length, we reset our currentFrame counter, and then we randomize our cycleLength & targetAlpha variables.
    if(currentFrame == cycleLength) {
      currentFrame = 0;
      cycleLength = int(random(minCycle, maxCycle));
      
      targetAlpha = random(minAlpha, maxAlpha);
      alphaIncr = abs((targetAlpha - currentAlpha) / cycleLength);
      //refresh();
    }
  }
  
  // This function will update the alphaIncr value whenever it's executed.  
  void refresh() {
    targetAlpha = random(minAlpha, maxAlpha);
    alphaIncr = ((targetAlpha - currentAlpha) / cycleLength);
  }
}
