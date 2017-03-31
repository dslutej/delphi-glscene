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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  
  GLScene,
  GLObjects,
  GLExtrusion,
  GLCadencer,
  GLVectorGeometry,
  GLWin32Viewer,
  GLCrossPlatform,
  GLCoordinates,
  GLBaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    Pipe1: TGLPipe;
    GLCadencer1: TGLCadencer;
    CBSpline: TCheckBox;
    DummyCube1: TGLDummyCube;
    CBFat: TCheckBox;
    Timer1: TTimer;
    PanelFPS: TPanel;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure CBSplineClick(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
     
  public
     
    mx, my : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
   Pipe1.Nodes[2].X:=1*Sin(newTime*60*cPIdiv180);
   if CBFat.Checked then
      TGLPipeNode(Pipe1.Nodes[1]).RadiusFactor:=1+Cos(newTime*30*cPIdiv180)
   else
     TGLPipeNode(Pipe1.Nodes[1]).RadiusFactor:=1;
end;

procedure TForm1.CBSplineClick(Sender: TObject);
begin
   if CBSpline.Checked then
      Pipe1.SplineMode:=lsmCubicSpline
   else Pipe1.SplineMode:=lsmLines;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   if Shift<>[] then
      GLCamera1.MoveAroundTarget(my-y, mx-x);
   mx:=x; my:=y;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   with GLSceneViewer1 do begin
      PanelFPS.Caption:=Format('%d Triangles, %.1f FPS', [Pipe1.TriangleCount, FramesPerSecond]);
      ResetPerformanceMonitor;
   end;
end;

end.
