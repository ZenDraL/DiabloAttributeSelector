﻿
#singleinstance force
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
SetMouseDelay, -1
SetKeyDelay, -1
SetDefaultMouseSpeed, 0
SetControlDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
;Initialize Variables and Coordinates
	Global readfirstline := 0	
	Gosub, CoordinateSystem
	
	IniRead, Tries, OCRsettings.ini, Settings, Tries
	
	if (Tries > 0) {
		IniRead, SleepClick, OCRsettings.ini, Settings, SleepClick
		Gosub, ClickSelect
		
		IniRead, Desired, OCRsettings.ini, Settings, Desired
		IniRead, DesiredNumber, OCRsettings.ini, Settings, DesiredNumber
		IniRead, DesiredNumber, OCRsettings.ini, Settings, DesiredNumber
		IniRead, SleepWait, OCRsettings.ini, Settings, SleepWait
		
		Sleep %SleepWait%
		Gosub, RunReaders
		
		
		
		
		
		
		
		IfNotInString, DesiredNumber, - ;;note a damage number
		{			
			IfInString, secondline, %Desired% 
			{
				if (secondlinenumber >= DesiredNumber)
				{
					IfInString, thirdline, %Desired% 
					{
						if (thirdlinenumber >= secondlinenumber) 
						{
							Gosub, ClickThirdLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
						else
						{
							Gosub, ClickSecondLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
					}
					IfNotInString, thirdline, %Desired% 
					{
						Gosub, ClickSecondLine
						Gosub, ClickSelect
						ExitApp
						;chose
					}
				}
				else
				{
					IfInString, thirdline, %Desired%
					{
						if (thirdlinenumber >= DesiredNumber) 
						{
							Gosub, ClickThirdLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
						else
						{
							Gosub, ClickFirstLine
							Gosub, ClickSelect
						}
					}
					else
					{
						Gosub, ClickFirstLine
						Gosub, ClickSelect
					}
				}
			}
			else
			{
				IfInString, thirdline, %Desired% 
				{
					if (thirdlinenumber >= Desirednumber) 
					{
						Gosub, ClickThirdLine
						Gosub, ClickSelect
						ExitApp
						;chose
					}
					else
					{
						Gosub, ClickFirstLine
						Gosub, ClickSelect
					}
				}
				else
				{
					Gosub, ClickFirstLine
					Gosub, ClickSelect
				}
			}
			Tries--
			IniWrite, %Tries%, OCRsettings.ini, Settings, Tries
			reload
		}
		IfInString, DesiredNumber, - ;;it is a damage roll
		{
			
			StringSplit, DesiredNumberArray, DesiredNumber, -	
			IfInString, secondline, %Desired% 
			{
				StringSplit, secondlinenumberArray1, secondlinenumber, -
				if (secondlinenumberArray1 >= DesiredNumberArray1 and secondlinenumberArray2 >= DesiredNumberArray2)
				{
					IfInString, thirdline, %Desired% 
					{
						StringSplit, thirdlinenumberArray, thirdlinenumber, -
						if (thirdlinenumberArray1 >= secondlinenumberArray1 and thirdlinenumberArray2 >= secondlinenumberArray2) 
						{
							Gosub, ClickThirdLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
						else
						{
							Gosub, ClickSecondLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
					}
					IfNotInString, thirdline, %Desired% 
					{
						Gosub, ClickSecondLine
						Gosub, ClickSelect
						ExitApp
						;chose
					}
				}
				else
				{
					IfInString, thirdline, %Desired%
					{
						StringSplit, thirdlinenumberArray, thirdlinenumber, -
						if (thirdlinenumberArray1 >= DesiredNumberArray1 and thirdlinenumberArray2 >= DesiredNumberArray2) 
						{
							Gosub, ClickThirdLine
							Gosub, ClickSelect
							ExitApp
							;chose
						}
						else
						{
							Gosub, ClickFirstLine
							Gosub, ClickSelect
						}
					}
					else
					{
						Gosub, ClickFirstLine
						Gosub, ClickSelect
					}
				}
			}
			else
			{
				IfInString, thirdline, %Desired% 
				{
					StringSplit, thirdlinenumberArray, thirdlinenumber, -
					if (thirdlinenumberArray1 >= DesiredNumberArray1 and thirdlinenumberArray2 >= DesiredNumberArray2) 
					{
						Gosub, ClickThirdLine
						Gosub, ClickSelect
						ExitApp
						;chose
					}
					else
					{
						Gosub, ClickFirstLine
						Gosub, ClickSelect
					}
				}
				else
				{
					Gosub, ClickFirstLine
					Gosub, ClickSelect
				}
			}
			Tries--
			IniWrite, %Tries%, OCRsettings.ini, Settings, Tries
			reload
		}
		
	}
	else {
		MsgBox Tries Over
	}
ExitApp

CoordinateSystem:
	;Initialize Coordinates and Convert them
	global FirstLine := [ 75, 375, 445, 420, 2 ]
	global SecondLine := [ 75, 420, 445, 460, 2 ]
	global ThirdLine := [ 75, 460, 445, 505, 2 ]
	global FirstLineClick := [ 255, 400, 2]
	global SecondLineClick := [ 255, 440, 2]
	global ThirdLineClick := [ 255, 480, 2]
	global SelectClick := [ 255, 780, 2]
	wOrigin := 1920
	hOrigin := 1080
	ConvertCoordinates(FirstLine,wOrigin,hOrigin)
	ConvertCoordinates(SecondLine,wOrigin,hOrigin)
	ConvertCoordinates(ThirdLine,wOrigin,hOrigin)
	ConvertClick(FirstLineClick,wOrigin,hOrigin)
	ConvertClick(SecondLineClick,wOrigin,hOrigin)
	ConvertClick(ThirdLineClick,wOrigin,hOrigin)
	ConvertClick(SelectClick,wOrigin,hOrigin)
return

 RunReaders:
	;OCR Reader
	if (readfirstline = 1){
		StringRun := A_ScriptDir . "\Capture2Text\Capture2Text_CLI.exe --clipboard -o lastread.txt --screen-rect """ . FirstLine[1] . " " . FirstLine[2] . " " . FirstLine[3] . " " . FirstLine[4] . """"
		RunWait, %StringRun%,%A_ScriptDir%, Hide, ocrPID
		Process, WaitClose, %ocrPID%
		global firstline := clipboard
		global firstlinenumber := ExtractNumbers(firstline)
	}
	StringRun := A_ScriptDir . "\Capture2Text\Capture2Text_CLI.exe --clipboard -o lastread.txt --screen-rect """ . SecondLine[1] . " " . SecondLine[2] . " " . SecondLine[3] . " " . SecondLine[4] . """"
	RunWait, %StringRun%,%A_ScriptDir%, Hide, ocrPID
	Process, WaitClose, %ocrPID%
	global secondline := clipboard
	global secondlinenumber := ExtractNumbers(secondline)
	StringRun := A_ScriptDir . "\Capture2Text\Capture2Text_CLI.exe --clipboard -o lastread.txt --screen-rect """ . ThirdLine[1] . " " . ThirdLine[2] . " " . ThirdLine[3] . " " . ThirdLine[4] . """"
	RunWait, %StringRun%,%A_ScriptDir%, Hide, ocrPID
	Process, WaitClose, %ocrPID%
	global thirdline := clipboard
	global thirdlinenumber := ExtractNumbers(thirdline)
return




ConvertCoordinates(ByRef Array, wOrigin, hOrigin)
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	D3ScreenResolution := DiabloWidth*DiabloHeight
	Position := Array[5]
    ;Pixel is always relative to the middle of the Diablo III window
	If (Position == 1){
		Array[1] := Round(Array[1]*DiabloHeight/hOrigin+(DiabloWidth-wOrigin*DiabloHeight/hOrigin)/2, 0)
		Array[3] := Round(Array[3]*DiabloHeight/hOrigin+(DiabloWidth-wOrigin*DiabloHeight/hOrigin)/2, 0)
	}
    ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
	If Else (Position == 2 || Position == 4){
		Array[1] := Round(Array[1]*(DiabloHeight/hOrigin), 0)
		Array[3] := Round(Array[3]*(DiabloHeight/hOrigin), 0)
	}
	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3){
		Array[1] := Round(DiabloWidth-(wOrigin-Array[1])*DiabloHeight/hOrigin, 0)
		Array[3] := Round(DiabloWidth-(wOrigin-Array[3])*DiabloHeight/hOrigin, 0)
	}
	Array[2] := Round(Array[2]*(DiabloHeight/hOrigin), 0)
	Array[4] := Round(Array[4]*(DiabloHeight/hOrigin), 0)
}

ConvertClick(ByRef Array, wOrigin, hOrigin)
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	D3ScreenResolution := DiabloWidth*DiabloHeight

	Position := Array[3]

	;Pixel is always relative to the middle of the Diablo III window
    If (Position == 1){
	Array[1] := Round(Array[1]*DiabloHeight/hOrigin+(DiabloWidth-wOrigin*DiabloHeight/hOrigin)/2, 0)
	}

    ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
    If Else (Position == 2 || Position == 4){
		Array[1] := Round(Array[1]*(DiabloHeight/hOrigin), 0)
	}

	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3){
		Array[1] := Round(DiabloWidth-(wOrigin-Array[1])*DiabloHeight/hOrigin, 0)
	}

	Array[2] := Round(Array[2]*(DiabloHeight/hOrigin), 0)
}

ExtractNumbers(MyString){
	firstdot := 0
	Loop, Parse, MyString
	{
		If A_LoopField is Number
			NewVar .= A_LoopField
		IfInString,A_LoopField,.
		{
			if (firstdot = 0){
				NewVar .= A_LoopField
				firstdot := 1
			}
		}
		IfInString,A_LoopField,`,
			NewVar .= A_LoopField
		IfInString,A_LoopField,-
			NewVar .= A_LoopField
	}
	checklastdigit := SubStr(NewVar, 0) ;;removes a last dot
		IfInString, checklastdigit , . 
			StringTrimRight, NewVar, NewVar, 1
	StringReplace, NewVar, NewVar,`,,., ;;replaces commas with dots
	Return NewVar
}

ClickFirstLine:
	x1 := FirstLineClick[1]
	y1 := FirstLineClick[2]
	SendInput, {Click %x1%, %y1%}
	Sleep %SleepClick%
return

ClickSecondLine:
	x1 := SecondLineClick[1]
	y1 := SecondLineClick[2]
	SendInput, {Click %x1%, %y1%}
	Sleep %SleepClick%
return

ClickThirdLine:
	x1 := ThirdLineClick[1]
	y1 := ThirdLineClick[2]
	SendInput, {Click %x1%, %y1%}
	Sleep %SleepClick%
return

ClickSelect:
	x1 := SelectClick[1]
	y1 := SelectClick[2]
	SendInput, {Click %x1%, %y1%}
	Sleep %SleepClick%
return

F12::ExitApp