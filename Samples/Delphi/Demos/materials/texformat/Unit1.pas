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
  GLObjects,
  GLTexture,
  GLHUDObjects,
  GLCadencer,
  GLWin32Viewer,
  GLCoordinates,
  GLCrossPlatform,
  GLBaseClasses;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    Panel1: TPanel;
    CBFormat: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    CBCompression: TComboBox;
    Label4: TLabel;
    CBImage: TComboBox;
    LAPicSize: TLabel;
    Label5: TLabel;
    RBDefault: TRadioButton;
    RBDouble: TRadioButton;
    HUDSprite1: TGLHUDSprite;
    LAUsedMemory: TLabel;
    RBQuad: TRadioButton;
    LARGB32: TLabel;
    LACompression: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CBImageChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GLSceneViewer1AfterRender(Sender: TObject);
  private
     
  public
     
    newSelection: Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  GLTextureFormat, GLUtils;

procedure TForm1.FormCreate(Sender: TObject);
var
  sr: TSearchRec;
  i: Integer;
begin
  SetGLSceneMediaDir();
  // collect JPeg textures from the demos' media directory
  i := FindFirst('*.jpg', faAnyFile, sr);
  while i = 0 do
  begin
    CBImage.Items.Add(sr.Name);
    i := FindNext(sr);
  end;
  FindClose(sr);
  // default selection
  CBFormat.ItemIndex := 0;
  CBCompression.ItemIndex := 0;
  CBImage.ItemIndex := 0;
  CBImageChange(Self);
end;

procedure TForm1.CBImageChange(Sender: TObject);
begin
  // adjust settings from selection and reload the texture map
  with HUDSprite1.Material.Texture do
  begin
    TextureFormat := TGLTextureFormat(Integer(tfRGB) + CBFormat.ItemIndex);
    Compression := TGLTextureCompression(Integer(tcNone) +
      CBCompression.ItemIndex);
    Image.LoadFromFile(CBImage.Text);
    LAPicSize.Caption := IntToStr(Image.Width) + ' x ' + IntToStr(Image.Height);
    if RBDefault.Checked then
    begin
      HUDSprite1.Width := Image.Width;
      HUDSprite1.Height := Image.Height;
    end
    else if RBDouble.Checked then
    begin
      HUDSprite1.Width := Image.Width * 2;
      HUDSprite1.Height := Image.Height * 2;
    end
    else
    begin
      HUDSprite1.Width := Image.Width * 4;
      HUDSprite1.Height := Image.Height * 4;
    end;
  end;
  FormResize(Self);
  newSelection := True;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  // re-center the HUDSprite
  HUDSprite1.Position.X := GLSceneViewer1.Width / 2;
  HUDSprite1.Position.Y := GLSceneViewer1.Height / 2;
  GLSceneViewer1.Invalidate;
end;

procedure TForm1.GLSceneViewer1AfterRender(Sender: TObject);
var
  rgb: Integer;
begin
  // update compression stats, only the 1st time after a new selection
  if newSelection then
    with HUDSprite1.Material.Texture do
    begin
      rgb := Image.Width * Image.Height * 4;
      LARGB32.Caption := Format('RGBA 32bits would require %d kB',
        [rgb div 1024]);
      LAUsedMemory.Caption := Format('Required memory : %d kB',
        [TextureImageRequiredMemory div 1024]);
      LACompression.Caption := Format('Compression ratio : %d %%',
        [100 - 100 * TextureImageRequiredMemory div rgb]);
      newSelection := False;
    end;
end;

end.
