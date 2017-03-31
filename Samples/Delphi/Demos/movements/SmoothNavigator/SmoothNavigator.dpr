{: GLSmoothNavigator Demo<p>

  A demo that shows what all classes inside the GLSmoothNavigator.pas unit
  are capable of.

  Note: there are lines commented out. These were used to manually set mouse
  position (useful in some cases).

  Version history:
    23/02/07 - DaStr - Initial version (contributed to GLScene)

}
program SmoothNavigator;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
