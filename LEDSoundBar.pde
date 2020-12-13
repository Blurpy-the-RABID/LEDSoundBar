import processing.sound.*;

// Display Window variables
int ledBarHeight = 30; // This represents the height of the LED Bar that's located at the top of the Display Window.
int vizAreaHeight = 480; // This represents the height of the Visualization Area that's located below the LED Bar.
int DispWinHeight = (ledBarHeight + vizAreaHeight); // This is the total height of the Display Window.  

// Frame Rate variables
float bpm = 64;
float fps = (3600 / bpm);
int cycleLength = int(fps); // This variable will be used to set how many frames will make up a single refresh cycle.
int currentFrCnt = 0; // This variable will be used to count alongside of frameCount to track when a refresh cycle should restart.
// BPM to FPS Formula:  FPS = (3600 / BPM)
// 150 BPM = 24 FPS
// 146 BPM = 24.658 (aka 25) FPS
// 140 BPM = 25.714 (aka 26) FPS
// 120 BPM = 30 FPS
// 60 BPM = 60 FPS

// Color variables
int Y_AXIS = 1; // Top to bottom gradient.
int X_AXIS = 2; // Left to right gradient.
color ledBG; // LED Bar Background color.
color vizBG; // Visualization Area Background color.
color fillColor; // Fill color.
int clrMode = HSB;
//int clrMode = RGB;
float colorRange = 100;
float rectStartBtm = 0;
float rectStartTop = 0;
color inter12, inter23, inter34, inter14;

//=============================================================
// EFFECTS/EVENTS-RELATED VARIABLES
//=============================================================
color clr1, clr2, clr3, clr4, clr5, clr6, clr7, clr8, clr9, clr10, clr11, clr12, clr13, clr14, clr15, clr16, clr17, clr18, clr19, clr20, clr21, clr22, clr23, clr24, clr25, clr26, clr27, clr28, clr29, clr30, clr31, clr32, clr33, clr34, clr35, clr36, clr37, clr38, clr39, clr40, clr41, clr42, clr43, clr44; // HSB colors
color r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12; // RGB colors
//ColorScroller4 clrScr1, clrScr2, clrScr3, clrScr4, clrScr5, clrScr6, subClrScr1, subClrScr2, subClrScr3; // ColorScroller4 colors
ColorScroller5 clrScr1, clrScr2, clrScr3, clrScr4, clrScr5, clrScr6, subClrScr1, subClrScr2, subClrScr3; // ColorScroller5 colors
boolean LEDBarOn = true; // This will be used to turn off the LED Bar whenever the Backspace key is pressed.

// FX_Pulse variables
FX_Pulse pulse1, pulse2, pulse3, pulse4, pulse5, pulse6, pulse7, pulse8;
FX_Pulse_S sPulse1, sPulse2, sPulse3, sPulse4;
boolean pulse_On = false; // Toggles the FX_Pulse objects on and off with the press of the P key.
int pulse1SizeX, pulse1SizeY;

// clrX color box location & size variables
int clrBoxLocX = 350;
int clrBoxLocY = 75;
int clrBoxSizeX = 20;
int clrBoxSizeY = 20;

// The following color variables will be set to the current value between their corellating sub-colors.
color clickColor1, clickColor2, clickColor3;

// The following colors will be used to select each clickColor's alternating colors.
color clickColor1a, clickColor1b, clickColor2a, clickColor2b, clickColor3a, clickColor3b;

// This variable will be used to scroll between 0 and 1 based on the current cycleLength value, and will assist subClrScr1/2/3 in switching between their two
// correlating colors.
float subColorPercent = 0.0;
float subColorStep = 0.25; // This will store the value of what one advancing step should be for subColorPercent based on the current cycleLength value.

// This will be used to count when a normal cycleLength has lapsed; when one cycleLength lapses, this variable increases by 1.  When this variable counts to
// 4, it resets to zero.
int subColorCount = 0;

// This variable will be used to detect whether we're to increase or decrease the value of subColorPercent by one step.
boolean subColorAdvance = true;

// The following boolean variables will keep track of which alternating color is to be selected with the correlating mouse button clicks. 
boolean clickColor1Mode = false; // When set to false, clickColor1a will be set when MOUSE1 is clicked on a color; when set to true, clickColor1b will be set when MOUSE1 is clicked on a color.
boolean clickColor2Mode = false; // When set to false, clickColor2a will be set when MOUSE2 is clicked on a color; when set to true, clickColor2b will be set when MOUSE2 is clicked on a color.
boolean clickColor3Mode = false; // When set to false, clickColor3a will be set when MOUSE3 is clicked on a color; when set to true, clickColor2b will be set when MOUSE3 is clicked on a color.

// This will be used to toggle Smooth Gradient Mode on/off when the S key is pressed.
boolean smoothGradOn = false;

// gradBox location & size variables
int gradBoxLocX = 400;
int gradBoxLocY = 200;
int gradBoxSizeX = 40;
int gradBoxSizeY = 20;

float flickerClr1, flickerClr2, flickerClr3, minA, maxA;
float pt1a, pt1b, pt1c, pt1d, rectWidth, rectHeight;
color flickerColor;
int flickerCountBtm, flickerCountTop;
CandleFlicker[] flickerArray1;
CandleFlicker[] flickerArray2;
CandleFlicker flickerTest1;
boolean flicker_On = true; // Toggles the CandleFlicker objects on and off with the press of the C key.

Beat_Bar BeatBar1;
Beat_Bar BeatBar2;
boolean beatBarsOn = true; // Toggles the Beat_Bar objects on and off with the press of the B key.

color blinkOffColor, blinkSq1Color, blinkSq2Color, blinkSq3Color, blinkSq4Color;
Blinker_Square blinkSq1, blinkSq2, blinkSq3, blinkSq4;
Blinker_Square[] topBlinkArray;
Blinker_Square[] bottomBlinkArray;
boolean blinkerSq_On = false; // Toggles the Blinker_Square[] array objects on and off with the press of the V key.
//=============================================================
// END OF EFFECTS/EVENTS-RELATED VARIABLES
//=============================================================

//=============================================================
// BRIGHTNESS CONTROLLER OBJECT VARIABLES
//=============================================================
// Define Brightness Controller object.
BriteCtrl briteness;
//=============================================================
// END OF BRIGHTNESS CONTROLLER OBJECT VARIABLES
//=============================================================

//=============================================================
// SOUND-RELATED VARIABLES
//=============================================================
final int BANDS = 256; // Number of BANDS in the FFT spectrum  (512 looks good on visual inspection and seems to perform well)
final int DESIRED = 8; // Desired portion of the FFT spectrum to inspect and display
float BANDSWidth; // This variable will represent how wide each stripe in the Frequency Spectrum will be.
final float[] spectrum = new float[BANDS]; // Field to store the FFT spectrum.
FreqBar[] freqBars; // Declare  our Frequency Bar array.
color barColor; // Color of our Frequency Bars.

float[] hiValues = new float[10]; // The following array will be used for storing the stopY values of the first set of 10 Frequency Bars.
float[] midValues = new float[10]; // The following array will be used for storing the stopY values of the second set of  10 Frequency Bars.
float[] lowValues = new float[10]; // The following array will be used for storing the stopY values of the third set of 10 Frequency Bars.

float hiAvg = 0; // This variable will be used to store the average frequency height of the High range frequencies.
float midAvg = 0; // This variable will be used to store the average frequency height of the Mid range frequencies.
float lowAvg = 0; // This variable will be used to store the average frequency height of the Low range frequencies.
float totalAvg; // This variable will be used to store the average frequency heights of the High, Mid, and Low range frequencies.

int hiFreqMagnify = 1; // This variable will be used to magnify the value of hiAvg.
int midFreqMagnify = 3; // This variable will be used to magnify the value of midAvg.
int lowFreqMagnify = 4; // This variable will be used to magnify the value of lowAvg.

// Mic input and FFT analyzer objects
AudioIn mic = new AudioIn(this, 0);
FFT transform = new FFT(this, BANDS);
Amplitude amp = new Amplitude(this);

// The following boolean variables will be used to set what the Outer Gradient element in the LED Bar is set to respond to (high/mid/low freq. ranges).
boolean hiMidLowModeOn = true; // Press the 1 key to toggle on/off.
boolean hiLowMidModeOn = false; // Press the 2 key to toggle on/off.
boolean midHiLowModeOn = false; // Press the 3 key to toggle on/off.
boolean midLowHiModeOn = false; // Press the 4 key to toggle on/off.
boolean lowMidHiModeOn = false; // Press the 5 key to toggle on/off.
boolean lowHiMidModeOn = false; // Press the 6 key to toggle on/off.
boolean avgModeOn = false; // Press the 7 key to toggle on/off.
//=============================================================
// END OF SOUND-RELATED VARIABLES
//=============================================================

//=============================================================
// LED-RELATED VARIABLES
//=============================================================
// Open Pixel Control
OPC opc;

// The Bottom LED strip consists of LEDs #0 thru #255, with LEDs #28 thru #63 missing from the LED Strip plugged into Port 0 (i.e. LED Strip #1).
// The Top LED strip consists of LEDs #256 thru #511, with LEDs #284 thru #320 missing from the LED Strip plugged into Port 4 (i.e. LED Strip #5).

