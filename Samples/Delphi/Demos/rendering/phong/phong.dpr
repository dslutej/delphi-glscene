{: Per-Pixel phong shading demo.<p>

   The TGLPhongShader implements phong shading through the use of an
   ARB vertex and fragment program. So far only the material and light
   properties are supported, some form of texture support will be
   added in future updates.<p>

}
program phong;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
