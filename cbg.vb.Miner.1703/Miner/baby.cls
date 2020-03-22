VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "baby"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private title As String
Private czList() As Double
Private skillPrice As New Collection
Private rankValue As New Collection
Private practiseValue As New Collection
Private skillList As New Collection
Private skillNumValue As New Collection
Private decorateValue(1) As Double
Private talentSkillValue As New Collection
Private wakeUpSkill(1) As Double
Private basePrice As Double
Public Sub init(iniData() As String, babyTitle As String)
    If UBound(iniData) > 11 Then
        SetErr "数据加载错误:$#255#请注意设置文件中关于$" & babyTitle & " 的信息"
        End
    End If
    title = babyTitle
    insertCzList Val(iniData(2)) '成长值范围
    setRankPrice iniData(4) '等级阶
    
    Dim tmp() As String, tmpFile As New clsFile
    tmpFile.init "setting", iniData(5), , 2 '技能表.txt
    tmp = Split(tmpFile.pFileContent, vbCrLf)
    setSkillValue tmp
    
    'setTalentSkillValue inidata(6) '天赋技能
    setPractiseValue iniData(7)

    tmp = Split(iniData(11), ",") '觉醒技能
    wakeUpSkill(0) = Val(tmp(0))
    If UBound(tmp) = 1 Then wakeUpSkill(1) = Val(tmp(1))

    setSkillNumValue iniData(9)
    basePrice = Val(iniData(10)) '基础价
    tmp = Split(iniData(8), ",") '装饰变色
    decorateValue(0) = Val(tmp(0))
    If UBound(tmp) = 1 Then decorateValue(1) = Val(tmp(1))
End Sub
Private Sub insertCzList(value As Double)
    Dim i As Long
    For i = 0 To UBound(czList)
        If czList(i) > value Or i = UBound(czList) Then
            ReDim Preserve czList(UBound(czList) + 1)
            Dim j As Long
            For j = UBound(czList) To i + 1 Step -1
                czList(j) = czList(j - 1)
            Next
            czList(i) = value
            Exit For
        End If
    Next
End Sub
Public Function getPrice(rank As String, skList() As String, tfSkill As String, spSkill As String, psValue As String, decorColor As String) As Double
    Dim skillNum As Long
    thisRec.logInfo "--------------" & vbCrLf & getMeNames & ".获取价值:"
    Dim 等级阶 As Double, 技能文件 As Double, 天赋技能 As Double, 修炼数值 As Double, 技能数量 As Double, 基础价值 As Double
    等级阶 = getRankPrice(rank)
    技能文件 = getSkillValue(skList, skillNum)
    修炼数值 = getPractiseValue(psValue)
    技能数量 = getSkillNumValue(CStr(skillNum))
    Dim maxNum As Double, minNum As Double
    minNum = min(等级阶, 技能文件, 修炼数值, 技能数量, basePrice)
    If minNum < 0 Then
        maxNum = -999999
    Else
        maxNum = max(等级阶, 技能文件, 修炼数值, 技能数量, basePrice)
    End If
    thisRec.logInfo "计算最大值:" & 等级阶 & "," & 技能文件 & "," & 修炼数值 & "," & 技能数量 & "," & basePrice & "=" & maxNum
    
    Dim dcV As Double, wuV As Double
    dcV = IIf(decorColor = "变", decorateValue(0), IIf(decorColor = "不变", decorateValue(1), 0))
    wuV = IIf(spSkill = "未觉醒" Or spSkill = "", wakeUpSkill(1), wakeUpSkill(0))
    thisRec.logInfo "饰品(" & decorColor & "):" & dcV & ",觉醒技(" & spSkill & "):" & wuV & ",基础:" & basePrice
    getPrice = dcV + wuV + maxNum
    thisRec.logInfo "总价:" & getPrice & vbCrLf & "--------------"
End Function

Private Sub Class_Initialize()
    ReDim czList(0)
End Sub
Private Sub setSkillValue(value() As String)
    Dim tmp() As String, i As Long
    For i = 0 To UBound(value)
        value(i) = Trim(value(i))
        tmp = Split(value(i), " ")
        If UBound(tmp) = 1 Then
            skillNum = skillNum + 1
            skillList.Add tmp(1), tmp(0)
        End If
    Next
End Sub
Private Function getSkillValue(value() As String, skillNum As Long) As Double
    Dim tmpRel As New CStringBuilder
    tmpRel.Append("获取技能价值:").Append (vbCrLf)
    Dim i As Long, max As Double, tmp As String
    For i = 0 To UBound(value)
        If collectionExist(value(i), skillList) Then
            tmp = skillList(value(i))
            tmpRel.Append("|").Append(value(i)).Append(":").Append (tmp)
            If max < Val(tmp) Then max = Val(tmp)
        Else
            tmpRel.Append("|").Append(value(i)).Append (":0")
        End If
        skillNum = skillNum + 1
    Next
    getSkillValue = max
    tmpRel.Append("最大值:").Append (CStr(max))
    thisRec.logInfo tmpRel.ToString
