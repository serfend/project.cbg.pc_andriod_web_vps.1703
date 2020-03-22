Attribute VB_Name = "MainApis"
Option Explicit
'Other Apis
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function CreateDIBSection Lib "gdi32" (ByVal hDc As Long, lpBitsInfo As BITMAPINFO, ByVal wUsage As Long, lpBits As Long, ByVal handle As Long, ByVal dw As Long) As Long
Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDc As Long) As Long
Public Declare Function DeleteDC Lib "gdi32" (ByVal hDc As Long) As Long
Public Declare Function SelectObject Lib "gdi32" (ByVal hDc As Long, ByVal hObject As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal MSG As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function DefWindowProc Lib "user32" Alias "DefWindowProcA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function GetProp Lib "user32" Alias "GetPropA" (ByVal hwnd As Long, ByVal lpString As String) As Long
Public Declare Function SetProp Lib "user32" Alias "SetPropA" (ByVal hwnd As Long, ByVal lpString As String, ByVal hData As Long) As Long
Public Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function GetWindowDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hDc As Long) As Long
'Public Declare Function BeginPaint Lib "user32" (ByVal hwnd As Long, lpPaint As PAINTSTRUCT) As Long
'Public Declare Function EndPaint Lib "user32" (ByVal hwnd As Long, lpPaint As PAINTSTRUCT) As Long
Public Declare Function TrackMouseEvent Lib "user32" (ByRef lpEventTrack As TrackMouseEvent) As Long
Public Declare Function VarPtrArray Lib "msvbvm60.dll" Alias "VarPtr" (ptr() As Any) As Long
Public Declare Sub ZeroMemory Lib "kernel32.dll" Alias "RtlZeroMemory" (ByVal Destination As Long, ByVal Length As Long)
'Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDest As Any, pSrc As Any, ByVal ByteLen As Long)
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Public Declare Function HeapAlloc Lib "kernel32" (ByVal hHeap As Long, ByVal dwFlags As Long, ByVal dwBytes As Long) As Long
Public Declare Function HeapFree Lib "kernel32" (ByVal hHeap As Long, ByVal dwFlags As Long, lpMem As Any) As Long
Public Declare Function GetProcessHeap Lib "kernel32" () As Long
Public Declare Function SetTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
Public Declare Function KillTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long) As Long
Public Declare Function ClientToScreen Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function RegisterClass Lib "user32" Alias "RegisterClassA" (Class As WNDCLASS) As Long
Public Declare Function RegisterClassEx Lib "user32" Alias "RegisterClassExA" (pcWndClassEx As WNDCLASSEX) As Integer
Public Declare Function UnregisterClass Lib "user32" Alias "UnregisterClassA" (ByVal lpClassName As String, ByVal hInstance As Long) As Long
Public Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Public Declare Sub PostQuitMessage Lib "user32" (ByVal nExitCode As Long)
Public Declare Function TranslateMessage Lib "user32" (lpMsg As tagMSG) As Long
Public Declare Function DispatchMessage Lib "user32" Alias "DispatchMessageA" (lpMsg As tagMSG) As Long
Public Declare Function GetMessage Lib "user32" Alias "GetMessageA" (lpMsg As tagMSG, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long) As Long
Public Declare Function LoadCursor Lib "user32" Alias "LoadCursorA" (ByVal hInstance As Long, ByVal lpCursorName As String) As Long
Public Declare Function GetClassInfoEx Lib "user32.dll" Alias "GetClassInfoExA" (ByVal hInstance As Long, ByVal lpcstr As String, ByRef lpwndclassexa As WNDCLASSEX) As Long
Public Declare Function GetModuleHandle Lib "kernel32" Alias "GetModuleHandleA" (ByVal lpModuleName As String) As Long
Public Declare Function LoadIcon Lib "user32" Alias "LoadIconA" (ByVal hInstance As Long, ByVal lpIconName As String) As Long
Public Declare Function SetLayeredWindowAttributes Lib "user32.dll" (ByVal hwnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Public Declare Function GetStockObject Lib "gdi32" (ByVal nIndex As Long) As Long
Public Declare Function IsWindowEnabled Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function IsWindowVisible Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function IsIconic Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function IsZoomed Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Enum_CmdShow) As Long
Public Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Declare Function GetWindowTextLength Lib "user32" Alias "GetWindowTextLengthA" (ByVal hwnd As Long) As Long
Public Declare Function EnableWindow Lib "user32" (ByVal hwnd As Long, ByVal fEnable As Long) As Long
Public Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As rect) As Long
Public Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Declare Function UpdateLayeredWindow Lib "user32.dll" (ByVal hwnd As Long, ByVal hdcDst As Long, ByRef pptDst As Any, ByRef pSize As SIZEAPI, ByVal hdcSrc As Long, ByRef pptSrc As POINTAPI, ByVal crKey As Long, ByRef pblend As BLENDFUNCTION, ByVal dwFlags As Long) As Long
Public Declare Function GetLastError Lib "kernel32" () As Long
Public Declare Function SetCapture Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ReleaseCapture Lib "user32" () As Long
Public Declare Function GetTextExtentPoint Lib "gdi32" Alias "GetTextExtentPointA" (ByVal hDc As Long, ByVal lpszString As String, ByVal cbString As Long, lpSize As SIZEAPI) As Long
Public Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer


