program GLSViewer;

{: GLScene Viewer based on GLSViewer by Eric Grange
   http://www.sourceforge.net/projects/glscene
}

uses
  Forms,
  fGLForm in 'Source\fGLForm.pas' {GLForm},
  fGLDialog in 'Source\fGLDialog.pas' {GLDialog},
  fMain in 'Source\fMain.pas' {MainForm},
  uNavCube in 'Source\uNavCube.pas',
  uGlobals in 'Source\uGlobals.pas',
  uSettings in 'Source\uSettings.pas',
  dGLSViewer in 'Source\dGLSViewer.pas' {dmGLSViewer: TDataModule},
  fGLAbout in 'Source\fGLAbout.pas' {GLAbout},
  fGLOptions in 'Source\fGLOptions.pas' {GLOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GLSViewer';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmGLSViewer, dmGLSViewer);
  Application.Run;
end.
