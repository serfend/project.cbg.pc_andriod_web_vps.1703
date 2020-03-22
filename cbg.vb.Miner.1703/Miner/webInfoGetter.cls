VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "webInfoGetter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Inied As Boolean, xmlhttp As Object, winHttp As Object
Private thisBeginProxyTime As Long
Private Sub IniHttp()
    If Not Inied Then
        thisLogger.logInfo getMeNames & "initHttpGetter()", 2
        Inied = True
        'Set xmlhttp = CreateObject("msxml2.xmlhttp")
        Set winHttp = CreateObject("WinHttp.WinHttpRequest.5.1") '创建WinHttp.WinHttpRequest
    End If
End Sub
Private Sub TerminateHttp()
    Set winHttp = Nothing
    Inied = False
End Sub
Private Sub Class_Initialize()
    IniHttp
End Sub
Private Sub Class_Terminate()
    TerminateHttp
End Sub
Public Function getHtml(Url As String) As String
On Error GoTo ErrHand:
With xmlhttp
    .Open "get", Url, True
    thisBeginProxyTime = Now
    .Send
    While .readyState <> 4
        If Abs(DateDiff("s", thisBeginProxyTime, Now)) > 5 Then Exit Function
        DoEvents
    Wend
    Dim tmpByte() As Byte
    getHtml = .ResponseText
End With
Exit Function
ErrHand:
    'thisLogger.WriteErrLog getMeNames & "getHtml()", Err.Number, Err.Description
    SetErr getMeNames & "getHtml()$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Function getHtmlUni(Url As String) As String
On Error GoTo ErrHand:
    getHtmlUni = winHttpGetResponse(Url, "", "get", "")
    Exit Function
With xmlhttp
    .Open "get", Url, False
    .SetRequestHeader "If-Modified-Since", "0"
    thisBeginProxyTime = GetTickCount
    thisLogger.logInfo getMeNames & "getHtmlUni()proxy", 5
    .Send
    While .readyState <> 4
        If GetTickCount - thisBeginProxyTime > 1000 Then
            thisLogger.logInfo getMeNames & "getHtmlUni()timeout", 5
            Exit Function
        End If
        Dim i As Long
        For i = 1 To 5
            DoEvents
        Next
    Wend
    Dim tmpByte() As Byte
    thisLogger.logInfo getMeNames & "getHtmlUni()reply in " & GetTickCount - thisBeginProxyTime & " ms", 5
    tmpByte = .responsebody
    getHtmlUni = StrConv(tmpByte, vbUnicode) 'getUnicode(tmpByte)
    thisLogger.logInfo getMeNames & "getHtmlUni()done in " & GetTickCount - thisBeginProxyTime & " ms", 5
End With
Exit Function
ErrHand:
    'thisLogger.WriteErrLog getMeNames & "getHtmlUni()", Err.Number, Err.Description
    If InStr(1, Err.Description, "超时") > 0 Then End
End Function
Public Function postHtml(Url As String, theData As String) As String
On Error GoTo ErrHand:
With xmlhttp
    .Open "post", Url, True
    .SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    .Send theData
    postHtml = StrConv(.responsebody, vbUnicode)
End With
Exit Function
ErrHand:
    'thisLogger.WriteErrLog getMeNames & "postHtml()", Err.Number, Err.Description
    SetErr getMeNames & "postHtml()$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Function winHttpGetResponse(postURL As String, postData As String, Method As String, setCookies As String) As String
    'If Len(Trim(setCookies)) = 0 Then setCookies = "a:x," '//cookie为空则随便弄个cookie，不然报错
    
    'MsgBox "到 这里"
    With winHttp
        .Open Method, postURL, True '同步接收数据
        '.Option(WinHttpRequestOption_SslErrorIgnoreFlags) = &H3300 '非常重要(忽略错误)
        '其它请求头设置
        
        .SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        '.SetRequestHeader "Cookie", setCookies
        .SetRequestHeader "If-Modified-Since", "0"
        .SetRequestHeader "Content-Length", Len(postData)
        thisBeginProxyTime = GetTickCount
        thisLogger.logInfo getMeNames & "getHtmlUni()proxy", 5
        .Send postData '' 开始发送
        
        .WaitForResponse '等待请求
        'MsgBox WinHttp.Status'请求状态
        '得到返回文本(或者是其它)
        Dim tmpByte() As Byte
        tmpByte = .responsebody
        winHttpGetResponse = StrConv(tmpByte, vbUnicode) 'getUnicode(tmpByte)
        thisLogger.logInfo getMeNames & "getHtmlUni()reply in " & GetTickCount - thisBeginProxyTime & " ms,length=" & Len(winHttpGetResponse), 5
        
    End With
End Function
