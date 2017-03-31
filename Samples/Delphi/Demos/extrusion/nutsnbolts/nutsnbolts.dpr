{: A Nut and Bolt sample, 100% defined at design-time.<p>

   Both use two revolution solids, one for the head/pans, another for the thread.
   Additionnally, a cylinder and an annulus help finish up by providing the
   shafts.<p>

   The head/pans are defined by simple rotated on 360� in 6 steps, the threads
   are a simpler curve : two segments in triangular shape, that are rotated and
   extruded in the y axis.<p>

   Smoothing is used in the head to make smoother edges (along with a bevel in
   the curve), while the threads are unsmoothed, to get a sharp edge effect.
}
program nutsnbolts;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
