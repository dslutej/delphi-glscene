{: Demo for Occlusion Querying (also includes timer query).<p>

   Occlusion querying is useful for counting how many pixels (or samples) of an
   object are visible on screen.<p>

   This demo renders a few objects normally, then queries how many pixels are
   visible of the objects rendered between the start of the query and the
   end of the query (the objects contained inside dcTestObjects dummycube).<p>

   Any objects rendered after the query has finished won't be included in the
   results.<p>

   A timer query is also included to see how long it takes to render the same
   objects.
}
program OcclusionQuery;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
