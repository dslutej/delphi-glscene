//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   Some useful methods for setting up bump maps. 
   History :
     28/07/03 - SG - Creation
     The whole history is logged in previous version of the unit
    
}
unit GLBumpMapping;

interface

uses
  Vcl.Graphics,
  GLVectorGeometry,
  GLVectorLists,
  GLCrossPlatform,
  GLVectorTypes;

type
  TNormalMapSpace = (nmsObject, nmsTangent);

// Object space
procedure CalcObjectSpaceLightVectors(Light : TAffineVector;
                                      Vertices: TAffineVectorList;
                                      Colors: TVectorList);
// Tangent space
procedure SetupTangentSpace(Vertices, Normals, TexCoords,
                            Tangents, BiNormals : TAffineVectorList);
procedure CalcTangentSpaceLightVectors(Light : TAffineVector;
                                       Vertices, Normals,
                                       Tangents, BiNormals : TAffineVectorList;
                                       Colors: TVectorList);

function CreateObjectSpaceNormalMap(Width, Height : Integer;
                                    HiNormals,HiTexCoords : TAffineVectorList) : TBitmap;
function CreateTangentSpaceNormalMap(Width, Height : Integer;
                                     HiNormals, HiTexCoords,
                                     LoNormals, LoTexCoords,
                                     Tangents, BiNormals : TAffineVectorList) : TBitmap;

implementation

uses

  System.UITypes;

// CalcObjectSpaceLightVectors
//
procedure CalcObjectSpaceLightVectors(Light : TAffineVector;
                                      Vertices: TAffineVectorList;
                                      Colors: TVectorList);
var
  i   : Integer;
  vec : TAffineVector;
begin
  Colors.Count:=Vertices.Count;
  for i:=0 to Vertices.Count-1 do begin
    vec:=VectorNormalize(VectorSubtract(Light,Vertices[i]));
    Colors[i]:=VectorMake(VectorAdd(VectorScale(vec,0.5),0.5),1);
  end;
end;

// SetupTangentSpace
//
procedure SetupTangentSpace(Vertices, Normals, TexCoords,
                            Tangents, BiNormals : TAffineVectorList);
var
  i,j        : Integer;
  v,n,t      : TAffineMatrix;
  vt,tt      : TAffineVector;
  interp,dot : Single;

  procedure SortVertexData(sortidx : Integer);
  begin
    if t.X.V[sortidx]<t.Y.V[sortidx] then begin
      vt:=v.X;   tt:=t.X;
      v.X:=v.Y; t.X:=t.Y;
      v.Y:=vt;   t.Y:=tt;
    end;
    if t.X.V[sortidx]<t.Z.V[sortidx] then begin
      vt:=v.X;   tt:=t.X;
      v.X:=v.Z; t.X:=t.Z;
      v.Z:=vt;   t.Z:=tt;
    end;
    if t.Y.V[sortidx]<t.Z.V[sortidx] then begin
      vt:=v.Y;   tt:=t.Y;
      v.Y:=v.Z; t.Y:=t.Z;
      v.Z:=vt;   t.Z:=tt;
    end;
  end;

begin
  for i:=0 to (Vertices.Count div 3)-1 do begin
    // Get triangle data
    for j:=0 to 2 do begin
      v.V[j]:=Vertices[3*i+j];
      n.V[j]:=Normals[3*i+j];
      t.V[j]:=TexCoords[3*i+j];
    end;

    for j:=0 to 2 do begin
      // Compute tangent
      SortVertexData(1);

      if (t.Z.Y-t.X.Y) = 0 then interp:=1
      else interp:=(t.Y.Y-t.X.Y)/(t.Z.Y-t.X.Y);

      vt:=VectorLerp(v.X,v.Z,interp);
      interp:=t.X.X+(t.Z.X-t.X.X)*interp;
      vt:=VectorSubtract(vt,v.Y);
      if t.Y.X<interp then vt:=VectorNegate(vt);
      dot:=VectorDotProduct(vt,n.V[j]);
      vt.X:=vt.X-n.V[j].X*dot;
      vt.Y:=vt.Y-n.V[j].Y*dot;
      vt.Z:=vt.Z-n.V[j].Z*dot;
      Tangents.Add(VectorNormalize(vt));

      // Compute Bi-Normal
      SortVertexData(0);

      if (t.Z.X-t.X.X) = 0 then interp:=1
      else interp:=(t.Y.X-t.X.X)/(t.Z.X-t.X.X);

      vt:=VectorLerp(v.X,v.Z,interp);
      interp:=t.X.Y+(t.Z.Y-t.X.Y)*interp;
      vt:=VectorSubtract(vt,v.Y);
      if t.Y.Y<interp then vt:=VectorNegate(vt);
      dot:=VectorDotProduct(vt,n.V[j]);
      vt.X:=vt.X-n.V[j].X*dot;
      vt.Y:=vt.Y-n.V[j].Y*dot;
      vt.Z:=vt.Z-n.V[j].Z*dot;
      BiNormals.Add(VectorNormalize(vt));
    end;
  end;