// Declare variables.
int strip1LEDCnt = 28; // This represents the quantity of LEDs present in LED Strip #1 (which is plugged into Port #0).
int strip5LEDCnt = 28; // This represents the quantity of LEDs present in LED Strip #5 (which is plugged into Port #4).
int maxStripLEDCnt = 64; // This represents the max number of LEDs present in any given LED strip.

int btmLEDCnt = (maxStripLEDCnt * 4); // Number of bottom LED sensors, which will be numbered from 0 thru (btmLEDCnt - 1) in the ledStrip array. (=256)
int topLEDCnt = (maxStripLEDCnt * 4); // Number of top LED sensors, which will be numbered starting at (value of topLEDCnt) in the ledStrip array. (=256)

int totalBtmLEDCnt = (btmLEDCnt - (maxStripLEDCnt - strip1LEDCnt)); // This represents the total number of LEDs actually present in the Bottom LED strip. (=220)
int totalTopLEDCnt = (topLEDCnt - (maxStripLEDCnt - strip1LEDCnt)); // This represents the total number of LEDs actually present in the Top LED strip. (=220)

int maxLEDCnt = (btmLEDCnt + topLEDCnt); // Total possible LED count. (=512)
int totalLEDCnt = (totalBtmLEDCnt + totalTopLEDCnt); // Total LED count, minus the missing LEDs in Strip #1. (=440)
float ledSpacing; // This will be used to calculate the spacing in between every LED sensor.

int btmLEDStopNum = strip1LEDCnt; // (= LED #28)
int btmLEDStartNum = maxStripLEDCnt; // (= LED #64)

int topLEDStopNum = (btmLEDCnt + strip5LEDCnt); // (= LED #284)
int topLEDStartNum = (btmLEDCnt + maxStripLEDCnt); // (= LED #320)

float ledBarDiv = 0.16666666666666667; // This variable is used to set the size of the experimental LED Bar gradients.
//=============================================================
// END OF LED-RELATED VARIABLES
//=============================================================
//===================================================================================================================================================================

