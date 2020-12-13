//=============================================================================================================================================================
// This version of the ColorScroller class will do just as ColorScroller4 does, but with some added features.  Currently, ColorScroller4 only bounces between
// the two provided color values by staying between the color values of 0 (i.e. the Red color on the far left of the rainbow color gradient) and 100 (the Red
// found on the far right of the rainbow gradient).  This is fine in numerous cases, but for some color choices where the chosen colors are on the outer
// extremes of the rainbow gradient; it creates this "rainbow scrolling effect" where the rendered ColorScroller4 object scrolls through most of the colors of
// the rainbow as it bounces between two colors.
//
// This new version of the ColorScroller class will be capable of analyzing the shortest path between the two chosen colors, and then use that path to bounce
// between the two chosen colors over the span of the specified cycle length.  For example, if I choose Violet (position 80-ish) as Color1 and Orange
// (position 20-ish) as Color2, a ColorScroller5 object will scroll from Color1's position (100) towards position 100 (Red @ far right of gradient) and then 
// LOOP AROUND to position 0 (Red @ far left of gradient) as it continues scrolling towards Color2.
//=============================================================================================================================================================

class ColorScroller5 {
  // Define Class Parameters:
  int clrMode; // Specifies if colorMode() is set to RGB or HSB.
  float cycleLength; // Used to define the increments that currentColor5's color values will be advanced every Update() cycle. Entered in BPM
  
  // The following variables will keep track of the percentage value that's provided to it based on the LEDSoundBar's current Equalizer setting and the current
  // audio frequency analysis data that generates the provided ColorMultiplier value.
  float newColorMultiplier = 1.0; // Used to specify the percentile to be scrolled to when colorPercentMode is set to True. // = 0.5;
  float oldColorMultiplier = 1.0; // Used to specify the previous percentile to be scrolled to when colorPercentMode is set to True in the last cycle. // = 0.5;
  
  // clr1 & clr2 will be the two color values that the ColorScroller5 object will shift between within the span of a single cycle.
  // currentColor will represent the current color value of the ColorScroller5 object as it shifts between clr1 & clr2 during the current cycle.  This variable
  // will be rendered every frame to visually show the transition from clr1 to clr2 and vice-versa in real time. 
  color clr1, clr2, currentColor;
  //  clr1 = color(25, 100, 100, 0);
  //  clr2 = color(100, 25, 100, 100);

  float c1a, c1b, c1c, c1alpha; // clr1 Color Values.
  float c2a, c2b, c2c, c2alpha; // clr2 Color Values.
  float v1, v2, v3, vAlpha; // Current Color Values.
  float v1Incr, v2Incr, v3Incr, vAlphaIncr; // Current color incremental values.
  float v1NewMax, v2NewMax, v3NewMax, vAlphaNewMax; // This will be the new target vMax color values.
  float v1OldMax, v2OldMax, v3OldMax, vAlphaOldMax; // These are the last set of vMax color values from the last cycle.

  boolean colorPercentMode = true; // Determines if the ColorScroller5 object is to use a percentile to scroll between clr1 and clr2.
  
  // advanceColorValues determines if the ColorScroller5 object is to advance the color values from clr1 towards clr2 or vice-versa.
  // NOTE:  This should only be set to True when colorPercentMode is set to False!
  boolean advanceColorValues = false;
  
