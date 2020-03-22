VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Function getElementLeft(content As String, beginStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long
    contentBegin = InStr(beginIndex, content, beginStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    beginIndex = contentBegin + Len(beginStr)
    getElementLeft = Mid(content, beginIndex)
End Function
Public Function getElementRight(content As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long
    contentBegin = InStr(beginIndex, content, endStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    beginIndex = contentBegin
    getElementRight = Mid(content, 1, beginIndex)
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
Public Function getElement(content As String, beginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    contentBegin = InStr(beginIndex, content, beginStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    contentBegin = contentBegin + Len(beginStr)
    ContentEnd = InStr(contentBegin, content, endStr)
    If ContentEnd = 0 Then
        beginIndex = 0
        Exit Function
    End If
    beginIndex = contentBegin
    getElement = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
Public Function getElementEx(content As String, beginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    contentBegin = InStr(beginIndex, content, beginStr)
    If contentBegin = 0 Then
        beginIndex = 0
        Exit Function
    End If
    ContentEnd = InStr(contentBegin, content, endStr)
    Do
        beginIndex = contentBegin
        contentBegin = InStr(contentBegin + 1, content, beginStr)
        If contentBegin = 0 Or contentBegin > ContentEnd Then Exit Do
    Loop
    contentBegin = beginIndex + Len(beginStr)
    beginIndex = ContentEnd
    getElementEx = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
Public Function getElementR(content As String, beginStr As String, endStr As String, Optional beginIndex As Long = 1) As String
    Dim contentBegin As Long, ContentEnd As Long
    ContentEnd = InStr(beginIndex, content, endStr)
    If ContentEnd = 0 Then
        beginIndex = 0
        Exit Function
    End If
    contentBegin = ContentEnd
    Dim lenthBeginStr As Long
    lenthBeginStr = Len(beginStr)
    Do
        contentBegin = contentBegin - 1
        If contentBegin = 0 Then
            beginIndex = 0
            Exit Function
        End If
    Loop Until Mid(content, contentBegin, lenthBeginStr) = beginStr
    contentBegin = contentBegin + lenthBeginStr
    beginIndex = ContentEnd
    getElementR = Mid(content, contentBegin, ContentEnd - contentBegin)
End Function
