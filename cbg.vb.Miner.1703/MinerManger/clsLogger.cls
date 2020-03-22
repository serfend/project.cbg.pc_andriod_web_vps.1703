VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsLogger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public gstrLogPath As String
Private nowRecordTime As Long, thisLogIndex As String
Private Sub Class_Initialize()
    setLogNowIndex "-" & Format(Now, "hhmmss")
    gstrLogPath = App.Path & "\log\C" & getLogNowIndex    'Log路径
    Dim nowRecordTime As Long
    nowRecordTime = Val(GetInfo("Main\Setting\MainCoreSetting", "recordNum"))
    nowRecordTime = nowRecordTime + 1
    SetInfo CStr(nowRecordTime), "Main\Setting\MainCoreSetting", "recordNum"
    setAppVersion
End Sub
Public Static Sub setLogNowIndex(nowIndex As String)
    thisLogIndex = nowIndex
    SetInfo nowIndex, "Main\Setting\CoreSetting", "LogIndex"
End Sub
Public Static Function getLogNowIndex() As String
    getLogNowIndex = GetInfo("Main\Setting\CoreSetting", "LogIndex")
End Function
Public Static Sub setRunTime()
    SetInfo CStr(Now), "Main\Setting\MainCoreSetting\runTime", "run:" & nowRecordTime
    logInfo "startMainThread"
End Sub
Public Static Sub setCloseTime()
    SetInfo CStr(Now), "Main\Setting\MainCoreSetting\closeTime", "close:" & nowRecordTime
    logInfo "terminateMainThread"
End Sub
Private Static Sub setAppVersion()
    SetInfo App.Major & "." & App.Minor & "." & App.Revision, "Main\Setting\MainCoreSetting\version", "version:" & nowRecordTime
    logInfo "mainThreadVersion:" & App.Major & "." & App.Minor & "." & App.Revision
End Sub
Public Static Function logInfo(ByVal strInfo As String, Optional ByVal logRank As Long) As Boolean
    Dim prfrmmainOpShowLog As String
    prfrmmainOpShowLog = FrmMain.opShowLog.Caption
    FrmMain.opShowLog.Caption = Format(Now, "hh:mm:ss") & "." & Format(GetTickCount Mod 1000, "000") & " :" & strInfo & vbCrLf & Mid(prfrmmainOpShowLog, 1, 200)
    Dim FileHandle As Long
    Dim strTxtName As String        '
    Dim FSOLog As Object            '
    
    On Error GoTo WriteLogFileErr:

    Set FSOLog = CreateObject("Scripting.FileSystemObject")
    
    logInfo = True

    If (gstrLogPath = "") Then
        logInfo = False
        GoTo WriteLogFileErr:
    End If
    
    '文件名
    strTxtName = Format(Date, "YYYYMMDD") & thisLogIndex & ".txt"
    
    '判断是否有Log文件夹
    If Dir(gstrLogPath, vbDirectory) = "" Then
            MkDir gstrLogPath
    End If

    FileHandle = FreeFile
    Open (gstrLogPath & "\" & strTxtName) For Append As #FileHandle
    Lock #FileHandle
        Print #FileHandle, Space(logRank * 2) & Format(Time, "HH:MM:SS") & " :" & strInfo
    Unlock #FileHandle
    Close #FileHandle
    
    Set FSOLog = Nothing
    Exit Function

WriteLogFileErr:
        logInfo = False
End Function


Public Static Function WriteErrLog(ByVal strErrLog As String, Optional ByVal strErrNumber As String, Optional ByVal strErrDesc As String) As Boolean
    Dim FileHandle As Long
    Dim strTxtName As String        '
    Dim FSOLog As Object            '
    
    On Error GoTo WriteLogFileErr:

    Set FSOLog = CreateObject("Scripting.FileSystemObject")
    
    WriteErrLog = True

    If (gstrLogPath = "") Then
        WriteErrLog = False
        GoTo WriteLogFileErr:
    End If
    
    '文件名
    strTxtName = Format(Date, "YYYYMMDD") & thisLogIndex & ".txt"
    
    '判断是否有Log文件夹
    If Dir(gstrLogPath, vbDirectory) = "" Then
            MkDir gstrLogPath
    End If

    FileHandle = FreeFile
    Open (gstrLogPath & "\" & strTxtName) For Append As #FileHandle
    Lock #FileHandle
        Print #FileHandle, "Date & Time: " & Format(Time, "HH:MM:SS")
        Print #FileHandle, "Program Name: " & App.EXEName
        Print #FileHandle, "Error Number: " & strErrNumber
        Print #FileHandle, "Error Desc: " & strErrDesc
        Print #FileHandle, "Log: " & strErrLog
        Print #FileHandle, vbNewLine
    Unlock #FileHandle
    Close #FileHandle
    
    Set FSOLog = Nothing
    Exit Function

WriteLogFileErr:
        WriteErrLog = False
End Function

