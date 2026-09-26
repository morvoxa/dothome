#Requires AutoHotkey v2.0

#i::Send("^#{Left}")   ; Win + U -> Previous Desktop
#u::Send("^#{Right}")  ; Win + I -> Next Desktop
; Window focusing (Alt + Esc cycles through windows in Z-order)
#j::Send("!{Esc}")      ; Win + J -> Focus next window
#k::Send("!+{Esc}")     ; Win + K -> Focus previous window
; Toggle Maximize / Minimize
#f:: {
    activeWin := WinGetID("A")
    minMaxState := WinGetMinMax(activeWin)
    
    if (minMaxState == 1)      ; If maximized
        WinRestore(activeWin)  ; Restore to normal
    else                       ; Otherwise (normal or minimized)
        WinMaximize(activeWin) ; Maximize it
}