end;

// CalcTangentSpaceLightVectors
//
procedure CalcTangentSpaceLightVectors(Light : TAffineVector;
                                       Vertices, Normals,
                                       Tangents, BiNormals : TAffineVectorList;
                                       Colors: TVectorList);
var
  i   : Integer;
  mat : TAffineMatrix;
  vec : TAffineVector;
begin
  Colors.Count:=Vertices.Count;
  for i:=0 to Vertices.Count-1 do begin
    mat.X:=Tangents[i];
    mat.Y:=BiNormals[i];
    mat.Z:=Normals[i];
    TransposeMatrix(mat);
    vec:=VectorNormalize(VectorTransform(VectorSubtract(Light,Vertices[i]),mat));
    vec.X:=-vec.X;
    Colors[i]:=VectorMake(VectorAdd(VectorScale(vec,0.5),0.5),1);
  end;
end;

// ------------------------------------------------------------------------
// Local functions used for creating normal maps
// ------------------------------------------------------------------------

function ConvertNormalToColor(normal : TAffineVector) : TDelphiColor;
var
  r,g,b : Byte;
begin
  r:=Round(255*(normal.X*0.5+0.5));
  g:=Round(255*(normal.Y*0.5+0.5));
  b:=Round(255*(normal.Z*0.5+0.5));
  Result:=RGB(r,g,b);
end;

procedure GetBlendCoeffs(x,y,x1,y1,x2,y2,x3,y3 : Integer; var f1,f2,f3 : single);
var
  m1,m2,d1,d2,
  px,py : single;
begin
  if (x1 = x) and (x2 = x3) then
    f1:=0
  else begin
    if x1 = x then begin
      m2:=(y3-y2)/(x3-x2);
      d2:=y2-m2*x2;
      px:=x;
      py:=m2*px+d2;
    end else if x2 = x3 then begin
      m1:=(y1-y)/(x1-x);
      d1:=y1-m1*x1;
      px:=x2;
      py:=m1*px+d1;
    end else begin
      m1:=(y1-y)/(x1-x);
      d1:=y1-m1*x1;
      m2:=(y3-y2)/(x3-x2);
      d2:=y2-m2*x2;
      px:=(d1-d2)/(m2-m1);
      py:=m2*px+d2;
    end;
    f1:=sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1))
        /sqrt((px-x1)*(px-x1)+(py-y1)*(py-y1));
  end;

  if (x2 = x) and (x1 = x3) then
    f2:=0
  else begin
    if x2 = x then begin
      m2:=(y3-y1)/(x3-x1);
      d2:=y1-m2*x1;
      px:=x;
      py:=m2*px+d2;
    end else if x3 = x1 then begin
      m1:=(y2-y)/(x2-x);
      d1:=y2-m1*x2;
      px:=x1;
      py:=m1*px+d1;
    end else begin
      m1:=(y2-y)/(x2-x);
      d1:=y2-m1*x2;
      m2:=(y3-y1)/(x3-x1);
      d2:=y1-m2*x1;
      px:=(d1-d2)/(m2-m1);
      py:=m2*px+d2;
    end;
    f2:=sqrt((x-x2)*(x-x2)+(y-y2)*(y-y2))
        /sqrt((px-x2)*(px-x2)+(py-y2)*(py-y2));
  end;

  if (x3 = x) and (x1 = x2) then
    f3:=0
  else begin
    if x = x3 then begin
      m2:=(y2-y1)/(x2-x1);
      d2:=y1-m2*x1;
      px:=x;
      py:=m2*px+d2;
    end else if x2 = x1 then begin
      m1:=(y3-y)/(x3-x);
      d1:=y3-m1*x3;
      px:=x1;
      py:=m1*px+d1;
    end else begin
      m1:=(y3-y)/(x3-x);
      d1:=y3-m1*x3;
      m2:=(y2-y1)/(x2-x1);
      d2:=y1-m2*x1;
      px:=(d1-d2)/(m2-m1);
      py:=m2*px+d2;
    end;
    f3:=sqrt((x-x3)*(x-x3)+(y-y3)*(y-y3))
        /sqrt((px-x3)*(px-x3)+(py-y3)*(py-y3));
  end;

