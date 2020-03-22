VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "pageMainInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Const DataSplitStr As String = "##"
Private Const DataListPath As String = "Main\Data\DataList\Server\@"
Private Const DataListPathCore As String = "Main\Data\DataList\Core\@"
Private thisDataListPath As String, thisDataListCorePath As String

Public BuyUrl As String, names As String, price As String, assumePrice As String, levInfo As String                '
Public Talent As String, Achievement As String, companyAchivement As String, Id As String
Public familyScorces As String
Public referBuyerId As String
Public babyList As New ±¦±¦ÁÐ±í, caclPrice As Double
Private thisServerId As String
Private refreshDate As Date, isThisFirstSubmit As Boolean
Private thisMainInfo As String, mainInfoStabled As Boolean
Public Function equal(compInfo As pageMainInfo) As Boolean
    If Me.BuyUrl = compInfo.BuyUrl Then
        equal = True
        Exit Function
    End If
End Function
Private Function Exitst() As Boolean
    If GetInfo(DataListPath & thisServerId, Id) <> "" Then
        Exitst = True
    Else
        SetInfo "exitst", DataListPath & thisServerId, Id
    End If
End Function
Public Function submit() As Long
    If Exitst Then Exit Function
    caclPrice = babyList.priceValue
    newInfo getMainInfo
End Function
Private Function getInfoNum() As Long
    Dim tmp As String
    tmp = GetInfo(DataListPath & thisServerId, "pageNum")
    getInfoNum = Val(tmp)
End Function
Private Sub newInfo(Info As String)
    If isThisFirstSubmit Then
        isThisFirstSubmit = False
        Exit Sub
    End If

    thisLogger.logInfo getMeNames & "submit(" & Info & ")"
    Dim nowIndex As Long
    refreshDate = Now
    SetInfo Info, thisDataListPath, "info"
    SetInfo getOrdersnl(Me.BuyUrl), thisDataListPath, "ordersn"
    SetInfo getOrdersnl(Me.assumePrice), thisDataListPath, "assumePrice"
    SetInfo getServerName(Me.BuyUrl & " "), thisDataListPath, "serverName"
    SetInfo CStr(refreshDate), thisDataListPath, "updateDate"
    SetInfo thisServerId, thisDataListCorePath, "hasNew"
    SetInfo "new", thisDataListPath, "hasNew"
    
    'ClientFrm.buildSndInfo thisDataListPath, "info", info
    'ClientFrm.buildSndInfo thisDataListPath, "updateDate", CStr(refreshDate)
    'ClientFrm.buildSndInfo thisDataListCorePath, "hasNew", thisServerId
    'ClientFrm.buildSndInfo thisDataListPath, "new", "hasNew"
    thisLogger.logInfo getMeNames & "submitSaveSuccess", 5
    'ClientFrm.buildMainShowInfo info
    'thisLogger.logInfo getMeNames & "submitBuildSndInfoSuccess", 5
    'ClientFrm.sndInfo
    'thisLogger.logInfo getMeNames & "submitSndInfoSuccess", 5
End Sub
Private Function getMainInfo() As String
    resetMainInfo
    getMainInfo = thisMainInfo
End Function
Private Sub resetMainInfo()
        thisMainInfo = Me.names & DataSplitStr & Me.price & "/" & Me.caclPrice & DataSplitStr & Me.levInfo & DataSplitStr _
            & Me.Talent & DataSplitStr & Me.Achievement & DataSplitStr & Me.companyAchivement & DataSplitStr & Me.familyScorces & DataSplitStr        '& Me.BuyUrl
End Sub
Private Function getServerName(Url As String)
    getServerName = mht.getElement(Url, "server_name=", " ")
End Function
Private Function getOrdersnl(Url As String)
    getOrdersnl = mht.getElement(Url, "ordersn=", "&")
End Function
Public Sub init(serverId As String)
    thisServerId = serverId
    thisDataListPath = DataListPath & thisServerId
    thisDataListCorePath = DataListPathCore & getThisThreadId
End Sub
Private Sub Class_Initialize()
    'isThisFirstSubmit = True
End Sub
