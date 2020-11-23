class ColorScroller4 {
  // Define Class Parameters:
  int clrMode; // Specifies if colorMode() is set to RGB or HSB.
  float newColorMultiplier = 1.0; // Used to specify the percentile to be scrolled to when colorPercentMode is set to True. // = 0.5;
  float oldColorMultiplier = 1.0; // Used to specify the previous percentile to be scrolled to when colorPercentMode is set to True in the last cycle. // = 0.5;
  float cycleLength; // Used to define the increments that currentColor//s color values will be advanced every Update() cycle. Entered in BPM

  float c1a, c1b, c1c, c1alpha; // clr1 Color Values.
  float c2a, c2b, c2c, c2alpha; // clr2 Color Values.
  float v1, v2, v3, vAlpha; // Current Color Values.
  float v1Incr, v2Incr, v3Incr, vAlphaIncr;
  float v1NewMax, v2NewMax, v3NewMax, vAlphaNewMax; // This will be the new target vMax color values.
  float v1OldMax, v2OldMax, v3OldMax, vAlphaOldMax; // These are the last set of vMax color values from the last cycle.
  
  color clr1, clr2, currentColor;
//  clr1 = color(25, 100, 100, 0);
//  clr2 = color(100, 25, 100, 100);

  boolean colorPercentMode; // Determines if the Color Scroller is to use a percentile to scroll between clr1 and clr2. // = true;
  boolean advanceColorValues = false; // Determines if the Color Scroller is to advance the color values from clr1 towards clr2 or vice-versa. // = true;
  
  // Define Constructor.
  ColorScroller4 (int modeColor, color color1, color color2, float lengthCycle, boolean PercentModeOn) {
    clrMode = modeColor;
    clr1 = color1;
    clr2 = color2;
    cycleLength = lengthCycle;
//    cycleLength = ((60 / lengthCycle) * 60); // Translates BPM into frames per second.
    colorPercentMode = PercentModeOn;
    
    // Assign the c1a & c2a color value parameters based on clrMode//s value.
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
    
    // If colorPercentMode is set to False, then we'll calculate the values for our vIncr variables.
    if (colorPercentMode == false) {
      // Define the vIncr incremental variables.
      v1Incr = abs((c1a - c2a) / cycleLength);
      v2Incr = abs((c1b - c2b) / cycleLength);
      v3Incr = abs((c1c - c2c) / cycleLength);
      vAlphaIncr = abs((c1alpha - c2alpha) / cycleLength);
    }
  }
  
  // This function will redefine the cycleLength variable's value.
  void redefineCycleLength(float newCycleLength) {
    cycleLength = newCycleLength;
  }
  
  // This function will take in a new percentage value, and then recalculate all of its relevant parameters// values.
  void getPercentValue(float newPercent) {
    // This function should only work when colorPercentMode is set to True.
    if (colorPercentMode == true) {
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
  }
  
  // This function will update the vX color values by one increment based on whether or not colorPercentMode is set to True. 
  void update() {
    if (colorPercentMode == true) {
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
  
  // This method will redefine clr1's & clr2's color values based on the input color values. 
  void redefineColors(color color1, color color2) {
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
  }
  
  // This function will return the color value that the ColorScroller4 is currently set to.
  color getColor() {
    currentColor = color(v1, v2, v3, vAlpha);
    return currentColor;
  }
}
