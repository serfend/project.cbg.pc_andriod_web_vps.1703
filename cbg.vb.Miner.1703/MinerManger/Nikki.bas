Attribute VB_Name = "MainInfo"
Option Explicit
Public mMyFont As String, mInfoFont As String
Public Function GetUserName() As String
Dim Tem As String
GetUserName = GetInfo("main\User", "UserName", "Undefined User")
End Function
Public Function InfoFont() As String
On Error GoTo Err
If mInfoFont = "" Then
    mInfoFont = GetInfo("main\User", "InfoFont", "΢���ź�")
End If
    InfoFont = mInfoFont
Exit Function
Err:
    mInfoFont = "΢���ź�"
    InfoFont = mInfoFont
    
End Function
Public Function MyFont() As String
On Error GoTo Err
If mMyFont = "" Then
    mMyFont = GetInfo("main\User", "MainFont", "΢���ź�")
End If
    MyFont = mMyFont
Exit Function
Err:
    mMyFont = "΢���ź�"
    MyFont = mMyFont
    
End Function
