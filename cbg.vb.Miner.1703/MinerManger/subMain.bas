Attribute VB_Name = "subMain"
Option Explicit
Public Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredaccess&, ByVal bInherithandle&, ByVal dwProcessid&) As Long
Private Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public serverListInfo As New ServerHander
Public thisLogger As New clsLogger
Public Function killThread(threadPid As String) As String
    killThread = TaskKill(Val(threadPid))
End Function

Public Function TaskKill(ByVal PID As Long) As String
    Dim lProcess As Long, ret As Long
    lProcess = OpenProcess(&H1F0FFF, False, PID)
    ret = TerminateProcess(lProcess, 0&)
    If ret <> 0 Then
        TaskKill = "closeSucess"
    End If
    CloseHandle lProcess
End Function
Public Sub init()
    thisLogger.logInfo "mainThreadInit"
    loadServerInfo
    loadRegSeverInfo
    refreshList
    FrmMain.ip(0).Text = GetInfo("Main\Setting\CoreSetting", "defaultInterval", "2500")
    FrmMain.ip(1).Text = GetInfo("Main\Setting\CoreSetting", "defaultRunNum", "2")
    FrmMain.ip(2).Text = GetInfo("Main\Setting\CoreSetting", "threadTimeOutNum", "2000")
    FrmMain.ip(3).Text = GetInfo("Main\Setting\CoreSetting", "threadCloseTimeOutNum", "3000")
    FrmMain.ip(4).Text = GetInfo("Main\Setting\CoreSetting", "addNewThreadInterval", "5000")
    FrmMain.IpResetThread(0).Text = GetInfo("Main\Setting\CoreSetting", "IpResetThread(0)", "800")
    FrmMain.IpResetThread(1).Text = GetInfo("Main\Setting\CoreSetting", "IpResetThread(1)", "Ê§°Ü")
    Dim tmp As String
    tmp = GetInfo("Main\Setting\MainCoreSetting", "loggerActive", "disable")
    Select Case tmp
        Case "active":
            FrmMain.optSelect(0).value = Checked
            FrmMain.optSelect(1).value = Checked
            FrmMain.optSelect(1).Visible = True
        Case "logError":
            FrmMain.optSelect(0).value = Checked
            FrmMain.optSelect(1).Visible = True
        Case Else:
    End Select
    
End Sub
Private Sub loadRegSeverInfo()
On Error GoTo Err:
    thisLogger.logInfo "loadRegSeverInfo()", 1
    Dim tmpServerNum As Long
    tmpServerNum = Val(GetInfo("Main\Setting\ServerInfo", "ServerNum"))
    Dim i As Long
    For i = 1 To tmpServerNum
        Dim tmp As String
        tmp = GetInfo("Main\Setting\ServerInfo\ServerList", "Server " & i)
        tmp = Replace(tmp, " ", "")
        Dim tmpInfo() As String
        tmpInfo = Split(tmp, ",")
        serverListInfo.Add tmpInfo(1), "ServerName#" & tmpInfo(0)
        serverListInfo.Add tmpInfo(2), "AeroID#" & tmpInfo(0)
        serverListInfo.Add tmpInfo(3), "AeroName#" & tmpInfo(0)
        If UBound(tmpInfo) = 4 Then
            serverListInfo.Add tmpInfo(4), "ServerRunNum#" & tmpInfo(0)
        Else
            serverListInfo.Add "1", "ServerRunNum#" & tmpInfo(0)
        End If
    Next
    Exit Sub
Err:
    SetErr "loadRegSeverInfo()$" & Err.Description
    thisLogger.WriteErrLog "loadRegSeverInfo()", Err.Number, Err.Description
    If MsgBox("¼ÌÐøÔËÐÐ?", vbYesNo) = vbNo Then End
End Sub

