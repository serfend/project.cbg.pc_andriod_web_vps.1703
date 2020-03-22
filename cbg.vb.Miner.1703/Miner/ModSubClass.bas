Attribute VB_Name = "ModSubClass"

Option Explicit

Public Const GWL_WNDPROC = (-4)
Public Const WM_NCDESTROY = &H82  '销毁

Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Public OldWndProc As Long

'子类化开始
Public Function SubClass(hWnd As Long, ByVal AddRess As Long) As Boolean
    OldWndProc = SetWindowLong(hWnd, GWL_WNDPROC, AddRess)
End Function

'卸载子类化
Public Function UnSubClass(hWnd As Long) As Boolean
    UnSubClass = SetWindowLong(hWnd, GWL_WNDPROC, OldWndProc)
End Function

