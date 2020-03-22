VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private filePath As String
Private fileName As String
Private fileContent As String
Private fileNum As Long
Public Sub init(sfilePath As String, fileNames As String, Optional sfileContent As String, Optional actionNow As Integer = 0)
    filePath = sfilePath
    fileName = fileNames
    fileContent = sfileContent
    Select Case actionNow
        Case 0:
        Case 1:
            save
        Case 2:
            load
    End Select
End Sub
Private Function ensurePath(path As String) As Boolean
    If Dir(App.path & "\" & path, vbDirectory) = "" Then
        ensurePath = True
        MkDir App.path & "\" & path
    End If
End Function
Private Function ensureFile(path As String, fileNames As String) As Boolean
    If Dir(App.path & "\" & path & "\" & fileNames) = "" Then
        ensureFile = True
    End If
End Function
Public Sub save()
    getFreeFileNum
    ensurePath filePath
    ensureFile filePath, fileName
    Open App.path & "\" & filePath & "\" & fileName For Output As #fileNum
        Print #fileNum, fileContent
    Close #fileNum
    fileNum = 0
End Sub
Public Sub load()
    getFreeFileNum
    Dim tmpStr As New CStringBuilder, tmp As String
    ensurePath filePath
    If ensureFile(filePath, fileName) Then Exit Sub
    Open App.path & "\" & filePath & "\" & fileName For Input As #fileNum
        While Not EOF(fileNum)
            Line Input #fileNum, tmp
            tmpStr.Append(tmp).Append vbCrLf
        Wend
    Close #fileNum
    fileContent = tmpStr.ToString
    fileNum = 0
End Sub
Private Sub getFreeFileNum()
    fileNum = FreeFile()
End Sub
Public Property Get pFilePath() As String
    pFilePath = filePath
End Property
Public Property Let pFilePath(newFilePath As String)
    filePath = newFilePath
End Property
Public Property Get pFileName() As String
    pFileName = fileName
End Property
Public Property Let pFileName(newFileName As String)
    fileName = newFileName
End Property
Public Property Get pFileContent() As String
    pFileContent = fileContent
End Property
Public Property Let pFileContent(vData As String)
    fileContent = vData
End Property

