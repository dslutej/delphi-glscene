//---------------------------------------------------------------------------

#include <vcl.h>
#include <tchar.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "GLBaseClasses"
#pragma link "GLCoordinates"
#pragma link "GLCrossPlatform"
#pragma link "GLGraph"
#pragma link "GLScene"
#pragma link "GLWin32Viewer"
#pragma resource "*.dfm"
TForm1 *Form1;
TColor grid[11][11];

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
 int ix, iy;

   // initialize grid color to white/gray (checked pattern)
  for (ix=-5; ix < 5; ix++)
	for (iy=-5; iy < 5; iy++)
	  if (((ix ^ iy) && 1)==0)
		 grid[ix][iy] = clWhite;
	  else
		grid[ix][iy] = clSilver;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::HeightFieldGetHeight(const float x, const float y, float &z,
          TVector4f &Color, TTexPoint &TexPoint)
{
   int ix, iy;

   // Nothing fancy here, the color is directly taken from the grid,
   // and the z function is a basic cosinus. The '+0.01' are to take
   // rounding issues out of the equation.
   ix = Round(ClampValue(x+0.01, -5, 5));
   iy = Round(ClampValue(y+0.01, -5, 5));
   Color = ConvertWinColor(grid[ix][iy]);
   z = Cos(VectorLength(x, y)*1.5);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewerMouseDown(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y)
{
   TAffineVector v;
   int ix, iy;

   mx = X;
   my = Y;
   if (RBPaint->Checked)
   {
	  // In Paint mode
	  // get absolute 3D coordinates of the point below the mouse
	  v = GLSceneViewer->Buffer->PixelRayToWorld(X, Y);
	  // convert to heightfield local coordinates
	  v = HeightField->AbsoluteToLocal(v);
	  // convert that local coords to grid pos
	  ix = Round(v.X);
	  iy = Round(v.Y);
	  // if we are in the grid...
	  if ((ix>=-5) && (ix<=5) && (iy>=-5) && (iy<=5))
	  {
		 // show last coord in the caption bar
		 Label2->Caption = Format("%d   %d",
		   ARRAYOFCONST ((ix, iy)));
		 // and paint blue or red depending on the button
		 if (Button==TMouseButton(Glcrossplatform::mbLeft))
			grid[ix][iy] = clBlue;
		 else
			grid[ix][iy] = clRed;
		 // Height field changed, rebuild it!
		 HeightField->StructureChanged();
	  }
   }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewerMouseMove(TObject *Sender, TShiftState Shift,
          int X, int Y)
{
   if (RBPaint->Checked)
   {
	  // in paint mode, paint if a button is pressed
	  if (Shift.Contains(ssLeft))
		 GLSceneViewerMouseDown(Sender, TMouseButton(Glcrossplatform::mbLeft), Shift, X, Y);
	  else
	  if (Shift.Contains(ssRight))
		 GLSceneViewerMouseDown(Sender, TMouseButton(Glcrossplatform::mbRight), Shift, X, Y);
   }
   else
   {
	  // rotate mode
	  if (Shift.Contains(ssAlt) || Shift.Contains(ssCtrl) || Shift.Contains(ssShift))
	  {
		 GLCamera1->MoveAroundTarget(my-Y, mx-X);
		 mx = X;
		 my = Y;

	  }
   }
}
//---------------------------------------------------------------------------



