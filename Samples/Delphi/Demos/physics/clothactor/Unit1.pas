unit Unit1;

interface

uses
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.Jpeg,
  
  GLScene,
  GLVectorFileObjects,
  GLObjects,
  GLCadencer,
  GLTexture,
  GLWin32Viewer,
  GLFileSMD,
  GLFile3DS,
  GLVerletClothify,
  GLVerletSkeletonColliders,
  GLShadowVolume,
  GLKeyboard,
  GLVectorGeometry,
  GLGeometryBB,
  GLVerletTypes,
  GLSpacePartition,
  GLCrossPlatform,
  GLMaterial,
  GLBaseClasses,
  GLRenderContextInfo,
  GLContext,
  GLUtils,
  GLCoordinates;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLActor1: TGLActor;
    ActorDummy: TGLDummyCube;
    Timer1: TTimer;
    OctreeRenderer: TGLDirectOpenGL;
    CheckBox_ShowOctree: TCheckBox;
    GLLightSource1: TGLLightSource;
    GLPlane1: TGLPlane;
    GLShadowVolume1: TGLShadowVolume;
    Cape: TGLActor;
    GLLightSource2: TGLLightSource;
    LabelFPS: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure Timer1Timer(Sender: TObject);
    procedure OctreeRendererRender(Sender: TObject;
      var rci: TGLRenderContextInfo);
  private
     
  public
     
    mx, my: Integer;
    VerletWorld: TGLVerletWorld;
    EdgeDetector: TEdgeDetector;
    AirResistance: TVFAirResistance;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
// Mesh normal recalculation routines

procedure PrepareMeshForNormalsRecalc(BaseMesh: TGLBaseMesh);
var
  i, j, k: Integer;
  mo: TMeshObject;
  fg: TFGVertexNormalTexIndexList;
begin
  // update normals
  // (not very efficient, could use some work...)
  for i := 0 to BaseMesh.MeshObjects.Count - 1 do
  begin
    mo := BaseMesh.MeshObjects[i];

    for j := 0 to mo.FaceGroups.Count - 1 do
    begin
      if mo.FaceGroups[j] is TFGVertexNormalTexIndexList then
      begin
        fg := TFGVertexNormalTexIndexList(mo.FaceGroups[j]);
        for k := 0 to fg.VertexIndices.Count - 1 do
        begin
          fg.NormalIndices.List[k] := fg.VertexIndices.List[k];
        end;
      end;
    end;
  end;

  BaseMesh.StructureChanged;
end;

procedure RecalcMeshNormals(BaseMesh: TGLBaseMesh);
var
  i, j, k: Integer;
  mo: TMeshObject;
  fg: TFGVertexIndexList;
  n: TAffineVector;