  // When this variable is set to True, the ColorScroller5 object will scroll from one end of the Color Gradient to the other on its path to render the shift
  // between clr1 & clr2.  So if clr1 is set to position 20 and clr2 is set to position 80 on the Color Gradient while reverseScrollOn is True, then the
  // ColorScroller5 object will scroll from position 20 towards position 0, then LOOP AROUND to position 100 and finally reach position 80.
  // When reverseScrollOn is set to False, then the ColorScroller5 object will scroll from position 20 to position 80 WITHOUT looping around the extreme edges
  // of the Color Gradient.
  boolean reverseScrollOn = false;
    
//--------------------------------------------------------------------------
// BEGIN Constructor Definition
//--------------------------------------------------------------------------
  // Define Constructor:
  ColorScroller5 (int modeColor, color color1, color color2, float lengthCycle, boolean PercentModeOn) {
    clrMode = modeColor;
    clr1 = color1;
    clr2 = color2;
    cycleLength = lengthCycle;
    colorPercentMode = PercentModeOn;
    
    // Assign the c1a & c2a color value parameters based on clrMode's value.
    if (clrMode == RGB) {
      c1a = red(clr1);
      c1b = green(clr1);
      c1c = blue(clr1);
      c1alpha = alpha(clr1);

      c2a = red(clr2);
      c2b = green(clr2);
      c2c = blue(clr2);
      c2alpha = alpha(clr2);
    }

    else if (clrMode == HSB) {
      c1a = hue(clr1);
      c1b = saturation(clr1);
      c1c = brightness(clr1);
      c1alpha = alpha(clr1);

      c2a = hue(clr2);
      c2b = saturation(clr2);
      c2c = brightness(clr2);
      c2alpha = alpha(clr2);
    }
    
    // Define currentColor Color Values, and currentColor itself (set to be equal to clr1 by default).
    v1 = c1a;
    v2 = c1b;
    v3 = c1c;
    vAlpha = c1alpha;
    currentColor = color(v1, v2, v3, vAlpha);
    
    // Set all vOldMax color values to zero, and all vNewMax color values to clr1's color values.
    // These variables are only interacted with when colorPercentMode is set to True.
    v1NewMax = c1a;
    v2NewMax = c1b;
    v3NewMax = c1c;
    vAlphaNewMax = c1alpha;
    v1OldMax = 0;
    v2OldMax = 0;
    v3OldMax = 0;
    vAlphaOldMax = 0;
    
    // If colorPercentMode is set to True, then we'll set advanceColorValues to False.
    if (colorPercentMode  == true) {
      advanceColorValues = false;
    }
    
    // If colorPercentMode is set to False, then we'll calculate the values for our vIncr variables.
    else if (colorPercentMode == false) {
      advanceColorValues = true;
      // Define the vIncr incremental variables.
      v1Incr = abs((c1a - c2a) / cycleLength);
      v2Incr = abs((c1b - c2b) / cycleLength);
      v3Incr = abs((c1c - c2c) / cycleLength);
      vAlphaIncr = abs((c1alpha - c2alpha) / cycleLength);
    }
    
    // We'll call upon the defClrScrollDir() function to determine the appropriate value for the reverseScrollOn variable.
    defClrScrollDir();
  }
//--------------------------------------------------------------------------
// END OF Constructor Definition
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// BEGIN Functions
//--------------------------------------------------------------------------
// This function will determine the appropriate value for the reverseScrollOn variable based on the current clr1 & clr2 color values.
  void defClrScrollDir() {
    // Here's where the ColorScroller5 intelligence comes into play.  We will next calculate the shortest path between clr1 & clr2 on the Color Gradient spectrum.
    // This will determine whether or not we set reverseScrollOn to True or False.
    // We first calculate a number of values based on clr1's & clr2's current color values.
    float clr1ToZero = c1a;
    float clr1ToMax = abs(100 - c1a);
    float clr2ToZero = c2a;
    float clr2ToMax = abs(100 - c2a);
    
    float normClrDist = abs(c1a - c2a); // This represents the distance between clr1 & clr2 if we DO NOT scroll past the outer edges of the Color Gradient spectrum.
    float revClrDist12 = abs(clr1ToZero + clr2ToMax);  // This represents the distance between clr1 & clr2 if we scroll towards zero from clr1, and towards 100 from clr2. 
    float revClrDist21 = abs(clr2ToZero + clr1ToMax);  // This represents the distance between clr1 & clr2 if we scroll towards zero from clr2, and towards 100 from clr1.
    
    // We'll now determine which of the revClrDist variables has the lowest value.  We'll then compare the chosen revClrDist variable to normClrDist to determine
    // if reverseScrollOn should be set to True or False.  If normClrDist is the smallest or both variables are equal, then reverseScrollOn is set to False.
    // If normClrDist is larger than the chosen revClrDist variable, then reverseScrollOn will be set to True.
    if (revClrDist12 < revClrDist21) {
      if (normClrDist < revClrDist12) {
        reverseScrollOn = false;
      }
      
      else if (normClrDist > revClrDist12) {
        reverseScrollOn = true;
      }
      
      else {
        reverseScrollOn = false;
      }
    }
    
    else if (revClrDist12 > revClrDist21) {
      if (normClrDist < revClrDist21) {
        reverseScrollOn = false;
      }
      
      else if (normClrDist > revClrDist21) {
        reverseScrollOn = true;
      }
      
      else {
        reverseScrollOn = false;
      }
    }
  } 

// This function will redefine clr1's & clr2's color values based on the input color values. 
  void setColors(color color1, color color2) {
    clr1 = color1;
    clr2 = color2;
    
    // Assign the c1a & c2a color value parameters based on clrMode's value.
    if (clrMode == RGB) {
      c1a = red(clr1);
      c1b = green(clr1);
      c1c = blue(clr1);
      c1alpha = alpha(clr1);

      c2a = red(clr2);
      c2b = green(clr2);
      c2c = blue(clr2);
      c2alpha = alpha(clr2);
    }

    else if (clrMode == HSB) {
      c1a = hue(clr1);
      c1b = saturation(clr1);
      c1c = brightness(clr1);
      c1alpha = alpha(clr1);

      c2a = hue(clr2);
      c2b = saturation(clr2);
      c2c = brightness(clr2);
      c2alpha = alpha(clr2);
    }
    
    // We'll call upon the defClrScrollDir() function to determine the appropriate value for the reverseScrollOn variable.
    defClrScrollDir();
  }

