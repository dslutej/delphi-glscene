{: The fire special effect basic sample.<p>

   If you look at the code you won't see anything fancy. The FireFX is a dynamic
   special effect (driven by a cadencer). Making use of it means two things :<br>
   - dropping a FirexFXManager, this one controls fire particle systems aspects<br>
   - adding a FireFX effect to the object you want to see burning (here, a sphere)<br>
   You may have multiple objects sharing the same FireFXManager, this means they
   will all look the same, but also that the particle system calculations are
   made only once.<p>

   This effect looks cool but is fill-rate hungry, but un-textured fillrate
   hungry, ie. video card memory bandwith is not an issue. Anyway, you can
   always make it look nice with smaller and/or less particles.
}
program fire;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
