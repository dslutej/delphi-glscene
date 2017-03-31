{:
  A demo for using Alex Denissov's Graphics32 library (http://www.g32.org)
  to generate 2D texture for use with GLScene.<p>

  By Nelson Chu<p>

  Try lighting the white line near the bottom of the window with your mouse
  pointer and see the fire spreads. Press ESC to quit.<p>

  To use Graphics32 with GLScene:<p>

  1. Make sure GLS_Graphics32_SUPPORT is defined in GLSCene.inc. Recompile if
     needed.<br>
  2. In your program, use code like:<br>

       GLTexture.Image.GetBitmap32(0).assign(Bitmap32);<br>
       GLTexture.Image.NotifyChange(self);<br>

     to assign the Bitmap32 to your GLScene texture and notify GLScene.<p>

  To get fast assignment, remember to make the dimensions of your Bitmap32 equal
  to a power of two, so that GLScene doesn't need to do conversion internally.<p>

  In this sample program, a 256 x 256 Graphics32 TByteMap is used to generate a
  "fire" image. At each frame, the fire image is first "visualized" in a
  Graphics32 Bitmap32. Then, the TBitmap32 is copied to the texture of a Cube.
}
program Fire2D;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
