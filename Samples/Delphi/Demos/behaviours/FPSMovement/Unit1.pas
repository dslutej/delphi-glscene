unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,

  
  GLScene,
  GLTexture,
  GLCadencer,
  GLFPSMovement,
  GLKeyboard,
  GLState,
  GLWin32Viewer,
  GLObjects,
  GLCollision,
  GLVectorFileObjects,
  GLNavigator,
  GLVectorLists,
  GLOctree,
  GLFile3DS,
  GLVectorGeometry,
  GLGeomObjects,
  GLCrossPlatform,
  GLMaterial,
  GLCoordinates,
  GLSimpleNavigation,
  GLBaseClasses,
  GLUtils;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    FirstPersonCamera: TGLCamera;
    Map1: TGLFreeForm;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLLight: TGLLightSource;
    World: TGLDummyCube;
    ThirdPersonCamera: TGLCamera;
    PlayerSphere: TGLSphere;
    GLLightSource1: TGLLightSource;
    PlayerCentre: TGLSphere;
    Player: TGLDummyCube;
    Map2: TGLFreeForm;
    Bot: TGLDummyCube;
    BotCenter: TGLSphere;
    BotSphere: TGLSphere;
    Navigator1: TGLNavigator;
    MovManager: TGLFPSMovementManager;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
     
  public
     
  end;

var
  Form1: TForm1;
  behav, behav2: TGLBFPSMovement;

implementation

var
  yangle: double = 90;
  xangle: double = 0;
  //Velocity:TVector=(0,0,0,0);
  //Gravity:TVector=(0,-9.81*20,0,0);
  Wireframe: Boolean;
  //DisplayTime:Integer=2000;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);

begin
  SetGLSceneMediaDir;
  Map1.LoadFromFile('map.3ds');
  Map1.BuildOctree();
  Map1.Up.SetVector(0, 1, 0);

  map2.LoadFromFile('beer.3ds');
  map2.BuildOctree;

  ShowCursor(false);
  SetCursorPos(screen.width div 2, screen.Height div 2);

  behav := GetFPSMovement(player);
  behav2 := GetFPSMovement(bot);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Halt;

  //show/hide arrows
  if key = VK_F1 then
    behav.ShowArrows := not behav.ShowArrows;

  //pause / unpause
  if Key = VK_PAUSE then
    GLCadencer1.Enabled := not GLCadencer1.Enabled;
  //first person
  if Key = VK_F2 then
    GLSceneViewer1.Camera := FirstPersonCamera;
  //third person
  if Key = VK_F3 then
    GLSceneViewer1.Camera := ThirdPersonCamera;
  // solid / wireframe
  if iskeydown(VK_F5) then
  begin
    WireFrame := not WireFrame;
    if WireFrame then
    begin
      Map1.UseMeshMaterials := false;
      Map1.Material.PolygonMode := pmLines;
      map2.UseMeshMaterials := false;
      Map2.Material.PolygonMode := pmLines;
    end
    else
    begin
      Map1.UseMeshMaterials := true;
      Map1.Material.PolygonMode := pmFill;
      Map2.UseMeshMaterials := true;
      Map2.Material.PolygonMode := pmFill;
    end;
  end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
  MovementScale: Single;
begin
  MovementScale := Movmanager.MovementScale;

  //then update position according to keys being pressed
  if IsKeyDown('W') or IsKeyDown('Z') then
    behav.MoveForward(MovementScale * deltaTime);
  if IsKeyDown('S') then
    behav.MoveForward(-MovementScale * deltaTime);
  if IsKeyDown('A') or IsKeyDown('Q') then
    behav.StrafeHorizontal(-MovementScale * deltaTime);
  if IsKeyDown('D') then
    behav.StrafeHorizontal(MovementScale * deltaTime);

  //move up/down (for debugging)
  if IsKeyDown(VK_PRIOR) or IsKeyDown(VK_SPACE) then
    behav.StrafeVertical(MovementScale * deltaTime);
  if IsKeyDown(VK_NEXT) then
    behav.StrafeVertical(-MovementScale * deltaTime);

  //move bot
  if IsKeyDown('I') then
    behav2.MoveForward(MovementScale * deltaTime);
  if IsKeyDown('K') then
    behav2.MoveForward(-MovementScale * deltaTime);
  if IsKeyDown('J') then
    behav2.StrafeHorizontal(-MovementScale * deltaTime);
  if IsKeyDown('L') then
    behav2.StrafeHorizontal(MovementScale * deltaTime);
  if IsKeyDown('O') then
    behav2.StrafeVertical(MovementScale * deltaTime);
  if IsKeyDown('P') then
    behav.StrafeVertical(-MovementScale * deltaTime);

  if IsKeyDown(VK_LEFT) then
    behav.TurnHorizontal(-70 * deltatime);
  if IsKeyDown(VK_RIGHT) then
    behav.TurnHorizontal(70 * deltatime);
  if IsKeyDown(VK_UP) then
    behav.turnVertical(-70 * deltatime);
  if IsKeyDown(VK_DOWN) then
    behav.turnVertical(70 * deltatime);

  //update mouse view
  xangle := mouse.CursorPos.X - screen.Width / 2;
  yangle := mouse.CursorPos.Y - screen.Height / 2;
  setcursorpos(screen.width div 2, screen.Height div 2);
  behav.TurnHorizontal(xangle * 40 * deltaTime);
  behav.TurnVertical(-yangle * 20 * deltaTime);

  GLSceneViewer1.Invalidate;
end;

end.

