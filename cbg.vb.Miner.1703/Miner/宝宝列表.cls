VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "±¦±¦ÁÐ±í"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private loadInitData As New clsFile
Private iniData As String
Private price As Double
Public Property Get priceValue() As Double
    priceValue = price
End Property
Public Property Get list() As Collection
    Set list = mCol
End Property
Public Property Let iniInfo(info As String)
    iniData = info
End Property

Public Sub init(info As String)
    iniInfo = info
    getAllBaby
End Sub
Private Sub getAllBaby()
    price = 0
    Dim tmp() As String, tmpBaby As ±¦±¦
    tmp = Split(iniData, "iType")
    Dim i As Long
    For i = 0 To UBound(tmp) - 1
        Set tmpBaby = New ±¦±¦
        Dim tmpPos As Long
        If InStr(1, tmp(i), "Ç×ÃÜ¶È") > 0 Then
            tmpPos = InStr(1, tmp(i), "cDesc")
            tmp(i) = Mid(tmp(i), tmpPos)
            If tmpBaby.init(tmp(i)) Then
                Dim tmpPrice As Double
                tmpPrice = tmpBaby.getPrice
                If tmpPrice < 0 Then tmpPrice = 0
                price = price + tmpPrice
            End If
        End If
    Next
End Sub
