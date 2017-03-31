{: Simple projective shadows.<p>

   The TGLShadowPlane component allows to render simple projective shadows.
   They have the benefit of being quite fast, but as the name says, your shadows
   will be projected only on a plane and  must be (entirely) on the same side
   of the plane as the light (the side pointed by the plane's direction).<p>
   Note that stenciling is required for proper operation (it is an option of
   the Viewer.Buffer.ContextOptions), which should be available on all modern
   graphics hardware. When stenciling is not activated, the ShadowPlane will
   use opaque shadows and you may see shadows appear beyond the plane limits...<p>

   The higher quality lighting on the marble planes is obtained by specifying
   Tiles in the plane and removing 'psSingleQuad' from the style. Lighting
   is computed per-vertex, this changes increase drastically the number of
   vertices that make up the planes, thus allowing for better lighting.
}
program shadowplane;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