  // This function will return the color value that the ColorScroller5 is currently set to.
  color getColor() {
    currentColor = color(v1, v2, v3, vAlpha);
    return currentColor;
  }
  
  // This function will redefine the cycleLength variable's value.
  void setCycleLength(float newCycleLength) {
    cycleLength = newCycleLength;
  }
  
  // This function will return the cycleLength variable's value.
  float getCycleLength() {
    return cycleLength;
  }
  
  // This function will take in a new percentage value, and then recalculate all of its relevant parameters' values.
  void setPercentValue(float newPercent) {
    // This function should only work when colorPercentMode is set to True.
    if (colorPercentMode == true) {
      //The following code will determine our incremental parameters when reverseScrollOn is set to False.
      if (reverseScrollOn == false) {
        // Recalculate all relevant Color Value parameters.
        oldColorMultiplier = newColorMultiplier; 
        newColorMultiplier = newPercent;
        
        // Assign the current vNewMax values to the vOldMax variables.
        v1OldMax = v1NewMax; // returns 0.75
        v2OldMax = v2NewMax;
        v3OldMax = v3NewMax;
        vAlphaOldMax = vAlphaNewMax;
        
        // Redefine the vNewMax variables.
        if (c1a < c2a) { // 25 < 100
          v1NewMax = (((abs(c1a - c2a)) * newColorMultiplier) + c1a); // returns 62.5
          
          // Ensure that v1NewMax doesn't exceed the range between c1a & c2a.
          if (v1NewMax < c1a) {
            v1NewMax = c1a;
          }
          
          else if (v1NewMax > c2a) {
            v1NewMax = c2a;
          }
        }
        
        else if (c1a > c2a) { // 100 > 25
          v1NewMax = abs(((abs(c1a - c2a)) * newColorMultiplier) - c1a); // returns 62.5
          
          // Ensure that v1NewMax doesn't exceed the range between c1a & c2a.
          if (v1NewMax > c1a) {
            v1NewMax = c1a;
          }
          
          else if (v1NewMax < c2a) {
            v1NewMax = c2a;
          }
        }
        
        if (c1b < c2b) { // 25 < 100
          v2NewMax = (((abs(c1b - c2b)) * newColorMultiplier) + c1b); // returns 62.5
          
          // Ensure that v2NewMax doesn't exceed the range between c1b & c2b.
          if (v2NewMax < c1b) {
            v2NewMax = c1b;
          }
          
          else if (v2NewMax > c2b) {
            v2NewMax = c2b;
          }
        }
        
        else if (c1b > c2b) { // 100 > 25
          v2NewMax = abs(((abs(c1b - c2b)) * newColorMultiplier) - c1b); // returns 62.5
          
          // Ensure that v2NewMax doesn't exceed the range between c1b & c2b.
          if (v2NewMax > c1b) {
            v2NewMax = c1b;
          }
          
          else if (v2NewMax < c2b) {
            v2NewMax = c2b;
          }
        }
        
        if (c1c < c2c) { // 25 < 100
          v3NewMax = (((abs(c1c - c2c)) * newColorMultiplier) + c1c); // returns 62.5
          
          // Ensure that v3NewMax doesn't exceed the range between c1c & c2c.
          if (v3NewMax < c1c) {
            v3NewMax = c1c;
          }
          
          else if (v3NewMax > c2c) {
            v3NewMax = c2c;
          }
        }
        
        else if (c1c > c2c) { // 100 > 25
          v3NewMax = abs(((abs(c1c - c2c)) * newColorMultiplier) - c1c); // returns 62.5
          
          // Ensure that v3NewMax doesn't exceed the range between c1c & c2c.
          if (v3NewMax > c1c) {
            v3NewMax = c1c;
          }
          
          else if (v3NewMax < c2c) {
            v3NewMax = c2c;
          }
        }
        
        if (c1alpha < c2alpha) { // 25 < 100
          vAlphaNewMax = (((abs(c1alpha - c2alpha)) * newColorMultiplier) + c1alpha); // returns 62.5
          
          // Ensure that vAlphaNewMax doesn't exceed the range between c1alpha & c2alpha.
          if (vAlphaNewMax < c1alpha) {
            vAlphaNewMax = c1alpha;
          }
          
          else if (vAlphaNewMax > c2alpha) {
            vAlphaNewMax = c2alpha;
          }
        }
        
        else if (c1alpha > c2alpha) { // 100 > 25
          vAlphaNewMax = abs(((abs(c1alpha - c2alpha)) * newColorMultiplier) - c1alpha); // returns 62.5
          
          // Ensure that vAlphaNewMax doesn't exceed the range between c1alpha & c2alpha.
          if (vAlphaNewMax > c1alpha) {
            vAlphaNewMax = c1alpha;
          }
          
          else if (vAlphaNewMax < c2alpha) {
            vAlphaNewMax = c2alpha;
          }
        }
        
        // Redefine the vIncr variables.
        v1Incr = (abs(v1OldMax - v1NewMax) / cycleLength);
        v2Incr = (abs(v2OldMax - v2NewMax) / cycleLength);
        v3Incr = (abs(v3OldMax - v3NewMax) / cycleLength);
        vAlphaIncr = (abs(vAlphaOldMax - vAlphaNewMax) / cycleLength);
      }
      
      // If reverseScrollOn is set to True, then we recalculate all of our incremental variables based on the "reversed" distance between clr1 & clr2.
      else if (reverseScrollOn == true) {
        // Recalculate all relevant Color Value parameters.
        oldColorMultiplier = newColorMultiplier; 
        newColorMultiplier = newPercent;
        
        // Assign the current vNewMax values to the vOldMax variables.
        v1OldMax = v1NewMax; // returns 0.75
        v2OldMax = v2NewMax;
        v3OldMax = v3NewMax;
        vAlphaOldMax = vAlphaNewMax;
        
        // Redefine the vNewMax variables.
        if (c1a > c2a) { // 25 < 100
          v1NewMax = (((abs(c1a - c2a)) * newColorMultiplier) - c1a); // returns 62.5
          
          // Ensure that v1NewMax doesn't exceed the range between c1a & c2a.
          if (v1NewMax > c1a) {
            v1NewMax = c1a;
          }
          
          else if (v1NewMax < c2a) {
            v1NewMax = c2a;
          }
        }
        
        else if (c1a < c2a) { // 100 > 25
          v1NewMax = abs(((abs(c1a - c2a)) * newColorMultiplier) + c1a); // returns 62.5
          
          // Ensure that v1NewMax doesn't exceed the range between c1a & c2a.
          if (v1NewMax > c1a) {
            v1NewMax = c1a;
          }
          
          else if (v1NewMax < c2a) {
            v1NewMax = c2a;
          }
        }
        
        if (c1b < c2b) { // 25 < 100
          v2NewMax = (((abs(c1b - c2b)) * newColorMultiplier) + c1b); // returns 62.5
          
          // Ensure that v2NewMax doesn't exceed the range between c1b & c2b.
          if (v2NewMax < c1b) {
            v2NewMax = c1b;
          }
          
          else if (v2NewMax > c2b) {
            v2NewMax = c2b;
          }
        }
        
        else if (c1b > c2b) { // 100 > 25
          v2NewMax = abs(((abs(c1b - c2b)) * newColorMultiplier) - c1b); // returns 62.5
          
          // Ensure that v2NewMax doesn't exceed the range between c1b & c2b.
          if (v2NewMax > c1b) {
            v2NewMax = c1b;
          }
          
          else if (v2NewMax < c2b) {
            v2NewMax = c2b;
          }
        }
        
        if (c1c < c2c) { // 25 < 100
          v3NewMax = (((abs(c1c - c2c)) * newColorMultiplier) + c1c); // returns 62.5
          
          // Ensure that v3NewMax doesn't exceed the range between c1c & c2c.
          if (v3NewMax < c1c) {
            v3NewMax = c1c;
          }
          
          else if (v3NewMax > c2c) {
            v3NewMax = c2c;
          }
        }
        
        else if (c1c > c2c) { // 100 > 25
          v3NewMax = abs(((abs(c1c - c2c)) * newColorMultiplier) - c1c); // returns 62.5
          
          // Ensure that v3NewMax doesn't exceed the range between c1c & c2c.
          if (v3NewMax > c1c) {
            v3NewMax = c1c;
          }
          
          else if (v3NewMax < c2c) {
            v3NewMax = c2c;
          }
        }
        
        if (c1alpha < c2alpha) { // 25 < 100
          vAlphaNewMax = (((abs(c1alpha - c2alpha)) * newColorMultiplier) + c1alpha); // returns 62.5
          
          // Ensure that vAlphaNewMax doesn't exceed the range between c1alpha & c2alpha.
          if (vAlphaNewMax < c1alpha) {
            vAlphaNewMax = c1alpha;
          }
          
          else if (vAlphaNewMax > c2alpha) {
            vAlphaNewMax = c2alpha;
          }
        }
        
        else if (c1alpha > c2alpha) { // 100 > 25
          vAlphaNewMax = abs(((abs(c1alpha - c2alpha)) * newColorMultiplier) - c1alpha); // returns 62.5
          
          // Ensure that vAlphaNewMax doesn't exceed the range between c1alpha & c2alpha.
          if (vAlphaNewMax > c1alpha) {
            vAlphaNewMax = c1alpha;
          }
          
          else if (vAlphaNewMax < c2alpha) {
            vAlphaNewMax = c2alpha;
          }
        }
        
        // Redefine the vIncr variables.
        v1Incr = (abs(v1OldMax - v1NewMax) / cycleLength);
        v2Incr = (abs(v2OldMax - v2NewMax) / cycleLength);
        v3Incr = (abs(v3OldMax - v3NewMax) / cycleLength);
        vAlphaIncr = (abs(vAlphaOldMax - vAlphaNewMax) / cycleLength);
      }
    }
  }
  
