VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form ClientFrm 
   AutoRedraw      =   -1  'True
   Caption         =   "Client"
   ClientHeight    =   750
   ClientLeft      =   3795
   ClientTop       =   1905
   ClientWidth     =   1740
   LinkTopic       =   "Form1"
   ScaleHeight     =   750
   ScaleWidth      =   1740
   Tag             =   "hello"
   Visible         =   0   'False
   Begin MSWinsockLib.Winsock SockCL 
      Left            =   90
      Top             =   90
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "ClientFrm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim SendMsg As String
Private thisIpAdress As String, con As New Connector
Private Sub Form_Load()
    '  指定服务器主机名
    thisIpAdress = con.getIp("1s68948k74.imwork.net")
    'MsgBox "目标服务器已复制到剪切板：" & thisIpAdress
    SockCL.RemoteHost = thisIpAdress
    Clipboard.SetText "thisIpAdress:" & thisIpAdress
    '  指定服务器端口名
    SockCL.RemotePort = con.port
    '  连接到服务器
    SockCL.Connect
End Sub

Private Sub SockCl_DataArrival(ByVal bytesTotal As Long)
    Dim DataStr As String, thisCmd() As String
    SockCL.GetData DataStr
    thisCmd = Split(DataStr, "#cmd#")
    Select Case thisCmd(0)
        Case "get":
            Stop
        Case "set":
            Stop
        Case "connect":
            con.isConnect = True
    End Select
End Sub
Private Sub SockCL_SendComplete()
    'SendMsg
End Sub

Public Sub sndRegInfo(path As String, Info As String)
    If Not con.isConnect Then
        MsgBox getMeNames & "未连接到服务器"
        Exit Sub
    End If
    SockCL.SendData path & "#reg#" & Info
End Sub
Public Sub sndSettingInfo(SettingNames As String, Infos As String)
    If Not con.isConnect Then
        MsgBox getMeNames & "未连接到服务器"
        Exit Sub
    End If
    SockCL.SendData SettingNames & "#setting#" & Infos
End Sub

