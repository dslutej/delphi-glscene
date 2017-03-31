//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "GLBaseClasses"
#pragma link "GLCoordinates"
#pragma link "GLCrossPlatform"
#pragma link "GLFeedback"
#pragma link "GLObjects"
#pragma link "GLPolyhedron"
#pragma link "GLScene"
#pragma link "GLVectorFileObjects"
#pragma link "GLWin32Viewer"
#pragma link "GLMesh"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  TMeshObject *mo;
  TFGIndexTexCoordList *fg;

  // Clear our freeform of any meshes
  GLFreeForm1->MeshObjects->Clear();

  // Set feedback to active, will feedback render child
  // objects into it's buffer
  GLFeedback1->Active = true;

  // Process the first mesh object (GLCube and GLDodecahedron)

  // Make the objects visible that we want to buffer
  MeshObject1->Visible = true;

  // Render the feedback object to buffer it's child object
  // that are visible
  GLSceneViewer1->Buffer->Render(GLFeedback1);

  // Hide the child objects we rendered
  MeshObject1->Visible = false;

  // Create a new mesh object in our freeform
  // Delphi -  mo := TMeshObject.CreateOwned(GLFreeForm1.MeshObjects);
  mo = new TMeshObject;
  mo = (TMeshObject *) (GLFreeForm1->MeshObjects);
  mo->Mode = momTriangles;

  // Process the feedback buffer for polygon data
  // and build a mesh (normals are recalculated
  // since feedback only yields position and
  // texcoords)
  GLFeedback1->BuildMeshFromBuffer(
	mo->Vertices, mo->Normals, mo->Colors, mo->TexCoords, NULL);

  // Process the second mesh object (GLSphere)
  // (comments from first mesh object apply here also)
  MeshObject2->Visible = true;
  GLSceneViewer1->Buffer->Render(GLFeedback1);
  MeshObject2->Visible = false;

  // Vertex indices are required for smooth normals
  // Delphi - mo := TMeshObject.CreateOwned(GLFreeForm1.MeshObjects);
  mo = new TMeshObject;
  mo = GLFreeForm1->MeshObjects->Items[0];
  mo->Mode = momFaceGroups;
  //Delphi - fg := TFGIndexTexCoordList.CreateOwned(mo.FaceGroups);
  fg = new TFGIndexTexCoordList;
  fg->Mode = fgmmTriangles;
  GLFeedback1->BuildMeshFromBuffer(
	mo->Vertices, mo->Normals, NULL, fg->TexCoords, fg->VertexIndices);

  // Deactivate the feedback object
  GLFeedback1->Active = false;
  GLFreeForm1->StructureChanged();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::GLSceneViewer1MouseDown(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y)
{
  mx = X;
  my = Y;

}
//---------------------------------------------------------------------------
void __fastcall TForm1::GLSceneViewer1MouseMove(TObject *Sender, TShiftState Shift,
          int X, int Y)
{
  if (Shift.Contains(ssLeft))
	GLCamera1->MoveAroundTarget(my - Y, mx - X);
  mx = X;
  my = Y;
}
//---------------------------------------------------------------------------
