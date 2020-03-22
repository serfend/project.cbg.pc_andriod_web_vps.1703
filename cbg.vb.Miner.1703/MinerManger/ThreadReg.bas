Attribute VB_Name = "ThreadReg"
Option Explicit
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private thisThread As String, NowCoreIndex As Long
Private Type serverInfo
    hdlCores() As String
    Id As String
    Names As String
    AeroId As String
    AeroName As String
    Abandant As Boolean
    runNum As Long
    nowRunNum As Long
End Type
Private mainServer() As serverInfo, serverNum As Long
Public Function setThread(threadID As String) As Long
    thisThread = threadID
    setThreadRefresh threadID
End Function
Public Function setThreadSetting(Optional setKey As String, Optional setValue As String, Optional ByVal threadID As String) As Long
    If threadID <> "" Then thisThread = threadID
    SetInfo setValue, "Main\Thread\" & thisThread, setKey
End Function
Public Function getThreadSetting(Optional ByVal getKey As String, Optional ByVal threadID As String) As String
    If threadID <> "" Then thisThread = threadID
    getThreadSetting = GetInfo("Main\Thread\" & thisThread, getKey)
End Function
Private Function setThreadRefresh(RefreshCoreId As String) As Long
    SetInfo "1", "Main\Thread\" & RefreshCoreId, "Refreshed"
End Function
Public Function getUnhdlTask(hdlCore As String, Optional ByVal serverAddNum As Long = -1) As String
    Dim i As Long
    If serverAddNum = -1 Then serverAddNum = serverNum
    For i = 1 To serverNum
        If mainServer(i).nowRunNum < mainServer(i).runNum And Not mainServer(i).Abandant Then
            If serverAddNum = 0 Then Exit Function
            serverAddNum = serverAddNum - 1

            getUnhdlTask = getUnhdlTask & mainServer(i).Id & "#"
        End If
    Next
End Function
Public Sub setHdlTask(CoreId As String, ServerId As String)
    Dim i As Long
    
    For i = 1 To serverNum
        If mainServer(i).Id = ServerId Then
            mainServer(i).nowRunNum = mainServer(i).nowRunNum + 1
            ReDim Preserve mainServer(i).hdlCores(mainServer(i).nowRunNum)
            mainServer(i).hdlCores(mainServer(i).nowRunNum) = CoreId
            Exit Sub
        End If
    Next
    
End Sub
Public Sub setServerState(Index As Long, StateAbandant As Boolean)
    mainServer(Index).Abandant = StateAbandant
    SetInfo IIf(StateAbandant, "1", "0"), "Main\Setting\ServerInfo\ServerSettingAbandant", mainServer(Index).Id
End Sub
Public Sub refreshList()
    Dim i As Long, j As Long
    With FrmMain.ServerLoaders
        .ListItems.Clear
        For i = 1 To serverNum
            .ListItems.Add , , mainServer(i).Id
            .ListItems(i).SubItems(1) = mainServer(i).Names
            If mainServer(i).nowRunNum = 0 Then
                If mainServer(i).Abandant Then
                    .ListItems(i).SubItems(2) = "禁用"
                Else
                    .ListItems(i).SubItems(2) = "待分配"
                End If
            Else
                .ListItems(i).SubItems(2) = "已分配" & mainServer(i).nowRunNum & "/" & mainServer(i).runNum
            End If
            
        Next
    End With
End Sub
Public Function removeHdlTask(hdlCore As String) As Long
    Dim i As Long, j As Long
    
    For i = 1 To serverNum
        For j = 1 To mainServer(i).nowRunNum
            If mainServer(i).hdlCores(j) = hdlCore Then
                Dim k As Long
                For k = j To mainServer(i).nowRunNum - 1
                    mainServer(i).hdlCores(k) = mainServer(i).hdlCores(k + 1)
                Next
                mainServer(i).nowRunNum = mainServer(i).nowRunNum - 1
                'TaskNum = TaskNum + 1
            End If
        Next
    Next
    
End Function
Public Sub loadServerInfo()
    serverNum = 0
    thisLogger.logInfo "loadServerInfo()", 1
    DelSub "Main\Setting\ServerInfo", "ServerList"
    Dim thisFile As Long, tmp As String
    thisFile = FreeFile()
    Open App.Path & "\ServerInfo.txt" For Input As #thisFile
        While Not EOF(thisFile)
            Line Input #thisFile, tmp
            If addNewServerInfo(tmp) = -1 Then
                 SetErr "读取ServerInfo.txt失败"
                 If MsgBox("继续运行?", vbYesNo) = vbNo Then End
            End If
        Wend
        SetInfo CStr(serverNum), "Main\Setting\ServerInfo", "ServerNum"
    Close #thisFile
End Sub
Private Function addNewServerInfo(info As String) As Long
    On Error GoTo Err:
    Dim tmpInfo() As String
        tmpInfo = Split(info, ",")
        If UBound(tmpInfo) < 3 Then Exit Function
        serverNum = serverNum + 1
        SetInfo info, "Main\Setting\ServerInfo\ServerList", "Server " & serverNum
        Dim i As Long
        For i = 0 To 3
            tmpInfo(i) = Replace(tmpInfo(i), " ", "")
        Next

        ReDim Preserve mainServer(serverNum)
        With mainServer(serverNum)
            .Id = tmpInfo(0)
            .Names = tmpInfo(1)
            .AeroId = tmpInfo(2)
            .AeroName = tmpInfo(3)
            If UBound(tmpInfo) = 3 Then
                .runNum = 1
            Else
                .runNum = Val(tmpInfo(4))
            End If
            .Abandant = IIf(GetInfo("Main\Setting\ServerInfo\ServerSettingAbandant", .Id, "1") = "1", True, False)
            
        End With
    Exit Function
Err:
    serverNum = serverNum - 1
    addNewServerInfo = -1
    Resume
End Function