End Function
Private Function collectionExist(value As String, colName As Collection) As Boolean
    On Error GoTo notExistException
        Dim tmp As Variant
        tmp = colName(value)
        collectionExist = True
    Exit Function
notExistException:
End Function
Private Sub setPractiseValue(value As String)
On Error GoTo Err:
    Dim tmp() As String
    tmp = Split(value, ",")
    Dim i As Long
    For i = 0 To UBound(tmp)
        Dim tmpTarget() As String
        tmpTarget = Split(tmp(i), ":")
        practiseValue.Add tmpTarget(1), tmpTarget(0)
    Next
Exit Sub
Err:
    SetErr getMeNames & "$baby(" & title & ")$setPractiseValue(" & value & ")$" & Err.Description
    End
End Sub
Private Function getPractiseValue(value As String) As Double
    Dim tmp As String, exist As Boolean
    If collectionExist(value, practiseValue) Then
        tmp = practiseValue(value)
        exist = True
    Else
        If collectionExist("其他", practiseValue) Then
            tmp = practiseValue("其他")
            exist = True
        End If
    End If
    If exist Then getPractiseValue = Val(tmp)
    thisRec.logInfo "修炼(" & value & ")" & "价值:" & getPractiseValue
End Function

Private Sub setRankPrice(value As String)
On Error GoTo Err:
    Dim tmp() As String
    tmp = Split(value, ",")
    Dim i As Long
    For i = 0 To UBound(tmp)
        Dim tmpTarget() As String
        tmpTarget = Split(tmp(i), ":")
        rankValue.Add tmpTarget(1), tmpTarget(0)
    Next
Exit Sub
Err:
    SetErr getMeNames & "$baby(" & title & ")$setRankPrice(" & value & ")$" & Err.Description
    End
End Sub
Private Function getRankPrice(value As String) As Double
    Dim tmp As String, exist As Boolean
    If collectionExist(value, rankValue) Then
        tmp = rankValue(value)
        exist = True
    Else
        If collectionExist("其他", rankValue) Then
            tmp = rankValue("其他")
            exist = True
        End If
    End If
    If exist Then getRankPrice = Val(tmp)
    thisRec.logInfo "等级阶(" & value & ")" & "价值:" & getRankPrice
End Function
Private Sub setSkillNumValue(value As String)
On Error GoTo Err:
    Dim tmp() As String
    tmp = Split(value, ",")
    Dim i As Long
    For i = 0 To UBound(tmp)
        Dim tmpTarget() As String
        tmpTarget = Split(tmp(i), ":")
        skillNumValue.Add tmpTarget(1), tmpTarget(0)
    Next
Exit Sub
Err:
    SetErr getMeNames & "$baby(" & title & ")$setSkillNumValue(" & value & ")$" & Err.Description
    End
End Sub
Private Function getSkillNumValue(value As String) As Double
    Dim tmp As String, exist As Boolean
    If collectionExist(value, skillNumValue) Then
        tmp = skillNumValue(value)
        exist = True
    Else
        If collectionExist("其他", skillNumValue) Then
            tmp = skillNumValue("其他")
            exist = True
        End If
    End If
    getSkillNumValue = Val(tmp)
    thisRec.logInfo "技能数量(" & value & ")" & "价值:" & getSkillNumValue
    If exist Then getSkillNumValue = Val(tmp)
End Function
Private Sub setTalentSkillValue(value As String)
On Error GoTo Err:
    Dim tmp() As String
    tmp = Split(value, ",")
    Dim i As Long
    For i = 0 To UBound(tmp)
        Dim tmpTarget() As String
        tmpTarget = Split(tmp(i), ":")
        talentSkillValue.Add tmpTarget(1), tmpTarget(0)
    Next
Exit Sub
Err:
    SetErr getMeNames & "$baby(" & title & ")$setTalentSkillValue(" & value & ")$" & Err.Description
    End
End Sub
Private Function getTalentSkillValue(value As String) As Double
    Dim tmp As String, exist As Boolean
    If collectionExist(value, talentSkillValue) Then
        tmp = talentSkillValue(value)
        exist = True
    Else
        If collectionExist("其他", talentSkillValue) Then
            tmp = talentSkillValue("其他")
            exist = True
        End If
    End If
    If exist Then getTalentSkillValue = Val(tmp)
    thisRec.logInfo "天赋技能(" & value & ")" & "价值:" & getTalentSkillValue
End Function

