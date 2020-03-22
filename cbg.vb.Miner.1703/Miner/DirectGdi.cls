VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DirectGDI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private Declare Function GdipDrawImageRectRectI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal dstX As Long, ByVal dstY As Long, ByVal dstWidth As Long, ByVal dstHeight As Long, ByVal srcx As Long, ByVal srcy As Long, ByVal srcwidth As Long, ByVal srcheight As Long, ByVal srcUnit As GpUnit, Optional ByVal imageAttributes As Long = 0, Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
Private Declare Function GetDeviceCaps Lib "gdi32.dll" (ByVal hDc As Long, ByVal nIndex As Long) As Long
'=========================================================================
Private mToken As Long, m_hDc As Long
Public HdcGraphics As Long, mDirectInHdc  As Long '绘制目标
Private mAntiAlias As Boolean, mInterMode As InterpolationMode  '局部复制
Private Fontfam As Long, _
       Strformat As Long, _
       curFont As Long, _
       rclayout As RECTF, _
       RcBlend As RECTF
Private mDpiX  As Long, mDpiY As Long, mTransX As Single, mTransY As Single
Private m_Width As Single, m_Height As Single
Private mFontName As String, mFontSize As Single, mStyle As FontStyle, mStrAlignment As StringAlignment

Private Type StringBox '以像素为单位的文字所占空间
    x As Long
    y As Long
    Width As Long
    Heigth As Long
End Type
Private mGDIHeight As Single, mGDIWidth As Single
Public Enum ShadowStyle
 Out = 0
 Insert
End Enum
Private Type ImgInfo
    w As Long
    h As Long
    ImgIndex As Long
End Type
Private ImgInfo() As ImgInfo, ImgNum As Long
Private FontBase() As Long, NowBaseSize As Long
'===渐变图形
Public Sub FillRoundRectS(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                                ByVal FillColor As Long, Optional SideColor As Long = 0, Optional SideWidth As Long, _
                                                Optional ByVal RoundWidth As Long = 20, Optional ByVal RoundHeight As Long = 20, _
                                                Optional hDc As Long = -1)
Stop
Dim Path As Long, Brush As Long, PathInsert As Long
Dim graphics As Long, Delete As Boolean
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

x = (x - SideWidth) / mTransX: y = (y - SideWidth) / mTransY: Width = (Width + SideWidth * 2) / mTransX: Height = (Height + SideWidth * 2) / mTransY

   GdipCreatePath FillModeAlternate, Path
   GdipAddPathArc Path, x, y, RoundWidth, RoundHeight, 180, 90
   GdipAddPathArc Path, x + Width - RoundWidth, y, RoundWidth, RoundHeight, 270, 90
   GdipAddPathArc Path, x + Width - RoundWidth, y + Height - RoundHeight, RoundWidth, RoundHeight, 0, 90
   GdipAddPathArc Path, x, y + Height - RoundHeight, RoundWidth, RoundHeight, 90, 90
   GdipClosePathFigure Path '闭合路径

    GdipCreatePathGradientFromPath Path, Brush
    Dim MixColor(3) As Long, MixPosit(3) As Single
    MixColor(0) = &H0
    If SideColor >= 0 Then
        MixColor(1) = SideColor
    Else
        MixColor(1) = FillColor
    End If
    MixColor(2) = FillColor
    MixPosit(0) = 0#
    MixPosit(1) = SideWidth * 0.1
    MixPosit(2) = 1#

     
    GdipSetPathGradientCenterPoint Brush, NewPointF(x + Width \ 2, y + Height \ 2)
    GdipSetPathGradientPresetBlend Brush, MixColor(0), MixPosit(0), 3
    
    GdipFillPath graphics, Brush, Path
    GdipDeletePath Path
    
If Delete Then GdipDeleteGraphics graphics
End Sub

Public Sub FillOvalS(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                                ByVal SideColor As Long, ByVal FillColor As Long, Optional SideWidth As Long, _
                                                Optional hDc As Long = -1)
