// This class will be used to generate a single Frequency Bar for each of the Frequency Spectrum's vertical stripes.
public class FreqBar {
  boolean isVisible = true; // This variable will be used to set whether or not this Frequency Bar is visible.
  int startX, startY; // These variables will store the starting end coordinates for our Frequency Bar.
  int stopX, stopY; // These variables will store the stopping end coordinates for our Frequency Bar.
  color barColor; // This will store the color values of the Frequency Bar.
  
  // Define constructor.
  FreqBar(int xStart, int yStart, color colorBar, boolean visibility) {
    startX = xStart;
    stopX = startX; // The default value for stopX is set to be equal to startX.
    startY = yStart;
    stopY = startY; // The default value for stopY is set to be equal to startY.
    barColor = colorBar;
    isVisible = visibility;
  }
  
  // This function displays this Frequency Bar on the Display Window at its designated location & color. 
  void display() {
    if (isVisible == true) {
      stroke(barColor);
    }
    else {
      noStroke();
    }
    
    line(startX, startY, stopX, stopY); // Now we finally render our Frequency Bar.
  }
  
  // The refresh() method will update this Frequency Bar's stopping end location. 
  void refresh(int newStopX, int newStopY) {
    stopX = newStopX;
    stopY = newStopY;
  }
}
