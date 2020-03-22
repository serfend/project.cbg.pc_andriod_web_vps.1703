VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "childWeb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private nowChild As New Collection, nowChildIndexs As Long
Private thisCoreExePath As String
Public Function loadNewChild(listIndex As Long) As String
    runChild CStr(listIndex + 1)
End Function
Private Sub runChild(childId As String)
    'MsgBox thisCoreExePath & "开启线程:" & childId
    ShellExecute frmMain.hwnd, "open", thisCoreExePath, childId, "", 1
End Sub
Public Function refresh() As String
On Error GoTo Err:
    getNextChild nowChildIndexs
    refreshChild nowChildIndexs
    refresh = childName(nowChildIndexs)
    If refresh <> "" Then refresh = "刷新:" & refresh
    Exit Function
Err:
    MsgBox "refresh()" & Err.Description
End Function
Private Sub refreshChild(nowChildIndex As Long)
     SetInfo "refresh", "Main\ThreadCmd\" & nowChildIndex, "cmd"
End Sub
Private Sub getNextChild(nowChildIndex As Long)
    Do
        nowChildIndex = nowChildIndex + 1
        If childName(nowChildIndex) = "" Then Exit Do
        If childRun(nowChildIndex) Then Exit Sub
    Loop
    nowChildIndex = 1
End Sub
Private Sub Class_Initialize()
    thisCoreExePath = App.Path & "\多开浏览器子线程.exe"
End Sub
Public Function getAllChild() As String()
    On Error GoTo Err:
    Dim i As Long, thisChildName As String, rel() As String
    ReDim rel(0)
    Do
        i = i + 1
        thisChildName = childName(i)
        If thisChildName = "" Then Exit Do
        ReDim Preserve rel(i)
        rel(i) = "[" & IIf(childRun(i), "运行", "未运行") & "]" & thisChildName & "." & ChildAlias(i) & "." & childServer(i) & ":" & ChildDefaultUrl(i)
    Loop
    getAllChild = rel
    Exit Function
Err:
    MsgBox "GetAllChild()" & Err.Description
End Function
Public Property Get childServer(childIndex As Long) As String
    childServer = GetInfo("Main\Setting\cmd", childIndex & ".server")
End Property
Public Property Let childServer(childIndex As Long, vData As String)
    SetInfo vData, "Main\Setting\cmd", childIndex & ".server"
    SetInfo CStr(childIndex), "Main\Setting\cmd\Server", "server" & vData
End Property
Public Property Get childName(childIndex As Long) As String
    childName = GetInfo("Main\Setting\cmd", childIndex & ".name")
End Property
Public Property Let childName(childIndex As Long, vData As String)
    SetInfo vData, "Main\Setting\cmd", childIndex & ".name"
End Property
Public Property Get ChildDefaultUrl(childIndex As Long) As String
    ChildDefaultUrl = GetInfo("Main\Setting\cmd", childIndex & ".defaultUrl")
End Property
Public Property Let ChildDefaultUrl(childIndex As Long, vData As String)
    SetInfo vData, "Main\Setting\cmd", childIndex & ".defaultUrl"
End Property
Public Property Get ChildAlias(childIndex As Long) As String
    ChildAlias = GetInfo("Main\Setting\cmd", childIndex & ".Alias")
End Property
Public Property Let ChildAlias(childIndex As Long, vData As String)
    SetInfo vData, "Main\Setting\cmd", childIndex & ".Alias"
End Property
Public Property Get childRun(childIndex As Long) As Boolean
On Error GoTo Err:
    Dim tmp As String
    tmp = GetInfo("Main\Setting\cmd", childIndex & ".lastRunTime")
    
    If tmp = "" Then Exit Property
    If Abs(DateDiff("s", tmp, Format(IIf(Hour(Now) > 12, Now - 0.5, Now), "yyyy-MM-dd hh:mm:ss"))) < 5 Then childRun = True
Exit Property
Err:
    MsgBox "ChildRun()" & Err.Description
End Property
