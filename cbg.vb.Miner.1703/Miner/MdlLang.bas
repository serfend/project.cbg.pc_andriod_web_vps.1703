Attribute VB_Name = "MdlLang"
Private NowLang As Integer '0 en,1 ch
Private Type ConstInfo
    Alias As String
    En As String
    Ch As String
End Type
Private LangConstInfo() As ConstInfo
Public Function ConstGet(Id As Long) As String
If NowLang = 0 Then
    ConstGet = LangConstInfo(Id).En
Else
    ConstGet = LangConstInfo(Id).Ch
End If
End Function
Public Sub SetLang(Lang As Integer)
    NowLang = Lang
End Sub
Public Sub IniLang(Optional Lang As Integer = 1)
    SetLang Lang
    ReDim LangConstInfo(100)
    Silg 0, "无效的题目类型于:", "invalid title is applied to:"
    Silg 1, "点击此处进行输入", "Click here to input your text"
    Silg 3, "问卷信息录入系统", "Questionnaire Survey Recorder System"
    Silg 4, "简介", "Abstract"
    Silg 5, "此软件可以进行问卷数据的录入,请将此软件放置于数据库[问卷存放.mdb]同一个文件夹中,否则将无法正确运行。" & vbCrLf & "如有任何疑问请联系lc960113@qq.com获取技术支持。" _
            , "This app can be your friend"
    Silg 6, "主程序开启", "Main sub is loaded"
    Silg 7, "序 号", "No.  "
    Silg 8, "数据录入", "Data Input"
    Silg 9, "数据表", "Data List"
    Silg 10, "问题表", "Question List"
    Silg 11, "文本输入", "TextInput"
    Silg 12, "输入", "Input"
End Sub
Private Sub Silg(Index As Long, Ch As String, En As String)
    With LangConstInfo(Index)
        .En = En
        .Ch = Ch
    End With
End Sub
