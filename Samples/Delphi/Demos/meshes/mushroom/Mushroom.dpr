{: Mushroom frenzy : demonstrates loading 3DS files and using proxy objects.<p>

   In this sample, we have a single 3DS mesh (a mushroom), and we want to display
   a whole bunch of mushrooms. To reach this goal, we use a TGLFreeForm and load
   the 3DS mesh with its "LoadFromFile" method.<p>

   The other mushrooms are obtained with proxy objects (see "AddMushrooms"),
   our freeform is used as MasterObject, the scale and position are then randomized
   and scattered around our ground (a textured disk).<p>

   This results could also have been obtained by creating FreeForms instead of
   ProxyObjects, but using ProxyObjects avoids duplicating mesh data and helps
   in sustaining better framerates (the same data and build list is shared among
   all mushrooms).
}
program Mushroom;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
