//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  DesignTime registration code for the Physics Managers

  History:
    12/01/16 - PW - Combined ODE&NGD register procedures
    18/06/03 - SG - Creation.
}

unit GLPhysicsRegister;

interface

uses
  System.Classes,
  GLODEManager,
  GLNGDManager;

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
  RegisterClasses([TGLODEManager, TGLODEJointList, TGLODEJoints, TGLODEElements,
                   TGLNGDManager, TGLNGDDynamic, TGLNGDStatic]);
  RegisterComponents('GLScene',[TGLODEManager,TGLODEJointList,
                                TGLNGDManager]);
end;

end.
