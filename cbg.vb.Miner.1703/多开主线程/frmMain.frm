VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "网页多开主线程"
   ClientHeight    =   11280
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   6915
   LinkTopic       =   "Form1"
   ScaleHeight     =   11280
   ScaleWidth      =   6915
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox ip 
      Height          =   270
      Index           =   4
      Left            =   3960
      TabIndex        =   12
      Top             =   480
      Width           =   1455
   End
   Begin VB.CommandButton cmd 
      Caption         =   "打开"
      Height          =   375
      Index           =   2
      Left            =   6000
      TabIndex        =   11
      Top             =   480
      Width           =   855
   End
   Begin VB.CommandButton cmd 
      Caption         =   "保存"
      Default         =   -1  'True
      Height          =   375
      Index           =   1
      Left            =   2880
      TabIndex        =   10
      Top             =   120
      Width           =   855
   End
   Begin VB.TextBox ip 
      Height          =   270
      Index           =   3
      Left            =   4800
      TabIndex        =   9
      Text            =   "60"
      Top             =   120
      Width           =   975
   End
   Begin VB.Timer MainTimer 
      Interval        =   1000
      Left            =   6480
      Top             =   0
   End
   Begin VB.CommandButton cmd 
      Caption         =   "新增"
      Height          =   375
      Index           =   0
      Left            =   2880
      TabIndex        =   7
      Top             =   480
      Width           =   855
   End
   Begin VB.ListBox sList 
      Height          =   9960
      Left            =   120
      MultiSelect     =   2  'Extended
      TabIndex        =   6
      Top             =   1320
      Width           =   6735
   End
   Begin VB.TextBox ip 
      Height          =   270
      Index           =   2
      Left            =   600
      TabIndex        =   2
      Top             =   840
      Width           =   6255
   End
   Begin VB.TextBox ip 
      Height          =   270
      Index           =   1
      Left            =   600
      TabIndex        =   1
      Top             =   480
      Width           =   2175
   End
   Begin VB.TextBox ip 
      Height          =   270
      Index           =   0
      Left            =   600
      TabIndex        =   0
      Top             =   120
      Width           =   2175
   End
   Begin VB.Label Label1 
      Caption         =   "刷新间隔"
      Height          =   255
      Index           =   3
      Left            =   3960
      TabIndex        =   8
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "网址"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   495
   End
   Begin VB.Label Label1 
      Caption         =   "区号"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   480
      Width           =   495
   End
   Begin VB.Label Label1 
      Caption         =   "名称"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   495
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private cdList As New childWeb
Private nowTimeCounter As Long

Private Sub cmd_Click(Index As Integer)
On Error GoTo Err:
    Select Case Index
        Case 0: '新增
            cdList.childName(sList.ListCount + 1) = "新建的浏览器"
        Case 1: '保存
            SetInfo ip(3).Text, "Main\Setting\Cmd", "childRefreshInterval"
            Dim nowIndex As Long
            nowIndex = sList.listIndex + 1
            cdList.childName(nowIndex) = ip(0).Text
            cdList.childServer(nowIndex) = ip(1).Text
            cdList.ChildDefaultUrl(nowIndex) = ip(2).Text
            cdList.ChildAlias(nowIndex) = ip(4).Text
            MsgBox "保存成功"
        Case 2:
            sList_DblClick
    End Select
    reLoadList
    Exit Sub
Err:
    MsgBox "cmd_Click()" & Err.Description
End Sub
Private Sub reLoadList()
On Error GoTo Err:
    'MsgBox "reload"
    sList.Clear
    
    Dim tmp() As String
    'MsgBox "getAllChild"
    tmp = cdList.getAllChild
    Dim i As Long
    'MsgBox "AddItem"
    For i = 1 To UBound(tmp)
        sList.AddItem tmp(i)
    Next
        Exit Sub
Err:
    MsgBox "reLoadList()" & Err.Description
End Sub
Private Sub Form_Load()
    ip(3).Text = GetInfo("Main\Setting\Cmd", "childRefreshInterval", "60")
    reLoadList
End Sub

Private Sub Form_Resize()
On Error Resume Next
    sList.Height = Me.Height - sList.Top
End Sub

Private Sub ip_Change(Index As Integer)
    Select Case Index
        Case 3:
            SetInfo ip(3).Text, "Main\Setting\Cmd", "childRefreshInterval"
    End Select
End Sub

Private Sub MainTimer_Timer()
    On Error GoTo Err:
    nowTimeCounter = nowTimeCounter + 1
    If nowTimeCounter Mod 10 = 0 Then
        reLoadList
    End If
    If nowTimeCounter >= Val(ip(3).Text) Then
        nowTimeCounter = 0
        Me.Caption = "多开主线程 - " & cdList.refresh
    End If
    Exit Sub
Err:
    MsgBox "MainThread()" & Err.Description
End Sub

Private Sub sList_Click()
On Error GoTo Err:
    Dim nowIndex As Long
    nowIndex = sList.listIndex + 1
    ip(0).Text = cdList.childName(nowIndex)
    ip(1).Text = cdList.childServer(nowIndex)
    ip(2).Text = cdList.ChildDefaultUrl(nowIndex)
    ip(4).Text = cdList.ChildAlias(nowIndex)
        Exit Sub
Err:
    MsgBox "sList_Click()" & Err.Description
End Sub

Private Sub sList_DblClick()
On Error GoTo Err:
    Dim i As Long
    For i = 0 To sList.ListCount - 1
        If sList.Selected(i) Then
            cdList.loadNewChild i
            Sleep 500
        End If
    Next
        Exit Sub
Err:
    MsgBox "sList_DblClick()" & Err.Description
End Sub
