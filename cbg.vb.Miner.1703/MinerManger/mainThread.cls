VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "mainThread"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Private Declare Sub Sleep Lib "Kernel32" (ByVal dwMilliseconds As Long) 'ÉùÃ÷
Private Running As Boolean, HandleServerId As String, threadInterval As Long
Private mhpt As HttpGetter, nowPage As clsPage
Private Type MainInfo
    BuyUrl As String
    Names As String
    Price As String
    levInfo As String '"iGrade":159,
    Talent As String
    Achievement As String ' iAchievement":4358,
    companyAchivement As String '"iChengjiu":553,
End Type
Private thisThreadInfo As MainInfo
Public Property Get IsRun() As Boolean
    IsRun = Running
End Property
Public Function sRun() As Long
    Running = True
    While (Running)
        getServerInfo
        hdlServerInfo
        resetConfi
        Debug.Print threadInterval
        Me.pause
    Wend
End Function
Public Function sStop() As Long
    Running = False
End Function
Private Sub hdlServerInfo()
    With thisThreadInfo
        If .Names = "" Then Exit Sub
        Stop
    End With
End Sub
Private Sub getServerInfo()
    Dim dataPage As clsPage, clsUrl As String
    clsUrl = getMainUrl(HandleServerId)
    If clsUrl = "none" Then
        setStatus "404"
        Exit Sub
    End If
    dataPage = newPage(clsUrl, True)
    '<a class="photo" style="text-decoration:none;" href="
    With dataPage
        If .pageTitle = "" Then 'Ê§°Ü
            
        Else
            Stop
        End If
    End With
End Sub
Public Function setInterval(ByVal DelayTimes As Long) As Long
    If DelayTimes < 0 Then DelayTimes = 0
    threadInterval = DelayTimes
End Function
Public Function pause()
    Sleep threadInterval
    DoEvents
End Function

Private Sub Class_Initialize()
    Set mhpt = New HttpGetter
    Set nowPage = New clsPage
End Sub
