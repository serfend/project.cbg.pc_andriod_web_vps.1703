VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl32.ocx"
Begin VB.Form FrmMain 
   BackColor       =   &H00FFFFFF&
   Caption         =   "������"
   ClientHeight    =   12375
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   13185
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   12375
   ScaleWidth      =   13185
   StartUpPosition =   3  '����ȱʡ
   Begin MSComctlLib.ListView MainOutPut 
      Height          =   6855
      Left            =   240
      TabIndex        =   27
      Top             =   120
      Width           =   8775
      _ExtentX        =   15478
      _ExtentY        =   12091
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView LstIpShow 
      Height          =   5055
      Left            =   9240
      TabIndex        =   26
      Top             =   7080
      Width           =   3615
      _ExtentX        =   6376
      _ExtentY        =   8916
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView ServerLoaders 
      Height          =   6735
      Left            =   9240
      TabIndex        =   25
      Top             =   120
      Width           =   3615
      _ExtentX        =   6376
      _ExtentY        =   11880
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Frame GrpSetting 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   4095
      Left            =   240
      TabIndex        =   0
      Top             =   7080
      Width           =   8775
      Begin VB.Frame Frame1 
         BackColor       =   &H00FFFFFF&
         Caption         =   "ͨ��  "
         Height          =   2055
         Left            =   0
         TabIndex        =   5
         Top             =   0
         Width           =   7095
         Begin VB.TextBox IpResetThread 
            Height          =   270
            Index           =   3
            Left            =   5640
            TabIndex        =   24
            Text            =   "10000"
            Top             =   1320
            Width           =   1335
         End
         Begin VB.TextBox IpResetThread 
            Height          =   270
            Index           =   2
            Left            =   5640
            TabIndex        =   18
            Text            =   "100"
            Top             =   960
            Width           =   1335
         End
         Begin VB.TextBox IpResetThread 
            Height          =   270
            Index           =   1
            Left            =   5640
            TabIndex        =   17
            Text            =   "ʧ��"
            Top             =   600
            Width           =   1335
         End
         Begin VB.TextBox IpResetThread 
            Height          =   270
            Index           =   0
            Left            =   5640
            TabIndex        =   16
            Text            =   "300"
            Top             =   240
            Width           =   1335
         End
         Begin VB.CommandButton MainCmd 
            Caption         =   "���Ӻ���"
            Height          =   555
            Index           =   0
            Left            =   120
            TabIndex        =   15
            Top             =   240
            Width           =   1545
         End
         Begin VB.CommandButton MainCmd 
            Caption         =   "ɾ������"
            Height          =   555
            Index           =   1
            Left            =   120
            TabIndex        =   14
            Top             =   960
            Width           =   1545
         End
         Begin VB.CommandButton MainCmd 
            Caption         =   "ֹͣ����"
            Height          =   555
            Index           =   3
            Left            =   2400
            TabIndex        =   13
            Top             =   240
            Width           =   1545
         End
         Begin VB.TextBox ip 
            Appearance      =   0  'Flat
            Height          =   285
            Index           =   2
            Left            =   1680
            TabIndex        =   12
            Text            =   "2000"
            Top             =   960
            Width           =   645
         End
         Begin VB.TextBox ip 
            Appearance      =   0  'Flat
            Height          =   270
            Index           =   3
            Left            =   1680
            TabIndex        =   11
            Text            =   "3000"
            Top             =   1320
            Width           =   645
         End
         Begin VB.TextBox ip 
            Appearance      =   0  'Flat
            Height          =   285
            Index           =   4
            Left            =   3960
            TabIndex        =   10
            Text            =   "5000"
            Top             =   360
            Width           =   645
         End
         Begin VB.TextBox ip 
            Appearance      =   0  'Flat
            Height          =   285
            Index           =   1
            Left            =   1680
            TabIndex        =   9
            Text            =   "2"
            Top             =   600
            Width           =   645
         End
         Begin VB.TextBox ip 
            Appearance      =   0  'Flat
            Height          =   285
            Index           =   0
            Left            =   1680
            TabIndex        =   8
            Text            =   "2500"
            Top             =   240
            Width           =   645
         End
         Begin VB.CheckBox optSelect 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            Caption         =   "������־"
            ForeColor       =   &H80000008&
            Height          =   375
            Index           =   0
            Left            =   2460
            TabIndex        =   7
            Top             =   840
            Width           =   1455
         End
         Begin VB.CheckBox optSelect 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            Caption         =   "��¼��ϸ��Ϣ"
            ForeColor       =   &H80000008&
            Height          =   375
            Index           =   1
            Left            =   2460
            TabIndex        =   6
            Top             =   1200
            Visible         =   0   'False
            Width           =   1455
         End
         Begin VB.Label Label1 
            BackStyle       =   0  'Transparent
            Caption         =   "ip��ͣ"
            Height          =   255
            Index           =   2
            Left            =   4920
            TabIndex        =   23
            Top             =   1320
            Width           =   735
         End
         Begin VB.Label Label1 
            BackStyle       =   0  'Transparent
            Caption         =   "�ؼ���"
            Height          =   255
            Index           =   1
            Left            =   4920
            TabIndex        =   19
            Top             =   600
            Width           =   735
         End
         Begin VB.Label Label1 
            BackStyle       =   0  'Transparent
            Caption         =   "�������"
            Height          =   255
            Index           =   0
            Left            =   4920
            TabIndex        =   21
            Top             =   240
            Width           =   735
         End
         Begin VB.Label Label1 
            BackStyle       =   0  'Transparent
            Caption         =   "���۱���"
            Height          =   255
            Index           =   1000
            Left            =   4920
            TabIndex        =   22
            Top             =   960
            Width           =   735
         End
      End
      Begin VB.Frame sMedia 
         BackColor       =   &H00FFFFFF&
         Caption         =   "����ѡ��  "
         Height          =   2055
         Left            =   7080
         TabIndex        =   1
         Top             =   0
         Width           =   1815
         Begin VB.CheckBox optSelect 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            Caption         =   "�µ��߳�"
            ForeColor       =   &H80000008&
            Height          =   375
            Index           =   2
            Left            =   120
            TabIndex        =   4
            Top             =   240
            Width           =   1455
         End
         Begin VB.CheckBox optSelect 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            Caption         =   "�̹߳ر�"
            ForeColor       =   &H80000008&
            Height          =   375
            Index           =   3
            Left            =   120
            TabIndex        =   3
            Top             =   600
            Width           =   1455
         End
         Begin VB.CheckBox optSelect 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            Caption         =   "�µ���Ʒ"
            ForeColor       =   &H80000008&
            Height          =   375
            Index           =   4
            Left            =   120
            TabIndex        =   2
            Top             =   960
            Width           =   1455
         End
      End
      Begin VB.Label opShowLog 
         BackStyle       =   0  'Transparent
         Height          =   2295
         Left            =   0
         TabIndex        =   20
         Top             =   2160
         Width           =   8775
      End
   End
   Begin VB.Timer CoreLoader 
      Interval        =   5000
      Left            =   1440
      Top             =   0
   End
   Begin VB.Timer MainMover 
      Interval        =   500
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private showNowCmdCaptionOfLoaderTimerCounter As Long
Private thisThreadNum As Long, cdList As CoreList, AllCoreIsLoaded As Boolean

