//
// This unit is part of the GLScene Project, http://glscene.org
//
{
   Pipeline transformations
   History :  
     13/12/13 - PW - Added GLSLog unit
     11/05/11 - Yar - Ranamed TGLPipelineTransformation to TGLTransformation
     16/11/10 - Yar - Added NormalModelMatrix
     23/08/10 - Yar - Creation
  
}

unit GLPipelineTransformation;

interface

{$I GLScene.inc}

uses
  OpenGLTokens,
  OpenGLAdapter,
  GLVectorGeometry,
  GLVectorTypes,
  GLSLog;

const
  MAX_MATRIX_STACK_DEPTH = 128;

type

  TGLPipelineTransformationState =
  (
    trsModelViewChanged,
    trsInvModelViewChanged,
    trsInvModelChanged,
    trsNormalModelChanged,
    trsViewProjChanged,
    trsFrustum
  );

  TGLPipelineTransformationStates = set of TGLPipelineTransformationState;

const
  cAllStatesChanged = [trsModelViewChanged, trsInvModelViewChanged, trsInvModelChanged, trsViewProjChanged, trsNormalModelChanged, trsFrustum];

type

  PTransformationRec = ^TTransformationRec;
  TTransformationRec = record
    FStates: TGLPipelineTransformationStates;
    FModelMatrix: TMatrix;
    FViewMatrix: TMatrix;
    FProjectionMatrix: TMatrix;
    FInvModelMatrix: TMatrix;
    FNormalModelMatrix: TAffineMatrix;
    FModelViewMatrix: TMatrix;
    FInvModelViewMatrix: TMatrix;
    FViewProjectionMatrix: TMatrix;
    FFrustum: TFrustum;
  end;

type

  TOnMatricesPush = procedure() of object;

  // TGLTransformation
  //
  TGLTransformation = class(TObject)
  private
    FStackPos: Integer;
    FStack: array of TTransformationRec;
    FLoadMatricesEnabled: Boolean;
    FOnPush: TOnMatricesPush;
    function GetModelMatrix: TMatrix; inline;
    function GetViewMatrix: TMatrix; inline;
    function GetProjectionMatrix: TMatrix; inline;
    function GetModelViewMatrix: PMatrix; inline;
    function GetInvModelViewMatrix: PMatrix; inline;
    function GetInvModelMatrix: PMatrix; inline;
    function GetNormalModelMatrix: PAffineMatrix; inline;
    function GetViewProjectionMatrix: PMatrix; inline;
    function GetFrustum: TFrustum; inline;

    procedure SetModelMatrix(const AMatrix: TMatrix); inline;
    procedure SetViewMatrix(const AMatrix: TMatrix); inline;
    procedure SetProjectionMatrix(const AMatrix: TMatrix); inline;
  protected
    procedure LoadModelViewMatrix; inline;
    procedure LoadProjectionMatrix; inline;
    procedure DoMatrcesLoaded; inline;
    property OnPush: TOnMatricesPush read FOnPush write FOnPush;
  public
    constructor Create;

    procedure IdentityAll; inline;
    procedure Push(AValue: PTransformationRec); overload;
    procedure Push(); overload; inline;
    procedure Pop;
    procedure ReplaceFromStack;
    function StackTop: TTransformationRec; inline;

    property ModelMatrix: TMatrix read GetModelMatrix write SetModelMatrix;
    property ViewMatrix: TMatrix read GetViewMatrix write SetViewMatrix;
    property ProjectionMatrix: TMatrix read GetProjectionMatrix write SetProjectionMatrix;

    property InvModelMatrix: PMatrix read GetInvModelMatrix;
    property ModelViewMatrix: PMatrix read GetModelViewMatrix;
    property NormalModelMatrix: PAffineMatrix read GetNormalModelMatrix;
    property InvModelViewMatrix: PMatrix read GetInvModelViewMatrix;
    property ViewProjectionMatrix: PMatrix read GetViewProjectionMatrix;
    property Frustum: TFrustum read GetFrustum;

    property LoadMatricesEnabled: Boolean read FLoadMatricesEnabled write FLoadMatricesEnabled;
  end;

