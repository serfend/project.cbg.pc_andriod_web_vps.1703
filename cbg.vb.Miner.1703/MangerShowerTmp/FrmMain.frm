VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form FrmMain 
   Caption         =   "数据显示"
   ClientHeight    =   8505
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   9540
   LinkTopic       =   "Form1"
   ScaleHeight     =   8505
   ScaleWidth      =   9540
   StartUpPosition =   3  '窗口缺省
   Begin MSComctlLib.ListView MainOutPut 
      Height          =   1935
      Left            =   0
      TabIndex        =   1
      Top             =   120
      Width           =   9495
      _ExtentX        =   16748
      _ExtentY        =   3413
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.TextBox ip 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15.75
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   630
      TabIndex        =   0
      Text            =   "2000"
      Top             =   2520
      Width           =   1095
   End
   Begin VB.Timer MainMover 
      Interval        =   2000
      Left            =   90
      Top             =   90
   End
   Begin VB.Menu mnCopy 
      Caption         =   "复制地址"
      Visible         =   0   'False
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private tD As New dateSaver
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, _
ByVal lpoperation As String, ByVal lpfile As String, ByVal lpparameters As String, _
ByVal lpdirectory As String, ByVal nshowcmd As Long) As Long
Private serverIdList() As String, serverIdListNum As Long
Private Sub loadAllServerId()
    Dim i As Long
    serverIdListNum = Val(GetInfo("Main\Setting\ServerInfo", "ServerNum"))
    ReDim serverIdList(serverIdListNum)
    For i = 1 To serverIdListNum
        serverIdList(i) = GetInfo("Main\Setting\ServerInfo\ServerList", "Server " & i)
        Dim tmp() As String
        tmp = Split(serverIdList(i), ",")
        serverIdList(i) = tmp(0)
    Next
End Sub
Private Sub Form_Load()
    DelSub "main", "data"
    loadMedia
    ip.Text = GetInfo("Main\Setting\ShowTmpSetting", "refreshInterval", "2000")
    loadAllServerId
    With MainOutPut
        .ColumnHeaders.Add , , "服务器", .Width * 0.1
        .ColumnHeaders.Add , , "名称", .Width * 0.1
        .ColumnHeaders.Add , , "价格", .Width * 0.1
        .ColumnHeaders.Add , , "等级", .Width * 0.1
        .ColumnHeaders.Add , , "天赋点数", .Width * 0.1
        .ColumnHeaders.Add , , "功绩点数", .Width * 0.1
        .ColumnHeaders.Add , , "帮派成就", .Width * 0.1
        .ColumnHeaders.Add , , "家族回灵", .Width * 0.1
        .ColumnHeaders.Add , , "购买链接", .Width * 0.3
        .Font.Size = 16
    End With
    thisLogger.setRunTime
    'mWeb.Silent = True
End Sub
Private Sub Form_Resize()
    MainOutPut.Move Me.Width * 0.01, Me.Height * 0.01, Me.Width * 0.95, Me.Height * 0.7
    'mWeb.Move Me.Width * 0.01, Me.Height * 0.16, Me.Width * 0.98, Me.Height * 0.85
    ip.Move Me.Width * 0.05, Me.Height * 0.75
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SetInfo ip.Text, "Main\Setting\ShowTmpSetting", "refreshInterval"
    thisLogger.setCloseTime
    Set tD = Nothing
End Sub

