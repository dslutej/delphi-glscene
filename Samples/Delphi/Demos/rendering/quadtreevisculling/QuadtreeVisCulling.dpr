{: Using the TOctreeSpacePartition for visibility culling.<p>

  Demo by HRLI slightly reworked to be a quadtree demo and committed by MF.<p>
}
program QuadtreeVisCulling;

uses
  Forms,
  fQuadtreeVisCulling in 'fQuadtreeVisCulling.pas' {frmQuadtreeVisCulling};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmQuadtreeVisCulling, frmQuadtreeVisCulling);
  Application.Run;
end.
