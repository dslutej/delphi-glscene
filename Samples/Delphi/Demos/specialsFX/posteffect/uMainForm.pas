unit uMainForm;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Imaging.Jpeg,

  
  GLScene, GLVectorFileObjects, GLObjects, GLTexture, GLVectorLists, GLCadencer,
  GLWin32Viewer, GLSimpleNavigation, GLPostEffects, GLCrossPlatform,
  GLMeshUtils, GLVectorGeometry, GLMaterial, GLCoordinates, GLBaseClasses,
  GLRenderContextInfo, GLUtils,
  GLFileMD2,
  GLFileTGA,
  GLFileObj,
  GLFile3DS,
  GLFileSMD;


type
  TMainForm = class(TForm)
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    GLActor1: TGLActor;
    Label1: TLabel;
    GLLightSource1: TGLLightSource;
    Panel1: TPanel;
    GLSceneViewer1: TGLSceneViewer;
    ComboBox1: TComboBox;
    GLPostEffect1: TGLPostEffect;
    Label2: TLabel;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure GLCadencer1Progress(Sender: TObject; const DeltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure GLPostEffect1CustomEffect(Sender: TObject;
      var rci: TGLRenderContextInfo; var Buffer: TGLPostEffectBuffer);
  private
     
  public
     

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.GLCadencer1Progress(Sender: TObject; const DeltaTime, newTime: Double);
begin
  GLSceneViewer1.Invalidate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetGLSceneMediaDir;
  GLMaterialLibrary1.TexturePaths := GetCurrentDir();
  GLActor1.LoadFromFile('waste.md2');
  GLActor1.Material.Texture.Image.LoadFromFile('waste.jpg');
  GLActor1.Material.Texture.Enabled := True;
  GLActor1.SwitchToAnimation(GLActor1.Animations[0]);

  GLActor1.AnimationMode := aamLoop;
  GLActor1.ObjectStyle := GLActor1.ObjectStyle + [osDirectDraw];
  GLActor1.Reference := aarMorph;
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: GLPostEffect1.Preset := pepNone;
    1: GLPostEffect1.Preset := pepGray;
    2: GLPostEffect1.Preset := pepNegative;
    3: GLPostEffect1.Preset := pepDistort;
    4: GLPostEffect1.Preset := pepNoise;
    5: GLPostEffect1.Preset := pepNightVision;
    6: GLPostEffect1.Preset := pepBlur;
    7: GLPostEffect1.Preset := pepCustom;
  end;
end;

{$R-} // Turn off range checking.
procedure TMainForm.GLPostEffect1CustomEffect(Sender: TObject;
  var rci: TGLRenderContextInfo; var Buffer: TGLPostEffectBuffer);
var
  I: Longword;
begin
  for I := 0 to High(Buffer) do
  begin
    Buffer[I].r := Round(Buffer[I + 5].r * 2);
    Buffer[I].g := Round(Buffer[I].g * 1.5);
    Buffer[I].b := Round(Buffer[I + 5].b * 1.5);
  end;
end;
{$R+}
end.

