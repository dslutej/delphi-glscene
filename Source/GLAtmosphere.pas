//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   This unit contains classes that imitate an atmosphere around a planet.

    History :
      07/02/07 - DaStr - Initial version (donated to GLScene)
      The whole history is logged in previous version of the unit

   Comments:
      1) Eats a lot of CPU (reduces FPS from 1240 to 520 on my PC with cSlices=100)
      2) Alpha in LowAtmColor, HighAtmColor is ignored.
}

unit GLAtmosphere;

interface

{$I GLScene.inc}

uses
  System.SysUtils,
  System.Classes,
  
  OpenGLTokens,
  GLScene,
  GLObjects,
  GLCadencer,
  GLVectorGeometry,
  GLContext,
  GLStrings,
  GLColor,
  GLRenderContextInfo,
  GLState,
  GLCrossPlatform,
  GLVectorTypes;

type
   EGLAtmosphereException = class(Exception);

   {
   With aabmOneMinusSrcAlpha atmosphere is transparent to other objects,
   but has problems, which are best seen when the Atmosphere radius is big.

   With bmOneMinusDstColor atmosphere doesn't have these problems, but offers
   limited transparency (when you look closely on the side).
  }
  TGLAtmosphereBlendingMode = (abmOneMinusDstColor, abmOneMinusSrcAlpha);

  {This class imitates an atmosphere around a planet. }
  TGLCustomAtmosphere = class(TGLBaseSceneObject)
  private
    // Used in DoRenderl
    cosCache, sinCache: array of Single;
    pVertex, pColor: PVectorArray;

    FSlices: Integer;
    FBlendingMode: TGLAtmosphereBlendingMode;
    FPlanetRadius: Single;
    FAtmosphereRadius: Single;
    FOpacity: Single;
    FLowAtmColor: TGLColor;
    FHighAtmColor: TGLColor;
    FSun: TglBaseSceneObject;
    procedure SetSun(const Value: TglBaseSceneObject);
    procedure SetAtmosphereRadius(const Value: Single);
    procedure SetPlanetRadius(const Value: Single);
    procedure EnableGLBlendingMode(StateCache: TGLStateCache);
    function StoreAtmosphereRadius: Boolean;
    function StoreOpacity: Boolean;
    function StorePlanetRadius: Boolean;
    procedure SetSlices(const Value: Integer);
    procedure SetLowAtmColor(const AValue: TGLColor);
    procedure SetHighAtmColor(const AValue: TGLColor);
    function StoreLowAtmColor: Boolean;
    function StoreHighAtmColor: Boolean;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property Sun: TglBaseSceneObject read FSun write SetSun;

    property Slices: Integer read FSlices write SetSlices default 60;
    property Opacity: Single read FOpacity write FOpacity stored StoreOpacity;

    // AtmosphereRadius > PlanetRadius!!!
    property AtmosphereRadius: Single read FAtmosphereRadius write SetAtmosphereRadius stored StoreAtmosphereRadius;
    property PlanetRadius: Single read FPlanetRadius write SetPlanetRadius stored StorePlanetRadius;

    // Use value slightly lower than actual radius, for antialiasing effect.
    property LowAtmColor: TGLColor read FLowAtmColor write SetLowAtmColor stored StoreLowAtmColor;
    property HighAtmColor: TGLColor read FHighAtmColor write SetHighAtmColor stored StoreHighAtmColor;
    property BlendingMode: TGLAtmosphereBlendingMode read FBlendingMode
                               write FBlendingMode default abmOneMinusSrcAlpha;

    procedure SetOptimalAtmosphere(const ARadius: Single);  //absolute
    procedure SetOptimalAtmosphere2(const ARadius: Single); //relative
    procedure TogleBlendingMode; //changes between 2 blending modes

    // Standard component stuff.
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Main rendering procedure.
    procedure DoRender(var rci: TGLRenderContextInfo; renderSelf, renderChildren: Boolean); override;
    // Used to determine extents.
    function AxisAlignedDimensionsUnscaled : TVector; override;
  end;

  TGLAtmosphere = class(TGLCustomAtmosphere)
  published
    property Sun;
    property Slices;
    property Opacity;
    property AtmosphereRadius;
    property PlanetRadius;
    property LowAtmColor;
    property HighAtmColor;
    property BlendingMode;

    property Position;
    property ObjectsSorting;
    property ShowAxes;
    property Visible;
    property OnProgress;
    property Behaviours;
    property Effects;
  end;