void setup() {
  // The top 25 pixel-high area of the Display Window will be used for the LED sensors.  The bottom 480 pixel-high area will be for the Visualizations.
  size(1024, 505);
  colorMode(clrMode, 100);
  
//=============================================================
// START OF EFFECTS/EVENTS-RELATED VARIABLE DEFINITIONS
//=============================================================
  clickColor1 = color(0, 100, 100, 100);
  clickColor1a = color(0, 100, 100, 100);
  clickColor1b = color(10, 100, 100, 100);
  
  clickColor2 = color(34, 100, 100, 100);
  clickColor2a = color(34, 100, 100, 100);
  clickColor2b = color(44, 100, 100, 100);
  
  clickColor3 = color(67, 100, 100, 100);
  clickColor3a = color(67, 100, 100, 100);
  clickColor3b = color(77, 100, 100, 100);
  
  //rX RGB color definitions.
  r1 = color(100, 0, 0, 0);
  r2 = color(100, 0, 0, 100);
  r3 = color(100, 43 , 0, 100);
  r4 = color(80, 100, 0, 100);
  r5 = color(20, 100, 0, 100);
  r6 = color(0, 100, 41, 100);
  r7 = color(0, 99, 100, 100);
  r8 = color(0, 39, 100, 100);
  r9 = color(21, 0, 100, 100);
  r10 = color(81, 0, 100, 100);
  r11 = color(100, 0, 58, 100);
  r12 = color(100, 0, 0, 100);
  
  // clrX HSB color definitions.
  clr1 = color(0, 100, 100, 100);
  clr2 = color(10, 100, 100, 100);
  clr3 = color(20, 100, 100, 100);
  clr4 = color(30, 100, 100, 100);
  clr5 = color(40, 100, 100, 100);
  clr6 = color(50, 100, 100, 100);
  clr7 = color(60, 100, 100, 100);
  clr8 = color(70, 100, 100, 100);
  clr9 = color(80, 100, 100, 100);
  clr10 = color(90, 100, 100, 100);
  clr11 = color(99, 100, 100, 100);
  
  clr12 = color(0, 100, 100, 75);
  clr13 = color(10, 100, 100, 75);
  clr14 = color(20, 100, 100, 75);
  clr15 = color(30, 100, 100, 75);
  clr16 = color(40, 100, 100, 75);
  clr17 = color(50, 100, 100, 75);
  clr18 = color(60, 100, 100, 75);
  clr19 = color(70, 100, 100, 75);
  clr20 = color(80, 100, 100, 75);
  clr21 = color(90, 100, 100, 75);
  clr22 = color(99, 100, 100, 75);
  
  clr23 = color(0, 100, 100, 50);
  clr24 = color(10, 100, 100, 50);
  clr25 = color(20, 100, 100, 50);
  clr26 = color(30, 100, 100, 50);
  clr27 = color(40, 100, 100, 50);
  clr28 = color(50, 100, 100, 50);
  clr29 = color(60, 100, 100, 50);
  clr30 = color(70, 100, 100, 50);
  clr31 = color(80, 100, 100, 50);
  clr32 = color(90, 100, 100, 50);
  clr33 = color(99, 100, 100, 50);
  
  clr34 = color(0, 100, 100, 25);
  clr35 = color(10, 100, 100, 25);
  clr36 = color(20, 100, 100, 25);
  clr37 = color(30, 100, 100, 25);
  clr38 = color(40, 100, 100, 25);
  clr39 = color(50, 100, 100, 25);
  clr40 = color(60, 100, 100, 25);
  clr41 = color(70, 100, 100, 25);
  clr42 = color(80, 100, 100, 25);
  clr43 = color(90, 100, 100, 25);
  clr44 = color(99, 100, 100, 25);
  
  // Define FX_Pulse objects.
  pulse1SizeX = ((width / cycleLength) * 4);
  pulse1SizeY = 10;
  color pulseClr2 = color (0, 0, 0, 10);
  
  // Define FX_Pulse objects.
  pulse1 = new FX_Pulse((bpm * 1), clickColor3, (0 - pulse1SizeX), 0, (width + pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, true);
  pulse2 = new FX_Pulse((bpm * 1), clickColor3, (width + pulse1SizeX), 0, (0 - pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, false);
  pulse3 = new FX_Pulse((bpm * 1), clickColor3, (0 - pulse1SizeX), pulse1SizeY, (width + pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, true);
  pulse4 = new FX_Pulse((bpm * 1), clickColor3, (width + pulse1SizeX), pulse1SizeY, (0 - pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, false);
  
  pulse5 = new FX_Pulse((bpm * 0.5), pulseClr2, (0 - pulse1SizeX), 0, (width + pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, true);
  pulse6 = new FX_Pulse((bpm * 0.5), pulseClr2, (width + pulse1SizeX), 0, (0 - pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, false);
  pulse7 = new FX_Pulse((bpm * 0.5), pulseClr2, (0 - pulse1SizeX), pulse1SizeY, (width + pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, true);
  pulse8 = new FX_Pulse((bpm * 0.5), pulseClr2, (width + pulse1SizeX), pulse1SizeY, (0 - pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, false);
  // FX_Pulse(int beatsPerMin, color pColor, int xStart, int yStart, int xEnd, int yEnd, float pWidth, float pHeight, boolean LtoR)
  
  // Define FX_Pulse_S objects.
//  sPulse1 = new FX_Pulse_S((bpm * 1), clickColor1, clickColor3, 100, 100, 300, 100, pulse1SizeX, pulse1SizeY, true);
  sPulse1 = new FX_Pulse_S((bpm * 0.5), clickColor1, clickColor2, (0 - pulse1SizeX), 0, (width + pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, true);
  sPulse2 = new FX_Pulse_S((bpm * 0.5), clickColor1, clickColor2, (width + pulse1SizeX), 0, (0 - pulse1SizeX), 0, pulse1SizeX, pulse1SizeY, false);
  sPulse3 = new FX_Pulse_S((bpm * 0.5), clickColor1, clickColor3, (0 - pulse1SizeX), pulse1SizeY, (width + pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, true);
  sPulse4 = new FX_Pulse_S((bpm * 0.5), clickColor1, clickColor3, (width + pulse1SizeX), pulse1SizeY, (0 - pulse1SizeX), pulse1SizeY, pulse1SizeX, pulse1SizeY, false);
  // FX_Pulse_S(float beatsPerMin, color pColorA, color pColorB, int xStart, int yStart, int xEnd, int yEnd, float pWidth, float pHeight, boolean LtoR)
  
  //// Define ColorScroller4 objects.
  //clrScr1 = new ColorScroller4(clrMode, clr2, clr11, cycleLength * 1, true); // Almost full color spectrum.  Uncomment this line for the default color setting.
  //clrScr2 = new ColorScroller4(clrMode, clr17, clr16, cycleLength * 1, true); // Original setting of Blue & Violet appearing at side edges of LED Bar.
  //clrScr3 = new ColorScroller4(clrMode, clr9, clr10, cycleLength * 1, true);
  
  //// This if-else statement tests out how things would look using RGB instead of HSB.  It looks like ass.
  //if (clrMode == RGB) {
  //  clrScr4 = new ColorScroller4(clrMode, r2, r5, cycleLength * 1, true);
  //  clrScr5 = new ColorScroller4(clrMode, r8, clrScr4.getColor(), cycleLength * 1, true);
  //  clrScr6 = new ColorScroller4(clrMode, clrScr5.getColor(), r2, cycleLength * 1, true);
    
  //  subClrScr1 = new ColorScroller4(clrMode, clickColor1a, clickColor1b, cycleLength * 1, true);
  //  subClrScr2 = new ColorScroller4(clrMode, clickColor2a, clickColor2b, cycleLength * 1, true);
  //  subClrScr3 = new ColorScroller4(clrMode, clickColor3a, clickColor3b, cycleLength * 1, true);
  //}
  //else {
  //  clrScr4 = new ColorScroller4(clrMode, clr2, clickColor1, cycleLength * 1, true);
  //  clrScr5 = new ColorScroller4(clrMode, clrScr4.getColor(), clickColor2, cycleLength * 1, true);
  //  clrScr6 = new ColorScroller4(clrMode, clrScr5.getColor(), clickColor3, cycleLength * 1, true);
    
  //  subClrScr1 = new ColorScroller4(clrMode, clickColor1a, clickColor1b, cycleLength * 1, true);
  //  subClrScr2 = new ColorScroller4(clrMode, clickColor2a, clickColor2b, cycleLength * 1, true);
  //  subClrScr3 = new ColorScroller4(clrMode, clickColor3a, clickColor3b, cycleLength * 1, true);
  
    // Define ColorScroller5 objects.
  clrScr1 = new ColorScroller5(clrMode, clr2, clr11, cycleLength * 1, true); // Almost full color spectrum.  Uncomment this line for the default color setting.
  clrScr2 = new ColorScroller5(clrMode, clr17, clr16, cycleLength * 1, true); // Original setting of Blue & Violet appearing at side edges of LED Bar.
  clrScr3 = new ColorScroller5(clrMode, clr9, clr10, cycleLength * 1, true);
  
  // This if-else statement tests out how things would look using RGB instead of HSB.  It looks like ass.
  if (clrMode == RGB) {
    clrScr4 = new ColorScroller5(clrMode, r2, r5, cycleLength * 1, true);
    clrScr5 = new ColorScroller5(clrMode, r8, clrScr4.getColor(), cycleLength * 1, true);
    clrScr6 = new ColorScroller5(clrMode, clrScr5.getColor(), r2, cycleLength * 1, true);
    
    subClrScr1 = new ColorScroller5(clrMode, clickColor1a, clickColor1b, cycleLength * 1, true);
    subClrScr2 = new ColorScroller5(clrMode, clickColor2a, clickColor2b, cycleLength * 1, true);
    subClrScr3 = new ColorScroller5(clrMode, clickColor3a, clickColor3b, cycleLength * 1, true);
  }
  else {
    clrScr4 = new ColorScroller5(clrMode, clr2, clickColor1, cycleLength * 1, true);
    clrScr5 = new ColorScroller5(clrMode, clrScr4.getColor(), clickColor2, cycleLength * 1, true);
    clrScr6 = new ColorScroller5(clrMode, clrScr5.getColor(), clickColor3, cycleLength * 1, true);
    
    subClrScr1 = new ColorScroller5(clrMode, clickColor1a, clickColor1b, cycleLength * 1, true);
    subClrScr2 = new ColorScroller5(clrMode, clickColor2a, clickColor2b, cycleLength * 1, true);
    subClrScr3 = new ColorScroller5(clrMode, clickColor3a, clickColor3b, cycleLength * 1, true);
  }
  
  // Define Beat_Bar objects.
  BeatBar1 = new Beat_Bar(clickColor2, (width / 2), 0, 1, 30, (width / 2), 30, (cycleLength), false);
  BeatBar2 = new Beat_Bar(clickColor2, (width / 2), 0, (-1), 30, ((width / 2) * (-1)), 30, (cycleLength), true);
  //Beat_Bar (color colorFill, int xLoc, int yLoc, int xMin, int yMin, int xMax, int yMax, float lengthCycle, boolean reversed)

//=========================================================================
// START OF Blinker_Square Setup
//=========================================================================  
  // The following variables will be used to draw out the bottomBlinkArray[] elements.
  int blinkPt1a = 0;
  int blinkPt1b = 12;
  int blinkWidth = 5;
  int blinkHeight = 10;
  float blinkStartBtm = rectStartBtm;
  int blinkPattern = 1; // Used to count which color configuration to assign to each bottomBlinkArray[] element.
  
  // Define Blink_Square colors.
  blinkOffColor = color(0,0,0,0);
  blinkSq1Color = color(0,100,100,100);
  blinkSq2Color = color(25,100,100,100);
  blinkSq3Color = color(50,100,100,100);
  blinkSq4Color = color(75,100,100,100);
  
  // Define Blinker_Square test objects.
  blinkSq1 = new Blinker_Square(blinkOffColor, blinkSq1Color, 450, 350, 20, 20, cycleLength, 0.25, 1, false);
  blinkSq2 = new Blinker_Square(blinkOffColor, blinkSq2Color, 470, 350, 20, 20, cycleLength, 0.25, 2, false);
  blinkSq3 = new Blinker_Square(blinkOffColor, blinkSq3Color, 490, 350, 20, 20, cycleLength, 0.25, 3, false);
  blinkSq4 = new Blinker_Square(blinkOffColor, blinkSq4Color, 510, 350, 20, 20, cycleLength, 0.25, 4, false);
  //Blinker_Square (color colorOff, color colorOn, int coordX, int coordY, int dimX, int dimY, float lengthCycle, float percentBlink, int delayRender, boolean reverseMode)
  
  // Define Blinker_Square[] arrays.
  topBlinkArray = new Blinker_Square[totalTopLEDCnt]; // 220 LEDs
  bottomBlinkArray = new Blinker_Square[totalBtmLEDCnt]; // 220 LEDs
  
  // Define each Blinker_Square element within the bottomBlinkArray[] array.
  for(int i = 0; i < bottomBlinkArray.length; i++) {
    /// Reset blinkPattern to 1 if it's currently greater than 4.
    if (blinkPattern > 4) {
      blinkPattern = 1;
    }
    
    // Define the bottomBlinkArray[] element's rect() coordinates.
    blinkPt1a = int(blinkStartBtm);
    
    switch (blinkPattern) {
      case 1:
        bottomBlinkArray[i] = new Blinker_Square(blinkOffColor, blinkSq1Color, blinkPt1a, blinkPt1b, blinkWidth, blinkHeight, cycleLength, 0.25, blinkPattern, false);      
        break;
      case 2:
        bottomBlinkArray[i] = new Blinker_Square(blinkOffColor, blinkSq2Color, blinkPt1a, blinkPt1b, blinkWidth, blinkHeight, cycleLength, 0.25, blinkPattern, false);
        break;
      case 3:
        bottomBlinkArray[i] = new Blinker_Square(blinkOffColor, blinkSq3Color, blinkPt1a, blinkPt1b, blinkWidth, blinkHeight, cycleLength, 0.25, blinkPattern, false);
        break;
      case 4:
        bottomBlinkArray[i] = new Blinker_Square(blinkOffColor, blinkSq4Color, blinkPt1a, blinkPt1b, blinkWidth, blinkHeight, cycleLength, 0.25, blinkPattern, false);
        break;
    }
    
    // Advance the next bottomBlinkArray[] element's rect() coordinates.
    blinkStartBtm += blinkWidth;
    blinkPattern++;
  }
//=========================================================================
// END OF Blinker_Square Setup
//=========================================================================  

//=============================================================
// END OF EFFECTS/EVENTS-RELATED VARIABLE DEFINITIONS
//=============================================================

//=============================================================
// START OF BRITENESS VARIABLE DEFINITIONS
//=============================================================
// Create the background brightness controller object using the BriteCtrl class.
  briteness = new BriteCtrl(0, 0, 0, 0.0, 0.4, cycleLength, "HSB", 100, false);
//BriteCtrl(color bkRed, color bkGreen, color bkBlue, float brightest, float darkest, int cycleDuration, String modeColor, int scaleColor, boolean briteToDark)
//=============================================================
// END OF BRITENESS VARIABLE DEFINITIONS
//=============================================================

//=============================================================
// START OF SOUND-RELATED VARIABLE DEFINITIONS
//=============================================================
  // start the Audio Input
  mic.start();
  transform.input(mic);
  
  // Create an Input stream which is routed into the Amplitude analyzer
  amp.input(mic);
  
  // Define BANDSWidth.
  BANDSWidth = (BANDS / DESIRED);
  
  // Define the freqBars[] array.
  freqBars = new FreqBar[int(BANDSWidth)];
  
  for(int i = 0; i < BANDSWidth; i++){
    noFill();
    //noStroke();
    stroke(0,0,0); // Comment out this line to hide the Frequency Spectrum's vertical stripes.
    strokeWeight(BANDSWidth);
    freqBars[i] = new FreqBar(int(i * (BANDSWidth)), height, barColor, true); // Define each Frequency Bar within the freqBars[] array.
  }
//=============================================================
// END OF SOUND-RELATED VARIABLE DEFINITIONS
//=============================================================

  // Define color variables.
  ledBG = color(0, 0, 0); // Black color.
  vizBG = color(0, 0, 100); // White color.
  
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  
  // Define ledSpacing.
  ledSpacing = (width / (totalLEDCnt * 0.5));
  
  // This for() loop will plot out each LED sensor location from right to left, just like how the LED strips are sequenced on the LED tracks.
  // It'll first start with plotting out the bottom LED track's sensors, making sure to skip the Bottom Track's missing LEDs (#28 thru #63).
  // Then it will plot out the top LED track's sensors, making sure to skip the Top Track's missing LEDs (#284 thru #320).
  for(int i = 0, j = 0, k = 0; i < maxLEDCnt; i++){
    // While i is less than the length of LED Strip #1, we'll plot out each LED in sequential order.
    // This if() code block  will place LED sensors for LEDs #0-27.
    if (i < btmLEDStopNum) {
      opc.led(i, (width - (int(ledSpacing * i) + int(ledSpacing))), 15);
      j++;
    }
    
    // We'll skip over LEDs #28 thru 63, and then continue plotting LEDs #64+ right where we left off after LED #27.
    if (i >= btmLEDStopNum && i < btmLEDStartNum) {
      // Do nothing for LEDs #28 thru #63.
    }
    
    // We'll now plot out LEDs #64 through #255.
    if (i >= btmLEDStartNum && i < btmLEDCnt - 1) {
      opc.led(i, (width - (int(ledSpacing * j) + int(ledSpacing))), 15);
      j++;
    }
    
    // Once we reach LED #256, we switch gears and start plotting out the LED sensors for the Top LED track.
    if (i >= (btmLEDCnt - 1) && i < topLEDStopNum) {
      opc.led(i, (width - (int(ledSpacing * k) + int(ledSpacing))), 5);
      j++;
      k++;
    }
    
    // We'll skip over LEDs #284 thru 320, and then continue plotting LEDs #321+ right where we left off after LED #283.
    if (i >= topLEDStopNum && i <= topLEDStartNum) {
      // Do nothing for LEDs #284 thru #320.
    }
    
    // We'll now plot out LEDs #321 through #511.
    if (i > topLEDStartNum) {
      opc.led(i, (width - (int(ledSpacing * k) + int(ledSpacing))), 5);
      j++;
      k++;
    }
  }
  
//=============================================================
// BEGIN CANDLEFLICKER ARRAY DEFINITION
//=============================================================
  // Define CandleFlicker parameters.
  flickerCountBtm = totalBtmLEDCnt;
  flickerCountTop = totalTopLEDCnt;
  flickerClr1 = 0;
  flickerClr2 = 0;
  flickerClr3 = 0;
  minA = 0;
  maxA = 35;
  pt1a = 0;
  pt1b = 12;
  pt1c = 0;
  pt1d = 0;
  //rectWidth = (width / flickerCountBtm);
  rectWidth = 5;
  rectHeight = 10;
  
  // Define the flickerArray1[] array.
  //flickerCountBtm = int(ledSpacing);
  
  //flickerCountBtm = 100;
  flickerArray1 = new CandleFlicker[int(flickerCountBtm)];
  flickerArray2 = new CandleFlicker[int(flickerCountTop)];
  
  // Define each CandleFlicker element within the flickerArray1[] array.
  for(int i = 0; i < flickerCountBtm; i++) {
    pt1a = rectStartBtm;
    rectStartBtm += rectWidth;
    
    flickerArray1[i] = new CandleFlicker(clrMode, colorRange, flickerClr1, flickerClr2, flickerClr3, minA, maxA, pt1a, pt1b, rectWidth, rectHeight, cycleLength);
  }
  
  // Define each CandleFlicker element within the flickerArray2[] array.
  for(int i = 0; i < flickerCountTop; i++) {
    pt1c = rectStartTop;
    rectStartTop += rectWidth;
    
    flickerArray2[i] = new CandleFlicker(clrMode, colorRange, flickerClr1, flickerClr2, flickerClr3, minA, maxA, pt1c, pt1d, rectWidth, rectHeight, cycleLength);
  }
  
  // This variable will be used to display a single large box that flickers like the flickerArrays.
  flickerTest1 = new CandleFlicker(clrMode, colorRange, flickerClr1, flickerClr2, flickerClr3, minA, maxA, 500, 200, 100, 100, cycleLength);
//=============================================================
// END OF CANDLEFLICKER ARRAY DEFINITION
//=============================================================
}
//===================================================================================================================================================================

void draw() {
  noStroke();
//=========================================================================
// Render LED Bar & Visualization Areas
//=========================================================================
  // Define the LED Bar's default background color.
  fill(0, 0, 0, 100);
  rect(0, 0, width, ledBarHeight);
  
  // The following renders the actual LED Bar.
  fill(clrScr1.getColor());
  rect(0, 0, width, ledBarHeight);
  
  // The following two lines will generate the two Low Frequency gradients that creep in from the side edges of the LED Bar.
  setGradient(0, 0, int(width * 0.5), (ledBarHeight), clrScr2.getColor(), clr17, X_AXIS); // Only reaches to the halfway point of the LED Bar.
  setGradient(int(width * 0.5), 0, int(width * 0.5), ledBarHeight, clr17, clrScr2.getColor(), X_AXIS); // Only reaches to the halfway point of the LED Bar.

  // Define the Visualization Area's default background color. 
  fill(vizBG);
  rect(0, (ledBarHeight + 1), width, vizAreaHeight);
  
  // Redefine our experimental ColorScroller4 objects.
  if (smoothGradOn == true) {
    //subClrScr1.redefineColors(clickColor1a, clickColor1b);
    //subClrScr2.redefineColors(clickColor2a, clickColor2b);
    //subClrScr3.redefineColors(clickColor3a, clickColor3b);
    //clrScr4.redefineColors(clickColor1, clickColor2);
    //clrScr5.redefineColors(clrScr4.getColor(), clickColor2);
    //clrScr6.redefineColors(clrScr5.getColor(), clickColor3);
    subClrScr1.setColors(clickColor1a, clickColor1b);
    subClrScr2.setColors(clickColor2a, clickColor2b);
    subClrScr3.setColors(clickColor3a, clickColor3b);
    clrScr4.setColors(clickColor1, clickColor2);
    clrScr5.setColors(clrScr4.getColor(), clickColor2);
    clrScr6.setColors(clrScr5.getColor(), clickColor3);
  }
  
  else if (smoothGradOn == false) {
    //subClrScr1.redefineColors(clickColor1a, clickColor1b);
    //subClrScr2.redefineColors(clickColor2a, clickColor2b);
    //subClrScr3.redefineColors(clickColor3a, clickColor3b);
    //clrScr4.redefineColors(clickColor1, clickColor2);
    //clrScr5.redefineColors(clickColor2, clrScr4.getColor());
    //clrScr6.redefineColors(clickColor3, clrScr5.getColor());
    subClrScr1.setColors(clickColor1a, clickColor1b);
    subClrScr2.setColors(clickColor2a, clickColor2b);
    subClrScr3.setColors(clickColor3a, clickColor3b);
    clrScr4.setColors(clickColor1, clickColor2);
    clrScr5.setColors(clickColor2, clrScr4.getColor());
    clrScr6.setColors(clickColor3, clrScr5.getColor());
  }
  
  // The following lines will define the experimental 6 gradients across the top of the LED Bar, which mirror themselves at the center point of the LED Bar.
  stroke(0, 0, 0);
  setGradient(0, 0, int(width * ledBarDiv), ledBarHeight, clickColor1, clrScr4.getColor(), X_AXIS);
  setGradient(int(width * ledBarDiv), 0, int(width * ledBarDiv), ledBarHeight, clrScr4.getColor(), clrScr5.getColor(), X_AXIS);
  setGradient((int(width * ledBarDiv) * 2), 0, int(width * ledBarDiv), ledBarHeight, clrScr5.getColor(), clrScr6.getColor(), X_AXIS);
  
  // The following 3 gradient definitions mirror the 3 gradients above.
  setGradient((width / 2), 0, int(width * ledBarDiv), ledBarHeight, clrScr6.getColor(), clrScr5.getColor(), X_AXIS);
  setGradient((width / 2) + int(width * ledBarDiv), 0, int(width * ledBarDiv), ledBarHeight, clrScr5.getColor(), clrScr4.getColor(), X_AXIS);
  setGradient((width / 2) + (int(width * ledBarDiv) * 2), 0, int(width * ledBarDiv), ledBarHeight, clrScr4.getColor(), clickColor1, X_AXIS);
//=========================================================================
// END OF Render LED Bar & Visualization Areas
//=========================================================================
  
//=========================================================================
// START OF Beat_Bar Rendering
//=========================================================================
  noStroke();
  // If beatBarsOn is set to true, we render the Beat_Bar objects.
  if (beatBarsOn == true) {
    BeatBar1.redefineColor(clickColor3);
    BeatBar1.render();
    
    BeatBar2.redefineColor(clickColor3);
    BeatBar2.render();
  }
//=========================================================================
// END OF Beat_Bar Rendering
//=========================================================================

//=========================================================================
// START OF Blinker_Square Rendering
//=========================================================================
  blinkSq1.redefineOnColor(clickColor1);
  blinkSq1.render();
  blinkSq1.update(frameCount);
  
  blinkSq2.redefineOnColor(clickColor2);
  blinkSq2.render();
  blinkSq2.update(frameCount);
  
  blinkSq3.redefineOnColor(clickColor3);
  blinkSq3.render();
  blinkSq3.update(frameCount);
  
  blinkSq4.redefineOnColor(clickColor3b);
  blinkSq4.render();
  blinkSq4.update(frameCount);
  
  //=========================================================================
  // START OF Blinker_Square[] ARRAY DISPLAY
  //=========================================================================
    if (blinkerSq_On == true) {
      // Display each element within the bottomBlinkArray[] array.
      for(int i = 0; i < bottomBlinkArray.length; i++) {
        noFill();
        noStroke();
        
        // Identify which delay pattern the current element has been assigned.
        int thisRenderDelay = bottomBlinkArray[i].returnRenderDelay();
        
        switch (thisRenderDelay) {
          case '1':
            bottomBlinkArray[i].redefineOnColor(clickColor1);
            break;
          case '2':
            bottomBlinkArray[i].redefineOnColor(clickColor2);
            break;
          case '3':
            bottomBlinkArray[i].redefineOnColor(clickColor3);
            break;
          case '4':
            bottomBlinkArray[i].redefineOnColor(clickColor3b);
            break;
        }
        
        bottomBlinkArray[i].redefineCycleLength(cycleLength);
        bottomBlinkArray[i].render();
        bottomBlinkArray[i].update(frameCount);
      }
    }
  //=========================================================================
  // END OF Blinker_Square[] ARRAY DISPLAY
  //=========================================================================
//=========================================================================
// END OF Blinker_Square Rendering
//=========================================================================

//=========================================================================
// START OF clrX Color Sample Grid
//=========================================================================
  // Define hsbArray.
  int[] hsbArray = {clr1, clr2, clr3, clr4, clr5, clr6, clr7, clr8, clr9, clr10, clr11, clr12, clr13, clr14, clr15, clr16, clr17, clr18, clr19, clr20, clr21, clr22, clr23, clr24, clr25, clr26, clr27, clr28, clr29, clr30, clr31, clr32, clr33, clr34, clr35, clr36, clr37, clr38, clr39, clr40, clr41, clr42, clr43, clr44};
  
  // Draw a black box background for the darker shades of the Color Sample Grid.
  fill(0, 0, 0, 100);
  noStroke();
  rect(((clrBoxLocX * 2) + clrBoxSizeX), (clrBoxLocY * 1), clrBoxSizeX * 11, clrBoxSizeY * 4);
  
  //-----------------------------------------------------------------
  // START OF Solid-to-Light Color Sample Grid
  //-----------------------------------------------------------------
  // 100% Opacity
  for (int i = 0; i < 11; i++) {
    fill(hsbArray[i]);
    rect(clrBoxLocX + (clrBoxSizeX * (i + 1)), clrBoxLocY, clrBoxSizeX, clrBoxSizeY);
  }
  
  // 75% Opacity
  for (int i = 11; i < 22; i++) {
    fill(hsbArray[i]);
    rect(clrBoxLocX + (clrBoxSizeX * ((i - 11) + 1)), (clrBoxLocY + clrBoxSizeX), clrBoxSizeX, clrBoxSizeY);
  }
  
  // 50% Opacity
  for (int i = 22; i < 33; i++) {
    fill(hsbArray[i]);
    rect(clrBoxLocX + (clrBoxSizeX * ((i - 22) + 1)), (clrBoxLocY + (clrBoxSizeX * 2)), clrBoxSizeX, clrBoxSizeY);
  }
  
  // 25% Opacity
  for (int i = 33; i < hsbArray.length; i++) {
    fill(hsbArray[i]);
    rect(clrBoxLocX + (clrBoxSizeX * ((i - 33) + 1)), (clrBoxLocY + (clrBoxSizeX * 3)), clrBoxSizeX, clrBoxSizeY);
  }
  //-----------------------------------------------------------------
  // END OF Solid-to-Light Color Sample Grid
  //-----------------------------------------------------------------
  
  //-----------------------------------------------------------------
  // START OF Solid-to-Dark Color Sample Grid
  //-----------------------------------------------------------------
  // 100% Opacity
  for (int i = 0; i < 11; i++) {
    fill(hsbArray[i]);
    rect((clrBoxLocX * 2) + (clrBoxSizeX * (i + 1)), clrBoxLocY, clrBoxSizeX, clrBoxSizeY);
  }
  
  // 75% Opacity
  for (int i = 11; i < 22; i++) {
    fill(hsbArray[i]);
    rect((clrBoxLocX * 2) + (clrBoxSizeX * ((i - 11) + 1)), (clrBoxLocY + clrBoxSizeX), clrBoxSizeX, clrBoxSizeY);
  }
  
  // 50% Opacity
  for (int i = 22; i < 33; i++) {
    fill(hsbArray[i]);
    rect((clrBoxLocX * 2) + (clrBoxSizeX * ((i - 22) + 1)), (clrBoxLocY + (clrBoxSizeX * 2)), clrBoxSizeX, clrBoxSizeY);
  }
  
  // 25% Opacity
  for (int i = 33; i < hsbArray.length; i++) {
    fill(hsbArray[i]);
    rect((clrBoxLocX * 2) + (clrBoxSizeX * ((i - 33) + 1)), (clrBoxLocY + (clrBoxSizeX * 3)), clrBoxSizeX, clrBoxSizeY);
  }
  //-----------------------------------------------------------------
  // END OF Solid-to-Dark Color Sample Grid
  //-----------------------------------------------------------------
//=========================================================================
// END OF clrX Color Sample Grid
//=========================================================================
  
//=========================================================================
// START OF gradBox Block Sample Renderings
//=========================================================================
// void setGradient(int x, int y, float w, float h, color c1, color c2, int axis )
  // This is the first large square in the middle of the Vizualization Area where I test my ColorScroller4 objects to create a dynamic linear gradient.
  // The bottom of this box also represents the primary color of the entire LED Bar. 
  setGradient(gradBoxLocX, (gradBoxLocY - gradBoxSizeY), gradBoxSizeX, gradBoxSizeY, clr1, clrScr1.getColor(), Y_AXIS);
    
// The following are the second and third gradient boxes in the middle of the rendering area.
  //clrScr3.redefineColors(clrScr2.getColor(), clr10);
  clrScr3.setColors(clrScr2.getColor(), clr10);
  fill(clrScr2.getColor());
  setGradient((gradBoxLocX + gradBoxSizeX), (gradBoxLocY - gradBoxSizeY), gradBoxSizeX, gradBoxSizeY, clr17, clrScr2.getColor(), X_AXIS);
  setGradient((gradBoxLocX + (gradBoxSizeX * 2)), (gradBoxLocY - gradBoxSizeY), gradBoxSizeX, gradBoxSizeY, clrScr3.getColor(), clr17, X_AXIS);
  
  //-----------------------------------------------------------------
  // START OF Smooth Gradient
  //-----------------------------------------------------------------
  noStroke();
  fill(0,0,0,100);
  rect(gradBoxLocX, gradBoxLocY, gradBoxSizeX * 11, gradBoxSizeY);
  noFill();
  // 50% Darker
  setGradient(gradBoxLocX + (gradBoxSizeX * 0), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr23, clr24, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 1), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr24, clr25, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 2), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr25, clr26, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 3), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr26, clr27, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 4), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr27, clr28, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 5), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr28, clr29, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 6), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr29, clr30, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 7), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr30, clr31, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 8), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr31, clr32, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 9), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr32, clr33, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 10), gradBoxLocY, gradBoxSizeX, gradBoxSizeY, clr33, clr34, X_AXIS);
  
  // 100% Full Color
  setGradient(gradBoxLocX + (gradBoxSizeX * 0), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr1, clr2, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 1), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr2, clr3, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 2), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr3, clr4, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 3), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr4, clr5, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 4), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr5, clr6, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 5), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr6, clr7, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 6), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr7, clr8, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 7), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr8, clr9, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 8), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr9, clr10, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 9), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr10, clr11, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 10), (gradBoxLocY + 20), gradBoxSizeX, gradBoxSizeY, clr11, clr12, X_AXIS);
  
  // 50% Lighter
  fill(0,0,0,0);
  rect(gradBoxLocX, (gradBoxLocY + 40), gradBoxSizeX * 11, gradBoxSizeY);
  noFill();
  setGradient(gradBoxLocX + (gradBoxSizeX * 0), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr23, clr24, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 1), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr24, clr25, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 2), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr25, clr26, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 3), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr26, clr27, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 4), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr27, clr28, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 5), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr28, clr29, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 6), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr29, clr30, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 7), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr30, clr31, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 8), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr31, clr32, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 9), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr32, clr33, X_AXIS);
  setGradient(gradBoxLocX + (gradBoxSizeX * 10), (gradBoxLocY + 40), gradBoxSizeX, gradBoxSizeY, clr33, clr34, X_AXIS);
  //-----------------------------------------------------------------
  // END OF Smooth Gradient
  //-----------------------------------------------------------------

