VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "ieframe.dll"
Begin VB.Form frmMain 
   Caption         =   "多开测试"
   ClientHeight    =   7530
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10710
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   7530
   ScaleWidth      =   10710
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton cmdSaveRefresh 
      Caption         =   "保存2"
      Height          =   315
      Index           =   1
      Left            =   0
      TabIndex        =   8
      Top             =   4000
      Visible         =   0   'False
      Width           =   900
   End
   Begin VB.CommandButton cmdSaveRefresh 
      Caption         =   "保存1"
      Height          =   315
      Index           =   0
      Left            =   1000
      TabIndex        =   7
      Top             =   4000
      Visible         =   0   'False
      Width           =   900
   End
   Begin SHDocVwCtl.WebBrowser WebBrow 
      Height          =   2535
      Left            =   0
      TabIndex        =   6
      Top             =   399
      Width           =   3855
      ExtentX         =   6800
      ExtentY         =   4471
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
   Begin VB.CommandButton cmdCancelTop 
      Caption         =   "取消置顶"
      Height          =   315
      Left            =   4800
      TabIndex        =   5
      Top             =   50
      Width           =   900
   End
   Begin VB.Timer MainTimer 
      Interval        =   200
      Left            =   8280
      Top             =   480
   End
   Begin VB.CommandButton cmdShowBuyList 
      Caption         =   "支付"
      Height          =   315
      Left            =   4200
      TabIndex        =   3
      Top             =   45
      Width           =   675
   End
   Begin VB.ComboBox CboAddress 
      Height          =   300
      ItemData        =   "frmMain.frx":000C
      Left            =   540
      List            =   "frmMain.frx":000E
      TabIndex        =   2
      Top             =   60
      Width           =   2895
   End
   Begin VB.CommandButton CmdNavigate 
      Caption         =   "打开"
      Height          =   315
      Left            =   3480
      TabIndex        =   0
      Top             =   45
      Width           =   675
   End
   Begin VB.Label lb 
      Caption         =   "默认地址："
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   6360
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label LblAddress 
      AutoSize        =   -1  'True
      Caption         =   "地址:"
      Height          =   180
      Left            =   60
      TabIndex        =   1
      Top             =   120
      Width           =   450
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function InternetSetOption Lib "wininet.dll" Alias "InternetSetOptionA" (ByVal hInternet As Long, ByVal dwOption As Long, ByRef lpBuffer As Any, ByVal dwBufferLength As Long) As Long

Private Type INTERNET_PROXY_INFO
    dwAccessType As Long
    lpszProxy As String
    lpszProxyBypass As String
End Type

Private Const INTERNET_OPTION_PROXY = 38&
Private Const INTERNET_OPTION_SETTINGS_CHANGED = 39&
Private Const INTERNET_OPEN_TYPE_DIRECT = 1&
Private Const INTERNET_OPEN_TYPE_PROXY = 3&

Public CCmd As New CCmdCtl
Dim TempPath As String, CookiesPath As String, CachePath As String
Attribute CookiesPath.VB_VarUserMemId = 1073938432
Attribute CachePath.VB_VarUserMemId = 1073938432
Dim bManyWindow As Boolean, bProxy As Boolean
Attribute bProxy.VB_VarUserMemId = 1073938434

Private Sub CboAddress_Click()
    If CboAddress.ListIndex < CboAddress.ListCount - 1 Then
        CmdNavigate_Click
    Else
        CboAddress.Text = ""
        CboAddress.Clear
        CboAddress.AddItem "清空收藏栏(URL+:添加,URL-:删除)"
    End If
End Sub

Private Sub CboAddress_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        KeyAscii = 0
        CmdNavigate_Click
    End If
End Sub

Private Sub cmdCancelTop_Click()
    SetOntop Me.hwnd, 1
End Sub
Private Sub navigateMain(Optional thisTimeUrl As String)
    'If CCmd.isRunning Then Exit Sub
    Dim i As Integer, strTmp As String, strCmd As String
    If thisTimeUrl = "" Then
        CboAddress.Text = Trim(CboAddress.Text)
        strTmp = CboAddress.Text
    Else
        CboAddress.Text = Trim(thisTimeUrl)
        strTmp = Trim(thisTimeUrl)
    End If
    WebBrow.Navigate2 strTmp
End Sub
Private Sub CmdNavigate_Click()
    navigateMain CboAddress.Text
End Sub

Private Sub cmdSaveRefresh_Click(Index As Integer)
    ShowInfos "已保存网页刷新页面" & Index & ":" & WebBrow.LocationURL
    cmdSaveRefresh(Index).Tag = WebBrow.LocationURL
End Sub