Private nextCoreLoadTime As Long
Private nextGetIpTime As Long
Private Sub CoreLoader_Timer()
On Error GoTo Err:
    Dim nextRefreshTimeCoreLoad As Long, nextGetIpTimeCoreLoad As Long, nowTime As Long
    nowTime = GetTickCount
    nextRefreshTimeCoreLoad = nowTime - nextCoreLoadTime
    nextGetIpTimeCoreLoad = nowTime - nextGetIpTime
    If nextRefreshTimeCoreLoad > 0 Then
        tryLoadNewCore
    Else
        Me.Caption = "������ - ��ͣ��" & -nextRefreshTimeCoreLoad
    End If
    
    If nextGetIpTimeCoreLoad > 0 Then
        CheckIpBase
        nextGetIpTime = nowTime + 10000
    End If
    Exit Sub
Err:
    SetErr "CoreLoader()$" & Err.Description
    thisLogger.WriteErrLog "CoreLoader()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub
Private Sub tryLoadNewCore(Optional byUser As Boolean)
On Error GoTo Err:
    If byUser Then thisLogger.logInfo "tryLoadNewCore()", 1
    If Not AllCoreIsLoaded Then
        Dim tmpCoreLoad As String
        tmpCoreLoad = getUnhdlTask("", Val(ip(1).Text))
        If tmpCoreLoad = "" Then
            'AllCoreIsLoaded = True
            'CoreLoader.Enabled = False
            CoreLoader.Interval = Val(ip(4).Text) / 2.5
            If byUser Then SetErr "��������Ҫ����"
        Else
            listAttachStatus "Main", "���غ���...Id=" & getUnhdlTask("C" & thisThreadNum, 1)
            listAddNewCore tmpCoreLoad, Val(ip(0).Text), "C" & thisThreadNum, True
            CoreLoader.Interval = Val(ip(4).Text)
        End If
    End If
    Exit Sub
