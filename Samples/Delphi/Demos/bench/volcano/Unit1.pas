unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,

  
  GLScene,
  GLObjects,
  GLParticleFX,
  GLCadencer,
  GLBehaviours,
  GLWin32Viewer, GLCrossPlatform, GLCoordinates,
  GLBaseClasses;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    DCVolcano: TGLDummyCube;
    PFXVolcano: TGLPolygonPFXManager;
    GLCadencer1: TGLCadencer;
    PFXRenderer: TGLParticleFXRenderer;
    Timer1: TTimer;
    Sphere1: TGLSphere;
    GLLightSource1: TGLLightSource;
    PFXBlue: TGLPolygonPFXManager;
    DCCamera: TGLDummyCube;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure Timer1Timer(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
   GLSceneViewer1.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   Panel1.Caption:=Format('%.1f FPS - %3d Particles - Depth Sort: %.2f msec',
                   [GLSceneViewer1.FramesPerSecond,
                    PFXVolcano.Particles.ItemCount+PFXBlue.Particles.ItemCount,
                    PFXRenderer.LastSortTime]);
   GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
var
   source : TGLSourcePFXEffect;
begin
   source:=GetOrCreateSourcePFX(DCVolcano);
   case RadioGroup1.ItemIndex of
      0 : source.ParticleInterval:=0.1;
      1 : source.ParticleInterval:=0.05;
      2 : source.ParticleInterval:=0.02;
      3 : source.ParticleInterval:=0.01;
      4 : source.ParticleInterval:=0.005;
      5 : source.ParticleInterval:=0.001;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   RadioGroup1Click(Self);
end;

end.
 