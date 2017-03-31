{: Basic interactive object picking<p>

	This is a bare bones sample on the use of the GetPickedObject function.
	Two events are handled : OnMouseMove triggers a color change (grey/red) when
	the mouse is moved over an object, and a message popups when an object is
	clicked in OnMouseDown.<p>

	In a real world proggie, both events should make use of the oldPick variable
	(since you can't click what is not under the mouse, the GetPickedObject in
	OnMouseDown returns what we already have in oldPick, set during the last
	OnMouseMove).
}
program Pick;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
