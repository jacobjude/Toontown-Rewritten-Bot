#Requires AutoHotkey v2.0-beta

#SingleInstance Force
SetWorkingDir(A_ScriptDir)

DetectHiddenWindows(True)
titleName := "Toontown Rewritten" 
backgroundMode := false

; reference arrays for doodle training
trickXRefArray := [1038.0, 1051.0, 1039.0]
trickYRefArray := [200.0, 267.0, 331.0]
xRefArray := [203.0, 455.0, 759.0]
yRefArray := [71.0, 202.0, 200.0]
pixelScanX := 3117.0
pixelScanY := 525.0

CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")


getScaledY(yRef, height) {
	; Multiply the reference position by client height / reference height to get the scaled Y position.
	return yRef * ((height) / 1984)
}

getScaledX(xRef, width, height) {
	; Multiply the reference position by the ratio of the client width to the reference width and by
	; the reference aspect ratio divided by the current aspect ratio to get the scaled X position.
	REFERENCE_ASPECT_RATIO := 3456 / 1984
	currentAspectRatio := (width) / (height)
	widthRatio := ((width) / 3456)
	return xRef * widthRatio * (REFERENCE_ASPECT_RATIO / currentAspectRatio)
}

doDoodleTrick(trickIndex, sleepTime, xRefArray, yRefArray, trickX, trickY, width, height) {
	; Click on each speedchat phrase.
	i := 1
	Loop(3) {
		mouseX := getScaledX(xRefArray[i], width, height)
		mouseY := getScaledY(yRefArray[i], height) 
        xString := "x" . mouseX " y" . mouseY
        xString2 := "NA x" . mouseX " y" . mouseY
		ControlClick(xString, titleName,,,, xString2)
		i++
		sleep(sleepTime)
		
	}
	; click on the trick phrase (1 = jump, 2 = play dead, 3 = speak)
	mouseX := getScaledX(trickXRefArray[2], width, height)
	mouseY := getScaledY(trickYRefArray[2], height)
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
	shouldAction := Random(0.0, 100.0)
	waitTime := Random(100, 1300)
	amountToTurn := Random(100, 1100)
	sleepTime := Random(50, 300)
}

guiFunc() {

	MyGui := Gui()
	MyGui.Title := "Toontown Rewritten Bot"
	MyGui.MarginX := 200
	MyGui.MarginY := 400
	MyGui.SetFont("s20 w200")
	MyGui.Add("Text","x200 y20", "Doodle Training")

	MyGui.SetFont("s20 w50")
	MyGui.Add("Checkbox", "vdtIsToggled x20 y70", "Toggle")
	dtToggledObj := MyGui["dtIsToggled"]
	dtToggledObj.ToolTip := ("Toggle on/off the doodle training bot.")

	MyGui.SetFont("s10 w50")
	MyGui.Add("Checkbox", "vbgMode x20 y110", "Background Mode")
	bgModeToggleObj := MyGui["bgMode"]

	MyGui.Add("Checkbox", "vrandMode x20 y130", "Randomization")
	randModeToggleObj := MyGui["randMode"]

	MyGui.Add("Text", "x20 y150", "Random action chance (%):")
	MyGui.AddSlider("vrandActionSlider x20 y170", 50)
	randActionSliderObj := MyGui["randActionSlider"]
	myGui.OnEvent("Close", myGui_Close)
	myGui_Close(thisGui) {  ; Declaring this parameter is optional.
		ExitApp
	}
	MyGui.Show() 

	Loop {
		while (dtToggledObj.Value == 1) {

			WinGetClientPos(,,&width, &height, titleName) 
			if (bgModeToggleObj.Value == 0) {
				blaY := getScaledY(pixelScanY, height)
				; if the color is white, execute trick			
				if (PixelSearch(&XPixel, &YPixel, width*0.8, blaY, width, blaY, 0xFEFEFE, 50)) {
					if (randModeToggleObj.Value == 1) {
						getRandomVars(&shouldAction, &waitTime, &amountToTurn,&sleepTime)
						sleep(waitTime)
						doDoodleTrick(3, sleepTime, xRefArray, yRefArray, trickXRefArray[2], trickYRefArray[2], width, height)
						doRandomAction(shouldAction, amountToTurn, randActionSliderObj.Value)
					} else {
						doDoodleTrick(3, 35, xRefArray, yRefArray, trickXRefArray[2], trickYRefArray[2], width, height)
					}
					sleep(800)
				}
			} else if (bgModeToggleObj.Value == 1) {
				; alternative course of action if background mode is disabled 
				; PixelSearch only works if the window active
				
				if (randModeToggleObj.Value == 1) {
					preWaitTime := Random(4600 - (sleepTime * 3), 5500)
					doDoodleTrick(3, sleepTime, xRefArray, yRefArray, trickXRefArray[2], trickYRefArray[2], width, height)
					doRandomAction(shouldAction, amountToTurn, randActionSliderObj.Value)
					sleep(preWaitTime)
				} else if (randModeToggleObj.Value == 0) {
					doDoodleTrick(3, 35, xRefArray, yRefArray, trickXRefArray[2], trickYRefArray[2], width, height)
				}
				sleep(4650)
			}
		}
	}
}
MyGui_Close() {
	ExitApp
}
guiFunc()