// Prevent Lazaruses issue with checksumm chenging!
{
type
  TGLCall = function(): TGLExtensionsAndEntryPoints;
var
  vLocalGL: TGLCall;
}

implementation

uses
{$IFDEF GLS_FASTMATH}
  Neslib.FastMath,
{$ENDIF}

  GLContext;

constructor TGLTransformation.Create;
begin
  FStackPos := 0;
  SetLength(FStack, MAX_MATRIX_STACK_DEPTH);
  IdentityAll;
end;

procedure TGLTransformation.LoadProjectionMatrix;
begin
  GL.MatrixMode(GL_PROJECTION);
  GL.LoadMatrixf(PGLFloat(@FStack[FStackPos].FProjectionMatrix));
  GL.MatrixMode(GL_MODELVIEW);
end;

function TGLTransformation.GetModelViewMatrix: PMatrix;
begin
  if trsModelViewChanged in FStack[FStackPos].FStates then
  begin
    FStack[FStackPos].FModelViewMatrix :=
      MatrixMultiply(FStack[FStackPos].FModelMatrix, FStack[FStackPos].FViewMatrix);
    Exclude(FStack[FStackPos].FStates, trsModelViewChanged);
  end;
  Result := @FStack[FStackPos].FModelViewMatrix;
end;

procedure TGLTransformation.LoadModelViewMatrix;
begin
  GL.LoadMatrixf(PGLFloat(GetModelViewMatrix));
end;

procedure TGLTransformation.IdentityAll;
begin
  with FStack[FStackPos] do
  begin
    FModelMatrix := IdentityHmgMatrix;
    FViewMatrix := IdentityHmgMatrix;
    FProjectionMatrix := IdentityHmgMatrix;
    FStates := cAllStatesChanged;
  end;
  if LoadMatricesEnabled then
  begin
    LoadModelViewMatrix;
    LoadProjectionMatrix;
  end;
end;

procedure TGLTransformation.DoMatrcesLoaded;
begin
  if Assigned(FOnPush) then
    FOnPush();
end;

procedure TGLTransformation.Push;
var
  prevPos: Integer;
begin
  prevPos := FStackPos;
  Inc(FStackPos);
  FStack[FStackPos] := FStack[prevPos];
end;

procedure TGLTransformation.Push(AValue: PTransformationRec);
var
  prevPos: Integer;
begin
  {$IFDEF GLS_LOGGING}
  if FStackPos > MAX_MATRIX_STACK_DEPTH then
  begin
    GLSLogger.LogWarningFmt('Transformation stack overflow, more then %d values',
      [MAX_MATRIX_STACK_DEPTH]);
  end;
  {$ENDIF}
  prevPos := FStackPos;
  Inc(FStackPos);

  if Assigned(AValue) then
  begin
    FStack[FStackPos] := AValue^;
    if LoadMatricesEnabled then
    begin
      LoadModelViewMatrix;
      LoadProjectionMatrix;
    end;
    DoMatrcesLoaded;
  end
  else
    FStack[FStackPos] := FStack[prevPos];
end;

procedure TGLTransformation.Pop;
begin
  {$IFDEF GLS_LOGGING}
  if FStackPos = 0 then
  begin
    GLSLogger.LogError('Transformation stack underflow');
    exit;
  end;
  {$ENDIF}

  Dec(FStackPos);
  if LoadMatricesEnabled then
  begin
    LoadModelViewMatrix;
    LoadProjectionMatrix;
  end;
end;



procedure TGLTransformation.ReplaceFromStack;
var
  prevPos: Integer;
begin
  {$IFDEF GLS_LOGGING}
  if FStackPos = 0 then
  begin
    GLSLogger.LogError('Transformation stack underflow');
    exit;
  end;
  {$ENDIF}
  prevPos := FStackPos - 1;
  FStack[FStackPos].FModelMatrix := FStack[prevPos].FModelMatrix;
  FStack[FStackPos].FViewMatrix:= FStack[prevPos].FViewMatrix;
  FStack[FStackPos].FProjectionMatrix:= FStack[prevPos].FProjectionMatrix;
  FStack[FStackPos].FStates := FStack[prevPos].FStates;
  if LoadMatricesEnabled then
  begin
    LoadModelViewMatrix;
    LoadProjectionMatrix;
  end;
