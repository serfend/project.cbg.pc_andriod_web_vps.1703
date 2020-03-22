VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "HttpGetter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Inied As Boolean, xmlhttp As Object
Private CookiesList As New Collection
Private Method As String
Public Property Let pMethod(value As String)
    If value = "post" Then
        Method = "post"
    Else
        Method = "get"
    End If
End Property
Public Function addCookies(keys As String, Info As String)
    Dim tmp As Object
    Set tmp = CookiesList.Item(keys)
    If tmp Is Nothing Then
        CookiesList.Add Info, keys
    Else
        tmp = Info
    End If
End Function
Public Sub clearCookies()
    Dim i As Object
    For Each i In CookiesList
        CookiesList.Remove i
    Next
End Sub
Private Sub IniHttp()
    Method = "post"
    If Not Inied Then
        Inied = True
        NoticeNum = 0
        Set xmlhttp = CreateObject("msxml2.xmlhttp")
    End If
End Sub
Private Sub TerminateHttp()
    Set xmlhttp = Nothing
    Inied = False
End Sub
Private Function browserCode() As String
    Dim i  As Long
    Dim tmp As String
    tmp = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50$Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50$Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0$Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1$Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5$MQQBrowser/26 Mozilla/5.0 (Linux; U; Android 2.3.7; zh-cn; MB200 Build/GRJ22; CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    Dim tmpS() As String
    tmpS = Split(tmp, "$")
    Dim nums As Long
    nums = UBound(tmpS)
    i = CInt(Rnd() * (1 + nums) - 0.5)
    browserCode = tmpS(i)
    browserCode = browserCode & " " & CInt(Rnd() * 1000)
End Function
Private Sub setHeader(http As Object)
    With http
        .SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        .SetRequestHeader "If-Modified-Since", "0"
        .SetRequestHeader "User-Agent", browserCode
        Dim i As Object, tmp As String
        For Each i In CookiesList
            tmp = tmp & i.Key & "=" & i.value & ";"
        Next
        .SetRequestHeader "cookie", tmp
    End With
End Sub



Public Function getHtml(Url As String) As String
On Error GoTo ErrHand:
Dim beginTime As Date
With xmlhttp
    beginTime = Now
    .Open "get", Url, True
    setHeader xmlhttp
    .Send
    While .readyState <> 4
        If DateDiff("s", beginTime, Now) > 10 Then
            getHtml = getHtml(Url)
            Exit Function
        End If
        DoEvents
    Wend
    Dim tmpByte() As Byte
    getHtml = .responsetext
    'tmpByte = .responsebody
    'getHtml = StrConv(tmpByte, coding)   'getUnicode(tmpByte)
End With
Exit Function
ErrHand:
    MsgBox "getHtml() " & Err.Description
End Function












Private Static Function getUnicode(CodeArr() As Byte) As String
Dim i As Long
Dim tmp As String, tmpChr As Long
Dim Strini  As String
Strini = CStr(CodeArr)
For i = 1 To Len(Strini) 'UBound(CodeArr)
    Dim ThisCode As String, NextCode As String
    ThisCode = AscB(MidB(Strini, i, 1))
    If ThisCode < &H80 Then
        tmp = tmp & Chr(ThisCode)
    Else
        NextCode = AscB(MidB(Strini, i + 1, 1))
        tmp = tmp & Chr(CLng(ThisCode) * h100 + CInt(NextCode))
        i = i + 1
    End If
Next
getUnicode = tmp
End Function
Public Static Function getFullUrl(ChildUrl As String, IniUrl As String, Optional divChr As String = "../") As String
    'Î´Íê³É
    If InStr(1, ChildUrl, "http://") > 0 Then
        getFullUrl = ChildUrl
        Exit Function
    Else
        getFullUrl = IniUrl & "/" & ChildUrl
    End If
End Function
Public Static Function getParentUrl(Url As String, Optional divChr As String = "/") As String
    Dim i As Long
    For i = Len(Url) To 1 Step -1
        If Mid(Url, i, 1) = divChr Then
            getParentUrl = Left(Url, i - 1)
            Exit Function
        End If
    Next
End Function
Public Static Function getElement(content As String, BeginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    contentBegin = InStr(beginIndex, content, BeginStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    contentBegin = contentBegin + Len(BeginStr)
    ContentEnd = InStr(contentBegin, content, endStr)
    If ContentEnd = 0 Then
        beginIndex = 0
        Exit Function
    End If
    beginIndex = contentBegin
    getElement = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
Public Static Function getElementEx(content As String, BeginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    contentBegin = InStr(beginIndex, content, BeginStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    ContentEnd = InStr(contentBegin, content, endStr)
    Do
        beginIndex = contentBegin
        contentBegin = InStr(contentBegin + 1, content, BeginStr)
        If contentBegin = 0 Or contentBegin > ContentEnd Then Exit Do
    Loop
    contentBegin = beginIndex + Len(BeginStr)
    beginIndex = ContentEnd
    getElementEx = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
Public Static Function getElementR(content As String, BeginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    ContentEnd = InStr(beginIndex, content, endStr)
    If ContentEnd = 0 Then
        beginIndex = 0
        Exit Function
    End If
    contentBegin = ContentEnd
    Dim lenthBeginStr As Long
    lenthBeginStr = Len(BeginStr)
    Do
        contentBegin = contentBegin - 1
        If contentBegin = 0 Then
            beginIndex = 0
            Exit Function
        End If
    Loop Until Mid(content, contentBegin, lenthBeginStr) = BeginStr
    contentBegin = contentBegin + lenthBeginStr
    beginIndex = ContentEnd
    getElementR = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
Public Function getElementLeft(content As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long
    contentBegin = InStr(1, content, endStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    getElementLeft = Mid(content, beginIndex, contentBegin - beginIndex)
    beginIndex = contentBegin
End Function
Public Function getElementRight(content As String, endStr As String, Optional beginIndex As Long = -1) As String
    Dim contentBegin As Long
    If beginIndex = -1 Then beginIndex = Len(content)
    contentBegin = InStrRev(content, endStr, beginIndex)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    getElementRight = Mid(content, contentBegin, beginIndex - contentBegin)
    beginIndex = contentBegin
End Function
Private Sub Class_Initialize()
    IniHttp
End Sub
Private Sub Class_Terminate()
    TerminateHttp
End Sub