// The following gradBoxes will display what each of the clrScrX objects are doing currently; the top of each box is set to a transparent red color. 
  fill(clrScr1.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 0), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clrScr2.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 1), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clrScr3.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 2), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clrScr4.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 3), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clrScr5.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 4), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clrScr6.getColor());
  rect(gradBoxLocX + (gradBoxSizeX * 5), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  
  fill(clickColor1);
  rect(gradBoxLocX + (gradBoxSizeX * 7), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clickColor2);
  rect(gradBoxLocX + (gradBoxSizeX * 8), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  fill(clickColor3);
  rect(gradBoxLocX + (gradBoxSizeX * 9), (gradBoxLocY + 40) + (gradBoxSizeY * 1), gradBoxSizeX, gradBoxSizeY);
  
  // clickColor Display Boxes
  stroke(0, 0, 0, 100);
  fill(clickColor1a);
  rect(gradBoxLocX + (gradBoxSizeX * 7), (gradBoxLocY + 40) + (gradBoxSizeY * 2), gradBoxSizeX, gradBoxSizeY);
  fill(clickColor1b);
  rect(gradBoxLocX + (gradBoxSizeX * 7), (gradBoxLocY + 40) + (gradBoxSizeY * 3), gradBoxSizeX, gradBoxSizeY);
  
  fill(clickColor2a);
  rect(gradBoxLocX + (gradBoxSizeX * 8), (gradBoxLocY + 40) + (gradBoxSizeY * 2), gradBoxSizeX, gradBoxSizeY);
  fill(clickColor2b);
  rect(gradBoxLocX + (gradBoxSizeX * 8), (gradBoxLocY + 40) + (gradBoxSizeY * 3), gradBoxSizeX, gradBoxSizeY);
  
  fill(clickColor3a);
  rect(gradBoxLocX + (gradBoxSizeX * 9), (gradBoxLocY + 40) + (gradBoxSizeY * 2), gradBoxSizeX, gradBoxSizeY);
  fill(clickColor3b);
  rect(gradBoxLocX + (gradBoxSizeX * 9), (gradBoxLocY + 40) + (gradBoxSizeY * 3), gradBoxSizeX, gradBoxSizeY);
//=========================================================================
// END OF gradBox Block Sample Renderings
//=========================================================================

//=========================================================================
// BEGIN VERTICAL FREQUENCY BANDS RENDERING
//=========================================================================
  // Do the FFT analysis
  transform.analyze(spectrum);
  
  // This for() loop will refresh & display each Frequency Bar based on the FFT analysis.  
  for(int i = 0; i < BANDSWidth; i++) {
    noFill();
    strokeWeight(BANDSWidth);
    freqBars[i].refresh(int(i * (BANDSWidth)), int(height - (spectrum[i] * height))); // Update the stopping end coordinates of each Frequency Bar.
    freqBars[i].display(); // Display each Frequency Bar.
  }
//=========================================================================
// END OF VERTICAL FREQUENCY BANDS RENDERING
//=========================================================================

//=========================================================================
// Frame Counter & Refresh Event Execution
//=========================================================================
  // Draw our stuff
  println(amp.analyze());
  
  fill(0, 0, 0);
  text("BANDS = " + BANDS, 10, 40);
  text("DESIRED = " + DESIRED, 10, 50);
  text("BANDSWidth = " + BANDSWidth, 10, 60);
  
  text("hiAvg = " + hiAvg, 10, 70);
  text("midAvg = " + midAvg, 10, 80);
  text("lowAvg = " + lowAvg, 10, 90);
  text("totalAvg = " + totalAvg, 10, 100);
  
  text("Outer Gradient = clickColor1 <--> clrScr4.getColor()", 10, 110);
  fill(clickColor1);
  text("clickColor1 = " + clickColor1, 10, 120);
  fill(clickColor1a);
  text("clickColor1a = " + clickColor1a, 10, 130);
  fill(clickColor1b);
  text("clickColor1b = " + clickColor1b, 10, 140);
  
  fill(clrScr4.getColor());
  text("clrScr4.getColor() = clickColor1 <--> clickColor2" + clrScr4.getColor(), 10, 150);
  fill(clickColor2);
  text("clickColor2 = " + clickColor2, 10, 160);
  fill(clickColor2a);
  text("clickColor2a = " + clickColor2a, 10, 170);
  fill(clickColor2b);
  text("clickColor2b = " + clickColor2b, 10, 180);
  
  fill(0, 0, 0);
  text("Middle Gradient = clrScr4.getColor() <--> clrScr5.getColor()", 10, 190);
  fill(clrScr4.getColor());
  text("clrScr4.getColor() = clickColor1 <--> clickColor2" + clrScr4.getColor(), 10, 200);
  fill(clrScr5.getColor());
  text("clrScr5.getColor() = clickColor2 <--> clrScr4.getColor()" + clrScr5.getColor(), 10, 210);
  
  fill(0, 0, 0);
  text("Central Gradient = clrScr5.getColor() <--> clrScr6.getColor()", 10, 220);
  fill(clrScr5.getColor());
  text("clrScr5.getColor() = clickColor2 <--> clrScr4.getColor()" + clrScr5.getColor(), 10, 230);
  fill(clrScr6.getColor());
  text("clrScr6.getColor() = clickColor3 <--> clrScr5.getColor()" + clrScr6.getColor(), 10, 240);
  
  fill(clickColor3);
  text("clickColor3 = " + clickColor3, 10, 250);
  fill(clickColor3a);
  text("clickColor3a = " + clickColor3a, 10, 260);
  fill(clickColor3b);
  text("clickColor3b = " + clickColor3b, 10, 270);
  
  fill(0, 0, 0);
  text("hiMidLowModeOn = " + hiMidLowModeOn, 10, 280);
  text("hiLowMidModeOn = " + hiLowMidModeOn, 10, 290);
  text("midLowHiModeOn = " + midLowHiModeOn, 10, 300);
  text("midHiLowModeOn = " + midHiLowModeOn, 10, 310);
  text("lowMidHiModeOn = " + lowMidHiModeOn, 10, 320);
  text("lowHiMidModeOn = " + lowHiMidModeOn, 10, 330);
  text("avgModeOn = " + avgModeOn, 10, 340);
  text("smoothGradOn = " + smoothGradOn, 10, 350);
  
  text("subColorCount = " + subColorCount, 10, 360);
  text("subColorStep = " + subColorStep, 10, 370);
  text("subColorPercent = " + subColorPercent, 10, 380);
  text("subColorAdvance = " + subColorAdvance, 10, 390);
  
  fill(subClrScr1.getColor());
  text("subClrScr1.getColor() = " + subClrScr1.getColor(), 10, 400);
  fill(subClrScr2.getColor());
  text("subClrScr2.getColor() = " + subClrScr2.getColor(), 10, 410);
  fill(subClrScr3.getColor());
  text("subClrScr3.getColor() = " + subClrScr3.getColor(), 10, 420);
  
  fill(0, 0, 0);
  text("BPM = " + bpm, 10, 430);
  text("cycleLength = " + cycleLength, 10, 440);
  
  // The following if statements will update currentFrCnt whenever frameCount advances by 1 frame.
  if (currentFrCnt < frameCount) {
    currentFrCnt++;
    
    // Update all ColorScroller objects every frame.
    clrScr1.update();
    clrScr1.setCycleLength(cycleLength);
//    clrScr1.redefineCycleLength(cycleLength);
    
    clrScr2.update();
    clrScr2.setCycleLength(cycleLength);
//    clrScr2.redefineCycleLength(cycleLength);
    
    clrScr3.update();
    clrScr3.setCycleLength(cycleLength);
//    clrScr3.redefineCycleLength(cycleLength);
    
    clrScr4.update();
    clrScr4.setCycleLength(cycleLength);
//    clrScr4.redefineCycleLength(cycleLength);
    
    clrScr5.update();
    clrScr5.setCycleLength(cycleLength);
//    clrScr5.redefineCycleLength(cycleLength);
    
    clrScr6.update();
    clrScr6.setCycleLength(cycleLength);
//    clrScr6.redefineCycleLength(cycleLength);
    
    // Redefine clickColor1/2/3.
    clickColor1 = subClrScr1.getColor();
    subClrScr1.update();
    subClrScr1.setCycleLength(cycleLength * 1);
//    subClrScr1.redefineCycleLength(cycleLength * 1);
    
    clickColor2 = subClrScr2.getColor();
    subClrScr2.update();
    subClrScr2.setCycleLength(cycleLength * 1);
//    subClrScr2.redefineCycleLength(cycleLength * 1);
    
    clickColor3 = subClrScr3.getColor();
    subClrScr3.update();
    subClrScr3.setCycleLength(cycleLength * 1);
//    subClrScr3.redefineCycleLength(cycleLength * 1);
    
//=========================================================================
// START OF CANDLEFLICKER ARRAY DISPLAY
//=========================================================================
    if (flicker_On == true) {
      // Display each element within the flickerArray1[] array.
      for(int i = 0; i < flickerCountBtm; i++) {
        noFill();
        noStroke();
        flickerArray1[i].display();
      }
      
      // Display each element within the flickerArray2[] array.
      for(int i = 0; i < flickerCountTop; i++) {
        noFill();
        noStroke();
        flickerArray2[i].display();
      }
    }
//=========================================================================
// END OF CANDLEFLICKER ARRAY DISPLAY
//=========================================================================
  }
  
//=========================================================================
// START OF FX_Pulse Object Rendering
//=========================================================================
  // When the User presses the P key, it'll toggle on/off the FX_Pulse objects.
  if (pulse_On == true) {
    pulse1.redefineColor(clickColor2);
    pulse1.refresh();
    pulse1.display();
    
    pulse2.redefineColor(clickColor2);
    pulse2.refresh();
    pulse2.display();
    
    pulse3.redefineColor(clickColor2);
    pulse3.refresh();
    pulse3.display();
    
    pulse4.redefineColor(clickColor2);
    pulse4.refresh();
    pulse4.display();
    //-----------------------------------------------------------------
    // START OF Smooth Pulse Refresh & Display
    //-----------------------------------------------------------------
    
    // Smooth Pulse object refresh & display.
    float pulse1SizeX = ((width / cycleLength) * 4);
    sPulse1.redefineColor(clickColor1, clickColor2);
    sPulse1.redefineBPM(bpm, pulse1SizeX);
    sPulse1.redefineStartEndPts(int(0 - pulse1SizeX), 0, int(width + pulse1SizeX), 0);
    sPulse1.refresh();
    sPulse1.display();
    
    sPulse2.redefineColor(clickColor1, clickColor2);
    sPulse2.redefineBPM(bpm, pulse1SizeX);
    sPulse2.redefineStartEndPts(int(width + pulse1SizeX), 0, int(0 - pulse1SizeX), 0);
    sPulse2.refresh();
    sPulse2.display();
    
    sPulse3.redefineColor(clickColor1, clickColor2);
    sPulse3.redefineBPM(bpm, pulse1SizeX);
    sPulse3.redefineStartEndPts(int(0 - pulse1SizeX), pulse1SizeY, int(width + pulse1SizeX), pulse1SizeY);
    sPulse3.refresh();
    sPulse3.display();
    
    sPulse4.redefineColor(clickColor1, clickColor2);
    sPulse4.redefineBPM(bpm, pulse1SizeX);
    sPulse4.redefineStartEndPts(int(width + pulse1SizeX), pulse1SizeY, int(0 - pulse1SizeX), pulse1SizeY);
    sPulse4.refresh();
    sPulse4.display();
    //-----------------------------------------------------------------
    // END OF Smooth Pulse Refresh & Display
    //-----------------------------------------------------------------
  }
//=========================================================================
// END OF FX_Pulse Object Rendering
//=========================================================================
  
//====================================================
// START OF Refresh events
//====================================================
  // If currentFrCnt becomes equal to our refresh cycle's length, then we'll reset it to zero and execute our refresh events.
  if (currentFrCnt >= cycleLength) {
    currentFrCnt = 0;
  //====================================================
  // Run refresh events HERE.
  //====================================================
    // BUH!
    
    //-----------------------------------------------------------------
    // START OF Beat_Bar Rendering
    //-----------------------------------------------------------------
    BeatBar1.updateDims((hiAvg * 10), 30);
    BeatBar1.redefineCycleLength(cycleLength);
    
    BeatBar2.updateDims(((hiAvg * 10) * (-1)), 30);
    BeatBar2.redefineCycleLength(cycleLength);
    
    //-----------------------------------------------------------------
    // END OF Beat_Bar Rendering
    //-----------------------------------------------------------------
    
    //-----------------------------------------------------------------
    // START OF SubColor Processing
    //-----------------------------------------------------------------
    subColorCount += 1;
    
    // This if statement will reset subColorCount to zero whenever its value is greater than 3.  We want it to 
    if (subColorCount >= 4) {
      subColorCount = 0;
    }
    
    if (subColorAdvance == true) {
      subColorPercent += subColorStep;
      
      if (subColorPercent >= 1) {
        subColorPercent = 1;
        subColorAdvance = false;
      }
    }
    
    else if (subColorAdvance == false) {
      subColorPercent -= subColorStep;
      
      if (subColorPercent <= 0) {
        subColorPercent = 0;
        subColorAdvance = true;
      }
    }
    
    //subClrScr1.getPercentValue(subColorPercent);
    //subClrScr2.getPercentValue(subColorPercent);
    //subClrScr3.getPercentValue(subColorPercent);
    subClrScr1.setPercentValue(subColorPercent);
    subClrScr2.setPercentValue(subColorPercent);
    subClrScr3.setPercentValue(subColorPercent);
    //-----------------------------------------------------------------
    // END OF SubColor Processing
    //-----------------------------------------------------------------
    
// The following for() loops will refresh the Top & Bottom FlickerArrays. 
    for(int i = 0; i < flickerCountBtm; i++) {
      noFill();
      noStroke();
//      flickerArray1[i].redefineCycleLength(cycleLength);
      flickerArray1[i].refresh();
    }
    
    for(int i = 0; i < flickerCountTop; i++) {
      noFill();
      noStroke();
//      flickerArray2[i].redefineCycleLength(cycleLength);
      flickerArray2[i].refresh();
    }
    
    // This will refresh the large FlickerTest box.
    flickerTest1.refresh();
    
    // We'll start off by resetting the values of our Avg variables to zero.
    hiAvg = 0;
    midAvg = 0;
    lowAvg = 0;

    // The following for() loop will iterate through each of the Frequency Bars and store their stopY values within the appropriate hi/mid/lowValues[] arrays.
    for(int i = 0, j = 0, k = 0; i < freqBars.length; i++) {
      // We'll take the first 10 (#0-9) Frequency Bars' stopY values and store them within the hiValues[] array.
      if (i < hiValues.length) {
        hiValues[i] = (height - freqBars[i].stopY);
      }
      
      // We'll take the next 10 (#10-19) Frequency Bars' stopY values and store them within the midValues[] array.
      else if (i >= hiValues.length && i < (hiValues.length + midValues.length)) {
        midValues[j] = (height - freqBars[i].stopY);
        j++;
      }
      
      // We'll take the final 10 (#20-29) Frequency Bars' stopY values and store them within the lowValues[] array.
      else if (i >= (hiValues.length + midValues.length) && i < (hiValues.length + midValues.length + lowValues.length)) {
        lowValues[k] = (height - freqBars[i].stopY);
        k++;
      }
    }
    
    // Now we'll calculate the average of the values stored within the hiValues[] array, and then store this average within hiAvg.
    for (int i = 0; i < hiValues.length; i++) {
      hiAvg += hiValues[i];
    }
    
    // Now we'll calculate the average of the values stored within the midValues[] array, and then store this average within midAvg.
    for (int i = 0; i < midValues.length; i++) {
      midAvg += midValues[i];
    }
    
    // Now we'll calculate the average of the values stored within the lowValues[] array, and then store this average within lowAvg.
    for (int i = 0; i < lowValues.length; i++) {
      lowAvg += lowValues[i];
    }
    
    // Finally, we calculate the average value for hiAvg, midAvg, and lowAvg.
    hiAvg = (hiAvg / hiValues.length);
    midAvg = (midAvg / midValues.length);
    lowAvg = (lowAvg / lowValues.length);
    totalAvg = ((hiAvg + midAvg + lowAvg) / 3);

    // We convert the hi/mid/lowAvg values into a percentage, and then we magnify them by their appropriate hi/mid/lowFreqMagnify variables.
    // We then pass each of these totals to each of our ColorScroller objects.
    clrScr1.setPercentValue((hiAvg / 100) * hiFreqMagnify);
    clrScr2.setPercentValue((midAvg / 100) * midFreqMagnify);
    clrScr3.setPercentValue((lowAvg / 100) * lowFreqMagnify);

//===============================================================================
// START OF AUDIO MODE TOGGLE CONTROLS
//===============================================================================
    if (hiMidLowModeOn == true) {
      //clrScr4.getPercentValue((hiAvg / 100) * hiFreqMagnify);
      //clrScr5.getPercentValue((midAvg / 100) * midFreqMagnify);
      //clrScr6.getPercentValue((lowAvg / 100) * lowFreqMagnify);
      clrScr4.setPercentValue((hiAvg / 100) * hiFreqMagnify);
      clrScr5.setPercentValue((midAvg / 100) * midFreqMagnify);
      clrScr6.setPercentValue((lowAvg / 100) * lowFreqMagnify);
    }
    
    else if (hiLowMidModeOn == true) {
      //clrScr4.getPercentValue((hiAvg / 100) * hiFreqMagnify);
      //clrScr5.getPercentValue((midAvg / 100) * lowFreqMagnify);
      //clrScr6.getPercentValue((lowAvg / 100) * midFreqMagnify);
      clrScr4.setPercentValue((hiAvg / 100) * hiFreqMagnify);
      clrScr5.setPercentValue((midAvg / 100) * lowFreqMagnify);
      clrScr6.setPercentValue((lowAvg / 100) * midFreqMagnify);
    }
    
    else if (midHiLowModeOn == true) {
      //clrScr4.getPercentValue((midAvg / 100) * midFreqMagnify);
      //clrScr5.getPercentValue((hiAvg / 100) * hiFreqMagnify);
      //clrScr6.getPercentValue((lowAvg / 100) * lowFreqMagnify);
      clrScr4.setPercentValue((midAvg / 100) * midFreqMagnify);
      clrScr5.setPercentValue((hiAvg / 100) * hiFreqMagnify);
      clrScr6.setPercentValue((lowAvg / 100) * lowFreqMagnify);
    }
    
    else if (midLowHiModeOn == true) {
      //clrScr4.getPercentValue((midAvg / 100) * midFreqMagnify);
      //clrScr5.getPercentValue((hiAvg / 100) * lowFreqMagnify);
      //clrScr6.getPercentValue((lowAvg / 100) * hiFreqMagnify);
      clrScr4.setPercentValue((midAvg / 100) * midFreqMagnify);
      clrScr5.setPercentValue((hiAvg / 100) * lowFreqMagnify);
      clrScr6.setPercentValue((lowAvg / 100) * hiFreqMagnify);
    }
    
    else if (lowMidHiModeOn == true) {
      //clrScr4.getPercentValue((lowAvg / 100) * lowFreqMagnify);
      //clrScr5.getPercentValue((midAvg / 100) * midFreqMagnify);
      //clrScr6.getPercentValue((hiAvg / 100) * hiFreqMagnify);
      clrScr4.setPercentValue((lowAvg / 100) * lowFreqMagnify);
      clrScr5.setPercentValue((midAvg / 100) * midFreqMagnify);
      clrScr6.setPercentValue((hiAvg / 100) * hiFreqMagnify);
    }
    
    else if (lowHiMidModeOn == true) {
      //clrScr4.getPercentValue((lowAvg / 100) * lowFreqMagnify);
      //clrScr5.getPercentValue((midAvg / 100) * hiFreqMagnify);
      //clrScr6.getPercentValue((hiAvg / 100) * midFreqMagnify);
      clrScr4.setPercentValue((lowAvg / 100) * lowFreqMagnify);
      clrScr5.setPercentValue((midAvg / 100) * hiFreqMagnify);
      clrScr6.setPercentValue((hiAvg / 100) * midFreqMagnify);
    }
    
    else if (avgModeOn == true) {
      //clrScr4.getPercentValue((totalAvg / 100) * lowFreqMagnify);
      //clrScr5.getPercentValue((totalAvg / 100) * hiFreqMagnify);
      //clrScr6.getPercentValue((totalAvg / 100) * midFreqMagnify);
      clrScr4.setPercentValue((totalAvg / 100) * lowFreqMagnify);
      clrScr5.setPercentValue((totalAvg / 100) * hiFreqMagnify);
      clrScr6.setPercentValue((totalAvg / 100) * midFreqMagnify);
    }
//===============================================================================
// END OF AUDIO MODE TOGGLE CONTROLS
//===============================================================================
    
    // Analyze the amp object, and refresh our Brightness Controller object.
    briteness.refresh(amp.analyze() * 2);
    
    // Activate each of the FX_Pulse objects based on what the frequency averages' values are on any given cycle.
    if (totalAvg >= 2) {
      //pulse1.activate();
      //pulse2.activate();
      //pulse3.activate();
      //pulse4.activate();
      sPulse1.activate();
      sPulse2.activate();
      sPulse3.activate();
      sPulse4.activate();
    }
    
    if (midAvg >= 15) {
      //pulse1.activate();
      //pulse2.activate();
      //pulse3.activate();
      //pulse4.activate();
//      pulse5.activate();
//      pulse6.activate();
      //pulse7.activate();
      //pulse8.activate();
    }
    
    if (lowAvg >= 10) {
      //pulse1.activate();
      //pulse2.activate();
      //pulse3.activate();
      //pulse4.activate();
      //pulse5.activate();
      //pulse6.activate();
//      pulse7.activate();
//      pulse8.activate();
    }
  }
//====================================================
// END OF Refresh events
//====================================================
  
  //----------------------------------------------------
  // START OF LEDBar Toggle On/Off
  //----------------------------------------------------
  if (LEDBarOn == true) {
    noStroke();
    fill(0, 0, 0, 0);
    rect(0, 0, width, ledBarHeight);
  }
  
  else if (LEDBarOn == false) {
    noStroke();
    fill(0, 0, 0, 100);
    rect(0, 0, width, ledBarHeight);
  }
  //----------------------------------------------------
  // END OF LEDBar Toggle On/Off
  //----------------------------------------------------
  
  // Display our Brightness Controller object.
//  briteness.display();
}
//===================================================================================================================================================================


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

// This function will allow the User to control what the three primary colors are for the experimental ColorScroller4 objects.
void mousePressed() {
  if (mouseButton == LEFT) {
//   clickColor1 = get(mouseX, mouseY);
   
   if (clickColor1Mode == false) {
     clickColor1a = get(mouseX, mouseY);
     clickColor1Mode = true;
   }
   else if (clickColor1Mode == true) {
     clickColor1b = get(mouseX, mouseY);
     clickColor1Mode = false;
   }
  }
  else if (mouseButton == CENTER) {
//   clickColor2 = get(mouseX, mouseY);

    if (clickColor2Mode == false) {
     clickColor2a = get(mouseX, mouseY);
     clickColor2Mode = true;
   }
   else if (clickColor2Mode == true) {
     clickColor2b = get(mouseX, mouseY);
     clickColor2Mode = false;
   }
  }
  else if (mouseButton == RIGHT) {
//   clickColor3 = get(mouseX, mouseY);

    if (clickColor3Mode == false) {
     clickColor3a = get(mouseX, mouseY);
     clickColor3Mode = true;
   }
   else if (clickColor3Mode == true) {
     clickColor3b = get(mouseX, mouseY);
     clickColor3Mode = false;
   }
  }
}

// This function will allow the User to manually activate an object with a press of a specified keyboard key.
void keyPressed() {
  if (keyCode == RIGHT) {
    //sPulse1.activate();
    //sPulse2.activate();
    //sPulse3.activate();
    //sPulse4.activate();
  }
  
  else if (keyCode == LEFT) {
//    pulse2.activate();
  }
  
  else if (keyCode == UP) {
//    pulse3.activate();
    bpm = (bpm + 1);
    if (bpm > 3600) {
      bpm = 3600;
    }
    fps = (3600 / bpm);
    cycleLength = int(fps);
  }
  
  else if (keyCode == DOWN) {
//    pulse4.activate();
    bpm = (bpm - 1);
    if (bpm < 0) {
      bpm = 0;
    }
    fps = (3600 / bpm);
    cycleLength = int(fps);
  }
  
  // FX_Pulse Toggle On/Off
  else if (key == 'p' || key == 'P') {
    if (pulse_On == false) {
      pulse_On = true;
    }
    
    else if (pulse_On == true) {
      pulse_On = false;
    }
  }
  
  // Blinker_Square Toggle On/Off
  else if (key == 'v' || key == 'V') {
    if (blinkerSq_On == false) {
      blinkerSq_On = true;
    }
    
    else if (blinkerSq_On == true) {
      blinkerSq_On = false;
    }
  }
  
  // Candleflicker Toggle On/Off
  else if (key == 'c' || key == 'C') {
    if (flicker_On == false) {
      flicker_On = true;
    }
    
    else if (flicker_On == true) {
      flicker_On = false;
    }
  }
  
  // Beat_Bar Toggle On/Off
  else if (key == 'b' || key == 'B') {
    if (beatBarsOn == true) {
      beatBarsOn = false;
    }
    
    else if (beatBarsOn == false) {
      beatBarsOn = true;
    }
  }
  
  // Smooth Gradient Mode Toggle
  else if (key == 's' || key == 'S') {
    if (smoothGradOn == false) {
      smoothGradOn = true;
    }
    
    else if (smoothGradOn == true) {
      smoothGradOn = false;
    }
  }
  
  // Low Frequency Mode On
  else if (key == '1') {
    if (hiMidLowModeOn == false) {
      hiMidLowModeOn = true;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
    
    else if (hiMidLowModeOn == true) {
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Mid Frequency Mode On
  else if (key == '2') {
    if (hiLowMidModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = true;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
    
    else if (hiLowMidModeOn == true) {
      hiMidLowModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Low Frequency Mode On
  else if (key == '3') {
    if (midLowHiModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = true;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
    
    else if (midLowHiModeOn == true) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Average Mode On/Off
  else if (key == '4') {
    if (midHiLowModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = true;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
    
    else if (midHiLowModeOn == true) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Average Mode On/Off
  else if (key == '5') {
    if (lowMidHiModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = true;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
    
    else if (lowMidHiModeOn == true) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Average Mode On/Off
  else if (key == '6') {
    if (lowHiMidModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = true;
      avgModeOn = false;
    }
    
    else if (lowHiMidModeOn == true) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      avgModeOn = false;
    }
  }
  
  // Average Mode On/Off
  else if (key == '7') {
    if (avgModeOn == false) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
      avgModeOn = true;
    }
    
    else if (avgModeOn == true) {
      hiMidLowModeOn = false;
      hiLowMidModeOn = false;
      midLowHiModeOn = false;
      midHiLowModeOn = false;
      lowMidHiModeOn = false;
      lowHiMidModeOn = false;
    }
  }
  
  // LED Bar Toggle On/Off
  else if (keyCode == BACKSPACE) {
    if (LEDBarOn == false) {
      LEDBarOn = true;
    }
    
    else if (LEDBarOn == true) {
      LEDBarOn = false;
    }
  }
}
