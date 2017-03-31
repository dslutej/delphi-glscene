object Form1: TForm1
  Left = 192
  Top = 105
  Caption = 'Simple ODE'
  ClientHeight = 422
  ClientWidth = 638
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 153
    Top = 0
    Width = 485
    Height = 422
    Camera = GLCamera1
    Buffer.BackgroundColor = clSkyBlue
    Buffer.ContextOptions = [roDoubleBuffer, roStencilBuffer, roRenderToWindow]
    FieldOfView = 153.337402343750000000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 422
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 64
      Width = 83
      Height = 13
      Caption = 'Choose an object'
    end
    object Label2: TLabel
      Left = 8
      Top = 208
      Width = 96
      Height = 26
      Caption = 'HeightField Contact Resolution'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 97
      Height = 13
      Caption = 'Choose surface type'
    end
    object Spawn: TButton
      Left = 40
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Spawn'
      TabOrder = 0
      OnClick = SpawnClick
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 80
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Sphere'
      Items.Strings = (
        'Sphere'
        'Box'
        'Capsule (CCylinder)'
        'Cylinder'
        'Cone')
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 144
      Width = 129
      Height = 17
      Caption = 'Show ODE Elements'
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 168
      Width = 129
      Height = 33
      Caption = 'Show HeightField Contacts'
      TabOrder = 3
      WordWrap = True
      OnClick = CheckBox2Click
    end
    object TrackBar1: TTrackBar
      Left = 10
      Top = 256
      Width = 137
      Height = 34
      TabOrder = 4
      ThumbLength = 10
      TickMarks = tmBoth
      OnChange = TrackBar1Change
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 24
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 5
      Text = 'Plane'
      OnChange = ComboBox2Change
      Items.Strings = (
        'Plane'
        'HeightField')
    end
  end
  object GLScene1: TGLScene
    Left = 168
    Top = 8
    object GLDummyCube1: TGLDummyCube
      Position.Coordinates = {000000000000803F000000000000803F}
      CubeSize = 1.000000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = GLDummyCube1
        Position.Coordinates = {0000803F000040400000A0400000803F}
        object GLLightSource1: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          LightStyle = lsOmni
          SpotCutOff = 180.000000000000000000
        end
      end
    end
    object GLHeightField1: TGLHeightField
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      Visible = False
      XSamplingScale.Min = -10.000000000000000000
      XSamplingScale.Max = 10.000000000000000000
      XSamplingScale.Step = 0.500000000000000000
      YSamplingScale.Min = -10.000000000000000000
      YSamplingScale.Max = 10.000000000000000000
      YSamplingScale.Step = 0.500000000000000000
      Options = []
      OnGetHeight = GLHeightField1GetHeight
      BehavioursData = {
        0458434F4C02010201060C54474C4F4445537461746963020012000000000200
        0200060D474C4F44454D616E616765723102000500000000006F1283F53F0801
        000500000000000000FA08400500000000000000000000050000000000000000
        0000050000000000000000000005000000000000000000000500000000000000
        0000000500000000000000000000050000000000000000000005000000000000
        00000000050000000000000000000002000458434F4C020102010610544F4445
        456C656D656E74506C616E650201020012000000000200020008020008020008
        050000000000000080FF3F}
    end
    object GLPlane1: TGLPlane
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      Height = 10.000000000000000000
      Width = 10.000000000000000000
      BehavioursData = {
        0458434F4C02010201060C54474C4F4445537461746963020012000000000200
        0200060D474C4F44454D616E616765723102000500000000006F1283F53F0800
        000500000000000000FA08400500000000000000000000050000000000000000
        0000050000000000000000000005000000000000000000000500000000000000
        0000000500000000000000000000050000000000000000000005000000000000
        00000000050000000000000000000002000458434F4C020102010610544F4445
        456C656D656E74506C616E650201020012000000000200020008020008020008
        050000000000000080FF3F}
    end
    object ODEObjects: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object GLRenderPoint1: TGLRenderPoint
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    MaxDeltaTime = 0.020000000000000000
    OnProgress = GLCadencer1Progress
    Left = 200
    Top = 8
  end
  object GLODEManager1: TGLODEManager
    Gravity.Coordinates = {00000000C3F51CC1000000000000803F}
    Solver = osmQuickStep
    Iterations = 3
    MaxContacts = 8
    RenderPoint = GLRenderPoint1
    Visible = False
    VisibleAtRunTime = True
    Left = 192
    Top = 88
  end
end