end;

function BlendNormals(x,y,x1,y1,x2,y2,x3,y3 : Integer;
                      n1,n2,n3 : TAffineVector) : TAffineVector;
var
  f1,f2,f3 : single;
begin
  GetBlendCoeffs(x,y,x1,y1,x2,y2,x3,y3,f1,f2,f3);
  Result:=VectorScale(n1,1-f1);
  AddVector(Result,VectorScale(n2,1-f2));
  AddVector(Result,VectorScale(n3,1-f3));
end;

procedure CalcObjectSpaceNormalMap(Width, Height : Integer;
                                   NormalMap, Normals, TexCoords : TAffineVectorList);
var
  i,x,y,xs,xe,
  x1,y1,x2,y2,x3,y3 : integer;
  n,n1,n2,n3 : TAffineVector;
begin
  for i:=0 to (TexCoords.Count div 3) - 1 do begin
    x1:=Round(TexCoords[3*i].X*(Width-1));
    y1:=Round((1-TexCoords[3*i].Y)*(Height-1));
    x2:=Round(TexCoords[3*i+1].X*(Width-1));
    y2:=Round((1-TexCoords[3*i+1].Y)*(Height-1));
    x3:=Round(TexCoords[3*i+2].X*(Width-1));
    y3:=Round((1-TexCoords[3*i+2].Y)*(Height-1));
    n1:=Normals[3*i];
    n2:=Normals[3*i+1];
    n3:=Normals[3*i+2];

    if y2<y1 then begin
      x:=x1;  y:=y1;  n:=n1;
      x1:=x2; y1:=y2; n1:=n2;
      x2:=x;  y2:=y;  n2:=n;
    end;
    if y3<y1 then begin
      x:=x1;  y:=y1;  n:=n1;
      x1:=x3; y1:=y3; n1:=n3;
      x3:=x;  y3:=y;  n3:=n;
    end;
    if y3<y2 then begin
      x:=x2;  y:=y2;  n:=n2;
      x2:=x3; y2:=y3; n2:=n3;
      x3:=x;  y3:=y;  n3:=n;
    end;

    if y1<y2 then
      for y:=y1 to y2 do begin
        xs:=Round(x1+(x2-x1)*((y-y1)/(y2-y1)));
        xe:=Round(x1+(x3-x1)*((y-y1)/(y3-y1)));
        if xe<xs then begin
          x:=xs; xs:=xe; xe:=x;
        end;
        for x:=xs to xe do
          NormalMap[x+y*Width]:=BlendNormals(x,y,x1,y1,x2,y2,x3,y3,n1,n2,n3);
      end;
    if y2<y3 then
      for y:=y2 to y3 do begin
        xs:=Round(x2+(x3-x2)*((y-y2)/(y3-y2)));
        xe:=Round(x1+(x3-x1)*((y-y1)/(y3-y1)));
        if xe<xs then begin
          x:=xs; xs:=xe; xe:=x;
        end;
        for x:=xs to xe do
          NormalMap[x+y*Width]:=BlendNormals(x,y,x1,y1,x2,y2,x3,y3,n1,n2,n3);
      end;
  end;
end;

// CreateObjectSpaceNormalMap
//
function CreateObjectSpaceNormalMap(Width, Height : Integer;
                                    HiNormals,HiTexCoords : TAffineVectorList) : TBitmap;
var
  i : integer;
  NormalMap : TAffineVectorList;
begin
  NormalMap:=TAffineVectorList.Create;
  NormalMap.AddNulls(Width*Height);

  CalcObjectSpaceNormalMap(Width,Height,NormalMap,HiNormals,HiTexCoords);

  // Creates the bitmap
  Result:=TBitmap.Create;
  Result.Width:=Width;
  Result.Height:=Height;
  Result.PixelFormat:=glpf24bit;

  // Paint bitmap with normal map normals (X,Y,Z) -> (R,G,B)
  for i:=0 to NormalMap.Count-1 do
    Result.Canvas.Pixels[i mod Width, i div Height]:=ConvertNormalToColor(NormalMap[i]);

  NormalMap.Free;
end;

