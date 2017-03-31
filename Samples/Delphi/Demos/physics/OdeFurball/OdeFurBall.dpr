//
{: Using Verlet Hair with ODE; Fur Balls<p> }
//
program OdeFurBall;

uses
  Forms,
  fFurBall in 'fFurBall.pas' {frmFurBall};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFurBall, frmFurBall);
  Application.Run;
end.