implementation

uses
  OpenGLAdapter
  ;

const
  EPS = 0.0001;
  cIntDivTable: array [2..20] of Single =
    (1 / 2, 1 / 3, 1 / 4, 1 / 5, 1 / 6, 1 / 7, 1 / 8, 1 / 9, 1 / 10,
    1 / 11, 1 / 12, 1 / 13, 1 / 14, 1 / 15, 1 / 16, 1 / 17, 1 / 18, 1 / 19, 1 / 20);

procedure TGLCustomAtmosphere.SetOptimalAtmosphere(const ARadius: Single);
begin
  FAtmosphereRadius := ARadius + 0.25;
  FPlanetRadius := ARadius - 0.07;
end;


procedure TGLCustomAtmosphere.SetOptimalAtmosphere2(const ARadius: Single);
begin
  FAtmosphereRadius := ARadius + ARadius / 15;
  FPlanetRadius := ARadius - ARadius / 50;
end;

constructor TGLCustomAtmosphere.Create(AOwner: TComponent);
begin
  inherited;
  FLowAtmColor := TGLColor.Create(Self);
  FHighAtmColor := TGLColor.Create(Self);

  FOpacity := 2.1;
  SetSlices(60);
  FAtmosphereRadius := 3.55;
  FPlanetRadius := 3.395;
  FLowAtmColor.Color := VectorMake(1, 1, 1, 1);
  FHighAtmColor.Color := VectorMake(0, 0, 1, 1);

  FBlendingMode := abmOneMinusSrcAlpha;
end;


destructor TGLCustomAtmosphere.Destroy;
begin
  FLowAtmColor.Free;
  FHighAtmColor.Free;
  FreeMem(pVertex);
  FreeMem(pColor);
  inherited;
end;


procedure TGLCustomAtmosphere.DoRender(var rci: TGLRenderContextInfo; renderSelf, renderChildren: Boolean);
var
  radius, invAtmosphereHeight:    Single;
  sunPos, eyePos, lightingVector: TVector;
  diskNormal, diskRight, diskUp:  TVector;


  function AtmosphereColor(const rayStart, rayEnd: TVector): TColorVector;
  var
    I, n:     Integer;
    atmPoint, normal: TVector;
    altColor: TColorVector;
    alt, rayLength, contrib, decay, intensity, invN: Single;
  begin
    Result := clrTransparent;
    rayLength := VectorDistance(rayStart, rayEnd);
    n := Round(3 * rayLength * invAtmosphereHeight) + 2;
    if n > 10 then
      n := 10;
    invN := cIntDivTable[n];//1/n;
    contrib := rayLength * invN * Opacity;
    decay := 1 - contrib * 0.5;
    contrib := contrib * (1 / 1.1);
    for I := n - 1 downto 0 do
    begin
      VectorLerp(rayStart, rayEnd, I * invN, atmPoint);
      // diffuse lighting normal
      normal := VectorNormalize(atmPoint);
      // diffuse lighting intensity
      intensity := VectorDotProduct(normal, lightingVector) + 0.1;
      if PInteger(@intensity)^ > 0 then
      begin
        // sample on the lit side
        intensity := intensity * contrib;
        alt := (VectorLength(atmPoint) - FPlanetRadius) * invAtmosphereHeight;
        VectorLerp(LowAtmColor.Color, HighAtmColor.Color, alt, altColor);
        Result.X := Result.X * decay + altColor.X * intensity;
        Result.Y := Result.Y * decay + altColor.Y * intensity;
        Result.Z := Result.Z * decay + altColor.Z * intensity;
      end
      else
      begin
        // sample on the dark sid
        Result.X := Result.X * decay;
        Result.Y := Result.Y * decay;
        Result.Z := Result.Z * decay;
      end;
    end;
    Result.W := n * contrib * Opacity * 0.1;
  end;


  function ComputeColor(var rayDest: TVector; mayHitGround: Boolean): TColorVector;
  var
    ai1, ai2, pi1, pi2: TVector;
    rayVector: TVector;
  begin
    rayVector := VectorNormalize(VectorSubtract(rayDest, eyePos));
    if RayCastSphereIntersect(eyePos, rayVector, NullHmgPoint,
      FAtmosphereRadius, ai1, ai2) > 1 then
    begin
      // atmosphere hit
      if mayHitGround and (RayCastSphereIntersect(eyePos, rayVector,
        NullHmgPoint, FPlanetRadius, pi1, pi2) > 0) then
      begin
        // hit ground
        Result := AtmosphereColor(ai1, pi1);
      end
      else
      begin
        // through atmosphere only
        Result := AtmosphereColor(ai1, ai2);
      end;
      rayDest := ai1;
    end
    else
      Result := clrTransparent;
  end;