Stop
Dim Path As Long, Brush As Long, PathInsert As Long
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

    GdipCreatePath FillModeAlternate, Path
    GdipAddPathEllipse Path, x - SideWidth, y - SideWidth, Width + SideWidth * 2, Height + SideWidth * 2
    GdipCreatePathGradientFromPath Path, Brush
    
    Dim MixColor(3) As Long, MixPosit(3) As Single
    MixColor(0) = &H0
    MixColor(1) = SideColor
    MixColor(2) = FillColor
    'MixColor(3) = &H0
    MixPosit(0) = 0#
    MixPosit(1) = SideWidth * 0.1
    MixPosit(2) = 1#
    'MixPosit(3) = 1#
     
    GdipSetPathGradientCenterPoint Brush, NewPointF(x + Width \ 2, y + Height \ 2)
    GdipSetPathGradientPresetBlend Brush, MixColor(0), MixPosit(0), 3
    
    GdipFillPath graphics, Brush, Path
    GdipDeletePath Path
    
If Delete Then GdipDeleteGraphics graphics
End Sub

Public Sub FillRectS(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                                ByVal SideColor As Long, ByVal FillColor As Long, Optional SideWidth As Long, _
                                                Optional hDc As Long = -1)
Stop
Dim Path As Long, Brush As Long, PathInsert As Long
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

    GdipCreatePath FillModeAlternate, Path
    GdipAddPathRectangle Path, x - SideWidth, y - SideWidth, Width + SideWidth * 2, Height + SideWidth * 2
    GdipCreatePathGradientFromPath Path, Brush
    
    Dim MixColor(3) As Long, MixPosit(3) As Single
    MixColor(0) = &H0
    MixColor(1) = SideColor
    MixColor(2) = FillColor
    'MixColor(3) = &H0
    MixPosit(0) = 0#
    MixPosit(1) = SideWidth * 0.1
    MixPosit(2) = 1#
    'MixPosit(3) = 1#
     
    GdipSetPathGradientCenterPoint Brush, NewPointF(x + Width \ 2, y + Height \ 2)
    GdipSetPathGradientPresetBlend Brush, MixColor(0), MixPosit(0), 3
    
    GdipFillPath graphics, Brush, Path
    GdipDeletePath Path
    
If Delete Then GdipDeleteGraphics graphics
End Sub
'===圆角矩形
Public Sub FillRoundRect(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                                ByVal FillColor As Long, Optional SideColor As Long = 0, Optional SideWidth As Long, _
                                              Optional ByVal RoundWidth As Long = 20, Optional ByVal RoundHeight As Long = 20, _
                                              Optional hDc As Long = -1)
Dim Path As Long
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
   GdipCreatePath FillModeAlternate, Path
   GdipAddPathArc Path, x, y, RoundWidth, RoundHeight, 180, 90
   GdipAddPathArc Path, x + Width - RoundWidth, y, RoundWidth, RoundHeight, 270, 90
   GdipAddPathArc Path, x + Width - RoundWidth, y + Height - RoundHeight, RoundWidth, RoundHeight, 0, 90
   GdipAddPathArc Path, x, y + Height - RoundHeight, RoundWidth, RoundHeight, 90, 90
   GdipClosePathFigure Path '闭合路径
Dim TempBrush As Long, TempPen As Long
If FillColor <> 0 Then
    TempBrush = NewBrush(FillColor)
    GdipFillPath graphics, TempBrush, Path
    GdipDeleteBrush TempBrush
End If
If SideColor <> 0 Then
    TempPen = NewBrush(FillColor)
    GdipDrawPath graphics, TempPen, Path
    GdipDeletePen TempPen
End If
   GdipDeletePath Path
   
If Delete Then GdipDeleteGraphics graphics
End Sub