Err:
    SetErr "tryLoadNewCore()$" & Err.Description
    thisLogger.WriteErrLog "tryLoadNewCore()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub

Private Sub Form_Load()
'On Error GoTo Err:
    showAllOpt
    DelSub "Main", "Data"
    DelSub "Main", "Thread"
    thisLogger.setRunTime
    Set cdList = New CoreList
    With MainOutPut
        .ColumnHeaders.Add , , "���", .Width * 0.08
        .ColumnHeaders.Add , , "����ID", .Width * 0.12, 2
        .ColumnHeaders.Add , , "���������", .Width * 0.2
        .ColumnHeaders.Add , , "״̬", .Width * 0.3, 2
        .ColumnHeaders.Add , , "��ʱ", .Width * 0.1, 2
        .ColumnHeaders.Add , , "�ϴ�ˢ��", .Width * 0.2, 2
        listAddNewCore "���������", "0", "Main"
        listAttachStatus "Main", "��ʼ��"
        
        .AllowColumnReorder = True
        .View = lvwReport
        .FullRowSelect = True
    End With
    With LstIpShow
        .ColumnHeaders.Add , , "����ip", .Width * 0.9
        .AllowColumnReorder = True
        .View = lvwReport
        .FullRowSelect = True
    End With
    With ServerLoaders
        .ColumnHeaders.Add , , "ID", .Width * 0.2
        .ColumnHeaders.Add , , "����", .Width * 0.4
        .ColumnHeaders.Add , , "״̬", .Width * 0.4
        
        .AllowColumnReorder = True
        .View = lvwReport
        .FullRowSelect = True
    End With
    IpResetThread(2).Text = GetInfo("Main\Setting\Price", "rate", "100")
    IpResetThread(3).Text = GetInfo("Main\Setting", "WarningIpWaitTime", "10000")
    init
    
    Dim xmlhttp As Object
    Set xmlhttp = CreateObject("msxml2.xmlhttp")
    With xmlhttp
        .Open "get", "http://proxy.baibianip.com:7000/getip.html", False
        .send
        SetInfo .responsetext, "Main\Setting", "SelfIp"
    End With
    Set xmlhttp = Nothing
    
    Exit Sub
Err:
    SetErr "frmMainCmdLoad()$" & Err.Description
    thisLogger.WriteErrLog "frmMainCmdLoad()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub
Private Sub listAddNewCore(CoreTask As String, Optional DelayTime As Long = 5000, Optional ByVal CoreId As String = "", Optional ActiveNow As Boolean = False)
On Error GoTo Err:
    Dim newCoreIp As String
    If CoreId <> "Main" Then
        newCoreIp = GetSingleIp()
        If newCoreIp = "" Then
            Me.Caption = "����ip����"
            Exit Sub
        End If
    End If
    thisLogger.logInfo "listAddNewCore(" & CoreTask & "," & DelayTime & "," & CoreId & ")", 1
    thisThreadNum = thisThreadNum + 1
    If CoreId = "" Then CoreId = "C" & thisThreadNum
    setThread CoreId
    setThreadSetting "runInterval", CStr(DelayTime)
    With MainOutPut
        .ListItems.Add , CoreId, thisThreadNum
        .ListItems(CoreId).SubItems(1) = CoreId
        
        Dim thisTaskInfo() As String
        thisTaskInfo = Split(CoreTask, "#")
        Dim i As Long, tmp As String
        For i = 0 To UBound(thisTaskInfo) - 1
            setHdlTask CoreId, thisTaskInfo(i)
            tmp = tmp & serverListInfo("ServerName#" & thisTaskInfo(i)) & ","
        Next
        If tmp <> "" Then tmp = Mid(tmp, 1, Len(tmp) - 1)
        .ListItems(CoreId).SubItems(2) = tmp
        .ListItems(CoreId).SubItems(4) = DelayTime
    End With
    Dim core As mainCore
    Set core = cdList.Add(CoreId, DelayTime, CoreTask, CoreId, ActiveNow, IpResetThread(0).Text, IpResetThread(1).Text)
    core.ip = newCoreIp
    refreshList
    Exit Sub
Err:
    SetErr "listAddNewCore()$" & Err.Description
    thisLogger.WriteErrLog "listAddNewCore()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub
Private Sub listAttachStatus(CoreId As String, CoreStatus As String)
    thisLogger.logInfo "listAttachStatus(" & CoreId & "," & CoreStatus & ")", 3
    MainOutPut.ListItems(CoreId).SubItems(3) = CoreStatus
    setThreadSetting "Status", CoreStatus, CoreId
End Sub
Private Sub listSetCoreInterval(CoreId As String, CoreInterval As Long)
    thisLogger.logInfo "listSetCoreInterval(" & CoreId & "," & CoreInterval & ")", 3
    MainOutPut.ListItems(CoreId).SubItems(4) = CoreInterval
    setThreadSetting "runInterval", CStr(CoreInterval), CoreId
End Sub
Private Sub listSetTask(CoreId As String, CoreNewTask As String)
    thisLogger.logInfo "listSetTask(" & CoreId & "," & CoreNewTask & ")", 3
    MainOutPut.ListItems(CoreId).SubItems(2) = CoreNewTask
    setThreadSetting "Task", CoreNewTask, CoreId
End Sub
Private Sub removeCore(CoreId As String, whyClose As String)
On Error GoTo Err:
    thisLogger.logInfo "removeCore(" & CoreId & ",for:" & whyClose & ")", 1
    Dim thisThread As mainCore
    Dim Des As String
    If CoreId = "Main" Then Exit Sub
    Des = "inCore:" & CoreId
    Set thisThread = cdList(CoreId)
    If thisThread Is Nothing Then
        'seterr
    Else
        
        'thisThreadNum = thisThreadNum - 1
        thisThread.Terminate
        Des = "Terminate"
        MainOutPut.ListItems.Remove CoreId
        cdList.Remove CoreId
        removeHdlTask CoreId
    End If
    Des = "refreshList"
    refreshList
    Exit Sub
Err:
    SetErr "removeCore()$" & Des & Err.Description
    thisLogger.WriteErrLog "removeCore()" & Des, Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub

Private Sub Form_Resize()
    MainOutPut.Height = Me.Height * 0.7
    ServerLoaders.Height = Me.Height * 0.8
    LstIpShow.Top = Me.Height * 0.82
    LstIpShow.Height = Me.Height * 0.15
    GrpSetting.Top = Me.Height * 0.72
    GrpSetting.Height = Me.Height * 0.2
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SetInfo FrmMain.ip(0).Text, "Main\Setting\CoreSetting", "defaultInterval"
    SetInfo FrmMain.ip(1).Text, "Main\Setting\CoreSetting", "defaultRunNum"
    SetInfo FrmMain.ip(2).Text, "Main\Setting\CoreSetting", "threadTimeOutNum"
    SetInfo FrmMain.ip(3).Text, "Main\Setting\CoreSetting", "threadCloseTimeOutNum"
    SetInfo FrmMain.ip(4).Text, "Main\Setting\CoreSetting", "addNewThreadInterval"
    SetInfo FrmMain.IpResetThread(0).Text, "Main\Setting\CoreSetting", "IpResetThread(0)"
    SetInfo FrmMain.IpResetThread(1).Text, "Main\Setting\CoreSetting", "IpResetThread(1)"
    
    Dim i As Long
    For i = 1 To cdList.Count
        cdList(i).Terminate
    Next
    thisLogger.setCloseTime