begin
  // update normals
  // (not very efficient, could use some work...)
  for i := 0 to BaseMesh.MeshObjects.Count - 1 do
  begin
    mo := BaseMesh.MeshObjects[i];

    FillChar(mo.Normals.List[0], SizeOf(TAffineVector) * mo.Normals.Count, 0);

    for j := 0 to mo.FaceGroups.Count - 1 do
    begin
      if mo.FaceGroups[j] is TFGVertexIndexList then
      begin
        fg := TFGVertexIndexList(mo.FaceGroups[j]);
        k := 0;
        while k <= fg.VertexIndices.Count - 3 do
        begin
          n := CalcPlaneNormal(mo.Vertices.List[fg.VertexIndices.List[k]],
            mo.Vertices.List[fg.VertexIndices.List[k + 1]],
            mo.Vertices.List[fg.VertexIndices.List[k + 2]]);
          mo.Normals.TranslateItem(fg.VertexIndices.List[k], n);
          mo.Normals.TranslateItem(fg.VertexIndices.List[k + 1], n);
          mo.Normals.TranslateItem(fg.VertexIndices.List[k + 2], n); // }

          Inc(k, 3);
        end;
      end;
    end;
    mo.Normals.Normalize;
  end;

  BaseMesh.StructureChanged;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetGLSceneMediaDir();
  Randomize;
  // Load the actor and animations
  GLActor1.LoadFromFile('trinityRAGE.smd');
  GLActor1.AddDataFromFile('walk.smd');
  GLActor1.Animations[1].MakeSkeletalTranslationStatic;
  GLActor1.SwitchToAnimation('walk');
  GLActor1.BuildSilhouetteConnectivityData;

  // Load the cape
  Cape.LoadFromFile('cape.3ds');
  Cape.Position.Y := GLActor1.BoundingSphereRadius - 10;
  PrepareMeshForNormalsRecalc(Cape);
  Cape.BuildSilhouetteConnectivityData;

  // Set up the floor texture and reposition to below the actors feet
  GLPlane1.Material.Texture.Image.LoadFromFile('beigemarble.jpg');
  GLPlane1.Material.Texture.Disabled := False;
  GLPlane1.Position.Y := -GLActor1.BoundingSphereRadius * 0.9;

  // Setting up the verlet world using the optional dynamic octree can
  // give good perfamnce increases.
  VerletWorld := TGLVerletWorld.Create;
  VerletWorld.CreateOctree(AffineVectorMake(0, 0, 0),
    AffineVectorMake(0, 0, 0), 10, 6);

  VerletWorld.UpdateSpacePartion := uspEveryFrame;
  VerletWorld.Iterations := 3;

  // 'Clothify' the cape and add it to the verlet world
  EdgeDetector := TEdgeDetector.Create(Cape);
  EdgeDetector.ProcessMesh;
  EdgeDetector.AddEdgesAsSticks(VerletWorld, 0.15);
  EdgeDetector.AddEdgesAsSolidEdges(VerletWorld);
  // EdgeDetector.AddOuterEdgesAsSolidEdges(VerletWorld);

  // Set up verlet gravity and add the floor as a constraint
  with TVFGravity.Create(VerletWorld) do
    Gravity := AffineVectorMake(0, -98.1, 0);
  with TVCFloor.Create(VerletWorld) do
  begin
    Normal := GLPlane1.Direction.AsAffineVector;
    Location := VectorAdd(GLPlane1.Position.AsAffineVector,
      VectorScale(GLPlane1.Direction.AsAffineVector, 0.1));
  end;

  // Load the skeleton colliders. Skeleton colliders define an
  // approximate collision boundary for actors and are controlled
  // by the actor's skeleton.
  with GLActor1.Skeleton.Colliders do
  begin
    LoadFromFile('trinityRAGE.glsc');
    AlignColliders;
  end;

  // Add the collider's verlet constraints to the verlet world
  AddSCVerletConstriantsToVerletWorld(GLActor1.Skeleton.Colliders, VerletWorld);

  { AirResistance := TVFAirResistance.Create(VerletWorld);
    AirResistance.DragCoeff := 0.001;
    AirResistance.WindDirection := AffineVectorMake(0,0,1);
    AirResistance.WindMagnitude := 15;
    AirResistance.WindChaos := 2;// }
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  VerletWorld.Free;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  i: Integer;
begin
  // Step the verlet world (this is where the magic happens)
  VerletWorld.Progress(deltaTime, newTime);

  // Recalculate the cape's normals
  RecalcMeshNormals(Cape);

  // Cycle the floor texture to make it look like it's moving
  GLPlane1.YOffset := GLPlane1.YOffset - 0.25 * deltaTime;
  if GLPlane1.YOffset < 0 then
    GLPlane1.YOffset := GLPlane1.YOffset + 1;

  // Orbit the light (to show off the pretty shadow volumes)
  GLLightSource1.MoveObjectAround(GLActor1, 0, -deltaTime * 20);
  GLLightSource1.PointTo(GLActor1, YHMGVector);
end;

procedure TForm1.OctreeRendererRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
  procedure RenderAABB(AABB: TAABB; w, r, g, b: single);
  begin
    glColor3f(r, g, b);
    glLineWidth(w);

    glBegin(GL_LINE_STRIP);
    glVertex3f(AABB.min.X, AABB.min.Y, AABB.min.Z);
    glVertex3f(AABB.min.X, AABB.max.Y, AABB.min.Z);
    glVertex3f(AABB.max.X, AABB.max.Y, AABB.min.Z);
    glVertex3f(AABB.max.X, AABB.min.Y, AABB.min.Z);
    glVertex3f(AABB.min.X, AABB.min.Y, AABB.min.Z);

    glVertex3f(AABB.min.X, AABB.min.Y, AABB.max.Z);
    glVertex3f(AABB.min.X, AABB.max.Y, AABB.max.Z);
    glVertex3f(AABB.max.X, AABB.max.Y, AABB.max.Z);
    glVertex3f(AABB.max.X, AABB.min.Y, AABB.max.Z);
    glVertex3f(AABB.min.X, AABB.min.Y, AABB.max.Z);
    glEnd;

    glBegin(GL_LINES);
    glVertex3f(AABB.min.X, AABB.max.Y, AABB.min.Z);
    glVertex3f(AABB.min.X, AABB.max.Y, AABB.max.Z);

    glVertex3f(AABB.max.X, AABB.max.Y, AABB.min.Z);
    glVertex3f(AABB.max.X, AABB.max.Y, AABB.max.Z);

    glVertex3f(AABB.max.X, AABB.min.Y, AABB.min.Z);
    glVertex3f(AABB.max.X, AABB.min.Y, AABB.max.Z);
    glEnd;
  end;

  procedure RenderOctreeNode(Node: TSectorNode);
  var
    i: Integer;
    AABB: TAABB;
  begin
    if Node.NoChildren then
    begin
      AABB := Node.AABB;

      if Node.RecursiveLeafCount > 0 then
        RenderAABB(AABB, 1, 0, 0, 0)
      else
        RenderAABB(AABB, 1, 0.8, 0.8, 0.8) // }

    end
    else
    begin
      for i := 0 to Node.ChildCount - 1 do
        RenderOctreeNode(Node.Children[i]);
    end;
  end;

begin
  if CheckBox_ShowOctree.Checked then
  begin
    if VerletWorld.SpacePartition is TOctreeSpacePartition then
    begin
      glPushAttrib(GL_ENABLE_BIT or GL_CURRENT_BIT or GL_LINE_BIT or
        GL_COLOR_BUFFER_BIT);
      glDisable(GL_LIGHTING);

      RenderOctreeNode(TOctreeSpacePartition(VerletWorld.SpacePartition)
        .RootNode);
      glPopAttrib;
    end;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  LabelFPS.Caption := Format('%2.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssLeft in Shift then
    GLCamera1.MoveAroundTarget(my - Y, mx - X);
  mx := X;
  my := Y;
end;

end.