end;



function TGLTransformation.GetModelMatrix: TMatrix;
begin
  Result := FStack[FStackPos].FModelMatrix;
end;

function TGLTransformation.GetViewMatrix: TMatrix;
begin
  Result := FStack[FStackPos].FViewMatrix;
end;

function TGLTransformation.GetProjectionMatrix: TMatrix;
begin
  Result := FStack[FStackPos].FProjectionMatrix;
end;

procedure TGLTransformation.SetModelMatrix(const AMatrix: TMatrix);
begin
  FStack[FStackPos].FModelMatrix := AMatrix;
  FStack[FStackPos].FStates := FStack[FStackPos].FStates +
    [trsModelViewChanged, trsInvModelViewChanged, trsInvModelChanged, trsNormalModelChanged];
  if LoadMatricesEnabled then
    LoadModelViewMatrix;
end;

procedure TGLTransformation.SetViewMatrix(const AMatrix: TMatrix);
begin
  FStack[FStackPos].FViewMatrix:= AMatrix;
  FStack[FStackPos].FStates := FStack[FStackPos].FStates +
    [trsModelViewChanged, trsInvModelViewChanged, trsViewProjChanged, trsFrustum];
  if LoadMatricesEnabled then
    LoadModelViewMatrix;
end;

function TGLTransformation.StackTop: TTransformationRec;
begin
  Result := FStack[FStackPos];
end;

procedure TGLTransformation.SetProjectionMatrix(const AMatrix: TMatrix);
begin
  FStack[FStackPos].FProjectionMatrix := AMatrix;
  FStack[FStackPos].FStates := FStack[FStackPos].FStates +
    [trsViewProjChanged, trsFrustum];
  if LoadMatricesEnabled then
    LoadProjectionMatrix;
end;


function TGLTransformation.GetInvModelViewMatrix: PMatrix;
begin
  if trsInvModelViewChanged in FStack[FStackPos].FStates then
  begin
    FStack[FStackPos].FInvModelViewMatrix := GetModelViewMatrix^;
    InvertMatrix(FStack[FStackPos].FInvModelViewMatrix);
    Exclude(FStack[FStackPos].FStates, trsInvModelViewChanged);
  end;
  Result := @FStack[FStackPos].FInvModelViewMatrix;
end;

function TGLTransformation.GetInvModelMatrix: PMatrix;
begin
  if trsInvModelChanged in FStack[FStackPos].FStates then
  begin
    FStack[FStackPos].FInvModelMatrix := MatrixInvert(FStack[FStackPos].FModelMatrix);
    Exclude(FStack[FStackPos].FStates, trsInvModelChanged);
  end;
  Result := @FStack[FStackPos].FInvModelMatrix;
end;

function TGLTransformation.GetNormalModelMatrix: PAffineMatrix;
var
  M: TMatrix;
begin
  if trsNormalModelChanged in FStack[FStackPos].FStates then
  begin
    M := FStack[FStackPos].FModelMatrix;
    NormalizeMatrix(M);
    SetMatrix(FStack[FStackPos].FNormalModelMatrix, M);
    Exclude(FStack[FStackPos].FStates, trsNormalModelChanged);
  end;
  Result := @FStack[FStackPos].FNormalModelMatrix;
end;

function TGLTransformation.GetViewProjectionMatrix: PMatrix;
begin
  if trsViewProjChanged in FStack[FStackPos].FStates then
  begin
    FStack[FStackPos].FViewProjectionMatrix :=
      MatrixMultiply(FStack[FStackPos].FViewMatrix, FStack[FStackPos].FProjectionMatrix);
    Exclude(FStack[FStackPos].FStates, trsViewProjChanged);
  end;
  Result := @FStack[FStackPos].FViewProjectionMatrix;
end;

function TGLTransformation.GetFrustum: TFrustum;
begin
  if trsFrustum in FStack[FStackPos].FStates then
  begin
    FStack[FStackPos].FFrustum := ExtractFrustumFromModelViewProjection(GetViewProjectionMatrix^);
    Exclude(FStack[FStackPos].FStates, trsFrustum);
  end;
  Result := FStack[FStackPos].FFrustum;
end;

end.
