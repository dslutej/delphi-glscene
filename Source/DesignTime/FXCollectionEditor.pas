//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  Edits a TGLXCollection 

   History :  
   20/01/11 - DanB - Collection items are now grouped by ItemCategory
   16/06/10 - YP - Fixed IDE exception when item removed
   05/10/08 - DanB - removed Kylix support + some other old ifdefs
   29/03/07 - DaStr - Renamed LINUX to KYLIX (BugTrackerID=1681585)
   03/07/04 - LR - Make change for Linux
   12/07/03 - DanB - Fixed crash when owner deleted
   27/02/02 - Egg - Fixed crash after item deletion
   11/04/00 - Egg - Fixed crashes in IDE
   06/04/00 - Egg - Creation
   
}
unit FXCollectionEditor;

interface

{$I GLScene.inc}

uses
  System.Classes, 
  System.SysUtils, 
  System.Actions, 
  System.ImageList,
  VCL.Forms, 
  VCL.ImgList, 
  VCL.Controls, 
  VCL.ActnList, 
  VCL.Menus,
  VCL.ComCtrls, 
  VCL.ToolWin, 
  VCL.Dialogs,

  DesignIntf,

  GLStrings,
  GLScene,
  GLBehaviours,
  GLMaterialEx,
  GLXCollection;

