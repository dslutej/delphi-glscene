unit FViewerForm;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.ToolWin, Vcl.Menus,
  //GR32
  GR32_Image, GR32,
  
  GLHeightTileFile, GLVectorGeometry, GLUtils;

type
  TViewerForm = class(TForm)
    ToolBar: TToolBar;
    ImageList: TImageList;
    ActionList: TActionList;
    ToolButton1: TToolButton;
    LAMap: TLabel;
    ToolButton2: TToolButton;
    ACOpen: TAction;
    ACExit: TAction;
    ToolButton3: TToolButton;
    OpenDialog: TOpenDialog;
    PaintBox: TPaintBox32;
    ToolButton4: TToolButton;
    TBGrid: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ACNavMap: TAction;
    StatusBar: TStatusBar;
    ToolButton7: TToolButton;
    ACPalette: TAction;
    PMPalettes: TPopupMenu;
    OpenDialogPal: TOpenDialog;
    procedure ACExitExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ACOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxResize(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TBGridClick(Sender: TObject);
    procedure ACNavMapExecute(Sender: TObject);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ACNavMapUpdate(Sender: TObject);
    procedure ACPaletteExecute(Sender: TObject);
  private
     
  public
     
    htf : TGLHeightTileFile;
    bmpTile : TBitmap32;
    curX, curY, mx, my : Integer;
    procedure PrepareBitmap;
  end;

var
  ViewerForm: TViewerForm;

var
   heightColor : array [Low(SmallInt)..High(SmallInt)] of TColor32;

implementation

{$R *.dfm}

uses FNavForm;

{ Quick'n dirty parser for palette file format '.pal', in which each line defines
  nodes in the color ramp palette:

   value:red,green,blue

   color is then interpolated between node values (ie. between each line in the file)
}
procedure PreparePal(const fileName : String);

   procedure ParseLine(buf : String; var n : Integer; var c : TAffineVector);
   var
      p : Integer;
   begin
      p:=Pos(':', buf);
      n:=StrToInt(Copy(buf, 1, p-1)); buf:=Copy(buf, p+1, MaxInt);
      p:=Pos(',', buf);
      c.X:=StrToInt(Copy(buf, 1, p-1)); buf:=Copy(buf, p+1, MaxInt);
      p:=Pos(',', buf);
      c.Y:=StrToInt(Copy(buf, 1, p-1)); buf:=Copy(buf, p+1, MaxInt);
      c.Z:=StrToInt(buf);
   end;

var
   prev, next : Integer;
   pC, nC : TAffineVector;

   procedure Ramp;
   var
      cur : Integer;
      cC : TAffineVector;
      d : Single;
   begin
      if prev<next then
         d:=1/(next-prev)
      else d:=0;
      for cur:=prev to next do begin
         cC:=VectorLerp(pC, nC, (cur-prev)*d);
         heightColor[cur]:=Color32(Round(cC.X), Round(cC.Y), Round(cC.Z));
      end;
   end;

var
   i : Integer;
   sl : TStrings;
begin
   sl:=TStringList.Create;
   try
      sl.LoadFromFile(fileName);
      prev:=0;
      pC:=NullVector;
      for i:=0 to sl.Count-1 do begin
         ParseLine(sl[i], next, nC);
         Ramp;
         prev:=next;
         pC:=nC;
      end;
   finally
      sl.Free;
   end;
end;

procedure TViewerForm.FormCreate(Sender: TObject);
var
   i : Integer;
   sr : TSearchRec;
   mi : TMenuItem;
   sl : TStringList;
   AppDir : String;

begin
   bmpTile:=TBitmap32.Create;

   AppDir:=ExtractFilePath(ParamStr(0));

   PreparePal(appDir+'Blue-Green-Red.pal');
   i:=FindFirst(appDir+'*.pal', faAnyFile, sr);
   sl:=TStringList.Create;
   try
      while i=0 do begin
         sl.Add(sr.Name);
         i:=FindNext(sr);
      end;
      sl.Sort;
      for i:=0 to sl.Count-1 do begin
         mi:=TMenuItem.Create(PMPalettes);
         mi.Caption:=Copy(sl[i], 1, Length(sl[i])-4);
         mi.Hint:=appDir+sl[i];
         mi.OnClick:=ACPaletteExecute;
         PMPalettes.Items.Add(mi);
      end;
   finally
      sl.Free;
      FindClose(sr);
   end;
end;

procedure TViewerForm.FormDestroy(Sender: TObject);
begin
   htf.Free;
   bmpTile.Free;
end;

procedure TViewerForm.ACExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TViewerForm.ACOpenExecute(Sender: TObject);
var
  I : Integer;
begin
  SetGLSceneMediaDir;
  OpenDialog.InitialDir := GetCurrentDir;
  if OpenDialog.Execute then begin
     htf.Free;
     htf:=TGLHeightTileFile.Create(OpenDialog.FileName);
     Caption:='HTFViewer - '+ExtractFileName(OpenDialog.FileName);
     curX:=0;
     curY:=0;
     PrepareBitmap;
     PaintBox.Invalidate;
  end;
end;

procedure TViewerForm.PrepareBitmap;
var
   i, sx, tx, ty : Integer;
   scanLine : PColor32Array;
   tileInfo : PHeightTileInfo;
   dataRow : PSmallIntArray;
   tile : PHeightTile;
   start, lap, stop, htfTime, drawTime, freq : Int64;
   tileList : TList;
   bmp : TBitmap32;
begin
   sx:=PaintBox.Width;
   bmp:=PaintBox.Buffer;
   bmp.Clear(clBlack32);
   if not Assigned(htf) then Exit;

   drawTime:=0;
   tileList:=TList.Create;
   try
      QueryPerformanceCounter(start);
      htf.TilesInRect(curX, curY, curX+sx-1, curY+bmp.Height-1, tileList);
      QueryPerformanceCounter(stop);
      htfTime:=stop-start;

      for i:=0 to tileList.Count-1 do begin
         tileInfo:=PHeightTileInfo(tileList[i]);

         QueryPerformanceCounter(start);

         tile:=htf.GetTile(tileInfo.left, tileInfo.top);

         QueryPerformanceCounter(lap);

         bmpTile.Width:=tileinfo.width;
         bmpTile.Height:=tileInfo.height;
         for ty:=0 to tileInfo.height-1 do begin
            scanLine:=bmpTile.ScanLine[ty];
            dataRow:=@tile.data[ty*tileInfo.width];
            for tx:=0 to tileInfo.width-1 do
               scanLine[tx]:=heightColor[dataRow[tx]];
         end;
         bmp.Draw(tileInfo.left-curX, tileInfo.top-curY, bmpTile);

         QueryPerformanceCounter(stop);

         htfTime:=htfTime+lap-start;
         drawTime:=drawTime+stop-lap;
      end;

      if TBGrid.Down then begin
         for i:=0 to tileList.Count-1 do with PHeightTileInfo(tileList[i])^ do begin
            bmp.FrameRectS(left-curX, top-curY, left+width-curX+1, top+height-curY+1, clWhite32);
         end;
      end;
   finally
      tileList.Free;
   end;

   QueryPerformanceFrequency(freq);
   LAMap.Caption:=Format(' %d x %d - %.1f ms HTF - %.1fms Draw ',
                         [htf.SizeX, htf.SizeY,
                          1000*htfTime/freq,
                          1000*drawTime/freq]);
end;

procedure TViewerForm.PaintBoxResize(Sender: TObject);
begin
   if Assigned(htf) then
      PrepareBitmap;
end;

procedure TViewerForm.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=X; my:=Y;
   Screen.Cursor:=crSizeAll;
end;

procedure TViewerForm.PaintBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Screen.Cursor:=crDefault;
end;

procedure TViewerForm.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   tileIdx, n : Integer;
   tileInfo : PHeightTileInfo;
begin
   if Shift<>[] then begin
      curX:=curX-(x-mx);
      curY:=curY-(y-my);
      mx:=x;
      my:=y;
      PrepareBitmap;
      PaintBox.Refresh;
   end;
   if Assigned(htf) then begin
      x:=x+curX;
      y:=y+curY;
      StatusBar.Panels[0].Text:=' X: '+IntToStr(x);
      StatusBar.Panels[1].Text:=' Y: '+IntToStr(y);
      StatusBar.Panels[2].Text:=' H: '+IntToStr(htf.XYHeight(x, y));

      tileInfo:=htf.XYTileInfo(x, y);
      if Assigned(tileInfo) then begin
         tileIdx:=htf.IndexOfTile(tileInfo);
         StatusBar.Panels[3].Text:=' Tile: '+IntToStr(tileIdx);
         n:=htf.TileCompressedSize(tileIdx)+SizeOf(TGLHeightTileInfo);
         StatusBar.Panels[4].Text:=Format(' %.2f kB (%.0f %%)',
                                          [n/1024, 100-100*n/(htf.TileSize*htf.TileSize*2)]);
         StatusBar.Panels[5].Text:=Format(' Tile average: %d, range: [%d; %d])',
                                          [tileInfo.average, tileInfo.min, tileInfo.max]);
      end else begin
         StatusBar.Panels[3].Text:=' Tile: N/A';
         StatusBar.Panels[4].Text:=' N/A';
         StatusBar.Panels[5].Text:=' N/A';
      end;
   end;
end;

procedure TViewerForm.TBGridClick(Sender: TObject);
begin
   PrepareBitmap;
   PaintBox.Invalidate;
end;

procedure TViewerForm.ACNavMapExecute(Sender: TObject);
begin
   if NavForm.Execute(htf) then begin
      curX:=NavForm.PickX;
      curY:=NavForm.PickY;
      PrepareBitmap;
      PaintBox.Invalidate;
   end;
end;

procedure TViewerForm.ACNavMapUpdate(Sender: TObject);
begin
   ACNavMap.Enabled:=Assigned(htf);
end;

procedure TViewerForm.ACPaletteExecute(Sender: TObject);
begin
   if Sender is TMenuItem then
      PreparePal(TMenuItem(Sender).Hint)
   else if OpenDialogPal.Execute then
         PreparePal(OpenDialogPal.FileName);
   PrepareBitmap;
   PaintBox.Invalidate;
end;

end.
