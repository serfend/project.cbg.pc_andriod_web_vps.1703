Attribute VB_Name = "modMsgBoxEx"
'欢迎你下载使用本代码，本份代码由程序太平洋提供下载学习之用
'声明:
'1.本站所有代码的版权归原作者所有，如果你使用了在本站下载的源代码
'  引起的一切纠纷(后果)与本站无关,请您尊重原作者的劳动成果！
'2.若本站在代码上有侵权之处请您与站长联系，站长会及时更正。
'网站：http://www.daima.com.cn
'程序太平洋：http://www.5ivb.net
'Email:dapha@etang.com
'CopyRight 2001-2005 By WangFeng
'整理时间：2005-3-17 23:36:36
Option Explicit

'MsgBoxEx for VB
'Variable position custom MsgBox by Ray Mercer
'Copyright (C) 1999 by Ray Mercer - All rights reserved
'Based on a sample I posted to news://msnews.microsoft.com/microsoft.public.vb.general.discussion
'Based on an earlier post by Didier Lefebvre <didier.lefebvre@free.fr> in the same newsgroup
'Latest version available at www.shrinkwrapvb.com
'
'You are free to use this code in your own projects and modify it in any way you see fit
'however you may not redistribute this archive sample without the express written consent
'from the author - Ray Mercer <raymer@shrinkwrapvb.com>
'
'*******************
'HOW TO USE
'*******************
'Just pop this module in your VB5 or 6 project.  Then you can call MsgBoxEx instead of MsgBox
'MsgBoxEx will return the same vbMsgBoxResults as MsgBox, but adds the frm, Left, and Top parameters.
'
' Useage sample:
'
'Dim ret As VbMsgBoxResult
'ret = MsgBoxEx(Me, "This is a test", vbOKCancel, "Cool!", 10, 10)
'If ret = vbOK Then
'    MsgBox "User pressed OK!"
'End If
'
' *Note if you leave out the Left and Top parameters the MsgBox will center itself over the Form
'
'e.g.;
'Call MsgBoxEx(Me, "This is a test")
'
'This will center the msgBox and use the default (vbOKonly) button style and default (app.title) title text
'
'Enjoy!
'Win32 API decs
'Hook functions
Private Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal idHook As Long, ByVal lpfn As Long, ByVal hmod As Long, ByVal dwThreadId As Long) As Long
Private Declare Function CallNextHookEx Lib "user32" (ByVal hHook As Long, ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function UnhookWindowsHookEx Lib "user32" (ByVal hHook As Long) As Long
Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Private Declare Function GetCurrentThreadId Lib "kernel32" () As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Private Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal ParenthWnd As Long, ByVal ChildhWnd As Long, ByVal ClassName As String, ByVal Caption As String) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long

'Constants
Private Const WH_CBT As Long = 5
Private Const HCBT_ACTIVATE As Long = 5
Private Const HWND_TOP As Long = 0
Private Const SWP_NOSIZE As Long = &H1
Private Const SWP_NOZORDER As Long = &H4
Private Const SWP_NOACTIVATE As Long = &H10
Private Const STM_SETICON As Long = &H170

'APP-SPECIFIC
Private Const SWVB_DEFAULT As Long = &HFFFFFFFF       '-1 is reserved for centering
Private Const SWVB_CAPTION_DEFAULT As String = "SWVB_DEFAULT_TO_APP_TITLE"

'Types
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

'module-level member variables
Private m_Hook As Long
Private m_Left As Long
Private m_Top As Long
Private m_hIcon As Long