Public Const VK_LBUTTON = &H1
Public Const VK_RBUTTON = &H2

Public Const GWL_EXSTYLE = (-20)
Public Const GWL_STYLE = (-16)
Public Const GWL_WNDPROC = (-4&)
Public Const HWND_BOTTOM = 1
Public Const HWND_BROADCAST = &HFFFF&
Public Const HWND_DESKTOP = 0
Public Const HWND_MESSAGE = (-3)
Public Const HWND_NOTOPMOST = -2
Public Const HWND_TOP = 0
Public Const HWND_TOPMOST = -1
Public Const SWP_ASYNCWINDOWPOS = &H4000
Public Const SWP_DEFERERASE = &H2000
Public Const SWP_FRAMECHANGED = &H20
Public Const SWP_HIDEWINDOW = &H80
Public Const SWP_NOACTIVATE = &H10
Public Const SWP_NOCOPYBITS = &H100
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOOWNERZORDER = &H200
Public Const SWP_NOREDRAW = &H8
Public Const SWP_NOREPOSITION = SWP_NOOWNERZORDER
Public Const SWP_DRAWFRAME = SWP_FRAMECHANGED
Public Const SWP_NOSENDCHANGING = &H400
Public Const SWP_NOSIZE = &H1
Public Const SWP_NOZORDER = &H4
Public Const SWP_SHOWWINDOW = &H40

Public Const NULL_BRUSH = 5
Public Const BLACK_BRUSH = 4

Public Const CS_HREDRAW = &H2
Public Const CS_VREDRAW = &H1
Public Const CS_OWNDC = &H20
Public Const IDI_APPLICATION = 32512&
Public Const IDI_HAND = 32513&
Public Const IDI_ASTERISK = 32516&
Public Const IDI_INFORMATION = IDI_ASTERISK
Public Const IDI_PROBLEM_OVL = 500
Public Const IDI_QUESTION = 32514&
Public Const IDI_FORCED_OVL = 502
Public Const IDI_EXCLAMATION = 32515&
Public Const IDI_ERROR = IDI_HAND
Public Const IDI_DISABLED_OVL = 501
Public Const IDI_CONFLICT = 161
Public Const IDI_CLASSICON_OVERLAYLAST = 502
Public Const IDI_CLASSICON_OVERLAYFIRST = 500
Public Const IDC_ARROW = 32512&
Public Const IDC_APPSTARTING = 32650&
Public Const IDC_CROSS = 32515&
Public Const IDC_HAND = (32649)
Public Const IDC_HELP = (32651)
Public Const IDC_IBEAM = 32513&
Public Const IDC_ICON = 32641&
Public Const IDC_NO = 32648&
Public Const IDC_SIZE = 32640&
Public Const IDC_WAIT = 32514&
Public Const LWA_COLORKEY = &H1
Public Const LWA_ALPHA = &H2
Public Const WS_EX_LAYERED = &H80000

