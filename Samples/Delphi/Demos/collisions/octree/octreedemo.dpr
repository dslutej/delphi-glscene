{: Octree raycast/mesh sample.<p>
   Demonstrating how to find the intersection point between eye-screen ray
   and a high poly mesh with an Octree property.

   To see the performance difference:
  -move mouse around on the scene with octree disabled (default)
   -check the "octree enabled" box.  Note the frame-rate difference.

   .<p>
}
program octreedemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
