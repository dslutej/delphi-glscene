unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,

  
  GLScene, GLObjects, GLWin32Viewer, GLTexture, GLVectorGeometry,
  GLCadencer, GLMultiMaterialShader, GLTexCombineShader, GLMaterial,
  GLCoordinates, GLCrossPlatform, GLUtils, GLBaseClasses, GLSimpleNavigation;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLCube1: TGLCube;
    GLLightSource1: TGLLightSource;
    GLMaterialLibrary2: TGLMaterialLibrary;
    GLMultiMaterialShader1: TGLMultiMaterialShader;
    GLCadencer1: TGLCadencer;
    GLTexCombineShader1: TGLTexCombineShader;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
     
  public
     
    mx,my : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetGLSceneMediaDir();

  // Add the specular pass
  with GLMaterialLibrary1.AddTextureMaterial('specular','glscene_alpha.bmp') do
  begin
      // tmBlend for shiny background
      //Material.Texture.TextureMode:=tmBlend;
      // tmModulate for shiny text
      Material.Texture.TextureMode:=tmModulate;
      Material.BlendingMode:=bmAdditive;
      Texture2Name:='specular_tex2';
  end;
  with GLMaterialLibrary1.AddTextureMaterial('specular_tex2','chrome_buckle.bmp') do
  begin
      Material.Texture.MappingMode:=tmmCubeMapReflection;
      Material.Texture.ImageBrightness:=0.3;
  end;

  // GLMaterialLibrary2 is the source of the GLMultiMaterialShader
  // passes.
    // Pass 1 : Base texture
  GLMaterialLibrary2.AddTextureMaterial('Pass1','glscene.bmp');//}

    // Pass 2 : Add a bit of detail
  with GLMaterialLibrary2.AddTextureMaterial('Pass2','detailmap.jpg') do
  begin
      Material.Texture.TextureMode:=tmBlend;
      Material.BlendingMode:=bmAdditive;
  end;//}

    // Pass 3 : And a little specular reflection
  with TGLLibMaterial.Create(GLMaterialLibrary2.Materials) do
  begin
      Material.MaterialLibrary:=GLMaterialLibrary1;
      Material.LibMaterialName:='specular';
  end;//}

    // This isn't limited to 3, try adding some more passes!
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx:=x;
  my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in shift then
    GLCamera1.MoveAroundTarget(my-y,mx-x);
  mx:=X;
  my:=Y;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
	GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta/120));
  Handled := true
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  GLCube1.Turn(deltaTime*10);
end;

end.
