{: Scripted OpenGL.<p>

   This demo shows how DWS2 can be used to script OpenGL
   calls. While this demo simply draws a cube, the same
   principles could easily be applied to a user shader
   to allow for scripted shading of materials. Try adding
   to or changing the script and press compile to see the
   results. If there is an error in the script it will
   be displayed in the HUD text object.<p>

   Not all OpenGL functions are available, but most of the
   commonly used functions are supplied and almost all
   of the constants. The list of supported functions can
   be extended in the future should the need arise.<p>
}
program glscript;

uses
  Forms,
  main in 'main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