  // This function will update the vX color values by one increment based on whether or not colorPercentMode is set to True. 
  void update() {
    if (colorPercentMode == true) {
      if (reverseScrollOn == false) {
        if (c1a < c2a) { // 25 < 100 
          if (v1 < v1NewMax) {
            v1 += v1Incr;
          }
          
          else if (v1 > v1NewMax) {
            v1 -= v1Incr;
          }
        }
        
        else if (c1a > c2a) { // 100 > 25 
          if (v1 < v1NewMax) {
            v1 += v1Incr;
          }
          
          else if (v1 > v1NewMax) {
            v1 -= v1Incr;
          }
        }
        
        if (c1b < c2b) { // 25 < 100 
          if (v2 < v2NewMax) {
            v2 += v2Incr;
          }
          
          else if (v2 > v2NewMax) {
            v2 -= v2Incr;
          }
        }
        
        else if (c1b > c2b) { // 100 > 25 
          if (v2 < v2NewMax) {
            v2 += v2Incr;
          }
          
          else if (v2 > v2NewMax) {
            v2 -= v2Incr;
          }
        }
        
        if (c1c < c2c) { // 25 < 100 
          if (v3 < v3NewMax) {
            v3 += v3Incr;
          }
          
          else if (v3 > v3NewMax) {
            v3 -= v3Incr;
          }
        }
        
        else if (c1c > c2c) { // 100 > 25 
          if (v3 < v3NewMax) {
            v3 += v3Incr;
          }
          
          else if (v3 > v3NewMax) {
            v3 -= v3Incr;
          }
        }
        
        if (c1alpha < c2alpha) { // 25 < 100 
          if (vAlpha < vAlphaNewMax) {
            vAlpha += vAlphaIncr;
          }
          
          else if (vAlpha > vAlphaNewMax) {
            vAlpha -= vAlphaIncr;
          }
        }
        
        else if (c1alpha > c2alpha) { // 100 > 25 
          if (vAlpha < vAlphaNewMax) {
            vAlpha += vAlphaIncr;
          }
          
          else if (vAlpha > vAlphaNewMax) {
            vAlpha -= vAlphaIncr;
          }
        }
      }
      
      // If reverseScrollOn is set to True, then we have to scroll from clr1 to clr2 by going beyond the outer edges of the Color Gradient spectrum.
      else if (reverseScrollOn == true) {
        if (c1a < c2a) { // 25 < 100 
          if (v1 > v1NewMax) {
            v1 -= v1Incr;
            
            if (v1 <= 0) {
              v1 += 100;
            }
          }
          
          else if (v1 < v1NewMax) {
            v1 += v1Incr;
            
            if (v1 >= 100) {
              v1 -= 100;
            }
          }
        }
        
        else if (c1a > c2a) { // 100 > 25 
          if (v1 < v1NewMax) {
            v1 += v1Incr;
            
            if (v1 >= 100) {
              v1 -= 100;
            }
          }
          
          else if (v1 > v1NewMax) {
            v1 -= v1Incr;
            
            if (v1 <= 0) {
              v1 += 100;
            }
          }
        }
        
        if (c1b < c2b) { // 25 < 100 
          if (v2 < v2NewMax) {
            v2 += v2Incr;
          }
          
          else if (v2 > v2NewMax) {
            v2 -= v2Incr;
          }
        }
        
        else if (c1b > c2b) { // 100 > 25 
          if (v2 < v2NewMax) {
            v2 += v2Incr;
          }
          
          else if (v2 > v2NewMax) {
            v2 -= v2Incr;
          }
        }
        
        if (c1c < c2c) { // 25 < 100 
          if (v3 < v3NewMax) {
            v3 += v3Incr;
          }
          
          else if (v3 > v3NewMax) {
            v3 -= v3Incr;
          }
        }
        
        else if (c1c > c2c) { // 100 > 25 
          if (v3 < v3NewMax) {
            v3 += v3Incr;
          }
          
          else if (v3 > v3NewMax) {
            v3 -= v3Incr;
          }
        }
        
        if (c1alpha < c2alpha) { // 25 < 100 
          if (vAlpha < vAlphaNewMax) {
            vAlpha += vAlphaIncr;
          }
          
          else if (vAlpha > vAlphaNewMax) {
            vAlpha -= vAlphaIncr;
          }
        }
        
        else if (c1alpha > c2alpha) { // 100 > 25 
          if (vAlpha < vAlphaNewMax) {
            vAlpha += vAlphaIncr;
          }
          
          else if (vAlpha > vAlphaNewMax) {
            vAlpha -= vAlphaIncr;
          }
        }
      }
    }
    
    // If colorPercentMode is set to False, then we'll adjust all vX color values between their respective c1x & c2x parameters.
    else if (colorPercentMode == false) {
      // If advanceColorValues is set to True, we want to advance all of currentColor's color values by one increment towards clr2's color values.
      if (advanceColorValues == true) {
        if (c1a > c2a) {
          if (v1 > c2a) {
            v1 -= v1Incr;
          }
          
          else if (v1 < c2a) {
            v1 = c2a;
          }
        }
        
        else if (c1a < c2a) {
          if (v1 < c2a) {
            v1 += v1Incr;
          }
          else if (v1 < c2a) {
            v1 = c2a;
          }
        }
        
        if (c1b > c2b) {
          if (v2 > c2b) {
            v2 -= v2Incr;
          }
          
          else if (v2 < c2b) {
            v2 = c2b;
          }
        }
        
        else if (c1b < c2b) {
          if (v2 < c2b) {
            v2 += v2Incr;
          }
          else if (v2 < c2b) {
            v2 = c2b;
          }
        }
        
        if (c1c > c2c) {
          if (v3 > c2c) {
            v3 -= v3Incr;
          }
          
          else if (v3 < c2c) {
            v3 = c2c;
          }
        }
        
        else if (c1c < c2c) {
          if (v3 < c2c) {
            v3 += v3Incr;
          }
          else if (v3 < c2c) {
            v3 = c2c;
          }
        }
        
        if (c1alpha > c2alpha) {
          if (vAlpha > c2alpha) {
            vAlpha -= vAlphaIncr;
          }
          
          else if (vAlpha < c2alpha) {
            vAlpha = c2alpha;
          }
        }
        
        else if (c1alpha < c2alpha) {
          if (vAlpha < c2alpha) {
            vAlpha += vAlphaIncr;
          }
          else if (vAlpha < c2alpha) {
            vAlpha = c2alpha;
          }
        }
      }
      
      // If advanceColorValues is set to False, we want to advance all of currentColor's color values by one increment towards clr1's color values.
      else if (advanceColorValues == false) {
        if (c1a > c2a) {
          if (v1 < c1a) {
            v1 += v1Incr;
          }
          else if (v1 < c1a) {
            v1 = c1a;
          }
        }
        
        else if (c1a < c2a) {
          if (v1 > c1a) {
            v1 -= v1Incr;
          }
          else if (v1 < c1a) {
            v1 = c1a;
          }
        }
        
        if (c1b > c2b) {
          if (v2 < c1b) {
            v2 += v2Incr;
          }
          else if (v2 < c1b) {
            v2 = c1b;
          }
        }
        
        else if (c1b < c2b) {
          if (v2 > c1b) {
            v2 -= v2Incr;
          }
          else if (v2 < c1b) {
            v2 = c1b;
          }
        }
        
        if (c1c > c2c) {
          if (v3 < c1c) {
            v3 += v3Incr;
          }
          else if (v3 < c1c) {
            v3 = c1c;
          }
        }
        
        else if (c1c < c2c) {
          if (v3 > c1c) {
            v3 -= v3Incr;
          }
          else if (v3 < c1c) {
            v3 = c1c;
          }
        }
        
        if (c1alpha > c2alpha) {
          if (vAlpha < c1alpha) {
            vAlpha += vAlphaIncr;
          }
          else if (vAlpha < c1alpha) {
            vAlpha = c1alpha;
          }
        }
        
        else if (c1alpha < c2alpha) {
          if (vAlpha > c1alpha) {
            vAlpha -= vAlphaIncr;
          }
          else if (vAlpha < c1alpha) {
            vAlpha = c1alpha;
          }
        }
      }
    }
  }
  
  // This function will set advanceColorValues to True because the triggering event has occurred.
  void advanceColor() {
    advanceColorValues = true;
  }
  
  // This function will set advanceColorValues to False because the triggering event has NOT occurred.
  void resetColor() {
    advanceColorValues = false;
  }
//--------------------------------------------------------------------------
// END OF Functions
//--------------------------------------------------------------------------
}
