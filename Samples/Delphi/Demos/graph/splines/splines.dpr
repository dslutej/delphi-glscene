{: This is a quick demo for the TGLLines object and spline functionality.<p>

   TGLLines can handle normal lines and cubic splines, each node can have a
   different color, and the line can be color-interpolated.<p>

   Note that the camera in this sample is in <i>orthogonal</i> mode, this makes
   for a quick and easy way to work in 2D with OpenGL (try switching the camera
   to perpective mode if you don't see the point).
}
program splines;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
