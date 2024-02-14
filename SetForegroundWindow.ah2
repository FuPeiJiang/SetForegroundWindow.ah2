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
            toRelease:=""
            if (LShiftDown) {
                toRelease.="{LShift Up}"
            }
            if (RShiftDown) {
                toRelease.="{RShift Up}"
            }
            if (toRelease) {
                Send "{Blind}" toRelease
            }
        }
        Send "{LAlt Down}{LAlt Down}" ;more stable than single on test: testf1_hotkey_hooked_Ctrl_Win_Alt.ah2
        ;Send "{LAlt Down}"
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