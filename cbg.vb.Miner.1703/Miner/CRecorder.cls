VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CRecorder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public gstrLogPath As String, fileName As String
Private nowRecordTime As Long
Private Sub Class_Initialize()
    gstrLogPath = App.path & "\log"     'Log路径
    fileName = "记录" & getMeNames & ".txt"
End Sub
Public Static Function logInfo(ByVal strInfo As String, Optional ByVal logRank As Long) As Boolean
    Dim FileHandle As Long
    Dim FSOLog As Object            '
    On Error GoTo WriteLogFileErr:

    Set FSOLog = CreateObject("Scripting.FileSystemObject")
    
    logInfo = True

    If (gstrLogPath = "") Then
        logInfo = False
        GoTo WriteLogFileErr:
    End If

    '判断是否有Log文件夹
    If Dir(gstrLogPath, vbDirectory) = "" Then
            MkDir gstrLogPath
    End If

    FileHandle = FreeFile
    Open (gstrLogPath & "\" & fileName) For Append As #FileHandle
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
    Dim FileHandle As Long    '
    Dim FSOLog As Object            '
    On Error GoTo WriteLogFileErr:

    Set FSOLog = CreateObject("Scripting.FileSystemObject")
    
    WriteErrLog = True

    If (gstrLogPath = "") Then
        WriteErrLog = False
        GoTo WriteLogFileErr:
    End If
    
    
    '判断是否有Log文件夹
    If Dir(gstrLogPath, vbDirectory) = "" Then
            MkDir gstrLogPath
    End If

    FileHandle = FreeFile
    Open (gstrLogPath & "\" & fileName) For Append As #FileHandle
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


