# Week 6

Week 6 consisted of more implementation of the UI, tying together AudioKit to Apples AudioToolBox, and learning how to merge UIKit’s viewcontrollers with SwiftUI.

This version of the app has a functioning piano keyboard that plays notes through the iphones speakers when you tap on the keys.  This is a big step becuase it was implemented with Midi, and supports poly-touch of the keys.  The midi will ideally be digitized and quantized for the AI to be able to train on, since Midi is in a nutshell just a bunch of numbers and codes to turn notes on and off.

I am having issued with SwiftUI’s landscape views, and the goal is to force the device orientation into landscape when the user wants to navigate to playing notes on the keyboard.

<img src="https://github.com/gwayne9955/MuseAI/raw/master/Screenshots/Week%206/IMG_3931.PNG" height="50%" width="50%" alt="App Icon">

<img src="https://github.com/gwayne9955/MuseAI/raw/master/Screenshots/Week%206/IMG_3932.PNG" height="50%" width="50%" alt="App Icon">

<img src="https://github.com/gwayne9955/MuseAI/raw/master/Screenshots/Week%206/IMG_3933.PNG" height="50%" width="50%" alt="App Icon">
