{: Using the TJoystick to retrieve joystick position.<p>

   The component make it fairly easy to get this info. The first method is to use
   the events, the second it use its properties.<br>
   I've tried to put both methods at use in this sample :<ul>
   <li>spheres on the right are adjusted when button are pressed/depressed
   <li>the 3D stick position is read in the rendering loop
   </ul>
}
program JoystickDemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
