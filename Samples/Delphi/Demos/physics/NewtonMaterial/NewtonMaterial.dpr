{ : Newton Game Dynamics Physics Engine demo.<p>

  This demo demontrate how to use material (or surface) effect of newton.
  Manager owns SurfaceItems and SurfacePair list where we can adjust
  elasticity,friction... between two SurfaceItems.
  We set SurfaceItems for each NGDBehaviours, and in SurfacePair,
  we choose the two group-id wich perform these effects.

  Actually we can't set surfaceItem on behaviour (or on surfacePair)
  in design time. This must be done in runtime.

  <b>History : </b><font size=-1><ul>
  <li>31/01/11 - FP - Update for GLNGDManager
  <li>17/09/10 - FP - Created by Franck Papouin
  </ul>
}
program NewtonMaterial;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