type
  TGLXCollectionEditorForm = class(TForm)
    ListView: TListView;
    PMListView: TPopupMenu;
    ActionList: TActionList;
    ACRemove: TAction;
    ACMoveUp: TAction;
    ACMoveDown: TAction;
    ImageList: TImageList;
    MIAdd: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    ToolBar1: TToolBar;
    TBAdd: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    PMToolBar: TPopupMenu;
    procedure TBAddClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ACRemoveExecute(Sender: TObject);
    procedure ACMoveUpExecute(Sender: TObject);
    procedure ACMoveDownExecute(Sender: TObject);
    procedure PMToolBarPopup(Sender: TObject);
    procedure PMListViewPopup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
     
    FXCollection: TGLXCollection;
    // ownerComponent : TComponent;
    FDesigner: IDesigner;
    UpdatingListView: Boolean;
    procedure PrepareListView;
    procedure PrepareXCollectionItemPopup(parent: TMenuItem);
    procedure OnAddXCollectionItemClick(Sender: TObject);
    procedure OnNameChanged(Sender: TObject);
    procedure OnXCollectionDestroyed(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    
    procedure SetXCollection(aXCollection: TGLXCollection; designer: IDesigner );
  end;

function GLXCollectionEditorForm: TGLXCollectionEditorForm;
procedure ReleaseXCollectionEditor;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

{$R *.dfm}

var
  vGLXCollectionEditorForm: TGLXCollectionEditorForm;

function GLXCollectionEditorForm: TGLXCollectionEditorForm;
begin
  if not Assigned(vGLXCollectionEditorForm) then
    vGLXCollectionEditorForm := TGLXCollectionEditorForm.Create(nil);
  Result := vGLXCollectionEditorForm;
end;

procedure ReleaseXCollectionEditor;
begin
  if Assigned(vGLXCollectionEditorForm) then
  begin
    vGLXCollectionEditorForm.Release;
    vGLXCollectionEditorForm := nil;
  end;
end;

// FormCreate
//
procedure TGLXCollectionEditorForm.FormCreate(Sender: TObject);
begin
  RegisterGLBehaviourNameChangeEvent(OnNameChanged);
  RegisterGLMaterialExNameChangeEvent(OnNameChanged);
  RegisterXCollectionDestroyEvent(OnXCollectionDestroyed);
end;

// FormDestroy
//
procedure TGLXCollectionEditorForm.FormDestroy(Sender: TObject);
begin
  DeRegisterGLBehaviourNameChangeEvent(OnNameChanged);
  DeRegisterGLMaterialExNameChangeEvent(OnNameChanged);
  DeRegisterXCollectionDestroyEvent(OnXCollectionDestroyed);
end;

// FormHide
//
procedure TGLXCollectionEditorForm.FormHide(Sender: TObject);
begin
  SetXCollection(nil, nil);
  ReleaseXCollectionEditor;
end;

// SetXCollection
//
procedure TGLXCollectionEditorForm.SetXCollection(aXCollection: TGLXCollection; designer: IDesigner);
begin
  // if Assigned(ownerComponent) then
  // ownerComponent.RemoveFreeNotification(Self);
  FXCollection := aXCollection;
  FDesigner := designer;
  if Assigned(FXCollection) then
  begin
    // if Assigned(FXCollection.Owner) and (FXCollection.Owner is TComponent) then
    // ownerComponent:=TComponent(FXCollection.Owner);
    // if Assigned(ownerComponent) then
    // ownerComponent.FreeNotification(Self);
    Caption := FXCollection.GetNamePath;
  end
  else
  begin
    // ownerComponent:=nil;
    Caption := strXCollectionEditor;
  end;
  PrepareListView;
end;

// TBAddClick
//
procedure TGLXCollectionEditorForm.TBAddClick(Sender: TObject);
begin
  TBAdd.CheckMenuDropdown;
end;

// ListViewChange
//
procedure TGLXCollectionEditorForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  sel: Boolean;
begin
  if (Change = ctState) and Assigned(FDesigner) and (not updatingListView) then
  begin
    // setup enablings
    sel := (ListView.Selected <> nil);
    TBAdd.Enabled := Assigned(FDesigner);
    ACRemove.Enabled := sel;
    ACMoveUp.Enabled := sel and (ListView.Selected.Index > 0);
    ACMoveDown.Enabled := sel and
      (ListView.Selected.Index < ListView.Items.Count - 1);
    if Assigned(FDesigner) then
      if sel then
        FDesigner.SelectComponent(TGLXCollectionItem(ListView.Selected.Data))
      else
        FDesigner.SelectComponent(nil);
  end;
end;

// PrepareListView
//
procedure TGLXCollectionEditorForm.PrepareListView;
var
  i: Integer;
  prevSelData: Pointer;
  XCollectionItem: TGLXCollectionItem;
  DisplayedName: String;
begin
  Assert(Assigned(ListView));
  updatingListView := True;
  try
    if ListView.Selected <> nil then
      prevSelData := ListView.Selected.Data
    else
      prevSelData := nil;
    with ListView.Items do
    begin
      BeginUpdate;
      Clear;
      if Assigned(FXCollection) then
      begin
        for i := 0 to FXCollection.Count - 1 do
          with Add do
          begin
            XCollectionItem := FXCollection[i];
            DisplayedName := XCollectionItem.Name;
            if DisplayedName = '' then
              DisplayedName := '(unnamed)';
            Caption := Format('%d - %s', [i, DisplayedName]);
            SubItems.Add(XCollectionItem.FriendlyName);
            Data := XCollectionItem;
          end;
        if prevSelData <> nil then
          ListView.Selected := ListView.FindData(0, prevSelData, True, False);
      end;
      EndUpdate;
    end;
  finally
    updatingListView := False;
  end;
  ListViewChange(Self, nil, ctState);
end;

// PrepareXCollectionItemPopup
//
procedure TGLXCollectionEditorForm.PrepareXCollectionItemPopup(parent: TMenuItem);
var
  i: Integer;
  list: TList;
  XCollectionItemClass: TGLXCollectionItemClass;
  mi, categoryItem: TMenuItem;
begin
  list := GetXCollectionItemClassesList(FXCollection.ItemsClass);
  try
    parent.Clear;
    for i := 0 to list.Count - 1 do
    begin
      XCollectionItemClass := TGLXCollectionItemClass(list[i]);
      if XCollectionItemClass.ItemCategory <> '' then
      begin
        categoryItem := parent.Find(XCollectionItemClass.ItemCategory);
        if categoryItem = nil then
        begin
          categoryItem := TMenuItem.Create(owner);
          categoryItem.Caption := XCollectionItemClass.ItemCategory;
          parent.Add(categoryItem);
        end;
      end
      else
        categoryItem := parent;

      mi := TMenuItem.Create(owner);
      mi.Caption := XCollectionItemClass.FriendlyName;
      mi.OnClick := OnAddXCollectionItemClick;
      mi.Tag := Integer(XCollectionItemClass);
      mi.Enabled := Assigned(FXCollection) and
        FXCollection.CanAdd(XCollectionItemClass);
      categoryItem.Add(mi);
    end;
  finally
    list.Free;
  end;
end;

// OnNameChanged
//
procedure TGLXCollectionEditorForm.OnNameChanged(Sender: TObject);
begin
  if TGLXCollectionItem(Sender).owner = FXCollection then
    PrepareListView;
end;

// OnXCollectionDestroyed
//
procedure TGLXCollectionEditorForm.OnXCollectionDestroyed(Sender: TObject);
begin
  if TGLXCollection(Sender) = FXCollection then
    Close;
end;

// Notification
//
procedure TGLXCollectionEditorForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  { if (Operation=opRemove) and (AComponent=ownerComponent) then begin
    ownerComponent:=nil;
    SetXCollection(nil, nil);
    Close;
    end;
  }
  inherited;
end;

// OnAddXCollectionItemClick
//
procedure TGLXCollectionEditorForm.OnAddXCollectionItemClick(Sender: TObject);
var
  XCollectionItemClass: TGLXCollectionItemClass;
  XCollectionItem: TGLXCollectionItem;
begin
  XCollectionItemClass := TGLXCollectionItemClass((Sender as TMenuItem).Tag);
  XCollectionItem := XCollectionItemClass.Create(FXCollection);
  PrepareListView;
  ListView.Selected := ListView.FindData(0, XCollectionItem, True, False);
  FDesigner.Modified;
end;

// ACRemoveExecute
//
procedure TGLXCollectionEditorForm.ACRemoveExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then
  begin
    FDesigner.Modified;
    FDesigner.SelectComponent(FXCollection.owner);

    TGLXCollectionItem(ListView.Selected.Data).Free;
    ListView.Selected.Free;
    ListViewChange(Self, nil, ctState);
  end;
end;

// ACMoveUpExecute
//
procedure TGLXCollectionEditorForm.ACMoveUpExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then
  begin
    TGLXCollectionItem(ListView.Selected.Data).MoveUp;
    PrepareListView;
    FDesigner.Modified;
  end;
end;

// ACMoveDownExecute
//
procedure TGLXCollectionEditorForm.ACMoveDownExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then
  begin
    TGLXCollectionItem(ListView.Selected.Data).MoveDown;
    PrepareListView;
    FDesigner.Modified;
  end;
end;

// PMToolBarPopup
//
procedure TGLXCollectionEditorForm.PMToolBarPopup(Sender: TObject);
begin
  PrepareXCollectionItemPopup(PMToolBar.Items);
end;

// PMListViewPopup
//
procedure TGLXCollectionEditorForm.PMListViewPopup(Sender: TObject);
begin
  PrepareXCollectionItemPopup(MIAdd);
end;

initialization

finalization

ReleaseXCollectionEditor;

end.
