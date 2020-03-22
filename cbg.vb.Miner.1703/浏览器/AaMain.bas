Attribute VB_Name = "AaMain"
Option Explicit
Dim NowId As Long, NowOptId As Long ', FrmOpt() As FrmOpt, FrmMod() As FrmShow
Public Type Opt
    Infos As String
    DColor As Long
    UColor As Long
    CmdInfo As String
End Type
Public Sub SetErr(ByVal Errinfo As String, Optional Images As String = "")
Dim i As Long, TempShow As Long
For i = 1 To 7
    TempShow = Val(GetInfo("Main\ErrShowed", CStr(i)))
    If TempShow = 1 Then
        DelInfo "Main\ErrShowed", CStr(i)
        SetInfo Errinfo, "Main", "Err" & i
        Exit Sub
    End If
Next

    DelInfo "Main", "ErrShowed" & 1
    SetInfo Errinfo, "Main", "Err"
    Dim TempOpt(1) As Opt
    TempOpt(1).Infos = "Exit"
    TempOpt(1).DColor = vbGreen
    TempOpt(1).UColor = RGB(150, 255, 150)
    ShowOpt TempOpt, "Alert", Errinfo, Images
End Sub
Public Sub ShowInfos(Infos As String, Optional BColor As Long = vbBlack, Optional FColor As Long = vbGreen, Optional ShowTime As Double = 5)
On Error Resume Next
    'ReDim FrmMod(NowId)
    'Set FrmMod(NowId) = New FrmShow
    NowId = Val(GetInfo("Main\ShowInfo", "NewId")) + 1
    SetInfo CStr(NowId), "main\ShowInfo", "NewId"
    SetInfo CStr(Infos), "main\ShowInfo\" & NowId, "Infos"
    SetInfo CStr(BColor), "main\ShowInfo\" & NowId, "BColor"
    SetInfo CStr(FColor), "main\ShowInfo\" & NowId, "FColor"
    SetInfo CStr(ShowTime), "main\ShowInfo\" & NowId, "ShowTime"
    DelInfo "main\ShowInfo", "MaxWidth"
    Shell App.Path & "\InfoShow.exe", vbNormalFocus
    'Load FrmMod(NowId - 1)
    'FrmMod(NowId - 1).Show
    'FrmMain.SetFocus
End Sub
Public Sub ShowOpt(OptInfos() As Opt, Tittles As String, ContentInfo As String, Optional Images As String = "")
On Error Resume Next
    
    'ReDim FrmOpt(NowOptId)
    'Set FrmOpt(NowOptId) = New FrmOpt
    NowOptId = Val(GetInfo("Main\ShowInfo", "NowOptId")) + 1
    SetInfo CStr(NowOptId), "main\OptInfo", "NowOptId"
    SetInfo Tittles, "main\OptInfo\" & NowOptId, "FrmTittle"
    SetInfo ContentInfo, "main\OptInfo\" & NowOptId, "ContentInfo"
    SetInfo Images, "main\OptInfo\" & NowOptId, "Images"
    Dim i As Long
    For i = 1 To UBound(OptInfos)
        With OptInfos(i)
            SetInfo CStr(.DColor), "main\OptInfo\" & NowOptId & "\" & i, "DColor"
            SetInfo CStr(.UColor), "main\OptInfo\" & NowOptId & "\" & i, "UColor"
            SetInfo CStr(.Infos), "main\OptInfo\" & NowOptId & "\" & i, "Infos"  '
            SetInfo CStr(.CmdInfo), "main\OptInfo\" & NowOptId & "\" & i, "Cmd"  '
        End With
    Next
    SetInfo CStr(UBound(OptInfos)), "main\OptInfo\" & NowOptId, "FrmOptNum"
    'Load FrmMod(NowOptId - 1)
    'FrmOpt(NowOptId - 1).Show 1
    Shell App.Path & "\SelOption.exe", vbNormalFocus
End Sub