Public Const WM_CREATE = &H1
Public Const WM_CLOSE = &H10
Public Const WM_PAINT = &HF
Public Const WM_NCPAINT = &H85
Public Const WM_ERASEBKGND = &H14
Public Const WM_SIZE = &H5
Public Const WM_MOUSEMOVE = &H200
Public Const WM_MOUSELEAVE = &H2A3
Public Const WM_MOUSEWHEEL = &H20A
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_RBUTTONDBLCLK = &H206
Public Const WM_RBUTTONDOWN = &H204
Public Const WM_RBUTTONUP = &H205
Public Const WM_NCLBUTTONDOWN = &HA1
Public Const WM_NCRBUTTONDOWN = &HA4
Public Const WM_NCDESTROY = &H82
Public Const WM_MOUSEACTIVATE = &H21
Public Const WM_ACTIVATE = &H6
Public Const MA_ACTIVATE = 1
Public Const MA_ACTIVATEANDEAT = 2
Public Const MA_NOACTIVATE = 3
Public Const MA_NOACTIVATEANDEAT = 4

Public Const WM_WINDOWPOSCHANGING = &H46
Public Const WM_WINDOWPOSCHANGED = &H47
Public Const WM_DESTROY = &H2
Public Const MK_LBUTTON = &H1
Public Const MK_RBUTTON = &H2
Public Const MK_MBUTTON = &H10
Public Const MK_SHIFT = &H4
Public Const MK_CONTROL = &H8
Public Const MK_ALT = (&H20)
Public Const TME_CANCEL = &H80000000
Public Const TME_HOVER = &H1&
Public Const TME_LEAVE = &H2&
Public Const TME_NONCLIENT = &H10&
Public Const TME_QUERY = &H40000000
Public Const HTCAPTION = 2
Public Const SM_CXFRAME = 32
Public Const SM_CYFRAME = 33
Public Const WS_THICKFRAME = &H40000
Public Const WS_POPUP = &H80000000
Public Const WS_MAXIMIZE = &H1000000
Public Const WS_MAXIMIZEBOX = &H10000
Public Const WS_MINIMIZE = &H20000000
Public Const WS_MINIMIZEBOX = &H20000
Public Const WS_OVERLAPPED = &H0&
Public Const WS_SIZEBOX = WS_THICKFRAME
Public Const WS_SYSMENU = &H80000
Public Const WS_TABSTOP = &H10000
Public Const WS_TILED = WS_OVERLAPPED
Public Const WS_VISIBLE = &H10000000
Public Const WS_VSCROLL = &H200000
Public Const WS_CLIPSIBLINGS = &H4000000
Public Const WS_DISABLED = &H8000000
Public Const WS_DLGFRAME = &H400000
Public Const WS_CLIPCHILDREN = &H2000000
Public Const WS_CHILD = &H40000000
Public Const WS_CHILDWINDOW = (WS_CHILD)
Public Const WS_CAPTION = &HC00000
Public Const WS_BORDER = &H800000
Public Const WS_ACTIVECAPTION = &H1
Public Const WS_POPUPWINDOW = (WS_POPUP Or WS_BORDER Or WS_SYSMENU)
Public Const WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED Or WS_CAPTION Or WS_SYSMENU Or WS_THICKFRAME Or WS_MINIMIZEBOX Or WS_MAXIMIZEBOX)
Public Const WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW
Public Const WS_EX_TRANSPARENT = &H20&
Public Const WS_EX_TOOLWINDOW = &H80&
Public Const WS_EX_TOPMOST = &H8&
Public Const WS_EX_STATICEDGE = &H20000
Public Const WS_EX_RTLREADING = &H2000&
Public Const WS_EX_RIGHTSCROLLBAR = &H0&
Public Const WS_EX_RIGHT = &H1000&
Public Const WS_EX_NOPARENTNOTIFY = &H4&
Public Const WS_EX_NOINHERITLAYOUT = &H100000
Public Const WS_EX_NOACTIVATE = &H8000000
Public Const WS_EX_MDICHILD = &H40&
Public Const WS_EX_LEFT = &H0&
Public Const WS_EX_LEFTSCROLLBAR = &H4000&
Public Const WS_EX_LTRREADING = &H0&
Public Const WS_EX_APPWINDOW = &H40000
Public Const WS_EX_ACCEPTFILES = &H10&
Public Const WS_EX_CLIENTEDGE = &H200&
Public Const WS_EX_CONTEXTHELP = &H400&
Public Const WS_EX_CONTROLPARENT = &H10000
Public Const WS_EX_DLGMODALFRAME = &H1&
Public Const WS_EX_LAYOUTRTL = &H400000
Public Const WS_EX_WINDOWEDGE = &H100&
Public Const WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE Or WS_EX_CLIENTEDGE)
Public Const WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE Or WS_EX_TOOLWINDOW Or WS_EX_TOPMOST)


