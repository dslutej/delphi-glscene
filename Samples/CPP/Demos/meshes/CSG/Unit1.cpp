//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "GLBaseClasses"
#pragma link "GLCoordinates"
#pragma link "GLCrossPlatform"
#pragma link "GLMaterial"
#pragma link "GLObjects"
#pragma link "GLScene"
#pragma link "GLVectorFileObjects"
#pragma link "GLWin32Viewer"
#pragma link "GLFile3DS"

#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  SetGLSceneMediaDir();
  // scaled 40
  GLFreeForm1->LoadFromFile("polyhedron.3ds");

  // scaled 20, position.x = 16
  GLFreeForm2->LoadFromFile("polyhedron.3ds");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewer1MouseDown(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y)
{
 Drag = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewer1MouseUp(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y)
{
  Drag = false;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewer1MouseMove(TObject *Sender, TShiftState Shift,
          int X, int Y)
{
  if (Drag)
	GLCamera1->MoveAroundTarget(my-Y, mx-X);
  mx = X;
  my = Y;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormMouseWheelDown(TObject *Sender, TShiftState Shift, TPoint &MousePos,
		  bool &Handled)
{
  GLCamera1->AdjustDistanceToTarget(1.1);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormMouseWheelUp(TObject *Sender, TShiftState Shift, TPoint &MousePos,
		  bool &Handled)
{
  GLCamera1->AdjustDistanceToTarget(1/1.1);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ButtonClearClick(TObject *Sender)
{
  GLFreeForm3->MeshObjects->Clear();
  GLFreeForm3->StructureChanged();

  GLFreeForm1->Material->PolygonMode = pmFill;
  GLFreeForm2->Material->PolygonMode = pmFill;

}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  TMeshObject *Mesh;

  ButtonClearClick(Sender);
  if (GLFreeForm3->MeshObjects->Count == 0)
  {
//Delphi:  TMeshObject.CreateOwned(GLFreeForm3.MeshObjects).Mode := momFaceGroups;
	Mesh = new  (TMeshObject);
	Mesh->Mode = momFaceGroups;
  }
// Delphi:  Mesh := GLFreeForm3.MeshObjects[0];
// Mesh = GLFreeForm3->MeshObjects->Items[0];
  CSG_Operation(GLFreeForm1->MeshObjects->Items[0],
				GLFreeForm2->MeshObjects->Items[0],
				CSG_Union,Mesh,'1','2');
  GLFreeForm3->StructureChanged();

  GLFreeForm1->Material->PolygonMode = pmLines;
  GLFreeForm2->Material->PolygonMode = pmLines;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button3Click(TObject *Sender)
{
  TMeshObject *Mesh;

  ButtonClearClick(Sender);

  if (GLFreeForm3->MeshObjects->Count == 0)
  {
//Delphi:  TMeshObject.CreateOwned(GLFreeForm3.MeshObjects).Mode := momFaceGroups;
   Mesh = new (TMeshObject);
   Mesh->Mode = momFaceGroups;
  }
// Delphi:  Mesh := GLFreeForm3.MeshObjects[0];
//  Mesh = GLFreeForm3->MeshObjects->Items[0];

  CSG_Operation(GLFreeForm1->MeshObjects->Items[0],
				GLFreeForm2->MeshObjects->Items[0],
				CSG_Subtraction,Mesh,'1','2');
  GLFreeForm3->StructureChanged();

  GLFreeForm1->Material->PolygonMode = pmLines;
  GLFreeForm2->Material->PolygonMode = pmLines;

}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button4Click(TObject *Sender)
{
  TMeshObject *Mesh;

  ButtonClearClick(Sender);

  if (GLFreeForm3->MeshObjects->Count == 0)
  {
//Delphi:  TMeshObject.CreateOwned(GLFreeForm3.MeshObjects).Mode := momFaceGroups;
   Mesh = new (TMeshObject);
   Mesh->Mode = momFaceGroups;
  }
// Delphi:  Mesh := GLFreeForm3.MeshObjects[0];
//  Mesh = GLFreeForm3->MeshObjects->Items[0];

  CSG_Operation(GLFreeForm2->MeshObjects->Items[0],
				GLFreeForm1->MeshObjects->Items[0],
				CSG_Subtraction,Mesh,'1','2');
  GLFreeForm3->StructureChanged();

  GLFreeForm1->Material->PolygonMode = pmLines;
  GLFreeForm2->Material->PolygonMode = pmLines;

}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button5Click(TObject *Sender)
{
  TMeshObject *Mesh;

  ButtonClearClick(Sender);

  if (GLFreeForm3->MeshObjects->Count == 0)
  {
//Delphi:  TMeshObject.CreateOwned(GLFreeForm3.MeshObjects).Mode := momFaceGroups;
   Mesh = new (TMeshObject);
   Mesh->Mode = momFaceGroups;
  }
// Delphi:  Mesh := GLFreeForm3.MeshObjects[0];
//  Mesh = GLFreeForm3->MeshObjects->Items[0];

  CSG_Operation(GLFreeForm1->MeshObjects->Items[0],
				GLFreeForm2->MeshObjects->Items[0],
				CSG_Intersection,Mesh,'1','2');
  GLFreeForm3->StructureChanged();

  GLFreeForm1->Material->PolygonMode = pmLines;
  GLFreeForm2->Material->PolygonMode = pmLines;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::CheckBox1Click(TObject *Sender)
{
  if (CheckBox1->Checked)
  {
	GLMaterialLibrary1->Materials->Items[0]->Material->PolygonMode = pmFill;
	GLMaterialLibrary1->Materials->Items[1]->Material->PolygonMode = pmFill;
  }
  else
  {
	GLMaterialLibrary1->Materials->Items[0]->Material->PolygonMode = pmLines;
	GLMaterialLibrary1->Materials->Items[1]->Material->PolygonMode = pmLines;
  }
  GLFreeForm3->StructureChanged();
}
//---------------------------------------------------------------------------

