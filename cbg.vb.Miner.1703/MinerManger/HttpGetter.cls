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
Private Sub IniHttp()
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
Public Function postHtml(Url As String, theData As String) As String
On Error GoTo ErrHand:
With xmlhttp
    .Open "post", Url, True
    .setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    .send theData
    postHtml = StrConv(.responsebody, vbUnicode)
End With
Exit Function
ErrHand:
    MsgBox "postHtml() " & Err.Description
End Function
Private Function getUnicode(CodeArr() As Byte) As String
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
Public Function getHtml(Url As String) As String
On Error GoTo ErrHand:
With xmlhttp
    .Open "get", Url, True
    .send
    While .readyState <> 4
        DoEvents
    Wend
    Dim tmpByte() As Byte
    getHtml = .responsetext
End With
Exit Function
ErrHand:
    MsgBox "getHtml() " & Err.Description
End Function
Public Function getHtmlUni(Url As String) As String
On Error GoTo ErrHand:
With xmlhttp
    .Open "get", Url, True
    .send
    While .readyState <> 4
        DoEvents
    Wend
    Dim tmpByte() As Byte
    tmpByte = .responsebody
    getHtmlUni = StrConv(tmpByte, vbUnicode) 'getUnicode(tmpByte)
End With
Exit Function
ErrHand:
    MsgBox "getHtml() " & Err.Description
End Function
Public Function getFullUrl(ChildUrl As String, IniUrl As String, Optional divChr As String = "../") As String
    'Î´Íê³É
    If InStr(1, ChildUrl, "http://") > 0 Then
        getFullUrl = ChildUrl
        Exit Function
    Else
        getFullUrl = IniUrl & "/" & ChildUrl
    End If
End Function
Public Function getParentUrl(Url As String, Optional divChr As String = "/") As String
    Dim i As Long
    For i = Len(Url) To 1 Step -1
        If Mid(Url, i, 1) = divChr Then
            getParentUrl = Left(Url, i - 1)
            Exit Function
        End If
    Next
End Function

Private Sub Class_Initialize()
    IniHttp
End Sub
Private Sub Class_Terminate()
    TerminateHttp
End Sub
