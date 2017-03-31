{: Using the GLBumpShader for object space bump mapping.<p>

   The bump shader runs an ambient light pass and a pass for
   each light shining in the scene. There are currently 2
   bump methods: a dot3 texture combiner and a basic ARB
   fragment program.<p>

   The dot3 texture combiner only supports diffuse lighting
   but is fast and works on lower end graphics adapters.<p>

   The basic ARBFP method supports diffuse and specular
   lighting<p>

   Both methods pick up the light and material options
   through the OpenGL state.<p>

   The normal map is expected as the primary texture.<p>

   Diffuse textures are supported through the secondary
   texture and can be enabled using the boDiffuseTexture2
   bump option.<p>

   Specular textures are supported through the tertiary
   texture and can be enabled using the boSpecularTexture3
   bump option and setting the SpecularMode to smBlinn or
   smPhong (smOff will disable specular in the shader).<p>

   With the boLightAttenutation flag set the shader will
   use the OpenGL light attenuation coefficients when
   calculating light intensity.<p>
}
program bunnybump;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
