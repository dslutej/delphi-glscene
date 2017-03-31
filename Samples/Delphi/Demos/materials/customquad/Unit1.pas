unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  
  GLCadencer, GLScene, GLObjects, GLTexture, GLBehaviours,
  GLWin32Viewer, GLGeomObjects, GLColor, GLCrossPlatform, GLMaterial,
  GLCoordinates, GLBaseClasses, GLRenderContextInfo;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLMaterialLibrary: TGLMaterialLibrary;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    Torus1: TGLTorus;
    DirectOpenGL1: TGLDirectOpenGL;
    GLLightSource1: TGLLightSource;
    GLCadencer1: TGLCadencer;
    procedure DirectOpenGL1Render(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations  }
  public
    { Public declarations  }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses OpenGLTokens, GLContext, GLState, GLUtils;

procedure TForm1.FormCreate(Sender: TObject);
begin
   SetGLSceneMediaDir();
   // dynamically create 2 materials and load 2 textures
   with GLMaterialLibrary do begin
      with AddTextureMaterial('wood', 'ashwood.jpg') do
      begin
         Material.FrontProperties.Emission.Color:=clrGray50;
         Material.FaceCulling := fcNoCull;
      end;
      with AddTextureMaterial('stone', 'walkway.jpg') do
      begin
         Material.FrontProperties.Emission.Color:=clrGray50;
         Material.FaceCulling := fcNoCull;
      end;
   end;
end;

procedure TForm1.DirectOpenGL1Render(Sender: TObject; var rci: TGLRenderContextInfo);
var
   material : TGLLibMaterial;
begin
   // 1st quad, textured with 'wood', using standard method
   GLMaterialLibrary.ApplyMaterial('wood', rci);
   GL.Begin_(GL_QUADS);
      GL.TexCoord2f(0, 1);  GL.Vertex3f(0.5, 0.5, -0.5);
      GL.TexCoord2f(0, 0);  GL.Vertex3f(-0.5, 0.5, -0.5);
      GL.TexCoord2f(1, 0);  GL.Vertex3f(-0.5, 0, 0.5);
      GL.TexCoord2f(1, 1);  GL.Vertex3f(0.5, 0, 0.5);
   GL.End_;
   GLMaterialLibrary.UnApplyMaterial(rci);
   // 2nd quad, textured with 'stone'
   // we "manually" apply the material, this can be usefull if you want to have
   // some dynamic material control
   material:=GLMaterialLibrary.Materials.GetLibMaterialByName('stone');
   material.Material.Apply(rci);
   GL.Begin_(GL_QUADS);
      GL.TexCoord2f(0, 1);  GL.Vertex3f(0.5, -0.5, -0.5);
      GL.TexCoord2f(0, 0);  GL.Vertex3f(0.5, 0, 0.5);
      GL.TexCoord2f(1, 0);  GL.Vertex3f(-0.5, 0, 0.5);
      GL.TexCoord2f(1, 1);  GL.Vertex3f(-0.5, -0.5, -0.5);
   GL.End_;
   material.Material.UnApply(rci);
end;

end.
