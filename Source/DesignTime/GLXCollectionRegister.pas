//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   Register TGLXCollection property editor 
  
   History :  
       20/05/10 - Yar - Fixes for Linux x64
       11/11/09 - DaStr - Improved FPC compatibility
                             (thanks Predator) (BugtrackerID = 2893580)
       03/07/04 - LR - Removed ..\ from the GLScene.inc
       16/04/00 - Egg - Creation
	 
}
unit GLXCollectionRegister;

interface

{$I GLScene.inc}

uses
  System.Classes,
  GLXCollection,

  DesignEditors, DesignIntf;

type
	// TGLXCollectionProperty
	//
	TGLXCollectionProperty = class(TClassProperty)
		public
			
			function GetAttributes: TPropertyAttributes; override;
			procedure Edit; override;
	end;

procedure Register;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
uses
  FXCollectionEditor;


//----------------- TGLXCollectionProperty ------------------------------------

// GetAttributes
//
function TGLXCollectionProperty.GetAttributes: TPropertyAttributes;
begin
	Result:=[paDialog];
end;

// Edit
//
procedure TGLXCollectionProperty.Edit;
begin
   with GLXCollectionEditorForm do begin
     SetXCollection(TGLXCollection(GetOrdValue), Self.Designer);
     Show;
   end;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TGLXCollection), nil, '', TGLXCollectionProperty);
end;


// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

	// class registrations

end.
