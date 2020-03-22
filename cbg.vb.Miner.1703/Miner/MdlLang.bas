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
    Silg 0, "��Ч����Ŀ������:", "invalid title is applied to:"
    Silg 1, "����˴���������", "Click here to input your text"
    Silg 3, "�ʾ���Ϣ¼��ϵͳ", "Questionnaire Survey Recorder System"
    Silg 4, "���", "Abstract"
    Silg 5, "��������Խ����ʾ����ݵ�¼��,�뽫��������������ݿ�[�ʾ���.mdb]ͬһ���ļ�����,�����޷���ȷ���С�" & vbCrLf & "�����κ���������ϵlc960113@qq.com��ȡ����֧�֡�" _
            , "This app can be your friend"
    Silg 6, "��������", "Main sub is loaded"
    Silg 7, "�� ��", "No.  "
    Silg 8, "����¼��", "Data Input"
    Silg 9, "���ݱ�", "Data List"
    Silg 10, "�����", "Question List"
    Silg 11, "�ı�����", "TextInput"
    Silg 12, "����", "Input"
End Sub
Private Sub Silg(Index As Long, Ch As String, En As String)
    With LangConstInfo(Index)
        .En = En
        .Ch = Ch
    End With
End Sub
