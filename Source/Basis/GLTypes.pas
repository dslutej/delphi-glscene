//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   Defines vector types as advanced records.
   History:
     17/05/11 - PW - Creation.
     The whole history is logged in previous version of the unit
}
unit GLTypes;

interface

uses
  System.Types,
  System.Math.Vectors,
  GLVectorTypes;

//-----------------------
//Point types
//-----------------------
type

  TGLScalarValue = Single;
  TGLScalarField = function(X, Y, Z: Single): TGLScalarValue;

  // If data are made on integer XYZ index
  TGLScalarFieldInt = function(iX, iY, iZ: Integer): TGLScalarValue of object;

  TGLVertex = record
    P, N: TVector3f;  //Point and Normal
    Density: Single;
  end;

  TGLFace = record
    Normal: TVector3f;
    V1: TVector3f; // vertex 1
    V2: TVector3f; // vertex 2
    V3: TVector3f; // vertex 3
    Padding: array [0 .. 1] of Byte;
  end;

  PGLPoint2D = ^TGLPoint2D;
  TGLPoint2D = record
    X: Single;
    Y: Single;
    public
      function Create(X, Y : Single): TGLPoint2D;
      procedure SetPosition(const X, Y : Single);
      function Add(const APoint2D: TGLPoint2D): TGLPoint2D;
      function Length: Single; //distance from origin
      function Distance(const APoint2D : TGLPoint2D) : Single;
      class function PointInCircle(const Point, Center: TGLPoint2D;
        const Radius: Integer):Boolean; static; inline;
      procedure Offset(const ADeltaX, ADeltaY : Single);
  end;

  PGLPoint3D = ^TGLPoint3D;
  TGLPoint3D = record
    X: Single;
    Y: Single;
    Z: Single;
    public
      function Create(X, Y, Z: Single): TGLPoint3D;
      procedure SetPosition(const X, Y, Z: Single);
      function Add(const AGLPoint3D: TGLPoint3D): TGLPoint3D;
      function Length: Single; //distance to origin
      function Distance(const APoint3D : TGLPoint3D): Single;
      procedure Offset(const ADeltaX, ADeltaY, ADeltaZ: Single);
  end;

//Point Arrays
  TGLPoint2DArray = array of TGLPoint2D;
  TGLPoint3DArray = array of TGLPoint3D;


// Voxel types
  TGLVoxelStatus = (bpExternal, bpInternal);
  TGLVoxel = record
    P: TVector3f;
    Density: TGLScalarValue;
    Status: TGLVoxelStatus;
  end;
  PGLVoxel = ^TGLVoxel;

  TGLVoxelData = array [0 .. (MaxInt shr 8)] of TGLVoxel;
  PGLVoxelData = ^TGLVoxelData;


//-----------------------
// Vector types
//-----------------------

  TGLVector2DType = array [0..1] of Single;
  TGLVector3DType = array [0..2] of Single;

  TGLVector2D = record
      function Create(const AX, AY, AW : Single): TGLVector2D;
      function Add(const AVector2D: TGLVector2D): TGLVector2D;
      function Length: Single;
      function Norm: Single;
      function Normalize: TGLVector2D;
      function CrossProduct(const AVector: TGLVector2D): TGLVector2D;
      function DotProduct(const AVector: TGLVector2D): Single;
    case Integer of
      0: (V: TGLVector2DType;);
      1: (X: Single;
          Y: Single;
          W: Single;)
  end;

  TGLVector3D = record
      function Create(const AX, AY, AZ, AW : Single): TGLVector3D;
      function Add(const AVector3D: TGLVector3D): TGLVector3D;
      function Length: Single;
      function Norm: Single;
      function Normalize: TGLVector3D;
      function CrossProduct(const AVector3D: TVector3D): TVector3D;
      function DotProduct(const AVector3D: TVector3D): Single; inline;
    case Integer of
      0: (V: TGLVector3DType;);
      1: (X: Single;
          Y: Single;
          Z: Single;
          W: Single;)
  end;

//Vector Arrays
  TGLVector2DArray = array of TGLVector2D;
  TGLVector3DArray = array of TGLVector3D;