Public Sub FillRoundRectEx(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                            ByVal SideColor As Long, ByVal FillColor As Long, Optional SideWidth As Long, _
                                            Optional ByVal RoundWidth As Long = 20, Optional ByVal RoundHeight As Long = 20, Optional Shdowsize As Long = 0, _
                                            Optional ImageFileIndex As Long, Optional ImageX As Long, Optional ImageY As Long, _
                                            Optional ImageWidth As Long = -1, Optional ImageHeight As Long = -1, _
                                            Optional Angle As Long, Optional ByVal hDc As Long = -1)
Stop
Dim graphics As Long, Delete As Boolean, Path As Long, ImgW As Long, ImgH As Long
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
    x = x - Width / 2
    y = y - Width / 2
    GdipRotateWorldTransform graphics, Angle, MatrixOrderAppend
    GdipTranslateWorldTransform graphics, x + Width \ 2, y + Height \ 2, MatrixOrderAppend
    
   If Shdowsize <> 0 Then FillRoundRectS -Width \ 2, -Height \ 2, Width, Height, SideColor, SideColor, Shdowsize, RoundWidth, RoundHeight
    GdipCreatePath FillModeAlternate, Path
    GdipAddPathArc Path, 0, 0, RoundWidth, RoundHeight, 180, 90
    GdipAddPathArc Path, Width - RoundWidth, 0, RoundWidth, RoundHeight, 270, 90
    GdipAddPathArc Path, Width - RoundWidth, Height - RoundHeight, RoundWidth, RoundHeight, 0, 90
    GdipAddPathArc Path, 0, Height - RoundHeight, RoundWidth, RoundHeight, 90, 90
    GdipClosePathFigure Path '闭合路径
   If ImageFileIndex > 0 Then
    ImgW = ImgInfo(ImageFileIndex).w
    ImgH = ImgInfo(ImageFileIndex).h
    If ImageWidth <> 0 Then ImgW = ImageWidth
    If ImageHeight <> 0 Then ImgH = ImageHeight
     
    GdipSetClipPath graphics, Path, CombineModeIntersect
    GdipDrawImageRect graphics, ImgInfo(ImageFileIndex).ImgIndex, ImageX, ImageY, ImgW, ImgH
    GdipResetClip graphics
    GdipDrawPath graphics, NewPen(&HAA666666, 2), Path
   Else
    
    GdipFillPath graphics, NewBrush(FillColor), Path
    If SideWidth > 0 Then GdipDrawPath graphics, NewPen(SideColor, SideWidth), Path
   End If

    GdipTranslateWorldTransform graphics, -(x + Width \ 2), -(y + Height \ 2), MatrixOrderAppend
    GdipRotateWorldTransform graphics, -Angle, MatrixOrderAppend
    
   GdipDeletePath Path
If Delete Then GdipDeleteGraphics graphics
End Sub
'===绘制文字
Public Sub DwText(ByVal str As String, ByVal x As Long, ByVal y As Long, _
                                Optional ByVal Width As Long, Optional ByVal Height As Long, _
                                Optional ByVal StrColor As Long = &HFF0F0F0F, Optional Size As Long = -1, Optional hDc As Long = -1)
Dim rect As RECTF
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
'x = x - Width / 2
'y = y - Height / 2
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

    With rect
        .Left = x
        .Top = y
        .Right = Width
        .Bottom = Height
    End With
    Dim TempBrush As Long
    TempBrush = NewBrush(StrColor)
    If Size = -1 Then
        GdipDrawString graphics, StrPtr(str), -1, curFont, rect, Strformat, TempBrush
    Else
        GdipDrawString graphics, StrPtr(str), -1, FontDataBase(Size), rect, Strformat, TempBrush
    End If
    GdipDeleteBrush TempBrush
    
If Delete Then GdipDeleteGraphics graphics
End Sub
'===图片
Public Function LoadImg(ImgPath As String) As Long
ImgNum = ImgNum + 1
ReDim Preserve ImgInfo(ImgNum)
With ImgInfo(ImgNum)
    GdipLoadImageFromFile StrPtr(ImgPath), .ImgIndex
    GdipGetImageWidth .ImgIndex, .w
    GdipGetImageHeight .ImgIndex, .h
    If .ImgIndex = 0 Then
        LoadImg = -1
    Else
        LoadImg = ImgNum
    End If
