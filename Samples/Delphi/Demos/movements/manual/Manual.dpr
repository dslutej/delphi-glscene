{: This Form demonstrates basic "manual" movements.<p>

	Positions are computed directly using Sin/Cos functions.<p>

	A cadencer is used to "play" the animation, it is not used as a time-controler,
   but just as a way to push the animation as fast as possible. See further
   samples on framerate independance to see how it can be better used.<br>

	Note : when using 3Dfx OPENGL and a Voodoo3 on Win9x in 24bits resolution,
	the driver always uses internal double-buffering (since it can only render
	in 16bits), and keeping the requesting double-buffering in the TGLSceneViewer
	actually results in a "quadruple-buffering"...
}
program Manual;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
