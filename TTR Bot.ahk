#Requires AutoHotkey v2.0-beta

#SingleInstance Force
#WinActivateForce
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(True)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

titleName := "Toontown Rewritten" 
backgroundMode := false

; reference values for doodle training
; reference values were chosen at a client resolution of 3456 x 1984
refWidth := 3456.0
refHeight := 1984.0
chatTabWidth := 66.0
trickXRef := 1051.0
trickYRef := 200.0
xRefArray := [203.0, 455.0, 759.0]
yRefArray := [71.0, 202.0, 200.0]

pixelScanX := 3117.0
pixelScanY := 525.0

doDoodleTrick(petsPosition, tricksPosition, sleepTime, height) {
	; Get scaled X and Y mouse values, and click on each speedchat phrase based on scaled pet and trick position.
	i := 1
	Loop(3) {
		mouseX := xRefArray[i] * height / refHeight
		if (i == 1) {
			mouseY := (yRefArray[1] * height / refHeight)
		} else {
			mouseY := (yRefArray[i] * height / refHeight) + ((chatTabWidth * (petsPosition - 3)) * height / refHeight)
		}
        xString := "x" . mouseX " y" . mouseY
        xString2 := "NA x" . mouseX " y" . mouseY
		ControlClick(xString, titleName,,,, xString2)
		i++
		sleep(sleepTime)
	}
	; click on the trick phrase 
	mouseX := trickXRef * height / refHeight
	;mouseY := trickYRefArray[trickIndex] * height / 1984
	mouseY := ((trickYRef + ((tricksPosition - 1) * chatTabWidth) + (chatTabWidth * (petsPosition - 3))) * height / refHeight)
	
	xString := "x" . mouseX " y" . mouseY
	newxString := "NA x" . mouseX " y" . mouseY
	ControlClick xString, titleName,,,, newxString
}

doRandomAction(shouldAction, amountToTurn, compareToValue) {
	; Do some random action to prevent afking / seeming suspicious
	if (shouldAction < compareToValue * (125.0/300.0)) {
		SetKeyDelay(0,amountToTurn)
		ControlSend("ad",,titleName)
	} else if (shouldAction < compareToValue * (25.0/30.0)) {
		SetKeyDelay(0,amountToTurn)
		ControlSend("da",,titleName)
	} else if (shouldAction < compareToValue) {
		SetKeyDelay(0,60)
        ControlSend("{Space}",,titleName)
	}
}

getRandomVars(&shouldAction, &waitTime, &amountToTurn,  &sleepTime) {
	; values chosen arbitrarily
	shouldAction := Random(0.0, 100.0)
	waitTime := Random(100, 1300)
	amountToTurn := Random(100, 1100)
	sleepTime := Random(50, 300)
}

guiFunc() {
	; setup gui
	MyGui := Gui()
	MyGui.Title := "TTR Bot"
	MyGui.MarginX := 40
	MyGui.MarginY := 45
	MyGui.SetFont("s26 w200")
	MyGui.Add("Text","x110 y10", "Doodle Training")

	MyGui.SetFont("s20 w50")
	MyGui.Add("Checkbox", "vdtIsToggled x20 y70", "Toggle")
	dtToggledObj := MyGui["dtIsToggled"]	
	dtToggledObj.ToolTip := ("Toggle on/off the doodle training bot.")

	MyGui.SetFont("s10 w50")
	MyGui.Add("Checkbox", "vbgMode x20 y110", "Background Mode")
	bgModeToggleObj := MyGui["bgMode"]

	MyGui.Add("Checkbox", "vrandMode x20 y130", "Randomization Delays")
	randModeToggleObj := MyGui["randMode"]

	MyGui.Add("Text", "x20 y150", "Random action chance (%):")
	MyGui.AddSlider("vrandActionSlider x20 y170", 50)
	randActionSliderObj := MyGui["randActionSlider"]

	MyGui.Add("Text", "x250 y110", "Position of 'Pets' tab:")
	MyGui.Add("Edit", "vPetsPositionEdit h17 w40 x375 y109 +ReadOnly")
	MyGui.Add("UpDown", "vPetsPositionUpDown Range1-7", 3)
	PetsPositionUpDownObj := MyGui["PetsPositionUpDown"]

	MyGui.Add("Text", "x250 y130", "Position of trick to train:")	
	MyGui.Add("Edit", "vTrickPositionEdit h17 w40 x390 y129 +ReadOnly")
	MyGui.Add("UpDown", "vTrickPositionUpDown Range1-7", 2)
	TrickPositionUpDownObj := MyGui["TrickPositionUpDown"]

	myGui.OnEvent("Close", myGui_Close)
	myGui_Close(thisGui) {
		ExitApp
	}
	MyGui.Show() 

	; main loop
	Loop {
		firstRun := true
		while (dtToggledObj.Value == 1) {
			if (firstRun == true) {
				WinActivate(titleName)
				sleep(100)
			}
			WinGetClientPos(,,&width, &height, titleName) 
			if(((width / height) < (4/3)) and (WinActive(titleName) != 0) and firstRun == false) {
				MsgBox("Your window's aspect ratio is less than 4:3. Please adjust your screen resolution. Press OK to resume.")
			}

			firstRun := false
			if (bgModeToggleObj.Value == 0) {
				if (WinActive(titleName) == 0) {
					MsgBox("Please keep the Toontown Rewritten window active while background mode is disabled. Press OK to resume.")
					sleep(1500)
					WinActivate(titleName)
				}
				blaY := pixelScanY * height / 1984.0
				; if the color is white, execute trick			
				if (PixelSearch(&XPixel, &YPixel, width*0.8, blaY, width, blaY, 0xFEFEFE, 50)) {
					if (randModeToggleObj.Value == 1) {
						getRandomVars(&shouldAction, &waitTime, &amountToTurn,&sleepTime)
						sleep(waitTime)
						doDoodleTrick(PetsPositionUpDownObj.Value, TrickPositionUpDownObj.Value, sleepTime, height)
						doRandomAction(shouldAction, amountToTurn, randActionSliderObj.Value)
					} else {
						doDoodleTrick(PetsPositionUpDownObj.Value, TrickPositionUpDownObj.Value, 50, height)
					}
					sleep(500)
				}
			} else if (bgModeToggleObj.Value == 1) {
				; alternative course of action if background mode is disabled 
				; PixelSearch only works if the window active
				
				if (randModeToggleObj.Value == 1) {
					getRandomVars(&shouldAction, &waitTime, &amountToTurn,&sleepTime)
					randWaitTime := Random(4600 - (sleepTime * 3), 5500)
					doDoodleTrick(PetsPositionUpDownObj.Value, TrickPositionUpDownObj.Value, sleepTime, height)
					doRandomAction(shouldAction, amountToTurn, randActionSliderObj.Value)
					sleep(randWaitTime)
				} else if (randModeToggleObj.Value == 0) {
					doDoodleTrick(PetsPositionUpDownObj.Value, TrickPositionUpDownObj.Value, 50, height)
					sleep(4650)
				}
				
			}
		}
	}
}
MyGui_Close() {
	ExitApp
}
guiFunc()
