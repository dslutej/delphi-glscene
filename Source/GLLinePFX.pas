//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   A PFX whose particles are lines

    History :  
      20/02/05 - EG - Creation
      The whole history is logged in previous version of the unit
}
unit GLLinePFX;

interface

{$I GLScene.inc}

uses
  System.Classes,
  System.SysUtils,
  
  OpenGLTokens,
  GLPersistentClasses,
  GLVectorGeometry,
  GLParticleFX,
  GLTexture,
  GLColor,
  GLRenderContextInfo,
  GLContext,
  GLVectorTypes;

type

   // TGLLineParticle
   //
   {Linear particle.  }
   TGLLineParticle = class (TGLParticle)
      private
          
         FDirection : TAffineVector;
         FLength : Single;

      protected
         

      public
         
         procedure WriteToFiler(writer : TVirtualWriter); override;
         procedure ReadFromFiler(reader : TVirtualReader); override;

         {Direction of the line. }
         property Direction : TAffineVector read FDirection write FDirection;
         {Length of the line }
         property Length : Single read FLength write FLength;
   end;

   // TGLLinePFXManager
   //
   {Polygonal particles FX manager. 
      The particles of this manager are made of N-face regular polygon with
      a core and edge color. No texturing is available.
      If you render large particles and don't have T&L acceleration, consider
      using TGLPointLightPFXManager. }
   TGLLinePFXManager = class (TGLLifeColoredPFXManager)
      private
          
         Fvx, Fvy : TAffineVector;        // NOT persistent
         FNvx, FNvy : TAffineVector;        // NOT persistent
         FDefaultLength : Single;

      protected
         
         function StoreDefaultLength : Boolean;

         function TexturingMode : Cardinal; override;
         procedure InitializeRendering(var rci: TGLRenderContextInfo); override;
         procedure BeginParticles(var rci: TGLRenderContextInfo); override;
         procedure RenderParticle(var rci: TGLRenderContextInfo; aParticle : TGLParticle); override;
         procedure EndParticles(var rci: TGLRenderContextInfo); override;
         procedure FinalizeRendering(var rci: TGLRenderContextInfo); override;

      public
         
         constructor Create(aOwner : TComponent); override;
         destructor Destroy; override;

         class function ParticlesClass : TGLParticleClass; override;
         function CreateParticle : TGLParticle; override;

	   published
	      
         property DefaultLength : Single read FDefaultLength write FDefaultLength stored StoreDefaultLength;

         property ParticleSize;
         property ColorInner;
         property ColorOuter;
         property LifeColors;
   end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

uses

  OpenGLAdapter;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// ------------------
// ------------------ TGLLinePFXManager ------------------
// ------------------

 
//
constructor TGLLinePFXManager.Create(aOwner : TComponent);
begin
   inherited;
   FDefaultLength:=1;
end;

 
//
destructor TGLLinePFXManager.Destroy;
begin
   inherited Destroy;
end;

// ParticlesClass
//
class function TGLLinePFXManager.ParticlesClass : TGLParticleClass;
begin
   Result:=TGLLineParticle;
end;

// CreateParticle
//
function TGLLinePFXManager.CreateParticle : TGLParticle;
begin
   Result:=inherited CreateParticle;
   TGLLineParticle(Result).FLength:=DefaultLength;
end;

// TexturingMode
//
function TGLLinePFXManager.TexturingMode : Cardinal;
begin
   Result:=0;
end;

// InitializeRendering
//
procedure TGLLinePFXManager.InitializeRendering(var rci: TGLRenderContextInfo);
var
   i : Integer;
   matrix : TMatrix;
begin
   inherited;
   GL.GetFloatv(GL_MODELVIEW_MATRIX, @matrix);
   for i:=0 to 2 do begin
      Fvx.V[i]:=matrix.V[i].X;
      Fvy.V[i]:=matrix.V[i].Y;
   end;
   FNvx:=VectorNormalize(Fvx);
   FNvy:=VectorNormalize(Fvy);
end;

// BeginParticles
//
procedure TGLLinePFXManager.BeginParticles(var rci: TGLRenderContextInfo);
begin
   ApplyBlendingMode(rci);
end;

// RenderParticle
//
procedure TGLLinePFXManager.RenderParticle(var rci: TGLRenderContextInfo; aParticle : TGLParticle);
var
   lifeTime, sizeScale, fx, fy, f : Single;
   inner, outer : TColorVector;
   pos, dir, start, stop, dv : TAffineVector;
begin
   lifeTime:=CurrentTime-aParticle.CreationTime;
   ComputeColors(lifeTime, inner, outer);
   if ComputeSizeScale(lifeTime, sizeScale) then
      sizeScale:=sizeScale*ParticleSize
   else sizeScale:=ParticleSize;

   pos:=aParticle.Position;

   with TGLLineParticle(aParticle) do begin
      dir:=VectorNormalize(aParticle.Velocity);
      f:=Length*0.5;
   end;

   start:=VectorCombine(pos, dir, 1, f);
   stop:=VectorCombine(pos, dir, 1, -f);

   fx:=VectorDotProduct(dir, FNvy)*sizeScale;
   fy:=-VectorDotProduct(dir, FNvx)*sizeScale;

   dv:=VectorCombine(Fvx, Fvy, fx, fy);

   GL.Begin_(GL_TRIANGLE_FAN);
      GL.Color4fv(@inner);
      GL.Vertex3fv(@start);
      GL.Color4fv(@outer);
      GL.Vertex3f(start.X+dv.X, start.Y+dv.Y, start.Z+dv.Z);
      GL.Vertex3f(stop.X+dv.X, stop.Y+dv.Y, stop.Z+dv.Z);
      GL.Color4fv(@inner);
      GL.Vertex3fv(@stop);
      GL.Color4fv(@outer);
      GL.Vertex3f(stop.X-dv.X, stop.Y-dv.Y, stop.Z-dv.Z);
      GL.Vertex3f(start.X-dv.X, start.Y-dv.Y, start.Z-dv.Z);
   GL.End_;
end;

// EndParticles
//
procedure TGLLinePFXManager.EndParticles(var rci: TGLRenderContextInfo);
begin
   UnapplyBlendingMode(rci);
end;

// FinalizeRendering
//
procedure TGLLinePFXManager.FinalizeRendering(var rci: TGLRenderContextInfo);
begin
   inherited;
end;

// StoreDefaultLength
//
function TGLLinePFXManager.StoreDefaultLength : Boolean;
begin
   Result:=(FDefaultLength<>1);
end;

// ------------------
// ------------------ TGLLineParticle ------------------
// ------------------

// WriteToFiler
//
procedure TGLLineParticle.WriteToFiler(writer : TVirtualWriter);
begin
   inherited WriteToFiler(writer);
   with writer do begin
      WriteInteger(0); // Archive Version 0
      Write(FDirection, SizeOf(FDirection));
      WriteFloat(FLength);
   end;
end;

// ReadFromFiler
//
procedure TGLLineParticle.ReadFromFiler(reader : TVirtualReader);
var
   archiveVersion : integer;
begin
   inherited ReadFromFiler(reader);
   archiveVersion:=reader.ReadInteger;
   if archiveVersion=0 then with reader do begin
      Read(FDirection, SizeOf(FDirection));
      FLength:=ReadFloat;
   end else RaiseFilerException(archiveVersion);
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

   // class registrations
   RegisterClasses([TGLLineParticle, TGLLinePFXManager]);

end.