var
  I, J, k0, k1:    Integer;
begin
  if FSun <> nil then
  begin
    Assert(FAtmosphereRadius > FPlanetRadius);

    sunPos := VectorSubtract(FSun.AbsolutePosition, AbsolutePosition);
    eyepos := VectorSubtract(rci.CameraPosition, AbsolutePosition);

    diskNormal := VectorNegate(eyePos);
    NormalizeVector(diskNormal);
    diskRight := VectorCrossProduct(rci.CameraUp, diskNormal);
    NormalizeVector(diskRight);
    diskUp := VectorCrossProduct(diskNormal, diskRight);
    NormalizeVector(diskUp);

    invAtmosphereHeight := 1 / (FAtmosphereRadius - FPlanetRadius);
    lightingVector := VectorNormalize(sunPos); // sun at infinity

    rci.GLStates.DepthWriteMask := False;
    rci.GLStates.Disable(stLighting);
    rci.GLStates.Enable(stBlend);
    EnableGLBlendingMode(rci.GLStates);
    for I := 0 to 13 do
    begin
      if I < 5 then
        radius := FPlanetRadius * Sqrt(I * (1 / 5))
      else
        radius := FPlanetRadius + (I - 5.1) * (FAtmosphereRadius - FPlanetRadius) * (1 / 6.9);
      radius := SphereVisibleRadius(VectorLength(eyePos), radius);
      k0 := (I and 1) * (FSlices + 1);
      k1 := (FSlices + 1) - k0;
      for J := 0 to FSlices do
      begin
        VectorCombine(diskRight, diskUp,
          cosCache[J] * radius, sinCache[J] * radius,
          pVertex[k0 + J]);
        if I < 13 then
          pColor[k0 + J] := ComputeColor(pVertex[k0 + J], I <= 7);
        if I = 0 then
          Break;
      end;

      if I > 1 then
      begin
        if I = 13 then
        begin
          // GL.BlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
          GL.Begin_(GL_QUAD_STRIP);
          for J := FSlices downto 0 do
          begin
            GL.Color4fv(@pColor[k1 + J]);
            GL.Vertex3fv(@pVertex[k1 + J]);
            GL.Color4fv(@clrTransparent);
            GL.Vertex3fv(@pVertex[k0 + J]);
          end;
          GL.End_;
        end
        else
        begin
          // GL.BlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_DST_COLOR);
          GL.Begin_(GL_QUAD_STRIP);
          for J := FSlices downto 0 do
          begin
            GL.Color4fv(@pColor[k1 + J]);
            GL.Vertex3fv(@pVertex[k1 + J]);
            GL.Color4fv(@pColor[k0 + J]);
            GL.Vertex3fv(@pVertex[k0 + J]);
          end;
          GL.End_;
        end;
      end
      else if I = 1 then
      begin
        //GL.BlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        GL.Begin_(GL_TRIANGLE_FAN);
        GL.Color4fv(@pColor[k1]);
        GL.Vertex3fv(@pVertex[k1]);
        for J := k0 + FSlices downto k0 do
        begin
          GL.Color4fv(@pColor[J]);
          GL.Vertex3fv(@pVertex[J]);
        end;
        GL.End_;
      end;
    end;
  end;
  inherited;
end;

procedure TGLCustomAtmosphere.TogleBlendingMode;
begin
  if FBlendingMode = abmOneMinusSrcAlpha then
    FBlendingMode := abmOneMinusDstColor
  else
    FBlendingMode := abmOneMinusSrcAlpha;
end;

