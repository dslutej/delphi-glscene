{: Demo of the TGLPoints component.<p>

   The component is specialized in rendering large numbers of points,
   with ability to adjust point style (from fast square point to smooth
   round points) and point parameters.<p>
   The point parameters define how point size is adjusted with regard
   to eye-point distance (to make farther points smaller, see ARB_point_parameters
   for more details).<p>
   The component is also suitable for particle systems, but offers less
   flexibility than the TGLParticleFX.
}
program points;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
