unit Unit1;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Forms, Vcl.Dialogs,
  
  GLNGDManager, GLScene, GLObjects, GLCoordinates, GLCadencer,
  GLWin32Viewer, GLCrossPlatform, GLBaseClasses, GLVectorGeometry,
  GLSimpleNavigation, GLKeyboard, GLGeomObjects, GLHUDObjects, GLBitmapFont,
  GLWindowsFont,Controls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    Floor: TGLCube;
    Hinge: TGLCube;
    GLNGDManager1: TGLNGDManager;
    GLSimpleNavigation1: TGLSimpleNavigation;
    Slider: TGLCube;
    Corkscrew: TGLCube;
    CustomHinge: TGLCube;
    CustomSlider: TGLCube;
    Universal: TGLCone;
    CustomBall: TGLSphere;
    Ball: TGLSphere;
    GLAbsoluteHUDText1: TGLAbsoluteHUDText;
    GLAbsoluteHUDText2: TGLAbsoluteHUDText;
    GLAbsoluteHUDText3: TGLAbsoluteHUDText;
    GLAbsoluteHUDText4: TGLAbsoluteHUDText;
    GLAbsoluteHUDText5: TGLAbsoluteHUDText;
    GLAbsoluteHUDText6: TGLAbsoluteHUDText;
    GLAbsoluteHUDText8: TGLAbsoluteHUDText;
    GLAbsoluteHUDText7: TGLAbsoluteHUDText;
    GLLines1: TGLLines;
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSimpleNavigation1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
     
       point3d, FPaneNormal: TVector;

  public
     
        PickJoint: TGLNGDJoint;
    MousePoint: TPoint;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  PickJoint := GLNGDManager1.NewtonJoint.Items[0] as TGLNGDJoint;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
  var
  point2d, GotoPoint3d: TVector;
begin
  GLNGDManager1.Step(deltaTime);

  if IsKeyDown(VK_LBUTTON) then
  begin
    point2d := VectorMake(
      MousePoint.X, GLSceneViewer1.Height - MousePoint.Y, 0, 0);

      // Move the body to the new position
    if GLSceneViewer1.Buffer.ScreenVectorIntersectWithPlane(
      point2d, point3d,  FPaneNormal, GotoPoint3d) then
      PickJoint.KinematicControllerPick(GotoPoint3d, paMove);

  end
  else
    PickJoint.KinematicControllerPick(GotoPoint3d, paDetach);

end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pickedobj: TGLBaseSceneObject;
begin
  if Button = mbLeft then
  begin

    pickedobj := GLSceneViewer1.Buffer.GetPickedObject(X, Y);
    if Assigned(pickedobj) and Assigned(GetNGDDynamic(pickedobj)) then
      PickJoint.ParentObject := pickedobj
    else
      exit;

    point3d := VectorMake(GLSceneViewer1.Buffer.PixelRayToWorld(X, Y));
    // Attach the body
    PickJoint.KinematicControllerPick(point3d, paAttach);

    if Assigned(GLSceneViewer1.Camera.TargetObject) then
      FPaneNormal := GLSceneViewer1.Camera.AbsoluteVectorToTarget
    else
      FPaneNormal := GLSceneViewer1.Camera.AbsoluteDirection;
  end;

end;


procedure TForm1.GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Detach the body
  if Button = mbLeft then
    PickJoint.KinematicControllerPick(NullHmgVector, paDetach);
end;

procedure TForm1.GLSimpleNavigation1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
//Get mouse coord for cadencer event
  MousePoint.X := X;
  MousePoint.Y := Y;
end;

end.