Public Function MsgBoxEx(ByVal Prompt As String, Optional ByVal Buttons As VbMsgBoxStyle = vbOKOnly, Optional ByVal Title As String = SWVB_CAPTION_DEFAULT, Optional ByVal Left As Long = SWVB_DEFAULT, Optional ByVal Top As Long = SWVB_DEFAULT, Optional ByVal Icon As Long = 0&) As VbMsgBoxResult
    Dim hInst As Long
    Dim threadID As Long

    hInst = App.hInstance
    threadID = GetCurrentThreadId()
    'First "subclass" the MsgBox function
    m_Hook = SetWindowsHookEx(WH_CBT, AddressOf MsgBoxHook, hInst, threadID)
    'Save the new arguments as member variables to be used from the MsgBoxHook proc
    m_Left = Left
    m_Top = Top
    m_hIcon = Icon

    'default the msgBox caption to app.title
    If Title = SWVB_CAPTION_DEFAULT Then
        Title = App.Title
    End If

    'if user wants custom icon make sure dialog has an icon to replace
    If m_hIcon <> 0& Then
        Buttons = Buttons Or vbInformation
    End If

    'show the MsgBox and let hook proc take care of the rest...
    MsgBoxEx = MsgBox(Prompt, Buttons, Title)
End Function

Private Function MsgBoxHook(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Dim Height As Long
    Dim Width As Long
    Dim nSize As Long
    Dim wndRect As RECT
    Dim sBuffer As String
    Dim fWidth As Long
    Dim fHeight As Long
    Dim x As Long
    Dim y As Long
    Dim hIconWnd As Long

    'Call next hook in the chain and return the value
    '(this is the polite way to allow other hhoks to function too)
    MsgBoxHook = CallNextHookEx(m_Hook, nCode, wParam, lParam)

    ' hook only the activate msg
    If nCode = HCBT_ACTIVATE Then
        'handle only standard MsgBox class windows
        sBuffer = Space$(32)                               'this is the most efficient method to allocate strings in VB
        'according to Brad Martinez's results with tools from NuMega
        nSize = GetClassName(wParam, sBuffer, 32)          'GetClassName will truncate the class name if it doesn't fit in the buffer

        'we only care about the first 6 chars anyway
        If Left$(sBuffer, nSize) <> "#32770" Then

            Exit Function                                  'not a standard msgBox

            'we can just quit because we already called CallNextHookEx
        End If

        'store MsgBox window size in case we need it
        Call GetWindowRect(wParam, wndRect)

        'handle divide by zero errors (should never happen)
        On Error GoTo errorTrap

        Height = (wndRect.Bottom - wndRect.Top) / 2
        Width = (wndRect.Right - wndRect.Left) / 2
        'store parent window size
        Call GetWindowRect(GetParent(wParam), wndRect)

        'handle divide by zero errors (should never happen)
        On Error GoTo errorTrap

        fHeight = wndRect.Top + (wndRect.Bottom - wndRect.Top) / 2
        fWidth = wndRect.Left + (wndRect.Right - wndRect.Left) / 2

        'By default center MsgBox on the form
        'if user passed in specific values then use those instead
        If m_Left = SWVB_DEFAULT Then                      'default
            x = fWidth - Width

            If x < 0 Then x = 0
            If x > Screen.Width / Screen.TwipsPerPixelX - Width * 2 Then x = Screen.Width / Screen.TwipsPerPixelX - Width * 2
        Else
            x = m_Left
        End If

        If m_Top = SWVB_DEFAULT Then                       'default
            y = fHeight - Height

            If y < 0 Then y = 0
            If y > Screen.Height / Screen.TwipsPerPixelY - Height * 2 Then y = Screen.Height / Screen.TwipsPerPixelY - Height * 2
        Else
            y = m_Top
        End If

        'Manually set the MsgBox window position before Windows shows it
        SetWindowPos wParam, HWND_TOP, x, y, 0, 0, SWP_NOSIZE + SWP_NOZORDER + SWP_NOACTIVATE

        'If user passed in custom icon use that instead of the standard Windows icon
        If m_hIcon <> 0& Then
            hIconWnd = FindWindowEx(wParam, 0&, "Static", vbNullString)
            Call SendMessage(hIconWnd, STM_SETICON, m_hIcon, ByVal 0&)
        End If

errorTrap:
        'unhook the dialog and we are out clean!
        UnhookWindowsHookEx m_Hook
    End If

End Function
