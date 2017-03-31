{: Scene-wide Particles FX bench.<p>

   Originally planned for the specials FX, but become a bench due to lack of
   time to improve graphics ;)<br>
   This is quite a brute-force situation for the Particles FX Renderer, two
   systems are present (Red an Blue) but Red contains the bulk of the particles.<p>

   Benchmark results (default win size, "Inferno" mode, ie. approx 7000 particles):<p>

   CPU               Graphics          Colors      FPS         Sort Time
   AXP 2200+         GF3 Ti200         32 bits    126.0        0.82 msec
   --- 26/05/04 - Long time no bench
   TBird 1.1GHz      GeForce2 Pro      32 bits    103.8        2.60 msec
   Duron 800MHz      TNT2 M64          32 bits     16.7        3.92 msec
   --- 27/01/02 - ZWrite=False in the PFX Renderer, minor optims
   TBird 1.1GHz      GeForce2 Pro      32 bits     91.7        2.86 msec
   Duron 800MHz      TNT2 M64          32 bits     12.2        4.45 msec
   --- 20/01/02 - Optimized PFX (sort) and TGLPolygonPFXManager (rendering)
   TBird 1.1Ghz      GeForce2 Pro      32 bits     65.5        3.66 msec
   Duron 800MHz      Voodoo3 NT4       16 bits      7.4        5.52 msec
   --- 09/09/01 - Created Benchmark

}
program volcano;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