Public Const AC_SRC_OVER As Long = &H0&
Public Const ULW_ALPHA As Long = &H2&
Public Const AC_SRC_ALPHA = &H1


Public Enum Enum_CmdShow
    SW_AUTOPROF_LOAD_MASK = &H1
    SW_AUTOPROF_SAVE_MASK = &H2
    SW_ERASE = &H4
    SW_FORCEMINIMIZE = 11
    SW_HIDE = 0
    SW_INVALIDATE = &H2
    SW_MAX = 10
    SW_MAXIMIZE = 3
    SW_MINIMIZE = 6
    SW_NORMAL = 1
    SW_OTHERUNZOOM = 4
    SW_OTHERZOOM = 2
    SW_PARENTCLOSING = 1
    SW_PARENTOPENING = 3
    SW_RESTORE = 9
    SW_SCROLLCHILDREN = &H1
    SW_SHOW = 5
    SW_SHOWDEFAULT = 10
    SW_SHOWMAXIMIZED = 3
    SW_SHOWMINIMIZED = 2
    SW_SHOWMINNOACTIVE = 7
    SW_SHOWNA = 8
    SW_SHOWNOACTIVATE = 4
    SW_SHOWNORMAL = 1
    SW_SMOOTHSCROLL = &H10
End Enum

Public Enum Enum_ActiveStatus
    WA_INACTIVE = 0
    WA_ACTIVE = 1
    WA_CLICKACTIVE = 2
End Enum

Public Const BI_RGB = 0
Public Const DIB_RGB_COLORS = 0


Public Const HEAP_ZERO_MEMORY = &H8

Public Type WNDCLASS
    Style As Long
    lpfnWndProc As Long
    cbClsExtra As Long
    cbWndExtra2 As Long
    hInstance As Long
    hicon As Long
    hCursor As Long
    hbrBackground As Long
    lpszMenuName As String
    lpszClassName As String
End Type

Type WNDCLASSEX
    cbSize As Long
    Style As Long
    lpfnWndProc As Long
    cbClsExtra As Long
    cbWndExtra As Long
    hInstance As Long
    hicon As Long
    hCursor As Long
    hbrBackground As Long
    lpszMenuName As String
    lpszClassName As String
    hIconSm As Long
End Type

Public Type TrackMouseEvent
    cbSize As Long
    dwFlags As Long
    hwndTrack As Long
    dwHoverTime As Long
End Type

Public Type POINTAPI
    x As Long
    y As Long
End Type

Public Type rect
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Public Type SIZEAPI
   cx As Long
   cy As Long
End Type

Public Type BLENDFUNCTION
   BlendOp As Byte
   BlendFlags As Byte
   SourceConstantAlpha As Byte
   AlphaFormat As Byte
End Type

Public Type tagMSG
    hwnd As Long
    message As Long
    wParam As Long
    lParam As Long
    time As Long
    pt As POINTAPI
End Type

Public Type WINDOWPOS
    hwnd As Long
    hWndInsertAfter As Long
    x As Long
    y As Long
    cx As Long
    cy As Long
    flags As Long
End Type

Public Type SAFEARRAYBOUND
    cElements As Long
    lLbound As Long
End Type

Public Type SAFEARRAY2D
    cDims As Integer
    fFeatures As Integer
    cbElements As Long
    cLocks As Long
    pvData As Long
    bounds(0 To 1) As SAFEARRAYBOUND
End Type



