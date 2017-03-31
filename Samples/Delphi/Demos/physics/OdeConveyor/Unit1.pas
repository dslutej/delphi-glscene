unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  GLODEManager,
  Odeimport,
  GLCadencer,
  GLScene,
  GLObjects,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses,
  GLWin32Viewer,
  GLVectorGeometry,
  GLKeyBoard,
  GLSimpleNavigation;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    ConveyorBelt1: TGLCube;
    GLCadencer1: TGLCadencer;
    GLODEManager1: TGLODEManager;
    GLRenderPoint1: TGLRenderPoint;
    GLSimpleNavigation1: TGLSimpleNavigation;
    Panel1: TPanel;
    Label1: TLabel;
    TrackBarMotionSpeed: TTrackBar;
    Label2: TLabel;
    Friction: TEdit;
    FrictionFeedback: TLabel;
    FDirX: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FDirY: TEdit;
    Label6: TLabel;
    FDirZ: TEdit;
    NormZ: TLabel;
    NormY: TLabel;
    NormX: TLabel;
    AddODECube: TButton;
    SpawnPoint: TGLDummyCube;
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormShow(Sender: TObject);
    procedure GLODEManager1Collision(Sender, Object1, Object2: TObject;
      var Contact: TdContact; var HandleCollision: Boolean);
    procedure TrackBarMotionSpeedChange(Sender: TObject);
    procedure FrictionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FDirChange(Sender: TObject);
    procedure AddODECubeClick(Sender: TObject);

  private
     
    FUserDirection: TVector;
    FDirectionVector: TVector;
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Initialize default values from the one of DesignTime;
  with GetOrCreateOdeStatic(ConveyorBelt1) do
  begin
    TrackBarMotionSpeed.Position := Round(Surface.Motion1);
    Friction.Text := FloatToStr(Surface.Mu);
  end;

  FDirX.Text := '0';
  FDirY.Text := '0';
  FDirZ.Text := '1';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  GLCadencer1.Enabled := true;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  GLODEManager1.Step(deltaTime);
end;

procedure TForm1.GLODEManager1Collision(Sender, Object1, Object2: TObject;
  var Contact: TdContact; var HandleCollision: Boolean);
begin
  if Object2 = GetOrCreateOdeStatic(ConveyorBelt1) then
  begin
    Contact.fdir1[0] := FDirectionVector.X;
    Contact.fdir1[1] := FDirectionVector.Y;
    Contact.fdir1[2] := FDirectionVector.Z;
    Contact.fdir1[3] := FDirectionVector.W; // not used
  end;
end;

procedure TForm1.TrackBarMotionSpeedChange(Sender: TObject);
begin
  with GetOrCreateOdeStatic(ConveyorBelt1) do
  begin
    Surface.Motion1 := TrackBarMotionSpeed.Position;
  end;
end;

procedure TForm1.FrictionChange(Sender: TObject);
begin
  with GetOrCreateOdeStatic(ConveyorBelt1) do
  begin
    Surface.Mu := StrToFloatDef(Friction.Text, Surface.Mu);
    FrictionFeedback.Caption := Format('�s = %.2f', [Surface.Mu]);
  end;
end;

procedure TForm1.AddODECubeClick(Sender: TObject);
var
  ACube: TGLCube;
  AODEDynamic: TGLODEDynamic;
  AODEElementBox: TODEElementBox;
begin

  // Create a new GLScene cube and add it to the current GLScene1
  ACube := TGLCube.Create(GLScene1.Objects);
  with ACube do
  begin
    Parent := GLScene1.Objects;
    Position.Assign(SpawnPoint.Position);
    Material.FrontProperties.Diffuse.RandomColor;
  end;

  // Add ODE Dynamic behaviour on it
  AODEDynamic := GetOrCreateOdeDynamic(ACube);
  AODEDynamic.Manager := GLODEManager1;

  // Set �s value to 1 (default=1000), just uses the one from the conveyor
  AODEDynamic.Surface.Mu := 1;

  // Finally create physical data in this behaviour
  AODEElementBox := TODEElementBox(AODEDynamic.AddNewElement(TODEElementBox));
  if Assigned(AODEElementBox) then
    with AODEElementBox do
    begin
      BoxWidth := ACube.CubeWidth;
      BoxHeight := ACube.CubeHeight;
      BoxDepth := ACube.CubeDepth;
    end;

  // The new camera target is the last added cube
  GLCamera1.TargetObject := ACube;

  // The spawn position is increased
  SpawnPoint.Position.Y := SpawnPoint.Position.Y + 1;
end;

procedure TForm1.FDirChange(Sender: TObject);
begin
  // Get back user data from GUI
  FUserDirection.X := StrToFloatDef(FDirX.Text, FUserDirection.X); // x
  FUserDirection.Y := StrToFloatDef(FDirY.Text, FUserDirection.Y); // y
  FUserDirection.Z := StrToFloatDef(FDirZ.Text, FUserDirection.Z); // z
  FUserDirection.W := 0; // not used

  // Copy user data and normalized it
  FDirectionVector := FUserDirection;
  NormalizeVector(FDirectionVector);

  // Now returned normalized data to user to understand the 1-unit thing
  NormX.Caption := Format('Norm(X) = %.3f', [FDirectionVector.X]);
  NormY.Caption := Format('Norm(Y) = %.3f', [FDirectionVector.Y]);
  NormZ.Caption := Format('Norm(Z) = %.3f', [FDirectionVector.Z]);
end;

end.
