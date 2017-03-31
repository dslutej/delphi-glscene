//---------------------------------------------------------------------------

#include <System.hpp>
#include <tchar.h>
#pragma hdrstop
USEFORMNS("..\..\Source\DesignTime\FRTextureEdit.pas", Frtextureedit, RTextureEdit); /* TFrame: File Type */
USEFORMNS("..\..\Source\DesignTime\FRTrackBarEdit.pas", Frtrackbaredit, RTrackBarEdit); /* TFrame: File Type */
USEFORMNS("..\..\Source\DesignTime\FSceneEditor.pas", Fsceneeditor, GLSceneEditorForm);
USEFORMNS("..\..\Source\DesignTime\FPlugInManagerEditor.pas", Fpluginmanagereditor, GLPlugInManagerEditorForm);
USEFORMNS("..\..\Source\DesignTime\FRColorEditor.pas", Frcoloreditor, RColorEditor); /* TFrame: File Type */
USEFORMNS("..\..\Source\DesignTime\FXCollectionEditor.pas", Fxcollectioneditor, GLXCollectionEditorForm);
USEFORMNS("..\..\Source\DesignTime\FShaderUniformEditor.pas", Fshaderuniformeditor, GLShaderUniformEditor);
USEFORMNS("..\..\Source\DesignTime\FVectorEditor.pas", Fvectoreditor, GLVectorEditorForm);
USEFORMNS("..\..\Source\DesignTime\FInfo.pas", Finfo, GLInfoForm);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------


#pragma argsused
extern "C" int _libmain(unsigned long reason)
{
	return 1;
}
//---------------------------------------------------------------------------
