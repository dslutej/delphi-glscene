//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  Design time registration code for the Sounds

  History:
    01/12/15 - PW - Creation.
}
unit GLSoundRegister;

interface

uses
  System.Classes,
  GLSMBASS,
  GLSMFMOD,
  GLSMOpenAL,
  GLSMWaveOut;

procedure Register;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// Register
//
procedure Register;
begin
  RegisterComponents('GLScene',[TGLSMBASS,TGLSMFMOD,TGLSMOpenAL,TGLSMWaveOut]);
end;

end.