End With
End Function
Public Sub DwImg(ByVal ImgIndex As Long, ByVal x As Long, ByVal y As Long, _
                                Optional ByVal Width As Long = -15, Optional ByVal Height As Long = -15, _
                                Optional Angle As Long = 0, Optional hDc As Long = -1)
Dim ImgW As Long, ImgH As Long, WdivH As Single
Dim graphics As Long, Delete As Boolean
If ImgIndex = -1 Then Me.FillRect x, y, Width, Height, Me.ARGB(255, 255, 0, 0): Exit Sub
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

  GdipSetInterpolationMode graphics, mInterMode
    ImgW = ImgInfo(ImgIndex).w
    ImgH = ImgInfo(ImgIndex).h
    If ImgH > 1 Then WdivH = ImgW / ImgH
  If Width > 0 Then
    ImgW = Width
    If Height = -1 Then ImgH = ImgW / WdivH
  ElseIf Height > 0 Then
    ImgH = Height
    ImgW = ImgH * WdivH
  End If
  GdipRotateWorldTransform graphics, Angle, MatrixOrderAppend
  GdipTranslateWorldTransform graphics, x + ImgW \ 2, y + ImgH \ 2, MatrixOrderAppend
  GdipDrawImageRect graphics, ImgInfo(ImgIndex).ImgIndex, -ImgW \ 2, -ImgH \ 2, ImgW, ImgH
  GdipTranslateWorldTransform graphics, -(x + ImgW \ 2), -(y + ImgH \ 2), MatrixOrderAppend
  GdipRotateWorldTransform graphics, -Angle, MatrixOrderAppend
  
If Delete Then GdipDeleteGraphics graphics
End Sub
Public Sub DwImgEx(ByVal ImgIndex As Long, ByVal x As Long, ByVal y As Long, _
                                Optional ByVal Width As Long = -1, Optional ByVal Height As Long = -1, _
                                Optional Flipx As Long = 0, Optional Filpy As Long = 0, _
                                Optional FlipWidth As Long = -1, Optional FlipHeight As Long = -1, _
                                Optional Alpha As Single = 1, Optional Red As Single = 1, Optional Green As Single = 1, Optional Bule As Single = 1, _
                                Optional Angle As Long = 0, Optional hDc As Long = -1)
Dim cMatrix As ColorMatrix, gMatrix As ColorMatrix, Attributes As Long, ImgW As Long, ImgH As Long
Dim graphics As Long, Delete As Boolean
If ImgIndex = -1 Then Me.FillRect x, y, Width, Height, Me.ARGB(255, 255, 0, 0): Exit Sub
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If

  GdipSetInterpolationMode graphics, mInterMode
    ImgW = ImgInfo(ImgIndex).w
    ImgH = ImgInfo(ImgIndex).h
  If Width <> 0 Then ImgW = Width
  If Height <> 0 Then ImgH = Height
  If FlipWidth = -1 Then FlipWidth = ImgW
  If FlipHeight = -1 Then FlipHeight = ImgH
  cMatrix.m(0, 0) = Red
  cMatrix.m(1, 1) = Green
  cMatrix.m(2, 2) = Bule
  cMatrix.m(3, 3) = Alpha
  GdipRotateWorldTransform graphics, Angle, MatrixOrderAppend
  GdipTranslateWorldTransform graphics, x + ImgW \ 2, y + ImgH \ 2, MatrixOrderAppend
  GdipCreateImageAttributes Attributes
  GdipSetImageAttributesColorMatrix Attributes, ColorAdjustTypeDefault, -1, cMatrix, gMatrix, ColorMatrixFlagsDefault
  GdipDrawImageRectRectI graphics, ImgInfo(ImgIndex).ImgIndex, -ImgW \ 2, -ImgH \ 2, ImgW, ImgH, Flipx, Filpy, FlipWidth, FlipHeight, UnitPixel, Attributes
  GdipTranslateWorldTransform graphics, -(x + ImgW \ 2), -(y + ImgH \ 2), MatrixOrderAppend
  GdipRotateWorldTransform graphics, -Angle, MatrixOrderAppend
  GdipDisposeImageAttributes Attributes

