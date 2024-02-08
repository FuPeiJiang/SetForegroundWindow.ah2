edgeId:=WinGetID("ahk_exe msedge.exe")
vscodeId:=WinGetID("ahk_exe code.exe")

#SingleInstance Force

;you can't send this through keybd_event, and h-hook ignores SendInput
;Right::
;^+#Right::
;^+!Right::
;>!Right::
;<!Right::
;>^Right::
;<^Right::
$^+#Right:: ;use RShift on your keyboard
{
    if (DllCall("GetForegroundWindow","Ptr")==edgeId) {
        SetForegroundWindow(vscodeId)
    } else {
        SetForegroundWindow(edgeId)
    }
}

;#Include %A_LineFile%\..\SetForegroundWindow.ah2
#Include %A_LineFile%\..\SetForegroundWindow_CtrlWin.ah2