Private Sub cmdShowBuyList_Click()
    Dim OrderId As String, tmp As New CString
    'Open App.Path & "\1.txt" For Output As #1
    '    Print #1, WebBrow.Document.Body.InnerHtml
    'Close
    OrderId = tmp.getElementR(WebBrow.Document.Body.InnerHtml, "orderid=", """>进入重新支付页面")
    WebBrow.Navigate "http://xy2.cbg.163.com/cgi-bin/usertrade.py?act=order_to_epay&orderid=" & OrderId
End Sub

Private Sub Form_Initialize()
    Dim wsh As New WshShell
    Dim fso As New FileSystemObject
    Dim str1 As String, str2 As String
    Dim nMany As Integer

    WriteConfig "Set", "Rem", "注释：Many=0 关闭账号多开；1 开启账号多开；2 用户选择"
    WriteConfig "Address", "Rem", "注释：网址收藏栏"
    WriteConfig "Proxy", "Rem", "注释：代理收藏栏"

    nMany = ReadConfig("Set", "Many", 2)
    Select Case nMany
    Case 0
        bManyWindow = False
    Case 1
        bManyWindow = True
    Case Else
        nMany = 2
        WriteConfig "Set", "Many", nMany
        'If MsgBoxEx("启用账号多开吗？", vbQuestion Or vbYesNo) = vbYes Then
            bManyWindow = True
        'Else
        '    bManyWindow = False
        'End If
    End Select

    If bManyWindow Then
        TempPath = App.Path & "\Temp"
        If Not fso.FolderExists(TempPath) Then fso.CreateFolder TempPath
        TempPath = TempPath & "\" & Replace(Replace(Now, ":", "_"), "/", "_")
        If Not fso.FolderExists(TempPath) Then fso.CreateFolder TempPath
        str1 = TempPath & "\Cookies"
        If Not fso.FolderExists(str1) Then fso.CreateFolder str1
        str2 = TempPath & "\Cache"
        If Not fso.FolderExists(str2) Then fso.CreateFolder str2

        CookiesPath = wsh.RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cookies")
        CachePath = wsh.RegRead("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\EXPLORER\User Shell Folders\Cache")
        wsh.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cookies", str1
        wsh.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cache", str2

        InternetSetOption 0, INTERNET_OPTION_SETTINGS_CHANGED, vbNull, 0
    End If
End Sub

Private Sub Form_Load()
    reLocateFrmMe
    Dim i As Integer
    Dim n As Integer, strTmp As String
    Dim wsh As New WshShell
    On Error GoTo Form_LoadErr
    
    bProxy = False
    WebBrow.RegisterAsBrowser = True
    WebBrow.Silent = True

    For i = 0 To 1000
        strTmp = ReadConfig("Address", "URL" & i, "")
        If Len(strTmp) = 0 Then Exit For
        CboAddress.AddItem strTmp
    Next

    CboAddress.AddItem "清空收藏栏(URL+:添加,URL-:删除)"

    'WebBrow.GoHome
    
Form_LoadErr:
    If bManyWindow Then
        wsh.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cookies", CookiesPath
        wsh.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cache", CachePath
    End If
End Sub
Private Sub reLocateFrmMe()
    Dim tmp(4) As Single
    tmp(1) = getMyFrmPosInfo("left", Me.Left)
    tmp(2) = getMyFrmPosInfo("top", Me.Top)
    tmp(3) = getMyFrmPosInfo("width", Me.Width)
    tmp(4) = getMyFrmPosInfo("height", Me.Height)
    'MsgBox "加载:" & tmp(1) & "," & tmp(2) & "," & tmp(3) & "," & tmp(4)
    Me.Move tmp(1), tmp(2), tmp(3), tmp(4)
End Sub
Private Sub recordLocateFrmMe()
    setMyFrmPosInfo "left", Me.Left
    setMyFrmPosInfo "top", Me.Top
    setMyFrmPosInfo "width", Me.Width
    setMyFrmPosInfo "height", Me.Height
End Sub
Private Function getMyFrmPosInfo(propertyInfo As String, Default As Single) As Single
    getMyFrmPosInfo = Val(GetInfo("Main\Setting\frmBrowser\Pos", propertyInfo, CStr(Default)))
    If getMyFrmPosInfo <= 0 Then getMyFrmPosInfo = Default
End Function
Private Sub setMyFrmPosInfo(propertyInfo As String, Value As Single)
    If Value <= 0 Then Exit Sub
    SetInfo CStr(Value), "Main\Setting\frmBrowser\Pos", propertyInfo
End Sub
Private Sub Form_Resize()
    If Me.WindowState <> 1 Then
        If Me.Width < 4335 And Me.Height < 3990 Then
            Me.Move Me.Left, Me.Top, 4335, 3990
        ElseIf Me.Width < 4335 Then
            Me.Width = 4335
        ElseIf Me.Height < 3990 Then
            Me.Height = 3990
        Else
            CboAddress.Width = Me.ScaleWidth - (5015 - 2895) - CmdNavigate.Width * 1.1
            CmdNavigate.Left = Me.ScaleWidth - (5015 - 3480) - CmdNavigate.Width * 1.1
            cmdShowBuyList.Left = Me.ScaleWidth - (5015 - 3480)
            WebBrow.Width = Me.ScaleWidth
            WebBrow.Height = (Me.ScaleHeight - (3080 - 2355)) ' * 0.9
            lb.Width = Me.ScaleWidth * 0.9
            lb.Top = Me.ScaleHeight * 0.91
            cmdCancelTop.Left = Me.ScaleWidth - (5015 - 3480) + cmdShowBuyList.Width * 1.1
            cmdSaveRefresh(0).Move Me.ScaleWidth * 0.01, Me.ScaleHeight * 0.95
            cmdSaveRefresh(1).Move Me.ScaleWidth * 0.01 + cmdSaveRefresh(0).Width * 1.1, Me.ScaleHeight * 0.95
        End If
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If bManyWindow Then
        Shell "cmd /c rd """ & TempPath & """ /s /q", vbHide
    End If
    recordLocateFrmMe
End Sub

Private Sub lb_DblClick()
    WebBrow.Navigate lb.Caption
End Sub

Private Sub LblAddress_Click()
    reLocateFrmMe
End Sub

Private Sub MainTimer_Timer()
    If CCmd.isRunning Then Exit Sub
    CCmd.isRunning = True
    Dim rel As Long, targetUrl As String
    Dim tmp As String, thisTimeUrl As String
    rel = CCmd.getCmd(targetUrl)
    Select Case rel
        Case -1:
            
        Case 404:
            End
        Case 233:
            tmp = getNextUrl
            'MsgBox "下一个网页打开中：" & tmp
            Me.SetFocus
            Me.WindowState = 0
            SetOntop Me.hwnd
            WebBrow.Navigate tmp
        Case 2333:
            Me.Caption = thisExeThreadId & ": " & getWebTitle
            
            thisTimeUrl = targetUrl
            If tmp <> "" Then
                ShowInfos "读取新的网页成功:" & getWebTitle
                lb.Caption = thisTimeUrl
            Else
                thisTimeUrl = "http://xy2.cbg.163.com/"
            End If
            navigateMain thisTimeUrl
        Case Else
            'CmdNavigate_Click '
            WebBrow.refresh
            ShowInfos getMeNames & "页面刷新"
            Static nowRefreshWebUrlIndex As Long
            nowRefreshWebUrlIndex = nowRefreshWebUrlIndex + 1
            If nowRefreshWebUrlIndex = 2 Then
                nowRefreshWebUrlIndex = 0
            End If
            thisTimeUrl = cmdSaveRefresh(nowRefreshWebUrlIndex).Tag
            If thisTimeUrl <> "" Then
            '    navigateMain thisTimeUrl
            Else
            '    CmdNavigate_Click
            End If
    End Select
    CCmd.isRunning = False
End Sub
Private Function getWebTitle() As String
    getWebTitle = GetInfo("Main\Setting\Cmd", thisExeThreadId & ".name")
End Function
Private Function getNextUrl() As String
    DoEvents
    getNextUrl = GetInfo("Main\ThreadCmd\" & thisExeThreadId, "url")
    DoEvents
End Function
Private Sub WebBrow_DocumentComplete(ByVal pDisp As Object, Url As Variant)
    CboAddress.Text = WebBrow.LocationURL
    CCmd.refresh
End Sub

Private Sub WebBrow_NewWindow2(ppDisp As Object, Cancel As Boolean)
    Cancel = True
    WebBrow.Navigate WebBrow.Document.activeElement.href
End Sub

Private Sub WebBrow_StatusTextChange(ByVal Text As String)
    'stBar.Panels(1).Text = Text
End Sub

Private Sub WebBrow_TitleChange(ByVal Text As String)
    Dim strFlag As String
    If bManyWindow Then
        strFlag = "[M]"
    End If
    If bProxy Then
        strFlag = strFlag & "[P]"
    End If

    'Me.Caption = strFlag & Text
End Sub

Private Function ReadConfig(lpApplicationName As String, lpKeyName As String, ByVal lpDefault As String) As String
    Dim strBuf As String
    strBuf = String$(255, vbNullChar)
    GetPrivateProfileString lpApplicationName, lpKeyName, lpDefault, strBuf, 255, App.Path & "\Set.ini"
    ReadConfig = Left$(strBuf, InStr(strBuf, vbNullChar) - 1)
End Function

Private Sub WriteConfig(lpApplicationName As String, lpKeyName As String, ByVal lpString As String)
    WritePrivateProfileString lpApplicationName, lpKeyName, lpString, App.Path & "\Set.ini"
End Sub