// CreateTangentSpaceNormalMap
//
function CreateTangentSpaceNormalMap(Width, Height : Integer;
                                     HiNormals, HiTexCoords,
                                     LoNormals, LoTexCoords,
                                     Tangents, BiNormals : TAffineVectorList) : TBitmap;

  function NormalToTangentSpace(Normal : TAffineVector;
                                x,y,x1,y1,x2,y2,x3,y3 : Integer;
                                m1,m2,m3 : TAffineMatrix) : TAffineVector;
  var
    n1,n2,n3 : TAffineVector;
  begin
    n1:=VectorTransform(Normal,m1);
    n2:=VectorTransform(Normal,m2);
    n3:=VectorTransform(Normal,m3);
    Result:=BlendNormals(x,y,x1,y1,x2,y2,x3,y3,n1,n2,n3);
    NormalizeVector(Result);
  end;

var
  i,x,y,xs,xe,
  x1,y1,x2,y2,x3,y3 : integer;
  NormalMap : TAffineVectorList;
  n : TAffineVector;
  m,m1,m2,m3 : TAffineMatrix;
begin
  NormalMap:=TAffineVectorList.Create;
  NormalMap.AddNulls(Width*Height);

  CalcObjectSpaceNormalMap(Width,Height,NormalMap,HiNormals,HiTexCoords);

  // Transform the object space normals into tangent space
  for i:=0 to (LoTexCoords.Count div 3) - 1 do begin
    x1:=Round(LoTexCoords[3*i].X*(Width-1));
    y1:=Round((1-LoTexCoords[3*i].Y)*(Height-1));
    x2:=Round(LoTexCoords[3*i+1].X*(Width-1));
    y2:=Round((1-LoTexCoords[3*i+1].Y)*(Height-1));
    x3:=Round(LoTexCoords[3*i+2].X*(Width-1));
    y3:=Round((1-LoTexCoords[3*i+2].Y)*(Height-1));

    m1.X:=Tangents[3*i];   m1.Y:=BiNormals[3*i];   m1.Z:=LoNormals[3*i];
    m2.X:=Tangents[3*i+1]; m2.Y:=BiNormals[3*i+1]; m2.Z:=LoNormals[3*i+1];
    m3.X:=Tangents[3*i+2]; m3.Y:=BiNormals[3*i+2]; m3.Z:=LoNormals[3*i+2];
    TransposeMatrix(m1);
    TransposeMatrix(m2);
    TransposeMatrix(m3);
    InvertMatrix(m1);
    InvertMatrix(m2);
    InvertMatrix(m3);
    if y2<y1 then begin
      x:=x1;  y:=y1;  m:=m1;
      x1:=x2; y1:=y2; m1:=m2;
      x2:=x;  y2:=y;  m2:=m;
    end;
    if y3<y1 then begin
      x:=x1;  y:=y1;  m:=m1;
      x1:=x3; y1:=y3; m1:=m3;
      x3:=x;  y3:=y;  m3:=m;
    end;
    if y3<y2 then begin
      x:=x2;  y:=y2;  m:=m2;
      x2:=x3; y2:=y3; m2:=m3;
      x3:=x;  y3:=y;  m3:=m;
    end;

    if y1<y2 then
      for y:=y1 to y2 do begin
        xs:=Round(x1+(x2-x1)*((y-y1)/(y2-y1)));
        xe:=Round(x1+(x3-x1)*((y-y1)/(y3-y1)));
        if xe<xs then begin
          x:=xs; xs:=xe; xe:=x;
        end;
        for x:=xs to xe-1 do begin
          n:=NormalToTangentSpace(NormalMap[x+y*Width],x,y,x1,y1,x2,y2,x3,y3,m1,m2,m3);
          NormalizeVector(n);
          n.X:=-n.X;
          NormalMap[x+y*Width]:=n;
        end;
      end;
    if y2<y3 then
      for y:=y2+1 to y3 do begin
        xs:=Round(x2+(x3-x2)*((y-y2)/(y3-y2)));
        xe:=Round(x1+(x3-x1)*((y-y1)/(y3-y1)));
        if xe<xs then begin
          x:=xs; xs:=xe; xe:=x;
        end;
        for x:=xs to xe-1 do begin
          n:=NormalToTangentSpace(NormalMap[x+y*Width],x,y,x1,y1,x2,y2,x3,y3,m1,m2,m3);
          NormalizeVector(n);
          n.X:=-n.X;
          NormalMap[x+y*Width]:=n;
        end;
      end;
  end;

  // Creates the bitmap
  Result:=TBitmap.Create;
  Result.Width:=Width;
  Result.Height:=Height;
  Result.PixelFormat:=glpf24bit;

  // Paint bitmap with normal map normals (X,Y,Z) -> (R,G,B)
  for i:=0 to NormalMap.Count-1 do
    Result.Canvas.Pixels[i mod Width, i div Height]:=ConvertNormalToColor(NormalMap[i]);

  NormalMap.Free;
end;

end.