If Delete Then GdipDeleteGraphics graphics
End Sub
'===清除
Public Sub Clear(Optional FillColor As Long = &HFFFFFFFF, Optional hDc As Long = -1)
Dim graphics As Long, Delete As Boolean
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
End If

  GdipGraphicsClear graphics, FillColor
  
If Delete Then GdipDeleteGraphics graphics
End Sub
'===绘制圆
Public Sub FillOval(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                  ByVal FillColor As Long, Optional SideColor As Long, _
                                 Optional SideWidth As Long = 0, Optional hDc As Long = -1)
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
  
   If FillColor <> 0 Then GdipFillEllipseI graphics, NewBrush(FillColor), x - Width / 2, y - Height / 2, Width, Height
   If SideColor <> 0 Then GdipDrawEllipseI graphics, NewPen(SideColor, SideWidth), x - Width / 2, y - Height / 2, Width, Height
   
If Delete Then GdipDeleteGraphics graphics
End Sub
Public Sub FillOvalEx(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                  ByVal FillColor As Long, Optional SideColor As Long, _
                                 Optional SideWidth As Long = 0, Optional Shdowsize As Long = 0, _
                                 Optional ImgIndex As Long, Optional ImageX As Long, Optional ImageY As Long, _
                                 Optional ImageWidth As Long = -1, Optional ImageHeight As Long = -1, _
                                 Optional hDc As Long = -1)
Dim graphics As Long, Delete As Boolean, Path As Long, ImgW As Long, ImgH As Long
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
   If SideWidth > 0 Then
    If FillColor <> 0 Then GdipFillEllipseI graphics, NewBrush(FillColor), x - Width / 2, y - Height / 2, Width, Height
    If SideColor <> 0 Then GdipDrawEllipseI graphics, NewPen(SideColor, SideWidth), x - Width / 2, y - Height / 2, Width, Height
   End If
   If ImgIndex > 0 Then
    ImgW = ImgInfo(ImgIndex).w
    ImgH = ImgInfo(ImgIndex).h
    If ImageWidth > 0 Then ImgW = ImageWidth * ImageWidth
    If ImageHeight > 0 Then ImgH = ImageHeight * ImageHeight
    GdipCreatePath FillModeAlternate, Path
    GdipAddPathEllipseI Path, x, y, Width, Height
    GdipSetClipPath graphics, Path, CombineModeIntersect
    GdipDrawImageRect graphics, ImgInfo(ImgIndex).ImgIndex, ImageX, ImageY, ImgW, ImgH
    GdipResetClip graphics
    'GdipDrawEllipseI graphics, NewPen(&HAA666666, 2), X, Y, Width, Height
    GdipDeletePath Path
   Else

   End If
If Delete Then GdipDeleteGraphics graphics
End Sub
'===绘制线
Public Sub DwLine(ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, _
                             ByVal Color As Long, Optional Width As Long = 1, _
                             Optional ByVal hDc As Long = -1)
Dim graphics As Long, Delete As Boolean
x1 = x1 / mTransX: y1 = y1 / mTransY: x2 = x2 / mTransX: y2 = y2 / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
  
  GdipDrawLineI graphics, NewPen(Color, Width), x1, y1, x2, y2
  
If Delete Then GdipDeleteGraphics graphics
End Sub
'===绘制矩形
Public Sub FillRect(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                                ByVal FillColor As Long, Optional SideColor As Long, Optional SideWidth As Long = 0, _
                               Optional ByVal hDc As Long = -1)
Dim graphics As Long, Delete As Boolean
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
Dim TempBrush As Long, TempPen As Long

If FillColor <> 0 Then
    TempBrush = NewBrush(FillColor)
    GdipFillRectangleI graphics, TempBrush, x, y, Width, Height
    GdipDeleteBrush TempBrush
