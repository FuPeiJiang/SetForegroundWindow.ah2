edgeId:=WinGetID("ahk_exe msedge.exe")
vscodeId:=WinGetID("ahk_exe code.exe")

#SingleInstance Force

$^+#f1:: ;pair with: Send "{LCtrl Down}{LShift Down}{LWin Down}" or with Send "{LCtrl Down}{RShift Down}{LWin Down}"
{
    if (DllCall("GetForegroundWindow","Ptr")==edgeId) {
        SetForegroundWindow(vscodeId)
    } else {
        SetForegroundWindow(edgeId)
    }
}

#Include %A_LineFile%\..\SetForegroundWindow.ah2