End Sub

Private Sub IpResetThread_Change(index As Integer)
    If index = 2 Then
        SetInfo IpResetThread(index).Text, "Main\Setting\Price", "rate"
    ElseIf index = 3 Then
        SetInfo IpResetThread(index).Text, "Main\Setting", "WarningIpWaitTime"
    End If
End Sub

Private Sub MainCmd_Click(index As Integer)
    Select Case index
        Case 0:
            'If AllCoreIsLoaded Then
                tryLoadNewCore True
            '    listAddNewCore InputBox("�������߳���Ҫ��ȡ�ķ�����", , getUnhdlTask("C" & thisThreadNum)), Val(ip(0).Text), "C" & thisThreadNum, True
            'Else
            '    SetErr "ϵͳδ��ɼ���"
            '    If MsgBox("��������?", vbYesNo) = vbNo Then End
            'End If
        Case 1:
            removeCore MainOutPut.SelectedItem.Key, "�ֶ��ر�"
        Case 2:
            
        Case 3:
            If MainCmd(index).Caption = "�ٰ�һ��ȷ��" Then
                CoreLoader.Enabled = Not CoreLoader.Enabled
                thisLogger.logInfo IIf(CoreLoader.Enabled, "userStartLoader()", "userStopLoader()")
                showNowCmdCaptionOfLoader
            Else
                MainCmd(index).Caption = "�ٰ�һ��ȷ��"
            End If
            
        Case 4:
    End Select
End Sub
Private Sub showNowCmdCaptionOfLoader()
    showNowCmdCaptionOfLoaderTimerCounter = 0
    MainCmd(3).Caption = IIf(CoreLoader.Enabled, "ֹͣ����", "��������")
End Sub
Private Sub MainMover_Timer()
    Dim thisErrPos As String, thisThreadTimeOutTime As Long, thisThreadCloseTimeOutTime As Long
    thisThreadTimeOutTime = Val(ip(2).Text)
    thisThreadCloseTimeOutTime = Val(ip(3).Text)
