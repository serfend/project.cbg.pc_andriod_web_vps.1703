Attribute VB_Name = "subMain"
 Option Explicit
Public Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long
Private thisPid As Long
Public thisThreadId As String, mht As New HttpGetter
Public webClient As New webInfoGetter
Public thisThreadMainThread As New mainThread
Public thisPriceHdl As priceHdl
Private thisThreadDelayTime As Long
Private serverListInfo As New ServerHander, TaskServerIds() As String, thisThreadStatus As String
Public thisLogger As New clsLogger, thisRec As New CRecorder
Public threadMediaer As New cMedia
Public Function getMePid() As Long
    getMePid = thisPid
End Function
Public Function getMainUrl(serverId As String) As String
On Error GoTo Err:
    Dim tmpServerName As String, tmpAeroId As String
    tmpServerName = serverListInfo("ServerName#" & serverId)
    tmpAeroId = serverListInfo("AeroID#" & serverId)
    If tmpServerName = "" Then
        thisLogger.logInfo "getServerUrlException(" & serverId & ")Name=" & tmpServerName & ",AeroID=" & tmpAeroId, 5
        getMainUrl = "none"
    Else
        getMainUrl = "http://xy2.cbg.163.com/cgi-bin/equipquery.py?act=fair_show_list&server_id=" & serverId & _
           "&areaid=" & tmpAeroId & "&page=1&kind_id=45&query_order=create_time+DESC&server_name=" & tmpServerName & "&kind_depth=2"
    End If
    Exit Function
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.getMainUrl()", Err.Number, Err.Description
    SetErr getMeNames & "MainSub.getMainUrl()$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Function getServerAllId() As String
    getServerAllId = thisThreadMainThread.getAllServerName
End Function
Private Sub init()
On Error GoTo Err:
    thisThreadId = Command$
    If App.LogMode = 0 Then thisThreadId = "test"
    threadMediaer.load App.path & "\media\音频.mp3", "CMedia" & thisThreadId
    If GetInfo("Main\setting\media", "threadRun") = "1" Then
        threadMediaer.play
    End If
    If thisThreadId = "" Then
        End
    End If
    Set thisPriceHdl = New priceHdl
    thisLogger.logInfo getMeNames & "初始化进程,pid:" & getMePid
    SetInfo CStr(getMePid), "Main\Thread\" & thisThreadId, "corePid"

    loadRegSeverInfo
    resetConfi
    thisThreadMainThread.sRun
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.init()", Err.Number, Err.Description
    SetErr getMeNames & "MainSub.init()$ " & Err.Description
    If 123 = 123 Then End
End Sub
Sub Main()
    'Load ClientFrm
    thisPid = GetCurrentProcessId
    init
    Set mht = Nothing
    Set thisThreadMainThread = Nothing
    Set serverListInfo = Nothing
    Set thisLogger = Nothing
    Set webClient = Nothing
    'Unload ClientFrm
