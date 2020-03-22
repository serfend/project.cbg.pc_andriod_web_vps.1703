VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMedia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'v0.1.0 基本的声音播放功能
'2017.11.15
'待添加 录音，视频，属性等设置
'http://blog.csdn.net/simonj07/article/details/5512093
'
Private Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpstrCommand As String, ByVal lpstrRetumString As String, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long
Private fileIndex As String, mPath As String, loaded As Boolean
Private Function reload() As Long
    closeFile
     reload = mciSendString("open " & mPath & " Alias " & fileIndex, 0&, 0, 0)
End Function
Public Function load(ByVal filePath As String, fileAliasName As String) As Long
    load = -1
    mPath = filePath
    Dim fileType As String
    filePath = Replace(filePath, "/", "//")
    filePath = Replace(filePath, "\", "\\")
    fileIndex = fileAliasName
    Dim commands As String
    commands = "open " & filePath & " Alias " & fileIndex ' & " parent %u Style %u notify"
    load = reload
    If load = 0 Then loaded = True

'mciSendString "open " & filePath & " type MPEGVideo parent %u Style %u notify", 0&, 0, 0
'type MPEGVideo    是指打开MPEG,AVI等类型，如果不加这一句，就是打开WAV,MP3等
End Function
Public Function play(Optional filePaths As String, Optional beginTime As Long, Optional toTime As Long, Optional repeat As Boolean = False, Optional fullScreen As Boolean = False) As Long
    If filePaths <> "" Then
        play = mciSendString("play " & filePaths, 0&, 0, 0)
        Exit Function
    End If
    If Not loaded Then
        closeFile
        If load(mPath, fileIndex) <> 0 Then Exit Function
    End If
    '2.播放（Play），格式：Play 设备名 [from 起点][to 终点]
    reload
    play = mciSendString("play " & fileIndex & IIf(repeat, " repeat", "") & IIf(fullScreen, " fullscreen", ""), 0&, 0, 0)
    'mciSendString "play movie fullscreen", 0&, 0, 0 '全屏播放
End Function
Public Sub pause()
    mciSendString "pause " & fileIndex, 0&, 0, 0
End Sub
Public Sub playResume()
    mciSendString "resume " & fileIndex, 0&, 0, 0
End Sub
Public Sub playStop()
    mciSendString "stop  " & fileIndex, 0&, 0, 0
End Sub
Private Function closeFile()
    If fileIndex <> "" Then
        mciSendString "close  " & fileIndex, 0&, 0, 0
    End If
End Function
Public Property Get length() As String
    Dim ST As String * 64
    mciSendString "status " & fileIndex & " length", ST, Len(ST), 0
    length = ST
End Property
Public Property Get pos() As String
    Dim ST As String * 64
    mciSendString "status " & fileIndex & " position", ST, Len(ST), 0
    pos = ST
End Property
Public Property Let pos(value As String)
    mciSendString "seek  & fileIndex &  to ", Val(value), 0, 0 'P1是当前起始位置，单位：毫秒
End Property

Public Property Get Info() As String
    Dim ST As String * 64
    mciSendString "status " & fileIndex & " mode", ST, Len(ST), 0
    Info = ST
'If Left(ST, 7) = "stopped" Then (处理代码) '播放完毕
End Property
Public Property Get volume() As Long
    mciSendString "status " & fileIndex & " volume", volume, 0, 0
End Property
Public Property Let volume(value As Long)
    mciSendString "setaudio " & fileIndex & " volume to " & value, &O0, 0, 0 'V是设置的音量值
End Property
Private Sub Class_Terminate()
    closeFile
End Sub
