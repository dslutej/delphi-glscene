unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.ExtCtrls,
  
  GLCadencer,
  GLScene,
  GLWin32Viewer,
  GLTexture,
  GLFileTGA,
  GLObjects,
  GLVectorGeometry,
  GLProjectedTextures,
  GLHUDObjects,
  GLCrossPlatform,
  GLMaterial,
  GLCoordinates,
  GLBaseClasses,
  GLSimpleNavigation,
  GLUtils;

type
  TForm1 = class(TForm)
    viewer: TGLSceneViewer;
    scene: TGLScene;
    GLCadencer1: TGLCadencer;
    camera: TGLCamera;
    GLPlane1: TGLPlane;
    GLPlane2: TGLPlane;
    GLPlane3: TGLPlane;
    scenery: TGLDummyCube;
    GLSphere1: TGLSphere;
    matLib: TGLMaterialLibrary;
    Light: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    light2: TGLDummyCube;
    GLSphere2: TGLSphere;
    GLSphere3: TGLSphere;
    ProjLight: TGLProjectedTextures;
    emitter1: TGLTextureEmitter;
    emitter2: TGLTextureEmitter;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure ViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure viewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
     
  public
     
  end;


var
  Form1: TForm1;
  ang: single;
  mx, my, mk: integer;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetGLSceneMediaDir();
  matLib.Materials[0].Material.Texture.Image.LoadFromFile('projector.tga');
  matLib.Materials[1].Material.Texture.Image.LoadFromFile('flare1.bmp');

  emitter1.Material.MaterialLibrary:= matLib;
  emitter1.Material.LibMaterialName:= 'spot';

  emitter2.Material.MaterialLibrary:= matLib;
  emitter2.Material.LibMaterialName:= 'spot2';
  emitter2.FOVy:= 40;

  GLPlane1.Material.Texture.Image.LoadFromFile('cm_front.jpg');
  GLPlane2.Material.Texture.Image.LoadFromFile('cm_left.jpg');
  GLPlane3.Material.Texture.Image.LoadFromFile('cm_bottom.jpg');

  projLight.Emitters.AddEmitter(emitter1);
  projLight.Emitters.AddEmitter(emitter2);
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
     ang:= ang + deltatime*20;

     Light.Position.Y:= sin(degToRad(ang));
     light.position.x:= cos(degToRad(ang));

     light2.pitch(deltatime*20);

     viewer.invalidate;
end;

procedure TForm1.viewerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     mk:= 1;
     mx:= x;
     my:= y;
end;

procedure TForm1.viewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     mk:= 0;
end;

procedure TForm1.viewerMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     if mk = 1 then begin
          if shift = [ssLeft] then
               camera.MoveAroundTarget(y - my, x - mx)
          else if shift = [ssRight] then
               camera.AdjustDistanceToTarget(1.0 + (y - my) / 100);
     end;

     mx:= x;
     my:= y;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = VK_ADD then
          emitter1.FOVy:= emitter1.FOVy + 5
     else if key = VK_SUBTRACT then
          emitter1.FOVy:= emitter1.FOVy - 5;

     if chr(Key) = 'S' then
          if ProjLight.style = ptsOriginal then
               ProjLight.style:= ptsInverse
          else
               ProjLight.style:= ptsOriginal;
end;

end.
