{: TGLTilePlane demo.<p>

   Illustrates the use of TGLTilePlane to render an area made of tiled
   textures placed in a grid. The components links to a materiallibrary
   (containing tile materials, referred by index) and renders the area
   with quads sorted by material.<br>
   The size of the area for TGLTilePlane is infinite (i.e. limited by
   available memory) and adjusts itself dynamically.<p>

   The tile overlap can be adjusted by the texture coordinates scaling
   of the material, for instance, the "marbletiles" texture covers 4 tiles
   and the "walkway" texture covers 2 tiles in this demo.<p>

   Note that if you don't have a "pro" OpenGL card, the grid with its smoothed
   lines may cost you a lot of FPS, so you may want to turn it off for
   performance assessments.
}
program tiles;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
