VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ServerHander"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ServerList"
Attribute VB_Ext_KEY = "Member0" ,"mainThread"
Attribute VB_Ext_KEY = "Member1" ,"ServerList"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Private mCol As Collection
Public Function Add(Key As String, Optional sKey As String) As ServerList
    Dim objNewMember As ServerList
    Set objNewMember = New ServerList
    objNewMember.Key = Key
    If Len(sKey) > 0 Then
        mCol.Add objNewMember, sKey
    End If
    Set Add = objNewMember
    Set objNewMember = Nothing
End Function

Public Function RemoveAll() As Long
    Set mCol = Nothing
    Set mCol = New Collection
End Function
Public Property Get Item(vntIndexKey As Variant) As String
Attribute Item.VB_UserMemId = 0
    On Error Resume Next
    Dim s As ServerList
    Set s = mCol(vntIndexKey)
    If s Is Nothing Then
        Item = ""
    Else
        Item = s.Key
    End If
End Property
Private Function listServer(vntIndexKey As Variant) As ServerList
    listServer = mCol(vntIndexKey)
End Function
Public Property Get Count() As Long
    Count = mCol.Count
End Property
Public Sub Remove(vntIndexKey As Variant)
    mCol.Remove vntIndexKey
End Sub
Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = mCol.[_NewEnum]
End Property
Private Sub Class_Initialize()
    Set mCol = New Collection
End Sub
Private Sub Class_Terminate()
    '类终止后破坏集合
    Set mCol = Nothing
End Sub

