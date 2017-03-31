{: Advenced for the TGLHeightField object.<p>

   Check the fxy sample first.<p>

   This sample shows a few more tricks : how to switch formulas at run-time,
   effects of base grid extents and resolution change as well as color and
   lighting options of the TGLHeightField.<p>

   Note that maxed out grid size and minimum step (high resolution) will bring
   most of todays cards to their knees (if they do not just crash, that is).<p>

   Used formulas :<p>
   The Formula1 is of type Sin(d)/(1+d), with d=sqr(x)+sqr(y), you may note
   the interesting sampling-interference effect with big step values (low res)
   and remember your math teacher's warnings on graph-plotting :)<p>

   Formula2 is a more classic sin*cos mix<p>

   Dynamic is the third formula, if you pick it, a small ball will appear and
   move around, the plotted formula being the square distance to the ball.
}
program heightfield;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
