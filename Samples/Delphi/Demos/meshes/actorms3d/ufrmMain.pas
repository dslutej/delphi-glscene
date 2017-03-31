unit ufrmMain;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Imaging.jpeg,
  
  OpenGLTokens,
  GLCadencer,
  GLWin32Viewer,
  GLCrossPlatform,
  GLBaseClasses,
  GLScene,
  GLVectorFileObjects,
  GLObjects, GLUtils,
  GLCoordinates,
  GLGeomObjects,
  GLFileMS3D,
  GLMaterial,
  GLCameraController,
  GLGraphics,
  GLVectorTypes,
  GLRenderContextInfo,
  GLCustomShader,
  GLSLShader,
  GLFBORenderer,
  GLShadowPlane,
  GLVectorGeometry,
  GLSimpleNavigation,
  GLMesh,
  GLGui,
  GLWindows,
  GLState,
  GLSArchiveManager,
  GLContext,
  GLCompositeImage,
  GLFileTGA,
  GLFileZLIB,
  GLFileJPEG,
  GLFilePNG;

type
  TfrmMain = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    Root: TGLDummyCube;
    GLCamera1: TGLCamera;
    Actor1: TGLActor;
    MatLib: TGLMaterialLibrary;
    Panel1: TPanel;
    Button2: TButton;
    btnStartStop: TButton;
    Button4: TButton;
    Light2: TGLLightSource;
    GLSLShader1: TGLSLShader;
    GLFrameBuffer: TGLFBORenderer;
    GLDirectOpenGL1: TGLDirectOpenGL;
    GLCamera2: TGLCamera;
    GLPlane1: TGLPlane;
    GLNavigation: TGLSimpleNavigation;
    Chair1: TGLFreeForm;
    GLSphere2: TGLSphere;
    GLLightSource1: TGLLightSource;
    aniBox: TComboBox;
    aniPos: TTrackBar;
    Timer1: TTimer;
    GLSArchiveManager1: TGLSArchiveManager;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLSLShader1Apply(Shader: TGLCustomGLSLShader);
    procedure GLDirectOpenGL1Render(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure aniPosChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure aniBoxSelect(Sender: TObject);
    procedure Actor1EndFrameReached(Sender: TObject);
    procedure GLFrameBufferAfterRender(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure GLFrameBufferBeforeRender(Sender: TObject;
      var rci: TGLRenderContextInfo);
  private
    FAppPath: string;
    procedure SetAppPath(const Value: string);
     
  public
     
    property AppPath: string read FAppPath write SetAppPath;
  end;

var
  frmMain: TfrmMain;
  mdx: Integer;
  mdy: integer;

  FBiasMatrix: TMatrix;
  FLightModelViewMatrix: TMatrix;
  FLightProjMatrix: TMatrix;
  FInvCameraMatrix: TMatrix;
  FEyeToLightMatrix: TMatrix;

  FLightModelViewMatrix2: TMatrix;
  FLightProjMatrix2: TMatrix;
  FInvCameraMatrix2: TMatrix;
  FEyeToLightMatrix2: TMatrix;

implementation

{$R *.dfm}


procedure TfrmMain.FormCreate(Sender: TObject);

  procedure LoadTexture(const AName: string; const ext: string);
  var
    img: TGLCompositeImage;
    strm: TStream;
  begin
    img := MatLib.TextureByName(AName).Image as TGLCompositeImage;
    strm := GLSArchiveManager1.Archives[0].GetContent('Main/'+AName+'.'+ext);
    img.LoadFromStream(strm);
    img.LoadFromFile('beigemarble.jpg');
  end;

begin
  SetGLSceneMediaDir();
  GLSArchiveManager1.Archives[0].LoadFromFile('ActorMS3D.zlib');

//  MatLib.TextureByName('floor_parquet').Image.LoadFromFile('ashwood.jpg');
  LoadTexture('floor_parquet', 'JPG');
  LoadTexture('Chair', 'PNG');
  LoadTexture('Hair', 'PNG');
  LoadTexture('Woman4-Remap-texture', 'PNG');
  Actor1.LoadFromStream('Woman4.ms3d', GLSArchiveManager1.Archives[0].GetContent('Main/Woman4.ms3d'));

  Chair1.LoadFromStream('Chair.ms3d', GLSArchiveManager1.Archives[0].GetContent('Main/Chair.ms3d'));
  MatLib.TextureByName('Lightspot').Image.LoadFromFile('Flare1.bmp');

  Actor1.AnimationMode := aamNone;
  Actor1.Scale.SetVector(0.1, 0.1, 0.1, 0);
  Chair1.Scale.SetVector(0.35, 0.35, 0.35, 0);

  //The MS3D Model has multiple animations all in sequence.
  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 2; //because first frame is going to be the RootPos
    EndFrame := 855;
    Name := 'Dance';
  end;
  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 856;
    EndFrame := 1166;
    Name := 'Sexy Walk';
  end;

  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 1168;
    EndFrame := 1203;
    Name := 'Cartwheel';
  end;

  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 1205;
    EndFrame := 1306;
    Name := 'Hand Flip';
  end;

  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 1308;
    EndFrame := 1395;
    Name := 'Wave';
  end;

  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 1397;
    EndFrame := 2014;
    Name := 'Sun Salutation';
  end;

  with Actor1.Animations.Add do
  begin
    Reference := aarSkeleton;
    StartFrame := 2016;
    EndFrame := 2133;
    Name := 'Sit';
  end;

  FBiasMatrix := CreateScaleAndTranslationMatrix(VectorMake(0.5, 0.5, 0.5),
    VectorMake(0.5, 0.5, 0.5));
  GLSLShader1.VertexProgram.LoadFromFile('Shaders\shadowmap_vp.glsl');
  GLSLShader1.FragmentProgram.LoadFromFile('Shaders\shadowmap_fp.glsl');
  GLSLShader1.Enabled := true;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  aniBox.ItemIndex := 0;
  aniBoxSelect(Sender);
end;

procedure TfrmMain.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
  af, af2, pv, pv2: TAffineVector;
begin
  //I don't know if I did this right or there is a better way,  but
  //it does seem to work well.
  //This is used to always keep the spotlight pointed at the model during
  //animation translations.

  GLCamera2.Position.Rotate(VectorMake(0, 1, 0), deltaTime * 0.1);
  af := Actor1.Skeleton.CurrentFrame.Position[0];
  scalevector(af, Actor1.Scale.AsAffineVector);
  af2 := GLCamera2.Position.AsAffineVector;
  pv := VectorSubtract(af, af2);
  NormalIzeVector(pv);
  GLCamera2.Direction.AsAffineVector := pv;
end;

procedure TfrmMain.Actor1EndFrameReached(Sender: TObject);
begin
  if (Actor1.AnimationMode = aamNone) then
  begin
    btnStartStop.Caption := 'Start';
    Timer1.Enabled := False;
    aniPos.Enabled := True;
  end;
end;

procedure TfrmMain.aniBoxSelect(Sender: TObject);
begin
  Actor1.AnimationMode := aamNone;
  if (aniBox.ItemIndex <> -1) then
  begin
    Chair1.Visible := aniBox.itemindex = 6;
    Timer1.Enabled := False;
    aniPos.Enabled := False;
    Actor1.SwitchToAnimation(aniBox.ItemIndex + 1, false);

    aniPos.Min := 0;
    aniPos.Max := Actor1.EndFrame - Actor1.StartFrame;
    aniPos.Position := 0;
    aniPos.Enabled := True;
    btnStartStop.Caption := 'Start';
  end;

end;

procedure TfrmMain.aniPosChange(Sender: TObject);
begin
  if (aniPos.Enabled) then
    Actor1.CurrentFrame := Actor1.StartFrame + aniPos.Position;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Actor1.NextFrame;
end;

procedure TfrmMain.btnStartStopClick(Sender: TObject);
begin
  if (Actor1.AnimationMode = aamNone) then
  begin
    if (Actor1.CurrentFrame = Actor1.EndFrame) then
      Actor1.CurrentFrame := Actor1.StartFrame;
    Actor1.AnimationMode := aamPlayOnce;
    TButton(Sender).Caption := 'Stop';
    Timer1.Enabled := True;
    aniPos.Enabled := False;
  end
  else
  begin
    Actor1.AnimationMode := aamNone;
    TButton(Sender).Caption := 'Start';
    Timer1.Enabled := False;
    aniPos.Enabled := True;
  end;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  Actor1.PrevFrame;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Actor1.AnimationMode := aamNone;
  GLCadencer1.Enabled := False;
  GLSLShader1.Enabled := false;
end;


procedure TfrmMain.GLDirectOpenGL1Render(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  // prepare shadow mapping matrix
  FInvCameraMatrix := rci.PipelineTransformation.InvModelViewMatrix;
  // go from eye space to light's "eye" space
  FEyeToLightMatrix := MatrixMultiply(FInvCameraMatrix, FLightModelViewMatrix);
  // then to clip space
  FEyeToLightMatrix := MatrixMultiply(FEyeToLightMatrix, FLightProjMatrix);
  // and finally make the [-1..1] coordinates into [0..1]
  FEyeToLightMatrix := MatrixMultiply(FEyeToLightMatrix, FBiasMatrix);
end;

procedure TfrmMain.GLFrameBufferAfterRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  CurrentGLContext.GLStates.Disable(stPolygonOffsetFill);
end;

procedure TfrmMain.GLFrameBufferBeforeRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  with CurrentGLContext.PipelineTransformation do
  begin
    FLightModelViewMatrix := ModelViewMatrix;
    FLightProjMatrix := ProjectionMatrix;
  end;
  // push geometry back a bit, prevents false self-shadowing
  with CurrentGLContext.GLStates do
  begin
    Enable(stPolygonOffsetFill);
    PolygonOffsetFactor := 2;
    PolygonOffsetUnits := 2;
  end;
end;

procedure TfrmMain.GLSLShader1Apply(Shader: TGLCustomGLSLShader);
begin
  Shader.SetTex('TextureMap', MatLib.TextureByName('floor_parquet'));
  Shader.SetTex('ShadowMap',MatLib.TextureByName(GLFrameBuffer.DepthTextureName));
  Shader.SetTex('LightspotMap', MatLib.TextureByName('Lightspot'));

  Shader.Param['Scale'].AsFloat := 16.0;
  Shader.Param['Softly'].AsInteger := 1;
  Shader.Param['EyeToLightMatrix'].AsMatrix4f := FEyeToLightMatrix;
end;

procedure TfrmMain.SetAppPath(const Value: string);
begin
  FAppPath := Value;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  aniPos.Position :=
    Actor1.CurrentFrame - Actor1.Animations[aniBox.ItemIndex + 1].StartFrame;
end;

end.