On Error GoTo Err:
    Static refreshTimes As Long, CoreAdder As Long
    refreshTimes = refreshTimes + 1
    showNowCmdCaptionOfLoaderTimerCounter = showNowCmdCaptionOfLoaderTimerCounter + 1
    If refreshTimes > 10 Then
        SetInfo CStr(GetTickCount), "Main\Thread\Main", "LastRunTime"
        MainOutPut.ListItems(1).SubItems(5) = CStr(Now)
        refreshTimes = 0
        If showNowCmdCaptionOfLoaderTimerCounter > 10 Then
            showNowCmdCaptionOfLoader
        End If
    End If
    Dim i As Long, thisThreadIndex As Long
    
    
    thisErrPos = "load MainOutPut"
    With MainOutPut
        thisErrPos = "get Mop listCount"
        For i = 2 To .ListItems.Count
            thisErrPos = "get mop thisThreadId"
            Dim thisThreadStatus As String, thisThreadId As String, thisThread As mainCore, thisGoingToTerminate As String
            With .ListItems(i)
                thisThreadId = Replace(.SubItems(1), " ", "")
                If thisThreadId <> "" Then
                    thisErrPos = "get cdList(thisThreadId)"
                    Set thisThread = cdList(thisThreadId)
                    thisErrPos = "loading this thread"
                    If thisThread Is Nothing Then
                        thisLogger.logInfo "getChildThread(" & thisThreadId & ") terminated"
                        thisGoingToTerminate = thisGoingToTerminate & "/" & .SubItems(1)
                    Else
                        thisThreadStatus = thisThread.Status
                        thisErrPos = "CheckIfNeedIp"
                        If thisThread.needNewIP Then
                            thisErrPos = "ipSettingA"
                            thisThread.needNewIP = False
                            thisErrPos = "ipSettingB"
                            thisThread.ip = GetSingleIp()
                        End If
                        If InStr(1, thisThreadStatus, "����ʹ�ñ���ip") Then
                            nextCoreLoadTime = GetTickCount + Val(IpResetThread(3).Text)  '��ͣ�����½���
                            removeCore thisThreadId, "����״̬:" & thisThreadStatus '���ֹر���Ϣ
                            Exit Sub
                        Else
                            If InStr(1, thisThreadStatus, IpResetThread(1).Text) Or InStr(1, thisThreadStatus, "��֤��") > 0 Then
                                removeCore thisThreadId, "����״̬:" & thisThreadStatus '���ֹر���Ϣ
                                Exit Sub
                            Else
                                If .SubItems(3) <> thisThreadStatus Then
                                    .SubItems(3) = thisThreadStatus
                                End If
                                thisErrPos = "get cdlist.runtime"
                                thisThreadStatus = thisThread.runTime
                                If Val(thisThreadStatus) - thisThread.CoreBeginTime > 1000 * Val(IpResetThread(0).Text) Then
                                    removeCore thisThreadId, "��������(�ﵽ�������)" '�ﵽˢ�¼��
                                    Exit Sub
                                Else
                                    Dim thisRunTime As Long
                                    thisRunTime = GetTickCount - Val(thisThreadStatus)
                                    thisErrPos = "get cdlist.interval"
                                    Debug.Print thisThreadId & " runtime:" & thisRunTime
                                    If Val(thisThreadStatus) = 0 Then
                                        thisThread.outofControlTime = thisThread.outofControlTime + 1
                                        If thisThread.outofControlTime > 10 Then
                                            removeCore thisThreadId, "��ʱ�˳�" '��ʱ�˳�
                                            Exit Sub
                                        End If
                                    ElseIf thisRunTime < thisThreadTimeOutTime Then
                                        If .SubItems(5) <> "��������" Then
                                            .SubItems(5) = thisRunTime & "ms"
                                            thisThread.outofControlTime = 0
                                        End If
                                    ElseIf thisRunTime < thisThreadCloseTimeOutTime Then
                                        If InStr(1, .SubItems(5), "����Ӧ") <= 0 Then
                                            .SubItems(5) = "����Ӧ(" & thisRunTime & ")ms"
                                        End If
                                    Else
                                        thisGoingToTerminate = thisGoingToTerminate & "/" & .SubItems(1)
                                    End If
                                End If
    
                            End If
                        End If
                    End If
                Else
                    If .SubItems(5) <> Replace(.SubItems(1), " ", "") & ".ID��Ч" Then
                        .SubItems(5) = Replace(.SubItems(1), " ", "") & ".ID��Ч"
                    End If
                End If
            End With
        Next
        If thisGoingToTerminate <> "" Then removeAllCoreList thisGoingToTerminate
    End With
    Exit Sub
Err:
    SetErr "MainMover()$#255#��:" & thisErrPos & "$#" & RGB(200, 200, 200) & "#" & Err.Description
    thisLogger.WriteErrLog "MainMover()" & thisErrPos, Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub
Private Sub removeAllCoreList(needRemoveList As String)
   Dim tmp() As String
   tmp = Split(needRemoveList, "/")
   Dim i As Long
   For i = 1 To UBound(tmp)
        removeCore tmp(i), "��������Ч"
   Next
End Sub
Private Sub showAllOpt()
    Dim loggerMod As String
    loggerMod = GetInfo("Main\setting\media", "loggerActive")
    Select Case loggerMod
        Case "active":
            optSelect(0).value = Checked
            optSelect(1).value = Checked
        Case "logError":
            optSelect(0).value = Checked
    End Select
    If GetInfo("Main\setting\media", "threadRun") = "1" Then optSelect(2).value = Checked
    If GetInfo("Main\setting\media", "threadStop") = "1" Then optSelect(3).value = Checked
    If GetInfo("Main\setting\media", "threadNewObj") = "1" Then optSelect(4).value = Checked

