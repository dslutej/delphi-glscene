{: An FireFX demo showcasing use of explosions.<p>

   In this sample, a small sphere is thrusted upward (with a gravity-like
   deceleration) with a small fire trail, explodes (in one of two styles,
   isotropic or ring, chosen at random), and falls back followed by a smoke
   trail.<br>
   The explosion takes place in 3D, to help you visualize it, hold the mouse
   button down and move around.<p>

   Two FireFXManager components are used, one for the fire, the other for
   the smoke. The explosion is triggered by calling IsotropicExplosion, which
   generates and "isotropic" population of particles that move away from the
   object position.<p>

   Note that to have trail effects, you must adjust the Reference property of
   a FireFX manager. It is unadjusted, the particles will not be "left behind",
   which is convenient for static fireplaces, but not for trials.
}
program boom;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
