VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Title As String
Private Url As String
Private Content As String
Private childPage() As Long
Private childNum As Long
Private Id As String
Public Property Get pageId() As String
    pageId = Id
End Property
Public Property Let pageId(newData As String)
    Id = newData
End Property
Public Property Get pageTitle() As String
    pageTitle = Title
End Property
Public Property Let pageTitle(newData As String)
    Title = newData
End Property
Public Property Get pageUrl() As String
    pageUrl = Url
End Property
Public Property Let pageUrl(newData As String)
    Url = newData
End Property
Public Property Get pageContent() As String
    pageContent = Content
End Property
Public Property Let pageContent(newData As String)
    Content = newData
End Property
Public Property Get pageChildNum() As Long
    pageChildNum = childNum
End Property
Public Property Let pageChildNum(newData As Long)
    childNum = newData
End Property
Public Property Get pageChildPage(Index As Long) As Long
    If Index > childNum Then setNewChildPage Index
    pageChildPage = childPage(Index)
End Property
Public Sub setPageChildPage(Index As Long, newData As String)
    If Index > childNum Then setNewChildPage Index
    childPage(Index) = newData
End Sub
Public Function newChildPage(childIndex As Long) As Long
    childNum = childNum + 1
    ReDim Preserve childPage(childNum)
    childPage(childNum) = childIndex
End Function
Private Sub setNewChildPage(PageNum As Long)
    If childNum < PageNum Then
        ReDim Preserve childPage(PageNum)
    End If
End Sub

