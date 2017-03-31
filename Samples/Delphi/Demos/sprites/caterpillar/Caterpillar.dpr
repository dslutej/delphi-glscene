{: Sample showing use of TGLSprite for "caterpillar" effect.<p>

	A bunch of TGLSprite is created in FormCreate, all copied from Sprite2 (used
	as "template"), then we move and resize them as they orbit a pulsating "star".<br>
	Textures are loaded from a "flare1.bmp" file that is expected to be in the
	same directory as the compiled EXE.<p>

	There is nothing really fancy in this code, but in the objects props :<ul>
		<li>blending is set to bmAdditive (for the color saturation effect)
      <li>DepthTest is disabled
		<li>ball color is determined with the Emission color
	</ul><br>
	The number of sprites is low to avoid stalling a software renderer
	(texture alpha-blending is a costly effect), if you're using a 3D hardware,
	you'll get FPS in the hundredths and may want to make the sprite count higher.<p>

	A material library component is used to store the material (and texture) for
	all the sprites, if we don't use it, sprites will all maintain their own copy
	of the texture, which would just be a waste of resources. With the library,
	only one texture exists (well, two, the sun has its own).
}
program Caterpillar;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
