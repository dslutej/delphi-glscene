object Form1: TForm1
  Left = 192
  Top = 107
  Caption = 'Bunny Bump Shader'
  ClientHeight = 437
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 57
    Width = 562
    Height = 380
    Camera = Camera
    BeforeRender = GLSceneViewer1BeforeRender
    Buffer.BackgroundColor = clBackground
    FieldOfView = 150.512878417968800000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 562
    Height = 57
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 70
      Height = 13
      Caption = 'Shade Method'
    end
    object Label2: TLabel
      Left = 368
      Top = 8
      Width = 72
      Height = 13
      Caption = 'Specular Mode'
    end
    object LabelFPS: TLabel
      Left = 514
      Top = 26
      Width = 20
      Height = 13
      Caption = 'FPS'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Per-Vertex'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Per-Vertex')
    end
    object GroupBox1: TGroupBox
      Left = 161
      Top = 10
      Width = 169
      Height = 41
      Caption = 'Lights'
      TabOrder = 1
      object Shape1: TShape
        Left = 32
        Top = 16
        Width = 17
        Height = 17
        OnMouseDown = ShapeMouseDown
      end
      object Shape2: TShape
        Left = 88
        Top = 16
        Width = 17
        Height = 17
        Brush.Color = clRed
        OnMouseDown = ShapeMouseDown
      end
      object Shape3: TShape
        Left = 144
        Top = 16
        Width = 17
        Height = 17
        Brush.Color = clBlue
        OnMouseDown = ShapeMouseDown
      end
      object CheckBox1: TCheckBox
        Left = 9
        Top = 16
        Width = 17
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object CheckBox2: TCheckBox
        Left = 65
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = CheckBoxClick
      end
      object CheckBox3: TCheckBox
        Left = 121
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 2
        OnClick = CheckBoxClick
      end
    end
    object CheckBox4: TCheckBox
      Left = 458
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Spin'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object ComboBox2: TComboBox
      Left = 371
      Top = 24
      Width = 73
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'smOff'
      OnChange = ComboBox2Change
      Items.Strings = (
        'smOff'
        'smBlinn'
        'smPhong')
    end
  end
  object GLScene1: TGLScene
    Left = 40
    Top = 72
    object DCLights: TGLDummyCube
      CubeSize = 1.000000000000000000
      object WhiteLight: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {0000404000000040000000000000803F}
        LightStyle = lsOmni
        Specular.Color = {0000803F0000803F0000803F0000803F}
        SpotCutOff = 180.000000000000000000
      end
      object RedLight: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {0000803F00000000000000000000803F}
        Position.Coordinates = {0000C0BF00000040666626C00000803F}
        LightStyle = lsOmni
        Shining = False
        Specular.Color = {0000803F0000003F0000003F0000803F}
        SpotCutOff = 180.000000000000000000
      end
      object BlueLight: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {00000000000000000000803F0000803F}
        Position.Coordinates = {0000C0BF00000040666626400000803F}
        LightStyle = lsOmni
        Shining = False
        Specular.Color = {0000003F0000003F0000803F0000803F}
        SpotCutOff = 180.000000000000000000
      end
    end
    object ffBunny: TGLFreeForm
      Material.FrontProperties.Shininess = 64
      Material.FrontProperties.Specular.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
      Material.MaterialLibrary = GLMaterialLibrary1
      AutoCentering = [macCenterX, macCenterY, macCenterZ]
    end
    object Camera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = ffBunny
      Position.Coordinates = {000080400000803F000000000000803F}
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 40
    Top = 136
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'Bump'
        Tag = 0
        Material.FrontProperties.Shininess = 64
        Material.FrontProperties.Specular.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
        Material.Texture.Disabled = False
        Shader = GLBumpShader1
      end>
    Left = 136
    Top = 72
  end
  object GLBumpShader1: TGLBumpShader
    BumpMethod = bmDot3TexCombiner
    BumpSpace = bsObject
    BumpOptions = []
    SpecularMode = smOff
    DesignTimeEnabled = False
    ParallaxOffset = 0.039999999105930330
    Left = 136
    Top = 136
  end
  object ColorDialog1: TColorDialog
    Left = 352
    Top = 72
  end
  object AsyncTimer1: TGLAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 248
    Top = 72
  end
end
