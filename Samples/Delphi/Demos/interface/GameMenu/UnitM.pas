unit UnitM;

interface

uses
  Winapi.Windows,
  Winapi.OpenGL,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Imaging.Jpeg,

  
  GLScene,
  GLObjects,
  GLWin32Viewer,
  GLGeomObjects,
  GLBitmapFont,
  GLWindowsFont,
  GLGameMenu,
  GLCadencer,
  GLTexture,
  GLKeyboard,
  GLCrossPlatform,
  GLMaterial,
  GLCoordinates,
  GLBaseClasses,
  GLUtils;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    GLCadencer1: TGLCadencer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCube1: TGLCube;
    MainPanel: TPanel;
    ShowTitleCheckbox: TCheckBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShowTitleCheckboxClick(Sender: TObject);
    procedure MainPanelResize(Sender: TObject);
  private
     
  public
     
    GameMenu: TGLGameMenu;
  end;

var
  Form1: TForm1;
  sMessage: String = 'You have selected the item ';
  sMenu: String = 'menu line ';


implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetGLSceneMediaDir();
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile('GLScene.bmp');

  GameMenu := TGLGameMenu(GLScene1.Objects.AddNewChild(TGLGameMenu));
  GameMenu.MaterialLibrary := GLMaterialLibrary1;
  GameMenu.TitleMaterialName := 'LibMaterial';
  GameMenu.TitleHeight := 80;
  GameMenu.TitleWidth := 200;
  GameMenu.Font := GLWindowsBitmapFont1;
  GameMenu.Items.Add(sMenu+'1');
  GameMenu.Items.Add(sMenu+'2');
  GameMenu.Items.Add(sMenu+'3');
  GameMenu.Items.Add(sMenu+'4');
  GameMenu.Items.Add(sMenu+'5');
  GameMenu.Items.Add(sMenu+'6');
  GameMenu.Spacing := 1;
  GameMenu.Selected := 0;
  GameMenu.Position.Y := 200;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if IsKeyDown('W') then GameMenu.SelectPrev;
//  if IsKeyDown(VK_UP) then GameMenu.SelectPrev;
  if IsKeyDown('S') then GameMenu.SelectNext;
//  if IsKeyDown(VK_DOWN) then GameMenu.SelectNext;
  if IsKeyDown(VK_RETURN) then
  begin
    if GameMenu.Selected <> -1 then
      ShowMessage(sMessage + '"'+GameMenu.SelectedText+ '"');
  end;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  GLSceneViewer1.Invalidate;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameMenu.MouseMenuSelect(X, Y);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GameMenu.MouseMenuSelect(X, Y);
  if GameMenu.Selected <> -1 then
    ShowMessage(sMessage + '"'+GameMenu.SelectedText+'"');
end;

procedure TForm1.ShowTitleCheckboxClick(Sender: TObject);
begin
  if GameMenu.TitleHeight = 0 then
    GameMenu.TitleHeight := 80
  else
   GameMenu.TitleHeight := 0;
end;

procedure TForm1.MainPanelResize(Sender: TObject);
begin
  GameMenu.Position.X := MainPanel.Width div 2;
end;

end.
