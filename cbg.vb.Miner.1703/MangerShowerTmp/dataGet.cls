VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "dataGet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private thisNowPointer As String, thisNextPointer As String, thisNextPointerLoaded As Boolean
Public Function hasNext() As Boolean
    thisLogger.startFun "hasNext()"
    thisNextPointer = getNextPointer
    thisLogger.logInfo thisNowPointer & "->getNextPointer:" & thisNextPointer
    thisNextPointerLoaded = True
    If thisNextPointer = "" Then
        thisLogger.endFun
        Exit Function
    End If
    hasNext = True
    thisLogger.endFun
End Function
Public Function getNextInfo() As String
    thisLogger.startFun "getNextInfo()"
    thisLogger.logInfo "check thisNextPointerLoaded"
    If Not thisNextPointerLoaded Then
        thisLogger.logInfo "true.getNextPointer(" & getNextPointer & ")"
        getNextInfo = getNextPointer
    Else
        thisNextPointerLoaded = False
        thisLogger.logInfo "false.getNextPointer(" & getNextPointer & ")"
        getNextInfo = thisNextPointer
    End If
    thisNowPointer = getNextInfo
    thisLogger.endFun
End Function
Public Function resetPointer() As Long
    thisNowPointer = "Main"
End Function
Private Function getNextPointer() As String
    getNextPointer = GetInfo("Main\Data\DataList\Core", thisNowPointer)
    
End Function
