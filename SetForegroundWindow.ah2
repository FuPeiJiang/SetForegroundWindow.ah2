SetForegroundWindow(hwnd) {
    if (DllCall("AllowSetForegroundWindow","Uint",DllCall("GetCurrentProcessId"))) {
        DllCall("SetForegroundWindow","Ptr",hwnd)
    } else {

        LCtrlDown:=GetKeyState("LCtrl")
        RCtrlDown:=GetKeyState("RCtrl")
        LShiftDown:=GetKeyState("LShift")
        RShiftDown:=GetKeyState("RShift")
        LWinDown:=GetKeyState("LWin")
        RWinDown:=GetKeyState("RWin")
        LAltDown:=GetKeyState("LAlt")
        RAltDown:=GetKeyState("RAlt")

        if ((LCtrlDown || RCtrlDown) && (LWinDown || RWinDown)) {
            if (LShiftDown) {
                DllCall("keybd_event","UChar",160,"UChar",42,"Uint",2,"Ptr",2) ;LShift Up
            } else if (RShiftDown) {
                DllCall("keybd_event","UChar",161,"UChar",310,"Uint",2,"Ptr",2) ;RShift Up
            }
        }
        Send "{LAlt Down}"
        DllCall("SetForegroundWindow","Ptr",hwnd)

        toAppend:=""
        if (!LAltDown) {
            toAppend.="{LAlt Up}"
        }
        if (RAltDown) {
            toAppend.="{RAlt Down}"
        }
        if (LCtrlDown) {
            toAppend.="{LCtrl Down}"
        }
        if (RCtrlDown) {
            toAppend.="{RCtrl Down}"
        }
        if (LShiftDown) {
            toAppend.="{LShift Down}"
        }
        if (RShiftDown) {
            toAppend.="{RShift Down}"
        }
        if (LWinDown) {
            toAppend.="{LWin Down}"
        }
        if (RWinDown) {
            toAppend.="{RWin Down}"
        }
        if (toAppend) {
            Send "{Blind}" toAppend
        }
    }
}