Attribute VB_Name = "Mover"
Option Explicit
Private Declare Function GetWindowLong Lib "user32.dll" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetLayeredWindowAttributes Lib "user32.dll" (ByVal hWnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Private Declare Function SetWindowLong Lib "user32.dll" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const WM_NCLBUTTONDOWN = &HA1
Private Const HTCAPTION = 2

Private Const LWA_ALPHA = &H2
Private Const LWA_COLORKEY = &H1
Private Const GWL_EXSTYLE = -20
Private Const WS_EX_LAYERED = &H80000

Private Const DefaultSet As Single = -1234
Private Const DefaultInt As Integer = -1
Public Type mColors
    a As Integer
    R As Integer
    G As Integer
    B As Integer
End Type
Public Type Pos
    x As Single
    y As Single
    w As Single
    h As Single
End Type
Public Type Mycube
    Types As Integer
    Pos As Pos
    aPos As Pos
    Bcolors As mColors
    Fcolors As mColors
    Bacolors As mColors
    Facolors As mColors
    Infos As String
    FSize As Long
    Tag As String
    Id As Long
    Stabled As Boolean
    TempColor As Long
    OnMouseIn As Long
    OnMouseDown As Long
End Type
Public Type FrmBar
    BarRect As Mycube
    CloseBar As Mycube
    MinestBar As Mycube
End Type
Private Const HWND_TOPMOST& = -1
' 将窗口置于列表顶部，并位于任何最顶部窗口的前面
Private Const SWP_NOSIZE& = &H1
' 保持窗口大小
Private Const SWP_NOMOVE& = &H2
Public Mg As New DirectGDI
' 保持窗口位置
Public Sub MoveWindow(hWnd As Long)
    ReleaseCapture
    SendMessage hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub
Public Sub SetOntop(hWnd As Long, Optional DeOntop As Integer = 0)
If DeOntop = 1 Then
    SetWindowPos hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
Else
    SetWindowPos hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
End If
End Sub
Public Sub setFRM(Frm As Form, ByVal limpid As Long) ' 设置窗体透明度
On Error Resume Next
     Call SetWindowLong(Frm.hWnd, GWL_EXSTYLE, GetWindowLong(Frm.hWnd, GWL_EXSTYLE) Or WS_EX_LAYERED)
     Call SetLayeredWindowAttributes(Frm.hWnd, 0, limpid, LWA_ALPHA)     'limpid在0--255之间
End Sub
Public Sub SetFrmAlphaColor(FrmHwnd As Long, Optional Colors As Long = 0)
    Dim rtn As Long
    rtn = GetWindowLong(FrmHwnd, GWL_EXSTYLE)
If Colors = -1 Then
    SetLayeredWindowAttributes FrmHwnd, 0, 255, LWA_ALPHA
Else
    SetWindowLong FrmHwnd, GWL_EXSTYLE, rtn Or WS_EX_LAYERED
    SetLayeredWindowAttributes FrmHwnd, Colors, 0, LWA_COLORKEY
End If
End Sub
Public Function IniFrmBar(Posi As Pos, FrmBar As FrmBar, Optional ShowClose As Boolean = False, Optional ShowMinest As Boolean = False) As Long
    With FrmBar
        With .BarRect
            .Pos.w = Posi.w
            .aPos.w = .Pos.w
            .aPos.h = Posi.h * 0.05
            With .Bacolors
                .a = 150
                .R = 100
                .G = 100
                .B = 200
            End With
            .Facolors.a = -1
            .aPos.y = -.aPos.h
        End With
        If ShowClose Then
            With .CloseBar
                .Pos.w = Posi.h * 0.05
                .aPos.w = .Pos.w
                .aPos.h = .Pos.w
                .aPos.x = Posi.w * 0.95
                .Infos = "X"
                .Facolors.a = -1
                With .Bacolors
                    .a = 150
                    .R = 155
                    .G = 0
                    .B = 0
                End With
                .aPos.y = -.aPos.h
            End With
        End If
        If ShowMinest Then
            With .MinestBar
                .aPos.w = Posi.w * 0.05
                .aPos.h = .Pos.w
                .aPos.w = .Pos.w
                .aPos.x = Posi.w * 0.9
                .Infos = "-"
                .Facolors.a = -1
                With .Bacolors
                    .a = 150
                    .R = 200
                    .G = 200
                    .B = 200
                End With
                .aPos.y = -.aPos.h
            End With
        End If
    End With
End Function
Public Sub ShowFrmBar(FrmBar As FrmBar, Optional ShowOut As Boolean = True)
If ShowOut = False Then
    With FrmBar
        .BarRect.aPos.y = -.BarRect.aPos.h
        .CloseBar.aPos.y = -.CloseBar.aPos.h
        .MinestBar.aPos.y = -.MinestBar.aPos.h
    End With
Else
    With FrmBar
        .BarRect.aPos.y = 0
        .CloseBar.aPos.y = 0
        .MinestBar.aPos.y = 0
    End With
End If
End Sub
Public Function OMoving(Obj As Object, Pos As Pos, Optional Scales As Single = 50, Optional Speed As Single = 0.2) As Boolean
Dim Stabled As Boolean
Stabled = True
With Obj
    .Left = GetAnimationPos(.Left, Pos.x, Scales, Speed, Stabled)
    .Top = GetAnimationPos(.Top, Pos.y, Scales, Speed, Stabled)
    .Height = GetAnimationPos(.Height, Pos.h, Scales, Speed, Stabled)
    .Width = GetAnimationPos(.Width, Pos.w, Scales, Speed, Stabled)
End With
OMoving = Stabled
End Function
Public Function SetCubePos(Cube As Mycube, Optional x As Single = DefaultSet, Optional y As Single = DefaultSet, Optional w As Single = DefaultSet, Optional h As Single = DefaultSet) As Long
With Cube
    If x <> DefaultSet Then .Pos.x = x
    If y <> DefaultSet Then .Pos.y = y
    If w <> DefaultSet Then .Pos.w = w
    If h <> DefaultSet Then .Pos.h = h
End With
End Function
Public Function SetCubeApos(Cube As Mycube, Optional x As Single = DefaultSet, Optional y As Single = DefaultSet, Optional w As Single = DefaultSet, Optional h As Single = DefaultSet) As Long
With Cube
    If x <> DefaultSet Then .aPos.x = x
    If y <> DefaultSet Then .aPos.y = y
    If w <> DefaultSet Then .aPos.w = w
    If h <> DefaultSet Then .aPos.h = h
End With
End Function
Public Function SetCubeColor(Cube As Mycube, Index As Integer, Optional a As Integer = DefaultInt, Optional R As Integer = DefaultInt, Optional G As Integer = DefaultInt, Optional B As Integer = DefaultInt)
With Cube
    Select Case Index
        Case 1:
            If a <> DefaultInt Then .Bcolors.a = a
            If R <> DefaultInt Then .Bcolors.R = R
            If G <> DefaultInt Then .Bcolors.G = G
            If B <> DefaultInt Then .Bcolors.B = B
        Case 2:
            If a <> DefaultInt Then .Bacolors.a = a
            If R <> DefaultInt Then .Bacolors.R = R
            If G <> DefaultInt Then .Bacolors.G = G
            If B <> DefaultInt Then .Bacolors.B = B
        Case 3:
            If a <> DefaultInt Then .Fcolors.a = a
            If R <> DefaultInt Then .Fcolors.R = R
            If G <> DefaultInt Then .Fcolors.G = G
            If B <> DefaultInt Then .Fcolors.B = B
        Case 4:
            If a <> DefaultInt Then .Facolors.a = a
            If R <> DefaultInt Then .Facolors.R = R
            If G <> DefaultInt Then .Facolors.G = G
            If B <> DefaultInt Then .Facolors.B = B
    End Select
End With
End Function
Public Function MoveCube(Cube As Mycube, Optional Scales As Single = 50, Optional Speed As Single = 0.2, Optional SviewX As Single, Optional SviewY As Single) As Boolean
    Dim Stabled As Boolean
    Stabled = True
    With Cube
        .Pos.x = GetAnimationPos(.Pos.x, .aPos.x, Scales, Speed, Stabled)
        .Pos.y = GetAnimationPos(.Pos.y, .aPos.y, Scales, Speed, Stabled)
        .Pos.w = GetAnimationPos(.Pos.w, .aPos.w, Scales, Speed, Stabled)
        .Pos.h = GetAnimationPos(.Pos.h, .aPos.h, Scales, Speed, Stabled)
        With .Pos
            Select Case Cube.Types
                Case 0:
                    Mg.FillRect .x + SviewX, .y + SviewY, .w, .h, Mg.ARGB(Cube.Bcolors.a, Cube.Bcolors.R, Cube.Bcolors.G, Cube.Bcolors.B)
                Case 1:
                    Mg.FillRoundRect .x + SviewX, .y + SviewY, .w, .h, Mg.ARGB(Cube.Bcolors.a, Cube.Bcolors.R, Cube.Bcolors.G, Cube.Bcolors.B)
                Case 2:
                    Mg.FillOval .x + SviewX, .y + SviewY, .w, .h, Mg.ARGB(Cube.Bcolors.a, Cube.Bcolors.R, Cube.Bcolors.G, Cube.Bcolors.B)
            End Select
            If Cube.Fcolors.a < 0 Then
                If Cube.FSize <= 0 Then
                    Mg.DwText Cube.Infos, .x + SviewX, .y + SviewY, .w, .h
                Else
                    Mg.DwText Cube.Infos, .x + SviewX, .y + SviewY, .w, .h, , Cube.FSize
                End If
            Else
                If Cube.FSize <= 0 Then
                    Mg.DwText Cube.Infos, .x + SviewX, .y + SviewY, .w, .h, Mg.ARGB(Cube.Fcolors.a, Cube.Fcolors.R, Cube.Fcolors.G, Cube.Fcolors.B)
                Else
                    Mg.DwText Cube.Infos, .x + SviewX, .y + SviewY, .w, .h, Mg.ARGB(Cube.Fcolors.a, Cube.Fcolors.R, Cube.Fcolors.G, Cube.Fcolors.B), Cube.FSize
                End If
            End If
        End With
    End With
    MoveCube = Stabled
End Function
Public Function CcolorEditEx(Cube As Mycube, Optional Speed As Single = 0.2, Optional Scales As Single = 50, Optional SviewX As Single, Optional SviewY As Single)
Dim Stabled As Boolean
Stabled = True
'If MoveCube(Cube, , Speed, SviewX, SviewY) = False Then Exit Function
With Cube
    .Bcolors.a = GetAnimationPos(.Bcolors.a, .Bacolors.a, Scales, Speed, Stabled)
    .Bcolors.R = GetAnimationPos(.Bcolors.R, .Bacolors.R, Scales, Speed, Stabled)
    .Bcolors.G = GetAnimationPos(.Bcolors.G, .Bacolors.G, Scales, Speed, Stabled)
    .Bcolors.B = GetAnimationPos(.Bcolors.B, .Bacolors.B, Scales, Speed, Stabled)
    .Fcolors.a = GetAnimationPos(.Fcolors.a, .Facolors.a, Scales, Speed, Stabled)
    .Fcolors.R = GetAnimationPos(.Fcolors.R, .Facolors.R, Scales, Speed, Stabled)
    .Fcolors.G = GetAnimationPos(.Fcolors.G, .Facolors.G, Scales, Speed, Stabled)
    .Fcolors.B = GetAnimationPos(.Fcolors.B, .Facolors.B, Scales, Speed, Stabled)
End With
MoveCube Cube, , Speed, SviewX, SviewY
End Function
Public Function CcolorEdit(Cube As Mycube, Optional Speed As Single = 0.2, Optional Scales As Single = 50)
Dim Stabled As Boolean
Stabled = True
'If MoveCube(Cube, , Speed) = 0 Then Exit Function
With Cube
    .Bcolors.a = GetAnimationPos(.Bcolors.a, .Bacolors.a, Scales, Speed, Stabled)
    .Bcolors.R = GetAnimationPos(.Bcolors.R, .Bacolors.R, Scales, Speed, Stabled)
    .Bcolors.G = GetAnimationPos(.Bcolors.G, .Bacolors.G, Scales, Speed, Stabled)
    .Bcolors.B = GetAnimationPos(.Bcolors.B, .Bacolors.B, Scales, Speed, Stabled)
    .Fcolors.a = GetAnimationPos(.Fcolors.a, .Facolors.a, Scales, Speed, Stabled)
    .Fcolors.R = GetAnimationPos(.Fcolors.R, .Facolors.R, Scales, Speed, Stabled)
    .Fcolors.G = GetAnimationPos(.Fcolors.G, .Facolors.G, Scales, Speed, Stabled)
    .Fcolors.B = GetAnimationPos(.Fcolors.B, .Facolors.B, Scales, Speed, Stabled)
End With
MoveCube Cube, , Speed
End Function
