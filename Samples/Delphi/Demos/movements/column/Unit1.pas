unit Unit1;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,

  GLScene,
  GLObjects,
  GLTexture,
  GLVectorTypes,
  GLCadencer,
  GLWin32Viewer,
  GLColor,
  GLCrossPlatform,
  GLCoordinates,
  GLBaseClasses,
  GLVectorGeometry;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    StaticText1: TStaticText;
    Timer1: TTimer;
    GLCadencer1: TGLCadencer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  cNbPlanes = 30;
  cStackHeight = 8;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  plane: TGLPlane;
begin
  // our column is just a stack of planes
  for i := 0 to cNbPlanes - 1 do
  begin
    // create planes as child of the dummycube
    plane := TGLPlane(DummyCube1.AddNewChild(TGLPlane));
    // default plane size is 1x1, we want bigger planes !
    plane.Width := 2;
    plane.Height := 2;
    // orient and position then planes in the stack
    plane.Position.Y := cStackHeight * (0.5 - i / cNbPlanes);
    plane.Direction.AsVector := YHmgVector;
    // we use the emission color, since there is no light in the scene
    // (allows 50+ FPS with software opengl on <400 Mhz CPUs ;)
    plane.Material.FrontProperties.Emission.Color :=
      VectorLerp(clrBlue, clrYellow, i / cNbPlanes);
  end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  i: Integer;
begin
  // for all planes (all childs of the dummycube)
  for i := 0 to DummyCube1.Count - 1 do
    // roll them accordingly to our time reference and position in the stack
    (DummyCube1.Children[i] as TGLPlane).RollAngle :=
      90 * cos(newTime + i * PI / cNbPlanes);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // update FPS and reset counter for the next second
  StaticText1.Caption := Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

end.