procedure TGLCustomAtmosphere.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TGLCustomAtmosphere then
  begin
    SetSlices(TGLCustomAtmosphere(Source).FSlices);
    FOpacity := TGLCustomAtmosphere(Source).FOpacity;
    FAtmosphereRadius := TGLCustomAtmosphere(Source).FAtmosphereRadius;
    FPlanetRadius := TGLCustomAtmosphere(Source).FPlanetRadius;
    FLowAtmColor.Color := TGLCustomAtmosphere(Source).FLowAtmColor.Color;
    FHighAtmColor.Color := TGLCustomAtmosphere(Source).FHighAtmColor.Color;
    FBlendingMode := TGLCustomAtmosphere(Source).FBlendingMode;
    SetSun(TGLCustomAtmosphere(Source).FSun);
  end;
end;

procedure TGLCustomAtmosphere.SetSun(const Value: TglBaseSceneObject);
begin
  if FSun <> nil then FSun.RemoveFreeNotification(Self);
  FSun := Value;
  if FSun <> nil then FSun.FreeNotification(Self);
end;

function TGLCustomAtmosphere.AxisAlignedDimensionsUnscaled : TVector;
begin
  Result.X := FAtmosphereRadius;
  Result.Y := Result.X;
  Result.Z := Result.X;
  Result.W := 0;
end;

procedure TGLCustomAtmosphere.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FSun) then
    FSun := nil;
end;

procedure TGLCustomAtmosphere.SetAtmosphereRadius(
  const Value: Single);
begin
  FAtmosphereRadius := Value;
  if Value <= FPlanetRadius then
    FPlanetRadius := FAtmosphereRadius / 1.01;
end;

procedure TGLCustomAtmosphere.SetPlanetRadius(const Value: Single);
begin
  FPlanetRadius := Value;
  if Value >= FAtmosphereRadius then
    FAtmosphereRadius := FPlanetRadius * 1.01;
end;

procedure TGLCustomAtmosphere.EnableGLBlendingMode(StateCache: TGLStateCache);
begin
  case FBlendingMode of
    abmOneMinusDstColor:
      StateCache.SetBlendFunc(bfDstAlpha, bfOneMinusDstColor);
    abmOneMinusSrcAlpha:
      StateCache.SetBlendFunc(bfDstAlpha, bfOneMinusSrcAlpha);
  else
    Assert(False, strErrorEx + strUnknownType);
  end;
  StateCache.Enable(stAlphaTest);
end;

function TGLCustomAtmosphere.StoreAtmosphereRadius: Boolean;
begin
  Result := Abs(FAtmosphereRadius - 3.55) > EPS;
end;

function TGLCustomAtmosphere.StoreOpacity: Boolean;
begin
  Result := Abs(FOpacity - 2.1) > EPS;
end;

function TGLCustomAtmosphere.StorePlanetRadius: Boolean;
begin
  Result := Abs(FPlanetRadius - 3.395) > EPS;
end;

procedure TGLCustomAtmosphere.SetSlices(const Value: Integer);
begin
  if Value > 0 then
  begin
    FSlices := Value;
    SetLength(cosCache, FSlices + 1);
    SetLength(sinCache, FSlices + 1);
    PrepareSinCosCache(sinCache, cosCache, 0, 360);

    GetMem(pVertex, 2 * (FSlices + 1) * SizeOf(TVector));
    GetMem(pColor, 2 * (FSlices + 1) * SizeOf(TVector));
  end
  else
    raise EGLAtmosphereException.Create('Slices must be more than0!');
end;

procedure TGLCustomAtmosphere.SetHighAtmColor(const AValue: TGLColor);
begin
  FHighAtmColor.Assign(AValue);
end;

procedure TGLCustomAtmosphere.SetLowAtmColor(const AValue: TGLColor);
begin
  FLowAtmColor.Assign(AValue);
end;

function TGLCustomAtmosphere.StoreHighAtmColor: Boolean;
begin
  Result := not VectorEquals(FHighAtmColor.Color, VectorMake(0, 0, 1, 1));
end;

function TGLCustomAtmosphere.StoreLowAtmColor: Boolean;
begin
  Result := not VectorEquals(FLowAtmColor.Color, VectorMake(1, 1, 1, 1));
end;

initialization
  RegisterClasses([TGLCustomAtmosphere, TGLAtmosphere]);

end.

