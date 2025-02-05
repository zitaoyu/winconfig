 #Requires AutoHotkey v2.0
#SingleInstance Force
Persistent  ; Keeps the script running

command := "wt --focus --window 0 --size 60,32 --pos 10,45"
terminalTitle := "PowerShell"
alwaysOnTop := false
transparency := 240 ; Adjust transparency (0-255)
x := 10
y := 60
width := 600
height := 1000

; Launch Windows Terminal when the script starts
if !WinExist(terminalTitle) {
    Run(command)
    WinWait(terminalTitle)
}

; Function to position and style the terminal
moveAndStyleTerminal() {
    global terminalTitle, x, y, width, height, transparency

    if !WinExist(terminalTitle) {
        Run(command)
        WinWait(terminalTitle)
    }
    WinActivate(terminalTitle) ; Bring window to the front
    ; WinMove(x, y, width, height, terminalTitle) ; Move to defined coordinates
    WinSetAlwaysOnTop(alwaysOnTop, terminalTitle) ; Keep window on top
    WinSetTransparent(transparency, terminalTitle) ; Apply transparency
}

; Run the function on script start to position the terminal
moveAndStyleTerminal()

#t::{  ; Win + T to reposition the terminal
    moveAndStyleTerminal()
}
