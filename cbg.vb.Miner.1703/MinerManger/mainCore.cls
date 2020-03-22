VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "mainCore"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"CoreList"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Private mvarCoreID As String, thisCoreCloseCounter As Long
Private mvarInterval As Long
Private mvarTask As String
Private mvarStatus As String
Private thisCoreRegPath As String, thisCoreExePath As String
Private RefreshedLastTime As Boolean
Private thisCorePid As String
Public lastKey As String, nextKey As String
Private thisCoreBeginTime As Long, CoreCloseInterval As Long
Private CoreCloseKeyWord As String
Private outofControlTimes As Long
Public Function Terminate() As String
    Task = "#subClose#"
    Status = "进程关闭"
    thisCorePid = GetInfo("Main\Thread\" & mvarCoreID, "corePid")
    Debug.Print "thisPid:" & thisCorePid
    Terminate = killThread(thisCorePid)
    Debug.Print "kill thisPid" & Terminate
End Function
Public Sub pause()
    Task = "#subPause#"
End Sub
Public Sub reSet(srcCore As mainCore)
    With srcCore
        Me.CoreId = .CoreId
        Me.lastKey = .lastKey
        Me.nextKey = .nextKey
    End With
End Sub
Public Sub init(thisCoreId As String, thisInterval As Long, thisTask As String, Optional Active As Boolean = True, Optional closeInterval As Long = 300000, Optional closeKeyWord As String = "失败")
    CoreCloseKeyWord = closeKeyWord
    CoreCloseInterval = closeInterval
    RefreshedLastTime = True
    mvarCoreID = thisCoreId
    thisCoreRegPath = "Main\Thread\" & mvarCoreID
    thisCoreExePath = App.Path & "\Miner.exe"
    Interval = thisInterval
    Task = thisTask
    
    'Shell "cmd.exe " & thisCoreExePath, vbHide
    If Active Then
        CoreBeginTime = GetTickCount
        ShellExecute FrmMain.hwnd, "open", thisCoreExePath, mvarCoreID, "", 7
    End If
    RefreshedLastTime = False
    Status = "新建的线程"
End Sub
Public Property Get outofControlTime() As Long
    outofControlTime = outofControlTimes
End Property
Public Property Let outofControlTime(value As Long)
    outofControlTimes = value
End Property
Public Property Get CoreBeginTime() As Long
    CoreBeginTime = thisCoreBeginTime
End Property
Public Property Let CoreBeginTime(value As Long)
    thisCoreBeginTime = value
End Property
Public Property Let Status(ByVal vData As String)
    mvarStatus = vData
    SetInfo mvarStatus, thisCoreRegPath, "Status"
    Refresh
End Property
Public Property Get Status() As String
    Status = GetInfo(thisCoreRegPath, "Status")
    If CoreCloseKeyWord <> "" Then
        If InStr(1, Status, CoreCloseKeyWord) > 0 Then
            'Terminate
        End If
    End If
End Property
Public Property Get runTime() As String
    runTime = GetInfo(thisCoreRegPath, "RunTime")
    If Val(runTime) - CoreBeginTime > CoreCloseInterval Then
        'Terminate
    End If
End Property
Public Property Let Task(ByVal vData As String)
    mvarTask = vData
    SetInfo mvarTask, thisCoreRegPath, "Task"
    Refresh
End Property
Public Property Get Task() As String
    Task = mvarTask
End Property
Public Property Let Interval(ByVal vData As Long)
    mvarInterval = vData
    SetInfo CStr(vData), thisCoreRegPath, "runInterval"
    Refresh
End Property
Public Property Get Interval() As Long
    Interval = mvarInterval
End Property
Public Property Let CoreId(ByVal vData As String)
    mvarCoreID = vData
End Property
Public Property Get CoreId() As String
    CoreId = mvarCoreID
End Property
Public Property Get needNewIP() As Boolean
    needNewIP = (GetInfo(thisCoreRegPath, "needNewIp") = "1")
End Property
Public Property Let needNewIP(ByVal vData As Boolean)
    SetInfo CStr(IIf(vData, "1", "0")), thisCoreRegPath, "needNewIP"
End Property
Public Property Get ip() As String
    ip = GetInfo(thisCoreRegPath, "Ip")
End Property
Public Property Let ip(ByVal vData As String)
    SetInfo vData, thisCoreRegPath, "Ip"
End Property
Private Sub Refresh()
    If RefreshedLastTime Then Exit Sub
    SetInfo "1", thisCoreRegPath, "Refreshed"
End Sub