//-----------------------
// Matrix types
//-----------------------
  TGLMatrix2DType = array[0..3] of TGLVector2D;
  {.$NODEFINE TGLMatrix2DType}
  {.$HPPEMIT END OPENNAMESPACE}
  {.$HPPEMIT END 'typedef TGLVector2D TGLMatrix2DArray[4];'}
  {.$HPPEMIT END CLOSENAMESPACE}
  TGLMatrix3DType = array[0..3] of TGLVector3D;
  {.$NODEFINE TGLMatrix3DType}
  {.$HPPEMIT END OPENNAMESPACE}
  {.$HPPEMIT END 'typedef TGLVector3D TGLMatrix3DType[4];'}
  {.$HPPEMIT END CLOSENAMESPACE}

  TGLMatrix2D = record
  private
  public
    case Integer of
      0: (M: TGLMatrix2DType;);
      1: (e11, e12, e13: Single;
          e21, e22, e23: Single;
          e31, e32, e33: Single);
  end;

  TGLMatrix3D = record
  private
  public
    case Integer of
      0: (M: TGLMatrix3DType;);
      1: (e11, e12, e13, e14: Single;
          e21, e22, e23, e24: Single;
          e31, e32, e33, e34: Single;
          e41, e42, e43, e44: Single);
  end;

//Matrix Arrays
  TGLMatrix2DArray = array of TGLMatrix2D;
  TGLMatrix3DArray = array of TGLMatrix3D;


//-----------------------
// Polygon types
//-----------------------

  TGLPolygon2D = TGLPoint2DArray;

  TGLPolygon3D = TGLPoint3DArray;
{
  TGLPolygon3D = record
    Vertices: array of TGLPoint3D;
    function Area;
  end;
}

const
   ClosedPolygon2D: TGLPoint2D = (X: $FFFF; Y: $FFFF);
   ClosedPolygon3D: TGLPoint3D = (X: $FFFF; Y: $FFFF; Z: $FFFF);

type
  TGLVertexArray = array [0 .. (MaxInt shr 8)] of TGLVertex;
  PGLVertexArray = ^TGLVertexArray;

type
  TGLTriangle = record
    v1, v2, v3: Integer;
    ///Vertices: array[0..2] of TGLPoint3D;
    ///function Area;
  end;

  TGLTriangleArray = array [0 .. (MaxInt shr 8)] of TGLTriangle;
  PGLTriangleArray = ^TGLTriangleArray;



//-----------------------
// Polyhedron types
//-----------------------
type
  TGLPolyhedron = array of TGLPolygon3D;

{
  TGLPolyhedron = record
    Facets: array of TGLPolygon3D;
    function NetLength;
    function Area;
    function Volume;
  end;
}

//--------------------------
// Mesh simple record types
//--------------------------
type
   TGLMesh2DVertex = record
    X, Y: Single;
    NX, NY: Single;
    tU, tV: Single;
  end;

   TGLMesh3DVertex = record
    X, Y, Z: Single;
    NX, NY, NZ: Single;
    tU, tV: Single;
  end;

  TGLMesh2D = array of TGLMesh2DVertex;
  TGLMesh3D = array of TGLMesh3DVertex;

//--------------------------
// Quaternion record types
//--------------------------
type

  TGLQuaternion = record
    ImPart: TGLVector3D;
    RePart: Single;
  end;

  TGLQuaternionArray = array of TGLQuaternion;


type
  TGLBox = record
    ALeft, ATop, ANear, ARight, ABottom, AFar: Single;
  end;


//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
implementation
//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------

{ TGLPoint2D }
//
function TGLPoint2D.Create(X, Y : Single): TGLPoint2D;
begin
  Result.X := X;
  Result.Y := Y;
end;

procedure TGLPoint2D.SetPosition(const X, Y: Single);
begin
  Self.X := X;
  Self.Y := Y;
end;

function TGLPoint2D.Length: Single;
begin
  Result := Sqrt(Self.X * Self.X + Self.Y * Self.Y);
end;

function TGLPoint2D.Add(const APoint2D: TGLPoint2D): TGLPoint2D;
begin
  Result.SetPosition(Self.X + APoint2D.X, Self.Y + APoint2D.Y);
end;

function TGLPoint2D.Distance(const APoint2D: TGLPoint2D): Single;
begin
  Result := Sqrt(Sqr(Self.X - APoint2D.X) +  Sqr(Self.Y - APoint2D.Y));
end;

procedure TGLPoint2D.Offset(const ADeltaX, ADeltaY: Single);
begin
  Self.X := Self.X + ADeltaX;
  Self.Y := Self.Y + ADeltaY;
end;

class function TGLPoint2D.PointInCircle(const Point, Center: TGLPoint2D;
  const Radius: Integer): Boolean;
begin
  Result := Point.Distance(Center) <= Radius;
end;

{ TGLPoint3D }
//
function TGLPoint3D.Create(X, Y, Z: Single): TGLPoint3D;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;

