VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "宝宝"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private isValue As Boolean
Private title As String, titleColor As String
Private skillList As New Collection
Private rank As String, rankColor As String '3转，点化

Private 神兽 As Boolean, 神兽技能 As String

Private 觉醒技能 As String
Private 变色 As Boolean
Private 修炼 As Boolean, 修炼参数1 As String, 修炼参数2 As String
Private 饰品变色 As String
Private 成长值 As Long
Private mht As New HttpGetter
Public Function getPrice() As Double
    If Not isValue Then Exit Function
    Dim tmp As baby
    Set tmp = thisPriceHdl.getBaby(title & " " & IIf(神兽, "神", "普") & " " & IIf(变色, "是", "否"), 成长值)
    If Not tmp Is Nothing Then
        getPrice = tmp.getPrice(Mid(rank, 1, 2), getSkillList, "", 觉醒技能, 修炼参数1, 饰品变色)
    End If
End Function
Private Function getBabyPrice(target As baby) As Double
    Stop
End Function
Private Function getSkillList() As String()
    Dim i As Long, tmp() As String, tmpS As New CStringBuilder
    ReDim tmp(skillList.Count - 1)
    For i = 1 To skillList.Count
        tmp(i - 1) = skillList(i).pTitle
        tmpS.Append(tmp(i - 1)).Append ("|")
    Next
    getSkillList = tmp
    'MsgBox "宝宝:" & title & "  技能:" & skillList.Count & ":" & tmpS.ToString
    
End Function
Public Function init(iniData As String) As Boolean
    If InStr(1, iniData, "成长率") = 0 Then Exit Function
    thisRec.logInfo "+++++++++++++详细+++++++++++++++" & vbCrLf & iniData & vbCrLf & "+++++++++++++详细+++++++++++++++"
    Dim tmpPos As Long
    If InStr(1, iniData, "不可交易") = 0 Then isValue = True
    If InStr(1, iniData, "为变色") > 0 Then 变色 = True
    getSkill修炼 iniData
    tmpPos = 1
    getTitle iniData, tmpPos
    If title = "" Then
        thisRec.logInfo "无效的数据:" & vbCrLf & iniData & vbCrLf
        Exit Function
    End If
    
    
    getRank iniData, tmpPos
    getSkill iniData, tmpPos
    getSpSkill iniData
    getGodSkill iniData
    get饰品变色 iniData
    Dim tmp As String
    tmp = mht.getElement(iniData, "成长率", "#r")
    tmp = Trim(tmp)
    成长值 = Val(tmp) * 1000
    init = True
End Function

Public Property Get names() As String
    names = title
End Property
Private Sub get饰品变色(iniData As String)
    If InStr(1, iniData, "饰品") > 0 Then 饰品变色 = "不变"
    If InStr(1, iniData, "饰品:已变色") > 0 Then 饰品变色 = "变"
End Sub
Private Sub getGodSkill(iniData As String)
    If InStr(1, iniData, "神兽技能") > 0 Then
        神兽 = True
        神兽技能 = mht.getElement(iniData, "神兽技能格：", " ")
    End If
End Sub
Private Sub getSkill修炼(iniData As String)
    If InStr(1, iniData, "技能修炼") > 0 Then
        修炼 = True
        Dim tmp As String
        tmp = mht.getElement(iniData, "修炼(", ")")
        修炼参数1 = mht.getElementLeft(tmp, "/")
        修炼参数2 = Mid(tmp, Len(修炼参数1) + 1)
    End If
End Sub
Private Sub getSpSkill(iniData As String)
    Dim tmp As String
    tmp = mht.getElement(iniData, "觉醒技：", " ")
    tmp = Replace(tmp, " ", "")
    tmp = Replace(tmp, "#n", "")
    觉醒技能 = tmp
End Sub
Private Sub getSkill(iniData As String, tmpPos As Long)
    Dim tmp() As String, tmpSkill As babySkill
    tmp = Split(iniData, "技能")
    Dim i As Long
    For i = 1 To UBound(tmp)
        If Val(Left(tmp(i), 1)) > 0 Then
            Dim tmpSkillName As String
            tmp(i) = Replace(tmp(i), "#r", "；")
            tmpSkillName = mht.getElement(tmp(i), ":", "；")
            Set tmpSkill = New babySkill
            tmpSkill.init Me, tmpSkillName
            skillList.Add tmpSkill
        Else
            Exit For
        End If
    Next
End Sub
Private Sub getRank(iniData As String, tmpPos As Long)
    rank = "#" & mht.getElement(iniData, "#", "级", tmpPos)
    splitColor rank, rankColor
End Sub
Private Sub getTitle(iniData As String, tmpPos As Long)
    title = mht.getElement(iniData, ":""", " ", tmpPos)
    If tmpPos > 50 Then
        title = ""
        Exit Sub
    End If
    splitColor title, titleColor
End Sub
Private Sub splitColor(iniInfo As String, colorInfo As String)
    colorInfo = Left(iniInfo, 8)
    iniInfo = Mid(iniInfo, 9)
End Sub
