{: PFX and FullScreen demo.<p>

   A basic sample for the PFX and the possibility to specify several colors
   to use throughout the life of the particles, additionnally it shows how
   to use the FullScreenViewer and avoid some pitfalls.<br>
   There are two PFXs actually, one rendering a spiral with colors from
   yellow (top), then blue, green and red (bottom); the second fades from
   blue to white and "explodes" periodically. The PFX depth-sorts particles
   for the whole scene, so these two systems can coexits peacefully without
   artefacts.<p>

   All movements and PFX parameters (except explosions) were defined at design-time.<p>

   You can switch to full-screen by double-clicking the viewer (and to get back
   to windowed mode, double click, hit ESC or ALT+F4).<p>

   For both windowed and full-screen modes, dragging the mouse with the right
   button pressed will move the camera so you may appreciate the 3D nature of
   the particle system. :)
}
program spiral;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