End Sub

Private Sub optSelect_Click(index As Integer)
    Select Case index
        Case 0:
            If optSelect(index).value = Checked Then
                SetInfo "logError", "Main\Setting\MainCoreSetting", "loggerActive"
                optSelect(1).value = Unchecked
                optSelect(1).Visible = True
            Else
                SetInfo "disable", "Main\Setting\MainCoreSetting", "loggerActive"
                optSelect(1).Visible = False
            End If
        Case 1:
            If optSelect(index).value = Checked Then
                SetInfo "active", "Main\Setting\MainCoreSetting", "loggerActive"
            Else
                SetInfo "logError", "Main\Setting\MainCoreSetting", "loggerActive"
            End If
        Case 2:
            If optSelect(index).value = Checked Then
                SetInfo "1", "Main\setting\media", "threadRun"
            Else
                SetInfo "0", "Main\setting\media", "threadRun"
            End If
        Case 3:
            If optSelect(index).value = Checked Then
                SetInfo "1", "Main\setting\media", "threadStop"
            Else
                SetInfo "0", "Main\setting\media", "threadStop"
            End If
        Case 4:
            If optSelect(index).value = Checked Then
                SetInfo "1", "Main\setting\media", "threadNewObj"
            Else
                SetInfo "0", "Main\setting\media", "threadNewObj"
            End If
    End Select
End Sub

Private Sub ServerLoaders_DblClick()
    Dim thisIndex As Long, thisState As String
    thisIndex = ServerLoaders.SelectedItem.index
    thisState = ServerLoaders.ListItems(thisIndex).SubItems(2)
    If thisState = "������" Then
        thisLogger.logInfo "editServerList(" & thisIndex & "->����)", 2
        ServerLoaders.ListItems(thisIndex).SubItems(2) = "����"
        setServerState thisIndex, True
    ElseIf thisState = "����" Then
        thisLogger.logInfo "editServerList(" & thisIndex & "->������)", 2
        ServerLoaders.ListItems(thisIndex).SubItems(2) = "������"
        setServerState thisIndex, False
    Else
        thisLogger.logInfo "editServerList(" & thisIndex & "->�����ò���ʧ��)", 2
        MsgBox "�޷������ѿ����ĺ���"
    End If
End Sub
Private Sub CheckIpBase()
On Error GoTo Err:
    If LstIpShow.ListItems.Count < 10 Then
        Dim http As HttpGetter
        Set http = New HttpGetter
        Dim newInfo As String
        newInfo = http.getHtml("https://h.wandouip.com/get/ip-list?pack=362&num=10&xy=1&type=2&lb=\r\n&mr=1&")
        Dim cstrs As CString
        Set cstrs = New CString
        cstrs.Append newInfo
        If InStr(1, newInfo, "������") Or InStr(1, newInfo, "code"":-1") > 0 Then
            MsgBox "����ipʧ��:" & newInfo
            End
        End If
        Debug.Print newInfo
        Dim ipList() As String
        ipList = cstrs.GetAllElement("ip"":""", ",""ex")
        'ipList = Split(newInfo, vbCrLf)
        Dim i As Long
        For i = 1 To UBound(ipList)
            ipList(i) = Replace(ipList(i), """,""port"":", ":")
            If ipList(i) <> "" Then
                LstIpShow.ListItems.Add , , ipList(i)
            End If
        Next
    End If
    Exit Sub
Err:
    SetErr "CheckIpBase()$" & Err.Description
    thisLogger.WriteErrLog "CheckIpBase()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Sub
Private Function GetSingleIp() As String
On Error GoTo Err:
    If LstIpShow.ListItems.Count = 0 Then
        Exit Function
    End If
    
    GetSingleIp = LstIpShow.ListItems(1)
    LstIpShow.ListItems.Remove 1
    Exit Function
Err:
    SetErr "GetSingleIp()$" & Err.Description
    thisLogger.WriteErrLog "GetSingleIp()", Err.Number, Err.Description
    If MsgBox("��������?", vbYesNo) = vbNo Then End
End Function
