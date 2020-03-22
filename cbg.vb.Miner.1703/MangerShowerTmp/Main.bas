Attribute VB_Name = "Main"
Public thisLogger As New clsLogger
Public threadMediaer As New cMedia
Public Sub loadMedia()
    threadMediaer.load App.Path & "\media\“Ù∆µ.mp3", "MainMedia"
    
End Sub
