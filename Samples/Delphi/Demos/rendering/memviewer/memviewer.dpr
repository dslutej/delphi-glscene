{: Rendering to a TMemoryViewer and using the render as texture.<p>

   This sample illustrates use of the TGLMemoryViewer to render to a texture.
   The simple scene features a lone cube, when rendered to the memory viewer,
   a red background is used (the TGLSceneViewer uses a gray background).<p>

   After each main viewer render, the scene is rendered to the memory viewer
   and the result is copied to the texture of the cube (a "BlankImage" was
   defined at runtime, because we only need to specify the texture size).
   Most of the time, you won't need to render textures at each frame, and a set
   options illustrates that. The 1:2 mode is significantly faster and visually
   equivalent (even with VSync on, to limit the framerate).<p>

   Never forget a memory viewer will use 3D board memory, thus reducing
   available space for GLVectorGeometry and textures... try using only one memory
   viewer and maximize its use.

   This sample will only work on 3D boards that support WGL_ARB_pbuffer, which
   should be the case for all of the modern boards, and even some of the older
   ones.
}

program Memviewer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
