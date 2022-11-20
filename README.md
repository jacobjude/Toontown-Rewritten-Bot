# Toontown Rewritten Trainer

This is a script written using AutoHotKey v2.0 that automates tasks within Toontown Rewritten.

It is able to efficiently train doodles by using pixel color scanning to determine when the doodle is available for training. 
It then uses simulated mouse clicks to click the appropriate SpeedChat phrase for doodle training. 

This bot works for all game resolutions and has a background mode for when the game is not in the foreground. 

## Installation
You must have **AutoHotKey version 2.0** or above to use this script. 

[Download it here: (https://www.autohotkey.com/v2/)](https://www.autohotkey.com/v2/) 

Once it's installed, simply download the latest version from [releases](https://github.com/jacobjude/Toontown-Rewritten-Bot/releases) and run it.

## Usage & Configuration
### Important: If you're not using background mode, the doodle menu **must** be open for the script to work (the feed, scratch, & call options must be onscreen). 

It is recommended to set Toontown Rewritten to **windowed** mode.

In the GUI, you must set where the 'Pets' tab appears on your SpeedChat+ menu. For example, if your 'Pets' tab is the third option in your SpeedChat+ menu like in the screenshot below, then you would set "Position of 'Pets' tab:" in the menu to 3.

Example: 

![image](https://user-images.githubusercontent.com/118640159/202913460-3122915c-0d30-49fa-9fc7-b891be513c33.png)
![image](https://user-images.githubusercontent.com/118640159/202913189-8d6a572b-1ce5-43e6-9cfd-ee1c20911537.png)

Use a similar process for selecting the trick you want to train. If you want to train "Speak" and it appears as the 3rd trick in your menu, then set "Position of trick to train" to 3. 

Example:

![image](https://user-images.githubusercontent.com/118640159/202913274-d9af68d3-0520-41c4-b0c8-7286427c4124.png)
![image](https://user-images.githubusercontent.com/118640159/202913446-8e3737f4-daff-479f-bc4a-50924b0f7e5d.png)


## Other Features & Options
**Background mode** lets you use the script while it is not in the foreground. Since it doesn't use pixel scanning, this option slightly reduces training efficiency.

**Randomization** is a precautionary measure used to make the player seem more human. For maximum training efficiency, these options can be disabled. Random actions will not occur if randomization is turned off. 

**Automatic Scaling** lets you set your game resolution to any size as long as its aspect ratio is greater than or equal to 4:3. Note: if the aspect ratio is less than 4:3, coordinates will not be scaled properly.
