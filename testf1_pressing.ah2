edgeId:=WinGetID("ahk_exe msedge.exe")
vscodeId:=WinGetID("ahk_exe code.exe")

#SingleInstance Force

keybd_event(key)
{
  DllCall("keybd_event", "uchar", GetKeyVK(key), "uchar", GetKeySC(key), "uint", 0, "ptr", 0)
  DllCall("keybd_event", "uchar", GetKeyVK(key), "uchar", GetKeySC(key), "uint", 2, "ptr", 0)
}

success_count:=0
attempt_num:=0
failed_indexes:=""
diff_list:=""
DllCall("Sleep","Uint",200)

OutputVarPID:=0

Ctrl_Shift_Win:="{LCtrl Down}{LShift Down}{LWin Down}"
Ctrl_Win_Alt:="{LCtrl Down}{LWin Down}{LAlt Down}"
Ctrl_Win:="{LCtrl Down}{LWin Down}"
RAlt:="{RAlt Down}"
RCtrl:="{RCtrl Down}"
Ctrl_RShift_Win:="{LCtrl Down}{RShift Down}{LWin Down}"
;make sure no .ah2 is ALREADY running, because this script doesn't cover the processes it didn't spawn
runTest("testf1_hotkey_Ctrl_Shift_Win.ah2",Ctrl_Shift_Win) ;pair with ^+#f1::
runTest("testf1_hotkey_Ctrl_Win_Alt.ah2",Ctrl_Win_Alt) ;pair with ^#!f1::
runTest("testf1_hotkey_Ctrl_Win.ah2",Ctrl_Win) ;pair with ^#f1::
runTest("testf1_hotkey_hooked_Ctrl_Shift_Win.ah2",Ctrl_Shift_Win) ;pair with $^+#f1::
runTest("testf1_hotkey_hooked_Ctrl_Win_Alt.ah2",Ctrl_Win_Alt) ;pair with $^#!f1::
runTest("testf1_hotkey_hooked_Ctrl_Win.ah2",Ctrl_Win) ;pair with $^#f1::
runTest("testf1_hotkey_hooked_RAlt.ah2",RAlt) ;pair with >!f1::
runTest("testf1_hotkey_hooked_RCtrl.ah2",RCtrl) ;pair with >^f1::
runTest("testf1_hotkey_hooked_Ctrl_Shift_Win.ah2",Ctrl_RShift_Win) ;pair with $^+#f1::

;with AllowSetForegroundWindow() branch commented out:
;single {LAlt Down}
;success_count:897
;90 ;testf1_hotkey_Ctrl_Shift_Win.ah2
;408 ;testf1_hotkey_hooked_Ctrl_Win_Alt.ah2
;709 ;testf1_hotkey_hooked_RCtrl.ah2
;double {LAlt Down}{LAlt Down}
;success_count:900

runTest(testName,modifiersToHoldDown) {
    global OutputVarPID
    Run "`"" A_AhkPath "`" `"" A_LineFile "\..\" testName "`"",,,&OutputVarPID
    DllCall("Sleep","Uint",500)
    Send modifiersToHoldDown
    loopSomeTimes()
    DllCall("Sleep","Uint",500)
}


loopSomeTimes() {
    global edgeId, vscodeId, success_count, attempt_num, failed_indexes, diff_list
    loop 100 {

        if (DllCall("GetForegroundWindow","Ptr")==edgeId) {
            to_activate:=vscodeId
        } else {
            to_activate:=edgeId
        }
        keybd_event("f1")

        ;Sleep 100

        start:=A_TickCount
        DllCall("Sleep","Uint",100)
        end:=A_TickCount
        diff:=end - start
        diff_list.=diff "`n"

        if (DllCall("GetForegroundWindow","Ptr")==to_activate) {
            ++success_count
        } else {
            failed_indexes.=attempt_num "`n"
        }
        ++attempt_num
    }

    releaseAllModifiers()
    killOutputVarPID()
}

releaseAllModifiers() {
    DllCall("keybd_event", "uchar", GetKeyVK("LCtrl"), "uchar", GetKeySC("LCtrl"), "uint", 2, "ptr", 0)
    DllCall("keybd_event", "uchar", GetKeyVK("LShift"), "uchar", GetKeySC("LShift"), "uint", 2, "ptr", 0)
    DllCall("keybd_event", "uchar", GetKeyVK("LWin"), "uchar", GetKeySC("LWin"), "uint", 2, "ptr", 0)
    DllCall("keybd_event", "uchar", GetKeyVK("LAlt"), "uchar", GetKeySC("LAlt"), "uint", 2, "ptr", 0)

    DllCall("keybd_event", "uchar", GetKeyVK("RShift"), "uchar", GetKeySC("RShift"), "uint", 2, "ptr", 0)
    DllCall("keybd_event", "uchar", GetKeyVK("RCtrl"), "uchar", GetKeySC("RCtrl"), "uint", 2, "ptr", 0)
    DllCall("keybd_event", "uchar", GetKeyVK("RAlt"), "uchar", 0, "uint", 2, "ptr", 0)
}

MsgBox A_Clipboard:=gather()
ExitApp

killOutputVarPID() {
    global OutputVarPID

    bak_A_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows 1
    if (OutputVarPID && WinExist("ahk_pid " OutputVarPID)) {
        WinClose("ahk_pid " OutputVarPID)
    }
    DetectHiddenWindows bak_A_DetectHiddenWindows
}

gather() {
    global success_count, failed_indexes, diff_list
    releaseAllModifiers()
    killOutputVarPID()
    return "success_count:" success_count "`n" failed_indexes "`n`n" diff_list
}

*f3::{
    A_Clipboard:=gather()
    Sleep 100
    ExitApp
}