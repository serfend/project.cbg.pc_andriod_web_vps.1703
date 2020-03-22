VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "mainThread"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Option Explicit
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long) '声明

Private lastRunTimeCount As Long, canProxy As Boolean
Private Running As Boolean, HandleServerId() As Server, serverNum As Long, threadInterval As Long
Public Property Get IsRun() As Boolean
    IsRun = Running
End Property
Public Function sRun() As Long
On Error GoTo Err:
    thisLogger.logInfo getMeNames & "Thread.sRun()", 2
    Running = True
    Me.pause
    While (Running)
        getAllServerInfo
        'Debug.Print threadInterval
        'Me.pause
    Wend
    Exit Function
Err:
    'thisLogger.WriteErrLog getMeNames & "sRun()", Err.Number, Err.Description
    SetErr getMeNames & "sRun()$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Sub resetTask(taskInfo As String)
    Dim i As Long
    For i = 0 To serverNum - 1
        Set HandleServerId(i) = Nothing
    Next
    serverNum = 0
    Dim TaskServerIds() As String
    TaskServerIds = Split(taskInfo, "#")
    
    ReDim HandleServerId(UBound(TaskServerIds))
    For i = 0 To UBound(TaskServerIds)
        If TaskServerIds(i) <> "" Then
            serverNum = serverNum + 1
            Set HandleServerId(i) = New Server
            HandleServerId(i).init TaskServerIds(i)
        End If
    Next
End Sub
Public Function sStop() As Long
    Running = False
    If GetInfo("Main\setting\media", "threadStop") = "1" Then threadMediaer.play
End Function
Public Function getAllServerName() As String
    Dim i As Long
    If serverNum = 0 Then Exit Function
    For i = 0 To serverNum - 1
        getAllServerName = getAllServerName & HandleServerId(i).thisServerId & IIf(i < serverNum - 1, ",", "")
    Next
    
End Function
Private Sub getAllServerInfo()
On Error GoTo Err:
    Dim i As Long
    
    If serverNum = 0 Then
        setStatus "空闲"
        Me.pause
    End If
    For i = 0 To serverNum - 1
        setStatus "处理:" & HandleServerId(i).thisServerId
        'If canProxy Then getServerInfo i
        getServerInfo i
        
        Me.pause
        'setStatus "处理完成:" & HandleServerId(i)
    Next
Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "mainThread.getAllServerInfo()", Err.Number, Err.Description
    SetErr getMeNames & "mainThread.getAllServerInfo()$ " & Err.Description
    If 123 = 123 Then End
End Sub
Private Sub getServerInfo(serverIndex As Long)
    HandleServerId(serverIndex).getNewInfo
End Sub
Public Function setInterval(ByVal DelayTimes As Long) As Long
    If DelayTimes < 0 Then DelayTimes = 0
    threadInterval = DelayTimes
End Function
Public Function pause()
On Error GoTo Err:
    Dim breathTimeCounter As Long, nowIntervalRunTimeCount As Long
    Dim forErrDes As String
    Do
        forErrDes = "Sleep 100"
        Sleep 100
        forErrDes = "setRunTime"
        setRunTime
        forErrDes = "DoEvents"
        DoEvents
        forErrDes = "breathTimeCounter++"
        breathTimeCounter = breathTimeCounter + 1
        forErrDes = "if breathTimeCounter%5"
        'If breathTimeCounter Mod 5 = 0 Then
        '    forErrDes = "setHeartBreath"
        '    ClientFrm.setHeartBreath
        '    thisLogger.logInfo getMeNames & "pause()breathSuccess", 4
            forErrDes = "resetConfi"
            resetConfi
        '    canProxy = True
        '    breathTimeCounter = 0
        'End If
        forErrDes = "if mainThreadStatusActive"
        If mainThreadStatusActive = False Then sStop
        forErrDes = "nowIntervalRunTimeCount-="
        nowIntervalRunTimeCount = GetTickCount - lastRunTimeCount
        forErrDes = "if nowIntervalRunTimeCount >"
        If nowIntervalRunTimeCount > threadInterval Then
            lastRunTimeCount = GetTickCount
            Exit Do
        End If
    Loop
    
    Exit Function
Err:
    SetErr getMeNames & "pause()" & Err.Description
    thisLogger.logInfo getMeNames & "pos:" & forErrDes
    'thisLogger.WriteErrLog getMeNames & "pause()", Err.Number, Err.Description & forErrDes
    If 123 = 123 Then End
End Function
Private Function mainThreadStatusActive() As Boolean
On Error GoTo Err:
    Dim mainSubThreadRunTime As Long
    If getThisThreadId = "test" Then
        mainThreadStatusActive = True
        Exit Function
    End If
    mainSubThreadRunTime = GetTickCount - getMainThreadRunTime
    If mainSubThreadRunTime > 4000 Then
        mainThreadStatusActive = False
    Else
        mainThreadStatusActive = True
    End If
    Exit Function
Err:
    mainThreadStatusActive = True
End Function
Private Function getMainThreadRunTime() As String
    getMainThreadRunTime = Val(GetInfo("Main\Thread\Main", "lastRunTime"))
End Function
Private Sub Class_Initialize()
    thisLogger.logInfo getMeNames & "ThreadInit()", 2
End Sub
