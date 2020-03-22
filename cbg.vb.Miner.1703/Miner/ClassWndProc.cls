VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassWndProc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, Optional ByVal Length As Long = 4)
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function VirtualProtect Lib "kernel32" (lpAddress As Any, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long
Private LinkProc(10)  As Long

Public Event WndProc(ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long)

Private Sub WindowProc(Result As Long, ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
    RaiseEvent WndProc(hWnd, wMsg, wParam, lParam)
    Result = CallWindowProc(OldWndProc, hWnd, wMsg, wParam, lParam)
End Sub

'封装为公共
Public Function GetFunctionAddress() As Long
    GetFunctionAddress = GetWndProcAddress(2)
End Function

Private Function GetWndProcAddress(ByVal SinceCount As Long) As Long
    '   地址指针 ＝ GetWndProcAddress( 取第 N 个公共函数（属性）  =或= 所有公共函数个数 + 第 N 个私有函数的函数地址）
    Dim mePtr As Long
    Dim jmpAddress As Long
    mePtr = ObjPtr(Me)
    CopyMemory jmpAddress, ByVal mePtr, 4
    CopyMemory jmpAddress, ByVal jmpAddress + (SinceCount - 1) * 4 + &H1C, 4
    
    LinkProc(0) = &H83EC8B55
    LinkProc(1) = &HFC8B14EC
    LinkProc(2) = &H56FC758D
    LinkProc(3) = &H3308758D
    LinkProc(4) = &HFC04B1C9
    LinkProc(5) = &HFF68A5F3
    LinkProc(6) = &HB8FFFFFF
    LinkProc(7) = &HFFFFFFFF
    LinkProc(8) = &H48BD0FF
    LinkProc(9) = &H10C2C924
    
    CopyMemory ByVal VarPtr(LinkProc(5)) + 3, mePtr, 4
    CopyMemory ByVal VarPtr(LinkProc(7)), jmpAddress, 4
    GetWndProcAddress = VarPtr(LinkProc(0))
    VirtualProtect ByVal VarPtr(LinkProc(0)), 44, &H40, mePtr
End Function

'**** 此标志前只许添加声明、自定义类型及变量声明 ****
