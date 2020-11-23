# LEDSoundBar
This is a repository where I'll store and further develop the WYSIWYG interface that controls my sound-responsive LED light system.  This specific repository contains the LEDSoundBar sketch, which serves as the primary interface which controls this LED light system.

I've developed this project using the Processing language due to my choice in hardware; the FadeCandy microcontroller uses its own FadeCandy software, which is written in the Processing language.  It's essentially a Java-based language that allows the User to create graphically-based programs via their coding.  For the purposes of my project, I use Processing to generate a sound-responsive graphical WYSIWYG interface that is projected to the LED lights.  There are several controls that allow the User to adjust the way the LEDs respond to the audio signals that it receives from the computer's system sounds.

You can see a video sample of this LED light system at work by checking out this link:  https://youtu.be/QIzyGim3IFo

The Purpose Of This Project:
----------------------------
I wanted to build my own sound-responsive LED light system in my basement so that I could have a unique experience while playing high-octane video games like Doom Eternal on my wall-mounted 65" flat screen TV; I wanted this system to also complement any movies or videos that I watch, as well.  Check out the video link above to see it in action!

How It All Works:
-----------------
This sketch requires that your computer is configured to listen to its own audio output.  For optimal conditions, I recommend using VoiceMeeter Banana.  Once the computer is listening to itself, the LEDSoundBar sketch will use a frequency analyzer to dynamically interpret the high, mid, and low ranges of the audio.  These audio range values will dictate how the top gradient bar will fluctuate based upon the various settings that the User has configured (see Interface Controls and Equalizer Presets below).

Hardware Details:
-----------------
I have used the following components to construct my LED light system:
- Microcontroller:  Adafruit FadeCandy microcontroller (https://www.adafruit.com/product/1689).
- LED Lights:  Alitove WS2812B fully-addressable RGB LED Light Strips (https://www.amazon.com/gp/product/B00VQ0D2TY/ref=ppx_yo_dt_b_asin_title_o07_s00?ie=UTF8&psc=1).
- Power Supply:  Alitove 5V 20A 100W AC to DC Power Supply (https://www.amazon.com/gp/product/B06XK2DDW4/ref=ppx_yo_dt_b_asin_title_o06_s00?ie=UTF8&psc=1).
- Lots and lots and LOTS of soldered 22awg wires and connectors.

Software Details:
-----------------
Here's a list of the software and programming language specs for my project:
Programming Language:  Processing (https://processing.org/).
Software:  FadeCandy 02 (https://github.com/scanlime/fadecandy/releases).
Audio Software:  VoiceMeeter Banana (https://vb-audio.com/Voicemeeter/banana.htm).

Step-By-Step Setup Process:
---------------------------
1.)  Download this repository's files to your local hard drive.
2.)  Download and install VoiceMeeter Banana, or use your own preferred audio software program to pipe the system audio back into itself.
3.)  Download and install the latest version of Processing (https://processing.org/download/).
4.)  Download the FadeCandy software (https://github.com/scanlime/fadecandy/releases).
5.)  Fire up the FadeCandy server per the instructions found at this tutorial (https://learn.adafruit.com/led-art-with-fadecandy/installing-software).
6.)  Launch VoiceMeeter Banana, and configure its settings to utilize your audio output device of choice (speakers, headset, etc.).
7.)  On Windows 10, press the Windows Start button, type in "Change System Sounds", and press Enter.  Set up your sound settings as follows:
  7a.)  In the Playback tab, select the "VoiceMeeter Input" option and set it as the Default Device.
  7b.)  In the Recording tab, select the "VoiceMeeter Output" option and set it as the Default Device.
8.)  Launch Processing, and load the LEDSoundBar sketch.  Press the Play button, or click the Sketch menu and select Run.

Everything Is Running, So Now What?
-----------------------------------
Once you have everything up and running, it's time to make some noise!  Do something with your computer that generates some audio; watch a YouTube video, play a video game, watch a Blu-Ray movie, etc.  The LEDSoundBar sketch will react to the audio that your computer is producing.  There are various controls that allow the User to tweak and fine-tune the WYSIWYG elements of the sketch to make the LEDs respond to the audio in different ways.

Interface Layout:
-----------------
- Top Gradient Bar:  The colorful gradient area that stretches across the top of the LEDSoundBar window.  This is the WYSIWYG portion of the LEDSoundBar interface; what you see in this top bar is what will be broadcasted to the LEDs via the FadeCandy microcontroller.
- Left-Hand Text Section:  This is my developer troubleshooting section of the interface.  Numerous variables are displayed that show what the machinations behind the scene are doing at any given time.
- Bottom Frequency Analyzer:  There are several black bars which make up the frequency analyzer that renders the live audio at the bottom of the screen.  This also helps to tell at a glance if the LEDSoundBar is properly detecting the system audio output.
- Right-Hand Color Section:  There are several color sampling sections in the middle right-hand area of the LEDSoundBar window which are intended for use in selecting colors to be rendered in the Top Gradient Bar.  Use the left, center, and right mouse buttons to select up to six variant colors to render in the Top Gradient Bar.

Interface Controls:
-------------------
NOTE:  All mouse-click controls above must be performed within the Processing Sketch window.  Clicking outside of the Processing Sketch window WILL NOT sample the pixel color underneath the mouse cursor.
- Mouse Left-Click:  Sets current pixel color underneath the mouse cursor alternatingly to clickColor1a or clickColor1b.
- Mouse Center-Click (click your Scroll Wheel):  Sets current pixel color underneath the mouse cursor alternatingly to clickColor2a or clickColor2b.
- Mouse Right-Click:  Sets current pixel color underneath the mouse cursor alternatingly to clickColor3a or clickColor3b.
- UP Arrow:  Increase BPM
- DOWN Arrow:  Decrease BPM
- C Key:  Toggle CandleFlicker effect.
- B Key:  Toggle Beat_Bar effect.
- S Key:  Toggle SmoothGradient Mode.
- V Key:  Toggle BlinkerSquare Mode (Experimental WIP).
- Backspace Key:  Toggle Top Gradient Bar off/on.

Equalizer Presets:
------------------
The following keys will control how the Hi, Mid, and Low ranges of the audio is arranged in the top LEDSoundBar's dynamic gradient rendering.
The top gradient is mirrored from its centerpoint, and each half consists of three evenly-spaced points where each pair of clickColors (clickColor1a & clickColor1b, clickColor2a & clickColor2b, and clickColor3a & clickColor3b) apply their current color settings to the gradient.  The left half of the top gradient dictates what the right half does, and the sound ranges are configured to each of these three points on the left half of the gradient.
By clicking each of the three mouse buttons within the LEDSoundBar Sketch window, six colors can be selected to influence how the top gradient is rendered during each cycle of the program.  Depending on which Equalizer setting is active and the audio that the sketch is picking up, the colors of the top gradient will behave differently.  Experiment to figure out which settings work best for the audio that you're playing.
- 1 Key:  Hi-Mid-Low
- 2 Key:  Low-Hi-Mid
- 3 Key:  Mid-Low-Hi (I find this preset to work well for most video games)
- 4 Key:  Mid-Hi-Low
- 5 Key:  Low-Mid-Hi
- 6 Key:  Low-Hi-Mid
- 7 Key:  "Average Mode" (tends to work best when SmoothGradient Mode is active)
