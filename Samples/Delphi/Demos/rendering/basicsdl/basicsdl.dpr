{: Basic demo for using the SDLViewer in GLScene.<p>

   The SDL Viewer allows to use SDL for setting up OpenGL, but still render
   with GLScene. The main differences are that SDL has no design-time preview
   and that  only one OpenGL window may exists throughout the application's
   lifetime (you may have standard forms around it, but as soon as the SDL
   window is closed, the application terminates.<p>

   The SDL viewer is more suited for games or simple apps that aim for
   cross-platform support, for SDL is available on multiple platforms.
   SDL also provides several game-related support APIs for sound, controlers,
   video etc. (see http://www.libsdl.org).<p>

   The rendered scene is similar to the one in the materials/cubemap demo.
}
program basicsdl;

uses
  Forms,
  Unit1 in 'Unit1.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
