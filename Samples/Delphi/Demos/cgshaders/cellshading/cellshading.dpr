{: Simple cell shading with CgShaders.<p>

   This demo uses a vertex program to combine the normal and
   light vector to produce a light intensity which is passed
   to the fragment program as the 3rd element in the texture
   coordinate stream. This intensity is then clamped to specific
   values based on the range the intensity falls into. This is
   how the cells are created. You can add or remove cells by
   adding and removing ranges from the intensity clamping in
   the fragment program. This intensity is multiplied to the
   color value for each fragment retrieved from the texture
   map. Using solid colors on the texture gives nice results
   once cell shaded.<p>

   While this demo only shows parallel lighting, you could use
   point lights quite easily by modifying the uniform
   parameters passed to the vertex program and the processing
   of the intensity. Multiple lights wouldn't be difficult
   to implement either.<p>
}
program cellshading;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
