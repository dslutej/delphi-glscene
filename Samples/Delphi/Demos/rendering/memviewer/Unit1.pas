unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Imaging.JPeg,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  
  GLScene,
  GLObjects,
  GLCadencer,
  GLTexture,
  GLWin32Viewer,
  GLCrossPlatform,
  GLCoordinates,
  GLBaseClasses,
  GLContext,
  OpenGLAdapter;


type
  TForm1 = class(TForm)
    Timer1: TTimer;
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    Cube1: TGLCube;
    GLLightSource1: TGLLightSource;
    GLMemoryViewer1: TGLMemoryViewer;
    GLCadencer1: TGLCadencer;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    RB1to1: TRadioButton;
    RB1to2: TRadioButton;
    RB1to10: TRadioButton;
    CheckBox1: TCheckBox;
    LabelFPS: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure CheckBox1Click(Sender: TObject);
    procedure GLSceneViewer1AfterRender(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RB1to1Click(Sender: TObject);
  private
     
    textureFramerateRatio, n: Integer;
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  textureFramerateRatio := 1;
  n := 0;
end;

procedure TForm1.RB1to1Click(Sender: TObject);
begin
  textureFramerateRatio := (Sender as TRadioButton).Tag;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    GLSceneViewer1.VSync := vsmSync
  else
    GLSceneViewer1.VSync := vsmNoSync;
end;

procedure TForm1.GLSceneViewer1AfterRender(Sender: TObject);
begin
  if not GLSceneViewer1.Buffer.RenderingContext.GL.W_ARB_pbuffer then
  begin
    ShowMessage('WGL_ARB_pbuffer not supported...'#13#10#13#10
      + 'Get newer graphics hardware or try updating your drivers!');
    GLSceneViewer1.AfterRender := nil;
    Exit;
  end;
  Inc(n);
  try
    if n >= textureFramerateRatio then
    begin
      // render to the viewer
      GLMemoryViewer1.Render;
      // copy result to the textures
      GLMemoryViewer1.CopyToTexture(Cube1.Material.Texture);
      n := 0;
    end;
  except
    // pbuffer not supported... catchall for exotic ICDs...
    GLSceneViewer1.AfterRender := nil;
    raise;
  end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  DummyCube1.TurnAngle := newTime * 60;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  LabelFPS.Caption := Format('GLScene Memory Viewer'+' - %.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

end.

