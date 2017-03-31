{: Advanced Demo for the GLScene Portal Renderer.<p>

   This example is quite big since it include a small "maze editor" : the grid
   defines walls and open areas, ala Wolfenstein maps, and the viewer displays
   the result interactively.<p>

   The portal mesh generation has been compacted in BBProcess but does not
   generate a "perfect" portal mesh, indeed it is some kind of a worst case
   situation since there are many more portals than actual polygons.<p>

   The GLScene portal object can handle all kind of polygonal descriptions,
   with not necessarily convex polygons, and non necessarily closed areas.
   It is optimized for T&L accelerated cards ie. only an ultra-basic culling is
   performed. It hasn't been tested on many map styles or 3D boards yet, but this
   approach just tramples any "classic" (CPU-intensive) portal renderers on my
   GeForce... not sure how it will scale, though.
}
program Portal;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