End If
If SideColor <> 0 Then
    TempPen = NewPen(SideColor, SideWidth)
    GdipDrawRectangleI graphics, TempPen, x, y, Width, Height
    GdipDeletePen TempPen
End If
If Delete Then GdipDeleteGraphics graphics
End Sub

Public Sub FillRectEx(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, _
                               ByVal FillColor As Long, Optional SideWidth As Long = 0, Optional ByVal SideColor As Long, Optional Shdowsize As Long = 0, _
                               Optional ImgIndex As Long, Optional ImageX As Long, Optional ImageY As Long, _
                               Optional ImageWidth As Single = -1, Optional ImageHeight As Single = -1, _
                               Optional ByVal hDc As Long = -1)
Stop
Dim graphics As Long, Delete As Boolean, Path As Long, ImgW As Long, ImgH As Long
x = x / mTransX: y = y / mTransY: Width = Width / mTransX: Height = Height / mTransY
If hDc = -1 Then
  graphics = HdcGraphics
Else
  Delete = True
  GdipCreateFromHDC hDc, graphics
  If mAntiAlias = True Then GdipSetSmoothingMode graphics, SmoothingModeAntiAlias
End If
   If Shdowsize > 0 Then FillRectS x - Width / 2, y - Height / 2, Width, Height, SideColor, SideColor, Shdowsize
    GdipFillRectangleI graphics, NewBrush(FillColor), x, y, Width, Height
    If SideWidth <> 0 Then GdipDrawRectangleI graphics, NewPen(SideColor, SideWidth), x, y, Width, Height
   If ImgIndex > 0 Then
    ImgW = ImgInfo(ImgIndex).w
    ImgH = ImgInfo(ImgIndex).h
    If ImageWidth > 0 Then ImgW = ImageWidth * Width
    If ImageHeight > 0 Then ImgH = ImageHeight * Height
        GdipCreatePath FillModeAlternate, Path
        GdipAddPathRectangle Path, x, y, Width, Height
        GdipSetClipPath graphics, Path, CombineModeIntersect
        GdipDrawImageRect graphics, ImgInfo(ImgIndex).ImgIndex, x + ImageX, y + ImageY, ImgW, ImgH
        GdipResetClip graphics
        'GdipDrawRectangle graphics, NewPen(&HAA666666, 2), X, Y, Width, Height
        GdipDeletePath Path
   End If
   
If Delete Then GdipDeleteGraphics graphics
End Sub

Private Sub Class_Initialize()
    Dim uInput As GdiplusStartupInput
    uInput.GdiplusVersion = 1
    GdiplusStartup mToken, uInput
    FontName = MyFont
    FontSize = 15
    AntiAlias = True
    ReDim ImgInfo(0)
'    GdipCreateFontFamilyFromName StrPtr("宋体"), 0, Fontfam
'    GdipCreateFont Fontfam, 15, FontStyleRegular, UnitPixel, curFont
'    GdipCreateStringFormat 0, 0, Strformat
'    GdipSetStringFormatAlign Strformat, StringAlignmentNear
    
End Sub
'-----------绘制目标--------------------------------------------------------
Public Property Let DirectInHdc(ByVal vData As Long)
    If mDirectInHdc <> 0 Then GdipDeleteGraphics HdcGraphics
    mDirectInHdc = vData
    GdipCreateFromHDC mDirectInHdc, HdcGraphics
    mDpiX = GetDeviceCaps(mDirectInHdc, 88)
    mDpiY = GetDeviceCaps(mDirectInHdc, 90)
    mTransX = 1440 / mDpiX
    mTransY = 1440 / mDpiY
    mGDIHeight = mDpiX
    mGDIWidth = mDpiY
    If AntiAlias = True Then GdipSetSmoothingMode HdcGraphics, SmoothingModeAntiAlias
End Property
Public Property Get DirectInHdc() As Long
    DirectInHdc = mDirectInHdc
End Property
'-----------插值--------------------------------------------------------
Public Property Let InterpolationMode(ByVal vData As InterpolationMode)
    mInterMode = vData
