edgeId:=WinGetID("ahk_exe msedge.exe")
vscodeId:=WinGetID("ahk_exe code.exe")

#SingleInstance Force

;RAlt, or left-right specific modifier, is always k-hook
>!f1:: ;pair with: Send "{RAlt Down}"
{
    if (DllCall("GetForegroundWindow","Ptr")==edgeId) {
        SetForegroundWindow(vscodeId)
    } else {
        SetForegroundWindow(edgeId)
    }
}

#Include %A_LineFile%\..\SetForegroundWindow.ah2