End Sub
Public Function getThisThreadIsRefresh() As Boolean
On Error GoTo Err:
    Dim tmp As String
    tmp = GetInfo("Main\Thread\" & thisThreadId, "Refreshed")
    If tmp = "" Then Exit Function
    SetInfo "", "Main\Thread\" & thisThreadId, "Refreshed"
    getThisThreadIsRefresh = True
    Exit Function
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.getThisThreadIsRefresh()", Err.Number, Err.Description
    SetErr getMeNames & "MainSub.getThisThreadIsRefresh()$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Function getThisThreadId() As String
    getThisThreadId = thisThreadId
End Function
Public Function getThisTask(Index As Long) As String
On Error GoTo Err:
    Dim i As Long
        For i = 0 To UBound(TaskServerIds)
            If serverListInfo(TaskServerIds(i)) <> "" Then
                
            End If
        Next
        'serverId
        Exit Function
Err:
    'thisLogger.WriteErrLog getMeNames & "getThisTask()", Err.Number, Err.Description
    SetErr getMeNames & "getThisTask() " & Err.Description
    If 123 = 123 Then End
End Function
Private Sub refreshTask()
On Error GoTo Err:
    Dim tmp As String
    tmp = GetInfo("Main\Thread\" & thisThreadId, "Task")
    If tmp <> "" Then
        If tmp = "#subClose#" Then
            thisLogger.logInfo getMeNames & "refreshTask().getCmdToCloseMe"
            thisLogger.setCloseTime
            End
            Exit Sub
        Else
            Dim TaskServerIds() As String
            thisLogger.logInfo getMeNames & "refreshTask().thisThreadMainThread.resetTask"
            thisThreadMainThread.resetTask tmp
        End If
    End If
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "refreshTask()", Err.Number, Err.Description
    SetErr getMeNames & " " & Err.Description
    If 123 = 123 Then End
End Sub
Public Function newPage(Url As String, Optional init As Boolean = False, Optional thisPageId As String = "default") As clsPage
On Error GoTo Err:
    If Url = "none" Then Exit Function
    Dim tmp As clsPage, tryTime As Long
    Set tmp = New clsPage
    'Set mht = New HttpGetter
    With tmp
        .pageUrl = Url
        .pageId = thisPageId
        If init Then
            'Do
                .pageContent = webClient.getHtmlUni(Url)
            '    tryTime = tryTime + 1
            'Loop Until .pageContent <> "" Or tryTime = 3
            .pageTitle = mht.getElement(.pageContent, "<title>", "</title>")
            If .pageTitle = "" Then .pageTitle = mht.getElement(.pageContent, "<TITLE>", "</TITLE>")
        End If
    End With
    Set newPage = tmp
    Exit Function
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.newPage(Url=..." & Url, Err.Number, Err.Description
    SetErr getMeNames & "MainSub.newPage(Url=..." & Right(Url, 5) & ")$ " & Err.Description
    If 123 = 123 Then End
End Function
Public Sub setStatus(nowStatus As String)
    If thisThreadStatus = nowStatus Then Exit Sub
    thisLogger.logInfo getMeNames & "setStatus(" & nowStatus & ")", 5
    thisThreadStatus = nowStatus
    SetInfo nowStatus, "Main\Thread\" & thisThreadId, "Status"
    'ShowInfos "状态更新:" & thisThreadStatus, RGB(100, 200, 100), RGB(200, 200, 255)
    Debug.Print thisThreadStatus
End Sub
Public Sub appendStatus(childStatus As String, Optional sndToServer As Boolean)
    thisLogger.logInfo getMeNames & "appendStatus(" & childStatus & "," & sndToServer & ")", 5
    SetInfo thisThreadStatus & " " & childStatus, "Main\Thread\" & thisThreadId, "Status"
    Debug.Print thisThreadStatus & " " & childStatus
    'ShowInfos "状态进度:" & thisThreadStatus & " " & childStatus, RGB(100, 200, 100), RGB(200, 200, 255)
    
    'If sndToServer Then
    '    ClientFrm.setStatusInfo childStatus
    'End If
End Sub
Public Sub setRunTime()
    SetInfo CStr(GetTickCount), "Main\Thread\" & thisThreadId, "Runtime"
End Sub
Public Sub resetConfi()
On Error GoTo Err:
    If getThisThreadIsRefresh = True Then
        thisLogger.logInfo getMeNames & "resetConfi().getThisThreadDelayTime", 1
        thisThreadDelayTime = Val(GetInfo("Main\Thread\" & thisThreadId, "runInterval", 1500))
        thisLogger.logInfo getMeNames & "resetConfi().thisThreadMainThread.setInterval", 1
        thisThreadMainThread.setInterval thisThreadDelayTime
        thisLogger.logInfo getMeNames & "resetConfi().refreshTask", 1
        refreshTask
        thisLogger.logInfo getMeNames & "resetConfi()success", 1
    End If
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.resetConfi()", Err.Number, Err.Description
    SetErr getMeNames & "MainSub.resetConfi()$ " & Err.Description
    If 123 = 123 Then End
End Sub
Private Sub loadRegSeverInfo()
On Error GoTo Err:
    thisLogger.logInfo getMeNames & "loadRegSeverInfo()", 1
    Dim tmpServerNum As Long
    Dim serverInfo As String
    serverListInfo.RemoveAll
    'tmpServerNum = Val(GetInfo("Main\Setting\ServerInfo", "ServerNum"))
    Do
        Dim tmp As String
        tmpServerNum = tmpServerNum + 1
        tmp = GetInfo("Main\Setting\ServerInfo\ServerList", "Server " & tmpServerNum)
        If tmp = "" Then Exit Do
        
        tmp = Replace(tmp, " ", "")
        Dim tmpInfo() As String
        tmpInfo = Split(tmp, ",")
        serverListInfo.Add tmpInfo(1), "ServerName#" & tmpInfo(0)
        serverListInfo.Add tmpInfo(2), "AeroID#" & tmpInfo(0)
        serverListInfo.Add tmpInfo(3), "AeroName#" & tmpInfo(0)
    Loop
    tmpServerNum = tmpServerNum - 1
    Exit Sub
Err:
    'thisLogger.WriteErrLog getMeNames & "MainSub.loadRegSeverInfo()", Err.Number, Err.Description
    SetErr getMeNames & "MainSub.loadRegSeverInfo()$ " & Err.Description
    If 123 = 123 Then End
End Sub
