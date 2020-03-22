Attribute VB_Name = "Mover"
Option Explicit
Private Declare Function GetWindowLong Lib "user32.dll" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetLayeredWindowAttributes Lib "user32.dll" (ByVal hwnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Private Declare Function SetWindowLong Lib "user32.dll" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const WM_NCLBUTTONDOWN = &HA1
Private Const HTCAPTION = 2

Private Const LWA_ALPHA = &H2
Private Const LWA_COLORKEY = &H1
Private Const GWL_ExsTyle = -20
Private Const WS_EX_LAYERED = &H80000

Private Const HWND_TopMost& = -1
' 将窗口置于列表顶部，并位于任何最顶部窗口的前面
Private Const SWP_NoSize& = &H1
' 保持窗口大小
Private Const SWP_NoMove& = &H2
' 保持窗口位置
Public Sub MoveWindow(hwnd As Long)
    ReleaseCapture
    SendMessage hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub
Public Sub SetOntop(hwnd As Long, Optional DeOntop As Integer = 0)
If DeOntop = 1 Then
    SetWindowPos hwnd, 0, 0, 0, 0, 0, SWP_NoMove Or SWP_NoSize
Else
    SetWindowPos hwnd, HWND_TopMost, 0, 0, 0, 0, SWP_NoMove Or SWP_NoSize
End If
End Sub
Public Sub setFRM(Frm As Form, ByVal limpid As Long) ' 设置窗体透明度
On Error Resume Next
     Call SetWindowLong(Frm.hwnd, GWL_ExsTyle, GetWindowLong(Frm.hwnd, GWL_ExsTyle) Or WS_EX_LAYERED)
     Call SetLayeredWindowAttributes(Frm.hwnd, 0, limpid, LWA_ALPHA)     'limpid在0--255之间
End Sub
Public Sub SetFrmAlphaColor(FrmHwnd As Long, Optional Colors As Long = 0)
    Dim rtn As Long
    rtn = GetWindowLong(FrmHwnd, GWL_ExsTyle)
If Colors = -1 Then
    SetLayeredWindowAttributes FrmHwnd, 0, 255, LWA_ALPHA
Else
    SetWindowLong FrmHwnd, GWL_ExsTyle, rtn Or WS_EX_LAYERED
    SetLayeredWindowAttributes FrmHwnd, Colors, 0, LWA_COLORKEY
End If
End Sub
