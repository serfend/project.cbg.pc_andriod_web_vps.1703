VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CCmdCtl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public lastRun As Date, notFirstTimeRun As Boolean
Public isRunning As Boolean
Public Function getCmd(Optional targetUrl As String) As Long
    DoEvents
    SetInfo CStr(Now), "Main\Setting\cmd", thisExeThreadId & ".lastRunTime"
    getCmd = needRefresh(targetUrl)
End Function
Public Sub refresh()
    lastRun = Now
End Sub
Private Function getNowCmd(threadId As String) As String
    getNowCmd = GetInfo("Main\ThreadCmd\" & threadId, "cmd")
    setRefresh threadId
End Function
Private Function needRefresh(Optional targetUrl As String) As Long
    If Not notFirstTimeRun Then
        notFirstTimeRun = True
        needRefresh = 2333
        targetUrl = getDefaultUrl
        setRefresh thisExeThreadId
        Exit Function
    End If
    If DateDiff("s", lastRun, Now) < 10 Then
        needRefresh = -1
        Exit Function
    End If
    Dim rel As String
    Select Case getNowCmd(thisExeThreadId)
        Case "": needRefresh = -1
        Case "subClose": needRefresh = 404
        Case "refresh": needRefresh = 1
        Case "newWeb": needRefresh = 233
    End Select
End Function
Private Sub setRefresh(threadId As String)
    SetInfo "", "Main\ThreadCmd\" & threadId, "cmd"
End Sub

Private Function getDefaultUrl() As String
    DoEvents
    getDefaultUrl = GetInfo("Main\Setting\Cmd", thisExeThreadId & ".defaultUrl")
    If getDefaultUrl = "" Then
        getDefaultUrl = "http://xy2.cbg.163.com/"
        'MsgBox getMeNames & "未指定的区，请在主线程设置"
    End If
    DoEvents
End Function
