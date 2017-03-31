{ demo showing the use of fog in GLScene<p>
   20/07/03 - php - started
 }
program fog;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
