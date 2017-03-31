{: Post Shader Demo<p>

  A demo that demostrates how to use different post shaders together.
  More post shaders will be added to it later on.

  Version history:
    12/06/07 - DaStr - Small cosmetic fixes
    05/04/07 - DaStr - Initial version
}
program PostShader;

uses
  Forms,
  UMainForm in 'UMainForm.pas' {PostShaderDemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPostShaderDemoForm, PostShaderDemoForm);
  Application.Run;
end.
