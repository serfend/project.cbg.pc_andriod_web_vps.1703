VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Connector"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Type HOSTENT
  hName As Long
  hAliases As Long
  hAddrType As Integer
  hLength As Integer
  hAddrList As Long
End Type
Private Const defaultIpWeb As String = "1s68948k74.imwork.net"
Private Declare Function gethostbyname Lib "wsock32.dll" (ByVal _
        hostname$) As Long
Private Declare Sub RtlMoveMemory Lib "kernel32" (hpvDest As Any, _
        ByVal hpvSource&, ByVal cbCopy&)
Private thisPort As Long
'   Dim con As New Connector
'   thisIpAdress = con.getIp("1s68948k74.imwork.net")
'   Port = 38030
Public Function getIp(Optional ByVal Name As String) As String '解析域名获取服务器IP地址
  Dim hostent_addr As Long      '存储了服务器的信息的内存地址
  Dim Host As HOSTENT           '服务器的信息
  Dim hostip_addr As Long
  Dim temp_ip_address() As Byte
  Dim i As Integer
  Dim ip_address As String
  If Name = "" Then Name = defaultIpWeb
  '调用系统API查询域名的IP，得到域名信息的数据的地址
  hostent_addr = gethostbyname(Name)
  '返回值为0，说明查询失败
  If hostent_addr = 0 Then
    getIp = ""                     '注释：主机名不能被解释
    Exit Function
  End If
  '将【服务器信息】的地址内的信息复制给，【服务器信息结构体】
  RtlMoveMemory Host, hostent_addr, LenB(Host)
  '
  RtlMoveMemory hostip_addr, Host.hAddrList, 4
  
  ReDim temp_ip_address(1 To Host.hLength)
  RtlMoveMemory temp_ip_address(1), hostip_addr, Host.hLength
  
  For i = 1 To Host.hLength
    ip_address = ip_address & temp_ip_address(i) & "."
  Next
  ip_address = Mid$(ip_address, 1, Len(ip_address) - 1)
  getIp = ip_address
End Function

Public Property Get port() As Long
    port = thisPort
End Property
Public Property Let port(vPort As Long)
    thisPort = vPort
End Property
Private Sub Class_Initialize()
    thisPort = 38030
End Sub
