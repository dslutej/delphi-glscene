unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,

  
  GLScene, GLObjects, GLParticles, GLBehaviours,
  GLVectorGeometry, GLCadencer, GLVectorTypes,
  GLWin32Viewer, GLCrossPlatform, GLCoordinates, GLBaseClasses, GLUtils;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLParticles1: TGLParticles;
    Sprite1: TGLSprite;
    GLCadencer1: TGLCadencer;
    Timer1: TTimer;
    procedure GLParticles1ActivateParticle(Sender: TObject;
      particle: TGLBaseSceneObject);
    procedure Sprite1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
     
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  MediaPath: String;
begin
  SetGLSceneMediaDir;
  MediaPath := GetCurrentDir + '\';
  Sprite1.Material.Texture.Image.LoadFromFile(MediaPath + 'Flare1.bmp');
  // if we don't do this, our random won't look like random
  Randomize;
end;

procedure TForm1.GLParticles1ActivateParticle(Sender: TObject;
  particle: TGLBaseSceneObject);
begin
  // this event is called when a particle is activated,
  // ie. just before it will be rendered
  with TGLSprite(particle) do
  begin
    with Material.FrontProperties do
    begin
      // we pick a random color
      Emission.Color := PointMake(Random, Random, Random);
      // our halo starts transparent
      Diffuse.Alpha := 0;
    end;
    // this is our "birth time"
    TagFloat := GLCadencer1.CurrentTime;
  end;
end;

procedure TForm1.Sprite1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  life: Double;
begin
  with TGLSprite(Sender) do
  begin
    // calculate for how long we've been living
    life := (newTime - TagFloat);
    if life > 10 then
      // old particle to kill
      GLParticles1.KillParticle(TGLSprite(Sender))
    else if life < 1 then
      // baby particles become brighter in their 1st second of life...
      Material.FrontProperties.Diffuse.Alpha := life
    else // ...and slowly disappear in the darkness
      Material.FrontProperties.Diffuse.Alpha := (9 - life) / 9;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // every timer, we create a particle at a random position
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  with TGLSprite(GLParticles1.CreateParticle).Position do
  begin
    X := 3 * (Random - 0.5);
    Y := 3 * (Random - 0.5);
    Z := 3 * (Random - 0.5);
  end;
  // infos for the user
  Caption := 'Particles - ' + Format('%d particles, %.1f FPS',
    [GLParticles1.Count - 1, GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  // change focal so the view will shrink and not just get clipped
  GLCamera1.FocalLength := 50 * Width / 280;
end;

end.
