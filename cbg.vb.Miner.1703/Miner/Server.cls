VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Server"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public thisServerId As String, thisThreadInfo As pageMainInfo, prThreadInfo As pageMainInfo
Private mhpt As New HttpGetter
Public Sub getNewInfo()
On Error GoTo Err:
    Dim dataPage As clsPage, clsUrl As String
    Static showErrTime As Long
    clsUrl = getMainUrl(thisServerId)
    If clsUrl = "none" Then
        appendStatus "无效的服务器ID:" & thisServerId
        Exit Sub
    End If
    thisLogger.logInfo getMeNames & "server." & thisServerId & ".getNewInfo().getNewPage", 5
    Set dataPage = newPage(clsUrl, True)
    '<a class="photo" style="text-decoration:none;" href="
    With dataPage
        If .pageTitle = "" Then '失败
            appendStatus "网页打开失败"
            showErrTime = showErrTime + 1
            If showErrTime Mod 5 = 0 Then
                showErrTime = 0
                thisThreadMainThread.sStop
            End If
        Else
            Dim tmp As String
            tmp = .pageContent
            thisLogger.logInfo getMeNames & "server." & thisServerId & ".successGetNewPage", 5
            With thisThreadInfo
                .BuyUrl = mhpt.getElement(tmp, "<a class=""photo"" style=""text-decoration:none;"" href=""", """ onclick=")
                Dim tmpData As String, skillData As String
                tmpData = mhpt.getElement(tmp, "generate_tips(", ")")
                If tmpData = "" Then
                    
                    Open App.path & "\log\C" & thisServerId & ".txt" For Output As #1
                        Print #1, clsUrl & vbCrLf & tmp
                    Close
                    
                    If showErrTime Mod 5 = 0 Then
                        thisLogger.logInfo vbCrLf & getMeNames & "getNewInfoServerReplyException", 3
                        If InStr(1, tmp, "请输入验证码") > 0 Then
                            appendStatus thisServerId & "需要验证码" ', True
                            thisThreadMainThread.sStop
                        ElseIf InStr(1, tmp, "系统繁忙") > 0 Then
                            appendStatus thisServerId & "网络繁忙，请稍后再试" ', True
                            thisThreadMainThread.sStop
                        Else
                            appendStatus thisServerId & "获取数据失败" ', True
                        End If
                        showErrTime = 0
                    End If
                    showErrTime = showErrTime + 1
                    Set dataPage = Nothing
                    Exit Sub
                End If
                'Debug.Print tmpData
                Dim thisTmpData() As String
                thisTmpData = Split(tmpData, "',")
                .names = Replace(Replace(thisTmpData(1), " ", ""), "'", "")
                .levInfo = mhpt.getElement(tmp, "data_equip_level_desc=""", """")
                If prThreadInfo.equal(thisThreadInfo) Then
                    appendStatus "物品:" & .names
                Else
                    appendStatus "新物品:" & .names
                    hdlServerInfo
                End If
            End With
            prThreadInfo.BuyUrl = thisThreadInfo.BuyUrl
        End If
    End With
    Set dataPage = Nothing
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "Server[" & thisServerId & "] " & ".getNewInfo()", Err.Number, Err.Description
    SetErr getMeNames & "Server[" & thisServerId & "] " & ".getNewInfo()$ " & Err.Description
    If 123 = 123 Then End
End Sub
Private Sub hdlServerInfo()
On Error GoTo Err:
    With thisThreadInfo
        If .BuyUrl = "" Then Exit Sub
        Debug.Print "buyUrl:" & vbCrLf & .BuyUrl
        Dim childPage As clsPage
        Set childPage = newPage(.BuyUrl, True) 'http://xy2.cbg.163.com/cgi-bin/equipquery.py act=buy_show_by_ordersn&server_id=211&ordersn=122000RXZR&server_name=%E6%B2%B3%E5%8C%97%E6%96%B0%E5%8C%BA
        Dim tmp As String
        tmp = childPage.pageContent
        Dim babyListTmp As String
        babyListTmp = mhpt.getElement(tmp, "<textarea", "xtarea")
        babyListTmp = mhpt.getElement(babyListTmp, "SummonList", "</te")
        .babyList.init babyListTmp
        .price = mhpt.getElement(tmp, "price"" : ", ",")
        .assumePrice = CStr(.babyList.priceValue)
        Debug.Print "price:" & .price & "  " & "assumePrice:" & .assumePrice
        .Id = mhpt.getElement(tmp, "equipid"" : """, """,")
        .companyAchivement = mhpt.getElement(tmp, "iChengjiu"":", ",")
        .Talent = mhpt.getElement(tmp, "iTalent"":", ",")
        .Achievement = mhpt.getElement(tmp, "iAchievement"":", ",")
        .familyScorces = mhpt.getElement(tmp, "iSingleEnergyRate"":", ",")
        .referBuyerId = mhpt.getElement(tmp, "appointed_roleid"" : """, """")
        If .referBuyerId = "" Then
            thisLogger.logInfo getMeNames & "submit()", 2
            .submit
            thisLogger.logInfo getMeNames & "submit()done", 2
        Else
            thisLogger.logInfo getMeNames & "referId:" & .referBuyerId & ",submit cancel", 2
        End If
        Set childPage = Nothing
    End With
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "Server[" & thisServerId & "] " & ".hdlServerInfo()", Err.Number, Err.Description
    SetErr getMeNames & "Server[" & thisServerId & "] " & ".hdlServerInfo()$ " & Err.Description
    If 123 = 123 Then End
End Sub
Public Sub init(serverId As String)
    thisServerId = serverId
    thisThreadInfo.init serverId
End Sub
Private Sub Class_Initialize()
    Set thisThreadInfo = New pageMainInfo
    Set prThreadInfo = New pageMainInfo
End Sub
