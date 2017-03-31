{: This is a basic use for TGLBInertia behaviour.<p>

	There are three objects, which we assign three different dampings, and we
	apply a torque to the object under the mouse pointer, other are left along
	with their inertia (and damping makes them progressively reduce their speed).<br>
	There is also a checkbox to double the objects mass.<p>

	Notice how the constant damping stops abruptly the dodecahedron, while the
	the octahedron, once spinned, is slowing down but never really stops.<br>
	However, don't show this sample to your science teacher, since our "torque"
	is actually an angular acceleration in degrees that gets affected by the
	object's mass... Anyway, it looks like a real torque is applied.<p>

	Note that the inertia behaviour could have been accessed directly with a
	TGLBInertia(Behaviours[0]) for all objects in this sample, but using the
	helper function GetOrCreateInertia is a more convenient (and resilient) way,
	since it will automatically add an inertia behaviour to our object if it
	doesn't have one.
}
program Torque;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