End Property
Public Property Get InterpolationMode() As InterpolationMode
    DirectInHdc = mInterMode
End Property
'--------------字体------------------------------------------------------------
Public Property Let FontName(ByVal vData As String)
    mFontName = vData
    ResetFont
End Property
Public Property Get FontName() As String
    FontName = mFontName
End Property

Public Property Let FontSize(ByVal vData As String)
    mFontSize = vData
    ResetFont
End Property
Public Property Get FontSize() As String
    FontSize = mFontSize
End Property

Public Property Let FontAlignment(ByVal vData As StringAlignment)
    mStrAlignment = vData
    ResetFont
End Property
Public Property Get FontAlignment() As StringAlignment
    FontAlignment = mFontSize
End Property
Private Sub ResetFont()
    GdipDeleteFontFamily Fontfam
    GdipDeleteFont curFont
    GdipDeleteStringFormat Strformat
    GdipCreateFontFamilyFromName StrPtr(mFontName), 0, Fontfam
    GdipCreateFont Fontfam, mFontSize, mStyle, UnitPixel, curFont
    GdipCreateStringFormat 0, 0, Strformat
    GdipSetStringFormatAlign Strformat, mStrAlignment
End Sub
Private Function FontDataBase(ByVal Size As Long) As Long
If NowBaseSize < Size Then
    FontDataBase = NewFontSize(Size)
Else
    If FontBase(Size) = 0 Then
        FontDataBase = NewFontSize(Size)
    Else
        FontDataBase = FontBase(Size)
    End If
End If
End Function
Private Function NewFontSize(Size As Long)
    GdipCreateFontFamilyFromName StrPtr(mFontName), 0, Fontfam
    GdipCreateFont Fontfam, Size, mStyle, UnitPixel, NewFontSize
    If NowBaseSize < Size Then
        ReDim Preserve FontBase(Size)
        NowBaseSize = Size
    End If
    FontBase(Size) = NewFontSize
End Function
'-------------抗锯齿----------------------------------------------------------
Public Property Let AntiAlias(ByVal vData As Boolean)
    mAntiAlias = vData
    If mAntiAlias = True Then GdipSetSmoothingMode HdcGraphics, SmoothingModeAntiAlias
End Property
Public Property Get AntiAlias() As Boolean
'检索属性值时使用
    AntiAlias = mAntiAlias
End Property
Public Property Get GetDcFromHWND(ByVal hWnd As Long) As Long
Dim NewGrap As Long, NewDc As Long
GdipCreateFromHWND hWnd, NewGrap
GdipGetDC NewGrap, NewDc
Me.DirectInHdc = NewDc
End Property
Public Property Get GetImgWidth(Index As Long) As Long
GetImgWidth = ImgInfo(Index).w * mTransX
End Property
Public Property Get GetImgHeight(Index As Long) As Long
GetImgHeight = ImgInfo(Index).h * mTransY
End Property
Public Property Get GetImgIndex(Index As Long) As Long
GetImgIndex = ImgInfo(Index).ImgIndex
End Property
Public Property Get GDIWidth() As Single
GDIWidth = mGDIWidth
End Property
Public Property Get GDIHeight() As Single
GDIHeight = mGDIHeight
End Property
Private Sub Class_Terminate()
Dim i As Long
For i = 1 To ImgNum
    GdipDisposeImage ImgInfo(i).ImgIndex
Next
GdipDeleteFontFamily Fontfam
GdipDeleteFont curFont
GdipDeleteStringFormat Strformat
GdiplusShutdown mToken

End Sub
Public Function ARGB(ByVal Alpha As Byte, ByVal Red As Byte, ByVal Green As Byte, ByVal Blue As Byte) As String
Dim a As String, R As String, G As String, B As String
a = Right("0" & Hex(Alpha), 2)
R = Right("0" & Hex(Red), 2)
G = Right("0" & Hex(Green), 2)
B = Right("0" & Hex(Blue), 2)
ARGB = "&h" & a & R & G & B
End Function
