unit Unit1;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  
  GLScene, GLObjects, GLWin32Viewer, GLODEManager, GLVectorGeometry,
  GLCadencer, GLGeomObjects, odeimport, GLHUDObjects, GLBitmapFont,
  GLWindowsFont, GLCrossPlatform, GLCoordinates, GLBaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLODEManager1: TGLODEManager;
    GLODEJointList1: TGLODEJointList;
    Machine: TGLDummyCube;
    Axle: TGLCylinder;
    GLLightSource1: TGLLightSource;
    Wheel: TGLCylinder;
    Pin1: TGLCylinder;
    Arm: TGLCube;
    Slider: TGLCube;
    Pin2: TGLCylinder;
    GLCadencer1: TGLCadencer;
    ODERenderPoint: TGLRenderPoint;
    GLHUDText1: TGLHUDText;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
     
  public
     
    mx, my : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx:=x;
  my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    GLCamera1.MoveAroundTarget(my-y,mx-x);
  mx:=x;
  my:=y;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
  velWheel,
  velPin2 : PdVector3;
begin
  GLODEManager1.Step(deltaTime);

  velWheel:=dBodyGetAngularVel(TGLODEDynamic(Wheel.Behaviours[0]).Body);
  velPin2:=dBodyGetLinearVel(TGLODEDynamic(Pin2.Behaviours[0]).Body);
  GLHUDText1.Text:=Format(
    'Wheel Angular Velocity (Y-Axis) = %.1f'+#13#10+
    'Pin2 Linear Velocity (X-Axis) = %.1f',
    [velWheel[1], velPin2[0]]);
end;

end.
