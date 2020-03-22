VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "priceHdl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mdic As New Collection
Private grownDic As New Collection
Public Function getBaby(title As String, grownValue As Long) As baby
    Dim tmp As baby, tmpRel As String
    Dim tmpTitle As String
    tmpTitle = title & " " & getGrownValueGroup(title, grownValue, tmpRel)
    thisRec.logInfo getMeNames & "宝宝:" & tmpTitle & " " & tmpRel
    If mdicExist(tmpTitle) Then
        Set getBaby = mdic(tmpTitle)
    Else
        thisRec.logInfo "不存在相应估价:" & title & " " & grownValue / 1000
    End If
End Function
Private Function mdicExist(title As String) As Boolean
    On Error GoTo notExistException
        Dim tmp As baby
        Set tmp = mdic(title)
        mdicExist = True
    Exit Function
notExistException:
End Function
Private Function grownDicExist(title As String) As Boolean
    On Error GoTo notExistException
        Dim tmp As String
        tmp = grownDic(title)
        grownDicExist = True
    Exit Function
notExistException:
End Function
Public Sub load()
    On Error GoTo Err:
    Dim iniData() As String
    iniData = getFileData
    hdlData iniData
    Exit Sub
Err:
    SetErr getMeNames & "priceHdl.load()$" & Err.Description
    End
End Sub
Private Sub hdlData(iniData() As String)
On Error GoTo Err:
    Dim i As Long
    For i = 0 To UBound(iniData)
        hdlLineData iniData(i)
    Next
    Exit Sub
Err:
    SetErr getMeNames & "priceHdl.hdlData() $" & Err.Description
End Sub
Private Function getGrownValueGroup(title As String, nowValue As Long, rel As String) As String
    Dim tmp() As Long, nowNum As Long
    If Not grownDicExist(title) Then Exit Function
    nowNum = Val(grownDic(title))
    ReDim tmp(nowNum)
    Dim i As Long
    For i = 1 To nowNum
        tmp(i) = Val(grownDic(title & " " & i))
    Next
    QuickSortStoB tmp, 1, nowNum
    For i = nowNum To 1 Step -1
        If nowValue >= tmp(i) Then
            rel = nowValue & ">=" & tmp(i) & " 组别:" & i
            getGrownValueGroup = i
            Exit Function
        End If
    Next
End Function
Private Function getGrownValueLink(title As String, nowGrownValue As Long) As String
    Dim tmp As String, nowNum As Long
    If grownDicExist(title) Then
        nowNum = Val(grownDic(title))
        Dim i As Long
        For i = 1 To nowNum
            If nowGrownValue = Val(grownDic(title & " " & i)) Then
                getGrownValueLink = i
                Exit Function
            End If
        Next
        nowNum = nowNum + 1
        grownDic.Add nowGrownValue, title & " " & nowNum
    Else
        grownDic.Add 1, title
        grownDic.Add nowGrownValue, title & " 1"
        nowNum = 1
    End If
    getGrownValueLink = CStr(nowNum)
End Function
Private Sub hdlLineData(ByVal info As String)
    info = Replace(info, "，", ",")
    info = Replace(info, "：", ":")
    
    Dim tmp() As String
    Dim i As Long, j As Long, k As Long
    Dim tmp1() As String, tmp2() As String, tmp3() As String
    tmp = Split(info, "\")
    tmp1 = Split(tmp(0), ",")
    tmp2 = Split(tmp(1), ",")
    tmp3 = Split(tmp(3), ",")
    Dim tmpBaby As baby
    For i = 0 To UBound(tmp1)
        For j = 0 To UBound(tmp2)
            For k = 0 To UBound(tmp3)
                Dim tmpTitle As String
                tmpTitle = tmp1(i) & " " & tmp2(j) & " " & tmp3(k)
                tmpTitle = tmpTitle & " " & getGrownValueLink(tmpTitle, Val(tmp(2)) * 1000)
                If Not mdicExist(tmpTitle) Then
                    Set tmpBaby = New baby
                    tmpBaby.init tmp, tmpTitle
                    mdic.Add tmpBaby, tmpTitle
                Else
                    
                End If
            Next
        Next
    Next

End Sub
Private Function getFileData() As String()
On Error GoTo Err:
    Dim tmpFileNum As Long, tmp As String, Temp() As String, i As Long
    tmpFileNum = FreeFile
    Open getSettingFilePath For Input As #tmpFileNum
        While Not EOF(tmpFileNum)
            Line Input #tmpFileNum, tmp
            tmp = getSciStr(tmp)
            If tmp <> "" Then
                ReDim Preserve Temp(i)
                Temp(i) = tmp
                i = i + 1
            End If
        Wend
    Close #tmpFileNum
    getFileData = Temp
    Exit Function
Err:
    SetErr getMeNames & "priceHdl.getFileData() $ " & Err.Description
    End
End Function
Private Function getSciStr(ByVal target As String) As String
    Dim tmpLen As Long, prLen As Long
    tmpLen = Len(target)
    target = Trim(target)
    If tmpLen >= 2 Then
        If Left(target, 2) = "//" Then Exit Function
    End If
    Do
        prLen = tmpLen
        target = Replace(target, "\\", "\")
        target = Replace(target, "  ", " ")
        tmpLen = Len(target)
    Loop Until tmpLen = prLen
    getSciStr = target
End Function
Private Function getSettingFilePath() As String
    getSettingFilePath = App.path & "\setting\" & GetInfo("Main\staticData", "settingFilePath", "默认价值.txt")
End Function

Private Sub Class_Initialize()
    load
End Sub
