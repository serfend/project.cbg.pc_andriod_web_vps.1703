VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CoreList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Attribute VB_Ext_KEY = "Collection" ,"mainCore"
Attribute VB_Ext_KEY = "Member0" ,"mainCore"
Option Explicit
Private mCol As Collection
Private lastMember As mainCore
Public Function Add(CoreId As String, Interval As Long, Task As String, Optional sKey As String, Optional toActive As Boolean = True, Optional closeInterval As Long = 300000, Optional closeKeyWord As String = "失败") As mainCore
    '创建新对象
    Dim objNewMember As mainCore
    Set objNewMember = New mainCore
    objNewMember.init CoreId, Interval, Task, toActive, closeInterval, closeKeyWord
    
    If lastMember Is Nothing Then
        Set lastMember = New mainCore
        lastMember.CoreId = ""
    End If
    objNewMember.lastKey = lastMember.CoreId
    If Me(lastMember.CoreId) Is Nothing Then
    
    Else
        Me(lastMember.CoreId).nextKey = CoreId
    End If
    
    SetInfo CoreId, "Main\Data\DataList\Core", lastMember.CoreId
    lastMember.reSet objNewMember
    
    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
    End If


    '返回已创建的对象
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function
Public Property Get Item(vntIndexKey As Variant) As mainCore
Attribute Item.VB_UserMemId = 0
On Error GoTo Err:
    If vntIndexKey = "" Then
        Set Item = New mainCore
        Exit Property
    End If
  Set Item = mCol(vntIndexKey)
  Exit Property
Err:
    'SetErr "MainMover()$#255#在:getCoreList.Item(" & vntIndexKey & ")$#" & RGB(200, 200, 200) & "#" & Err.Description
    'If MsgBox("继续运行?", vbYesNo) = vbNo Then End
End Property
Public Property Get Count() As Long
    Count = mCol.Count
End Property
Public Sub Remove(vntIndexKey As Variant)
    Dim thisServerLastServer As mainCore, thisServerNextServer As mainCore, thisServer As mainCore
    Set thisServer = Me(vntIndexKey)
    'thisServerLastServer = Me(thisServer.lastKey)
    'thisServerNextServer = Me(thisServer.nextKey)
    SetInfo thisServer.nextKey, "Main\Data\DataList\Core", thisServer.lastKey
    mCol.Remove thisServer.CoreId
End Sub
Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = mCol.[_NewEnum]
End Property
Private Sub Class_Initialize()
    Set mCol = New Collection
    DelSub "Main\Data\DataList", "Core"
End Sub
Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub

