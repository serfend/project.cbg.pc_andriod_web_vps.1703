Attribute VB_Name = "modXP"

'本代码欢迎读者转发及与我相互探讨,但请保留此文字说明 2005/12/31
'作者:宋陈三 南京金肯学院数学教研室  作者主页http://www.asanscape.com
'作者BLOG: http://blog.csdn.net/asanscape     QQ:6019187  Email:asangray@163.com

'本工程中的xp.res可以直接加入其他工程进行编译以使其具备XP风格
'注意加入资源文件时要同时加入本模块,  设置工程从Sub Main()启动,否则无初始化过程
'InitCommonControls函数存在于comctl32.dll(版本5)中,不建议使用,而要使用InitCommonControlsEx

Private Type tagInitCommonControlsEx
    lngSize As Long
    lngICC As Long
End Type
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Declare Function InitCommonControlsEx Lib "comctl32.dll" _
                                              (iccex As tagInitCommonControlsEx) As Boolean
Private Const ICC_USEREX_CLASSES = &H200
Public thisExeThreadId As String

Public Function InitCommonControlsVB() As Boolean
    On Error Resume Next
    Dim iccex As tagInitCommonControlsEx
    ' Ensure CC available:
    With iccex
        .lngSize = LenB(iccex)
        .lngICC = ICC_USEREX_CLASSES
    End With
    InitCommonControlsEx iccex
    InitCommonControlsVB = (Err.Number = 0)
    On Error GoTo 0
End Function

Sub Main()
    thisExeThreadId = Command
    InitCommonControlsVB
    frmMain.Show
End Sub



Public Function getMeNames() As String
    getMeNames = "[" & thisExeThreadId & "]" & vbCrLf
End Function
