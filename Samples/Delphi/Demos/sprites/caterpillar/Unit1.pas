unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  
  GLScene, GLObjects, GLTexture, GLVectorGeometry,
  GLCadencer, GLWin32Viewer, GLCrossPlatform, GLMaterial,
  GLCoordinates, GLBaseClasses, GLSimpleNavigation, GLProcTextures,
  GLUtils;

type
  TForm1 = class(TForm)
	 GLScene1: TGLScene;
	 GLSceneViewer1: TGLSceneViewer;
	 DummyCube1: TGLDummyCube;
    GLCamera1: TGLCamera;
    Sprite1: TGLSprite;
    Sprite2: TGLSprite;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    GLSimpleNavigation1: TGLSimpleNavigation;
	 procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
	  
  public
	 { Public declatrations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
	Spr : TGLSprite;
  I : Integer;
  MediaPath : String;
begin
  SetGLSceneMediaDir;
 	// Load texture for sprite2, this is the hand-coded way using a PersistentImage
	// Sprite1 uses a PicFileImage, and so the image is automagically loaded by
	// GLScene when necessary (no code is required).
	// (Had I used two PicFileImage, I would have avoided this code)
  GLMaterialLibrary1.TexturePaths := GetCurrentDir;
  MediaPath := GLMaterialLibrary1.TexturePaths + '\';
  Sprite1.Material.Texture.Image.LoadFromFile(MediaPath + 'Flare1.bmp');
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile('Flare1.bmp');
	// New sprites are created by duplicating the template "sprite2"
	for i:=1 to 9 do begin
		spr:=TGLSprite(DummyCube1.AddNewChild(TGLSprite));
		spr.Assign(Sprite2);
	end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
	i : Cardinal;
	a, aBase : Double;
begin
   // angular reference : 90� per second <=> 4 second per revolution
	aBase:=90*newTime;
   // "pulse" the star
   a:=DegToRad(aBase);
   Sprite1.SetSquareSize(4+0.2*cos(3.5*a));
	// rotate the sprites around the yellow "star"
	for i:=0 to DummyCube1.Count-1 do begin
		a:=DegToRad(aBase+i*8);
		with (DummyCube1.Children[i] as TGLSprite) do begin
         // rotation movement
			Position.X:=4*cos(a);
			Position.Z:=4*sin(a);
         // ondulation
      Position.Y:=2*cos(2.1*a);
			// sprite size change
			SetSquareSize(2+cos(3*a));
		end;
	end;
end;


procedure TForm1.FormResize(Sender: TObject);
begin
   // This lines take cares of auto-zooming.
   // magic numbers explanation :
   //  333 is a form width where things looks good when focal length is 50,
   //  ie. when form width is 333, uses 50 as focal length,
   //      when form is 666, uses 100, etc...
   GLCamera1.FocalLength:=Width*50/333;
end;

end.
