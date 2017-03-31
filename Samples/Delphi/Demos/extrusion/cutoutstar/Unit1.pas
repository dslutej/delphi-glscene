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

  
  GLCadencer,
  GLScene,
  GLExtrusion,
  GLVectorGeometry,
  GLMultiPolygon,
  GLWin32Viewer,
  GLCrossPlatform,
  GLCoordinates,
  GLBaseClasses;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    ExtrusionSolid: TGLExtrusionSolid;
    GLCadencer1: TGLCadencer;
    Timer1: TTimer;
    PanelFPS: TPanel;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
     
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
   i : Integer;
   r, x, y : Single;
const
   cSteps = 16;
begin
   // a small star contour
   with ExtrusionSolid.Contours do begin
      with Add.Nodes do for i:=0 to cSteps do begin
         r:=2+(i and 1)*2;
         SinCosine(i*c2PI/cSteps, y, x);
         AddNode(x*r, y*r, 0);
      end;
      // add an empty contour for the square cutout (see progress event)
      Add;
   end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
   x, y : Single;
begin
   // Make our Extrusion roll
   ExtrusionSolid.Roll(deltaTime*10);

   // At each frame, we drop the cutout and make a new.
   // Note that we could also have defined it once in the FormCreate and then moved
   // it around with the TGLNodes methods.
   SinCosine(newTime, 2, y, x);
   with ExtrusionSolid.Contours do begin
      Items[1].Free;
      with Add.Nodes do begin
         AddNode(x-1, y-1, 0);
         AddNode(x+1, y-1, 0);
         AddNode(x+1, y+1, 0);
         AddNode(x-1, y+1, 0);
      end;
   end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   // Standard FPS counter
   PanelFPS.Caption:=Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
   GLSceneViewer1.ResetPerformanceMonitor;
end;

end.