Private Sub MainMover_Timer()
    MainMover.Interval = Val(ip.Text)
    Dim i As Long
    For i = 1 To serverIdListNum
        Dim nextCoreId As String
        'nextCoreId = serverIdList(i)
        thisServerId = serverIdList(i) ' GetInfo("Main\Data\DataList\Core\@" & nextCoreId, "hasNew")
        If thisServerId <> "" Then
            Dim thisJudgeInfo As String, thisOrderSn As String, thisServerName As String
            Dim nextServerInfo As String
            thisServerName = GetInfo("Main\Data\DataList\Server\@" & thisServerId, "serverName")
            If thisServerName <> "" Then
                nextServerInfo = GetInfo("Main\Data\DataList\Server\@" & thisServerId, "info")
                thisOrderSn = GetInfo("Main\Data\DataList\Server\@" & thisServerId, "ordersn")
                thisJudgeInfo = thisServerId & nextServerInfo & thisOrderSn
                If tD(thisJudgeInfo) <> "exist" Then
                    thisLogger.startFun "addNewServerGetInfo"
                    tD.Add "exist", thisJudgeInfo
                    Dim tmp As String, thisData() As String, j As Long
                    thisData = Split(nextServerInfo, "##")
                    Me.Caption = "读取数据:" & thisOrderSn
                    With MainOutPut
                        thisLogger.logInfo "ListItemsAdds"
                        .ListItems.Add 1, , thisServerName
                        If GetInfo("Main\setting\media", "threadNewObj") = "1" Then threadMediaer.play
                        For j = 1 To UBound(thisData) + 1
                            .ListItems(1).SubItems(j) = thisData(j - 1)
                        Next
                        .ListItems(1).SubItems(8) = getIniUrl(CStr(thisServerId), thisOrderSn, thisServerName)
                        If .ListItems.Count > 10 Then .ListItems.Remove 11
                        DoEvents
                    End With
                End If
            End If
        End If
    Next
    
    Me.Caption = "读取数据 " & tD.Count
End Sub
Private Function getIniUrl(showThisServerId As String, showThisOrderSn As String, showThisServerName As String) As String
    getIniUrl = "http://xy2.cbg.163.com/cgi-bin/equipquery.py?act=buy_show_by_ordersn&server_id=" _
        & showThisServerId & "&ordersn=" & showThisOrderSn _
            & "&server_name=" & showThisServerName
End Function
Private Sub MainOutPut_DblClick()
On Error Resume Next
    Dim thisUrl As String
    thisUrl = MainOutPut.SelectedItem.SubItems(8)
    If Mid(thisUrl, 1, 4) = "http" Then
    '    mWeb.Navigate2 thisUrl
        showUrl thisUrl
    End If
End Sub
Private Sub showUrl(url As String)
    Dim thisWebThreadId As String, serverId As String
    serverId = getServerId(url)
    thisWebThreadId = getWebThreadId(serverId)
    If thisWebThreadId <> "" Then
        'If MsgBox("是否在独立浏览器显示", vbYesNo) = vbYes Then
            SetInfo "newWeb", "Main\ThreadCmd\" & thisWebThreadId, "cmd"
            SetInfo url, "Main\ThreadCmd\" & thisWebThreadId, "url"
            Exit Sub
        'End If
    End If
    ShellExecute Me.hwnd, "open", thisUrl, "", "", 0
End Sub
Private Function getServerId(url As String) As String
    Dim idBegin As Long, idEnd As Long
    idBegin = InStr(1, url, "server_id=")
    idEnd = InStr(1, url, "&ordersn")
    If idBegin = 0 Or idEnd = 0 Then
    
    Else
        getServerId = Mid(url, idBegin + Len("server_id="), idEnd - idBegin - Len("server_id="))
    End If
End Function
Private Function getWebThreadId(serverId As String) As String
    getWebThreadId = GetInfo("Main\Setting\cmd\Server", "server" & serverId)
End Function

Private Sub MainOutPut_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = vbRightButton Then
        'PopupMenu mnCopy
    End If
End Sub

Private Sub mnCopy_Click()
On Error Resume Next
    Dim thisUrl As String
    thisUrl = MainOutPut.SelectedItem.SubItems(8)
    If Mid(thisUrl, 1, 4) = "http" Then
    '    mWeb.Navigate2 thisUrl
        Clipboard.SetText thisUrl
    End If
End Sub
