{: This is a basic use for the Dynamic Collision Engine (DCE) by Lucas Goraieb.<p>

     The engine pretty much works by creating a TGLDCEManager, and several
     TGLDCEDynamic and TGLDCEStatic behaviours on the objects that should
     interact. Each object can be either an ellipsoid, cube, freeForm or terrain,
     have different sizes and friction, respond differently to collisions, etc.

     This means your next FPS project is pretty much done: All you have to do
     is keep loading object files into freeForms and letting DCE do the trick
     for you. The only "real" code in this demo is inside the onProgress event
     of the cadencer, that takes care of input.
}
program dceDemo;
uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