function TGLPoint3D.Add(const AGLPoint3D: TGLPoint3D): TGLPoint3D;
begin
  Result.X := Self.X + AGLPoint3D.X;
  Result.Y := Self.Y + AGLPoint3D.Y;
  Result.Z := Self.Z + AGLPoint3D.Z;
end;

function TGLPoint3D.Distance(const APoint3D: TGLPoint3D): Single;
begin
  Result := Self.Length - APoint3D.Length;
end;

function TGLPoint3D.Length: Single;
begin
  Result := Sqrt(Self.X * Self.X + Self.Y * Self.Y + Self.Z * Self.Z);
end;

procedure TGLPoint3D.Offset(const ADeltaX, ADeltaY, ADeltaZ: Single);
begin
  Self.X := Self.X + ADeltaX;
  Self.Y := Self.Y + ADeltaY;
  Self.Z := Self.Z + ADeltaZ;
end;

procedure TGLPoint3D.SetPosition(const X, Y, Z: Single);
begin
  Self.X := X;
  Self.Y := Y;
  Self.Z := Z;
end;

{ TGLVector2D }
//
function TGLVector2D.Create(const AX, AY, AW: Single): TGLVector2D;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.W := AW;
end;

function TGLVector2D.CrossProduct(const AVector: TGLVector2D): TGLVector2D;
begin
  Result.X := (Self.Y * AVector.W) - (Self.W * AVector.Y);
  Result.Y := (Self.W * AVector.X) - (Self.X * AVector.W);
  Result.W := (Self.X * AVector.Y) - (Self.Y * AVector.X);
end;

function TGLVector2D.DotProduct(const AVector: TGLVector2D): Single;
begin
  Result := (Self.X * AVector.X) + (Self.Y * AVector.Y) + (Self.W * AVector.W);
end;

function TGLVector2D.Add(const AVector2D: TGLVector2D): TGLVector2D;
begin
  Result.X := Self.X + AVector2D.X;
  Result.Y := Self.Y + AVector2D.Y;
  Result.W := 1.0;
end;

function TGLVector2D.Length: Single;
begin
  Result := Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TGLVector2D.Norm: Single;
begin
  result := Sqr(Self.X) + Sqr(Self.Y);
end;

function TGLVector2D.Normalize: TGLVector2D;
var
  invLen: Single;
  vn: Single;
const
  Tolerance: Single = 1E-12;
begin
  vn := Self.Norm;
  if vn > Tolerance then
  begin
    invLen := 1/Sqrt(vn);
    Result.X := Self.X * invLen;
    Result.Y := Self.Y * invLen;
  end
  else
    Result := Self;
end;

{ TGLVector3D }
//
function TGLVector3D.Create(const AX, AY, AZ, AW: Single): TGLVector3D;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.Z := AZ;
  Result.W := AW;
end;

function TGLVector3D.Add(const AVector3D: TGLVector3D): TGLVector3D;
begin
  Result.X := Self.X + AVector3D.X;
  Result.Y := Self.Y + AVector3D.Y;
  Result.Z := Self.Z + AVector3D.Z;
  Result.W := 1.0;
end;

function TGLVector3D.Norm: Single;
begin
  result := Self.X * Self.X + Self.Y * Self.Y + Self.Z * Self.Z;
end;

function TGLVector3D.Normalize: TGLVector3D;
var
  invLen: Single;
  vn: Single;
const
  Tolerance: Single = 1E-12;
begin
  vn := Self.Norm;
  if vn > 0 then
  begin
    invLen := 1/Sqrt(vn);
    Result.X := Self.X * invLen;
    Result.Y := Self.Y * invLen;
    Result.Z := Self.Z * invLen;
    Result.W := 0;
  end
  else
    Result := Self;
end;

function TGLVector3D.DotProduct(const AVector3D: TVector3D): Single;
begin
  Result := (Self.X * AVector3D.X) + (Self.Y * AVector3D.Y) + (Self.Z * AVector3D.Z);
end;

function TGLVector3D.CrossProduct(const AVector3D: TVector3D): TVector3D;
begin
  Result.X := (Self.Y * AVector3D.Z) - (Self.Z * AVector3D.Y);
  Result.Y := (Self.Z * AVector3D.X) - (Self.X * AVector3D.Z);
  Result.Z := (Self.X * AVector3D.Y) - (Self.Y * AVector3D.X);
end;

function TGLVector3D.Length: Single;
begin
  Result := Sqrt((Self.X * Self.X) + (Self.Y * Self.Y) + (Self.Z * Self.Z));
end;

end.