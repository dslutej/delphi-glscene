//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  Non visual wrapper around basic SDL window features. 
  Notes to Self:
  Unit must ultimately *NOT* make use of any platform specific stuff,
  *EVEN* through the use of conditionals.
  SDL-specifics should also be avoided in the "interface" section. 

  This component uses a Delphi header conversion for SDL from http://libsdl.org 

   History :  
   11/12/01 - Egg - Creation
   The whole history is logged in a former GLS version of the unit.
}
unit GLSDLWindow;

interface

{$I GLScene.inc}

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs,
  OpenGLAdapter, 
  GLContext, 
  GLVectorGeometry,
  SDL2;

type
  {  Pixel Depth options.
     vpd16bits: 16bpp graphics (565) (and 16 bits depth buffer for OpenGL)
     vpd24bits: 24bpp graphics (565) (and 24 bits depth buffer for OpenGL) }
  TGLSDLWindowPixelDepth = (vpd16bits, vpd24bits);

  {  Specifies optional settings for the SDL window.
    Those options are a simplified subset of the SDL options:
     voDoubleBuffer: create a double-buffered window
     voHardwareAccel: enables all hardware acceleration options (software
    only if not defined).
     voOpenGL: requires OpenGL capability for the window
     voResizable: window should be resizable
     voFullScreen: requires a full screen "window" (screen resolution may
    be changed)
     voStencilBuffer: requires a stencil buffer (8bits, use along voOpenGL)  }
  TGLSDLWindowOption = (voDoubleBuffer, voHardwareAccel, voOpenGL, voResizable,
    voFullScreen, voStencilBuffer);
  TGLSDLWindowOptions = set of TGLSDLWindowOption;
  TGLSDLEvent = procedure(sender: TObject; const event: TSDL_Event) of object;

const
  cDefaultSDLWindowOptions = [voDoubleBuffer, voHardwareAccel, voOpenGL,
    voResizable];

type
  {  A basic SDL-based window (non-visual component).
    Only a limited subset of SDL's features are available, and this window
    is heavily oriented toward using it for OpenGL rendering.
    Be aware SDL is currently limited to a single window at any time...
    so you may have multiple components, but only one can be used. }
  TGLSDLWindow = class(TComponent)
  private
    FWidth: Integer;
    FHeight: Integer;
    FPixelDepth: TGLSDLWindowPixelDepth;
    FOptions: TGLSDLWindowOptions;
    FActive: Boolean;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnResize: TNotifyEvent;
    FOnSDLEvent: TGLSDLEvent;
    FOnEventPollDone: TNotifyEvent;
    FCaption: String;
    FThreadSleepLength: Integer;
    FThreadPriority: TThreadPriority;
    FThreadedEventPolling: Boolean;
    FThread: TThread;
    FSDLSurface: PSDL_Surface;
    FWindowHandle: Longword;
  protected
    procedure SetWidth(const val: Integer);
    procedure SetHeight(const val: Integer);
    procedure SetPixelDepth(const val: TGLSDLWindowPixelDepth);
    procedure SetOptions(const val: TGLSDLWindowOptions);
    procedure SetActive(const val: Boolean);
    procedure SetCaption(const val: String);
    procedure SetThreadSleepLength(const val: Integer);
    procedure SetThreadPriority(const val: TThreadPriority);
    procedure SetThreadedEventPolling(const val: Boolean);
    function BuildSDLVideoFlags: Cardinal;
    procedure SetSDLGLAttributes;
    procedure CreateOrRecreateSDLSurface;
    procedure ResizeGLWindow;
    procedure SetupSDLEnvironmentValues;
    procedure StartThread;
    procedure StopThread;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {  Initializes and Opens an SDL window }
    procedure Open;
    {  Closes an already opened SDL Window.
      NOTE: will also kill the app due to an SDL limitation... }
    procedure Close;
    {  Applies changes (size, pixeldepth...) to the opened window. }
    procedure UpdateWindow;
    {  Swap front and back buffer.  }
    procedure SwapBuffers;
    {  Polls SDL events. 
      SDL events can be either polled "manually", through a call to this
      method, or automatically via ThreadEventPolling. }
    procedure PollEvents;
    {  Is the SDL window active (opened)? 
      Adjusting this value as the same effect as invoking Open/Close. }
    property Active: Boolean read FActive write SetActive;
    {  Presents the SDL surface of the window. 
      If Active is False, this value is undefined. }
    property Surface: PSDL_Surface read FSDLSurface;
    {  Experimental: ask SDL to reuse and existing WindowHandle }
    property WindowHandle: Cardinal read FWindowHandle write FWindowHandle;
  published
    {  Width of the SDL window.
      To apply changes to an active window, call UpdateWindow. }
    property Width: Integer read FWidth write SetWidth default 640;
    {  Height of the SDL window. 
      To apply changes to an active window, call UpdateWindow. }
    property Height: Integer read FHeight write SetHeight default 480;
    {  PixelDepth of the SDL window. 
      To apply changes to an active window, call UpdateWindow. }
    property PixelDepth: TGLSDLWindowPixelDepth read FPixelDepth
      write SetPixelDepth default vpd24bits;
    {  Options for the SDL window.
      To apply changes to an active window, call UpdateWindow. }
    property Options: TGLSDLWindowOptions read FOptions write SetOptions
      default cDefaultSDLWindowOptions;
    {  Caption of the SDL window }
    property Caption: String read FCaption write SetCaption;
    {  Controls automatic threaded event polling. }
    property ThreadedEventPolling: Boolean read FThreadedEventPolling
      write SetThreadedEventPolling default True;
    {  Sleep length between pollings in the polling thread. }
    property ThreadSleepLength: Integer read FThreadSleepLength
      write SetThreadSleepLength default 1;
    {  Priority of the event polling thread. }
    property ThreadPriority: TThreadPriority read FThreadPriority
      write SetThreadPriority default tpLower;
    {  Fired whenever Open succeeds. 
      The SDL surface is defined and usable when the event happens. }
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    {  Fired whenever closing the window. 
      The SDL surface is still defined and usable when the event happens. }
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    {  Fired whenever the window is resized. 
      Note: glViewPort call is handled automatically for OpenGL windows }
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    {  Fired whenever an SDL Event is polled. 
      SDL_QUITEV and SDL_VIDEORESIZE are not passed to this event handler,
      they are passed via OnClose and OnResize respectively. }
    property OnSDLEvent: TGLSDLEvent read FOnSDLEvent write FOnSDLEvent;
    {  Fired whenever an event polling completes with no events left to poll. }
    property OnEventPollDone: TNotifyEvent read FOnEventPollDone
      write FOnEventPollDone;
  end;

  {  Generic SDL or SDLWindow exception. }
  ESDLError = class(Exception);

procedure Register;

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
implementation
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------

var
  vSDLCS: TCriticalSection;
  vSDLActive: Boolean; // will be removed once SDL supports multiple windows

type

  TSDLEventThread = class(TThread)
    Owner: TGLSDLWindow;
    procedure Execute; override;
    procedure DoPollEvents;
  end;

procedure Register;
begin
  RegisterComponents('GLScene Utils', [TGLSDLWindow]);
end;

procedure RaiseSDLError(const msg: String = '');
begin
  if msg <> '' then
    raise ESDLError.Create(msg + #13#10 + SDL_GetError)
  else
    raise ESDLError.Create(SDL_GetError);
end;

// ------------------
// ------------------ TSDLEventThread ------------------
// ------------------

procedure TSDLEventThread.Execute;
begin
  try
    while not Terminated do
    begin
      vSDLCS.Enter;
      try
        SDL_Delay(Owner.ThreadSleepLength);
      finally
        vSDLCS.Leave;
      end;
      Synchronize(DoPollEvents);
    end;
  except
    // bail out asap, problem wasn't here anyway
  end;
  vSDLCS.Enter;
  try
    if Assigned(Owner) then
      Owner.FThread := nil;
  finally
    vSDLCS.Leave;
  end;
end;

procedure TSDLEventThread.DoPollEvents;
begin
  // no need for a CS here, we're in the main thread
  if Assigned(Owner) then
    Owner.PollEvents;
end;

// ------------------
// ------------------ TSDLWindow ------------------
// ------------------

constructor TGLSDLWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 640;
  FHeight := 480;
  FPixelDepth := vpd24bits;
  FThreadedEventPolling := True;
  FThreadSleepLength := 1;
  FThreadPriority := tpLower;
  FOptions := cDefaultSDLWindowOptions;
end;

destructor TGLSDLWindow.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TGLSDLWindow.SetWidth(const val: Integer);
begin
  if FWidth <> val then
    if val > 0 then
      FWidth := val;
end;

procedure TGLSDLWindow.SetHeight(const val: Integer);
begin
  if FHeight <> val then
    if val > 0 then
      FHeight := val;
end;

procedure TGLSDLWindow.SetPixelDepth(const val: TGLSDLWindowPixelDepth);
begin
  FPixelDepth := val;
end;

procedure TGLSDLWindow.SetOptions(const val: TGLSDLWindowOptions);
begin
  FOptions := val;
end;

function TGLSDLWindow.BuildSDLVideoFlags: Cardinal;
var
  videoInfo: PSDL_VideoInfo;
begin
  videoInfo := SDL_GetVideoInfo;
  if not Assigned(videoInfo) then
    raise ESDLError.Create('Video query failed.');

  Result := 0;
  if voOpenGL in Options then
    Result := Result + SDL_OPENGL;
  if voDoubleBuffer in Options then
    Result := Result + SDL_DOUBLEBUF;
  if voResizable in Options then
    Result := Result + SDL_RESIZABLE;
  if voFullScreen in Options then
    Result := Result + SDL_FULLSCREEN;
  if voHardwareAccel in Options then
  begin
    if videoInfo.hw_available <> 0 then
      Result := Result + SDL_HWPALETTE + SDL_HWSURFACE
    else
      Result := Result + SDL_SWSURFACE;
    if videoInfo.blit_hw <> 0 then
      Result := Result + SDL_HWACCEL;
  end
  else
    Result := Result + SDL_SWSURFACE;
end;

procedure TGLSDLWindow.SetSDLGLAttributes;
begin
  case PixelDepth of
    vpd16bits:
      begin
        SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 5);
        SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 6);
        SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 5);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 16);
      end;
    vpd24bits:
      begin
        SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
      end;
  else
    Assert(False);
  end;
  if voStencilBuffer in Options then
    SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8)
  else
    SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 0);
  if voDoubleBuffer in Options then
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
  else
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 0)
end;

procedure TGLSDLWindow.CreateOrRecreateSDLSurface;
const
  cPixelDepthToBpp: array [Low(TGLSDLWindowPixelDepth)
    .. High(TGLSDLWindowPixelDepth)] of Integer = (16, 24);
var
  videoFlags: Integer;
begin
  videoFlags := BuildSDLVideoFlags;
  if voOpenGL in Options then
    SetSDLGLAttributes;

  FSDLSurface := SDL_SetVideoMode(Width, Height, cPixelDepthToBpp[PixelDepth],
    videoFlags);
  if not Assigned(FSDLSurface) then
    RaiseSDLError('Unable to create surface.');

  SDL_WM_SetCaption(PAnsiChar(AnsiString(FCaption)), nil);

  if voOpenGL in Options then
    ResizeGLWindow;
end;

procedure TGLSDLWindow.SetupSDLEnvironmentValues;
var
  envVal: String;
begin
  if FWindowHandle <> 0 then
  begin
    envVal := '';
	
    SDL_putenv('SDL_VIDEODRIVER=windib');
    envVal := 'SDL_WINDOWID=' + IntToStr(Integer(FWindowHandle));
	
    SDL_putenv(PAnsiChar(AnsiString(envVal)));
  end;
end;

procedure TGLSDLWindow.Open;
begin
  if Active then
    Exit;
  if vSDLActive then
    raise ESDLError.Create('Only one SDL window can be opened at a time...')
  else
    vSDLActive := True;

  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    raise ESDLError.Create('Could not initialize SDL.');
  if voOpenGL in Options then
    InitOpenGL;
  SetupSDLEnvironmentValues;

  CreateOrRecreateSDLSurface;

  FActive := True;
  if Assigned(FOnOpen) then
    FOnOpen(Self);
  if Assigned(FOnResize) then
    FOnResize(Self);
  if ThreadedEventPolling then
    StartThread;
end;

procedure TGLSDLWindow.Close;
begin
  if not Active then
    Exit;
  if Assigned(FOnClose) then
    FOnClose(Self);
  FActive := False;
  StopThread;
  SDL_Quit; // SubSystem(SDL_INIT_VIDEO);
  FSDLSurface := nil;
  vSDLActive := False;
end;

procedure TGLSDLWindow.UpdateWindow;
begin
  if Active then
    CreateOrRecreateSDLSurface;
end;

procedure TGLSDLWindow.SwapBuffers;
begin
  if Active then
    if voOpenGL in Options then
      SDL_GL_SwapBuffers
    else
      SDL_Flip(Surface);
end;

procedure TGLSDLWindow.ResizeGLWindow;
var
  RC: TGLContext;
begin
  RC := CurrentGLContext;
  if Assigned(RC) then
    RC.GLStates.ViewPort := Vector4iMake(0, 0, Width, Height);
end;

procedure TGLSDLWindow.SetActive(const val: Boolean);
begin
  if val <> FActive then
    if val then
      Open
    else
      Close;
end;

procedure TGLSDLWindow.SetCaption(const val: String);
begin
  if FCaption <> val then
  begin
    FCaption := val;
    if Active then
      SDL_WM_SetCaption(PAnsiChar(AnsiString(FCaption)), nil);
  end;
end;

procedure TGLSDLWindow.SetThreadSleepLength(const val: Integer);
begin
  if val >= 0 then
    FThreadSleepLength := val;
end;

procedure TGLSDLWindow.SetThreadPriority(const val: TThreadPriority);
begin
  FThreadPriority := val;
  if Assigned(FThread) then
    FThread.Priority := val;
end;

procedure TGLSDLWindow.SetThreadedEventPolling(const val: Boolean);
begin
  if FThreadedEventPolling <> val then
  begin
    FThreadedEventPolling := val;
    if ThreadedEventPolling then
    begin
      if Active and (not Assigned(FThread)) then
        StartThread;
    end
    else if Assigned(FThread) then
      StopThread;
  end;
end;

procedure TGLSDLWindow.StartThread;
begin
  if Active and ThreadedEventPolling and (not Assigned(FThread)) then
  begin
    FThread := TSDLEventThread.Create(True);
    TSDLEventThread(FThread).Owner := Self;
    FThread.Priority := ThreadPriority;
    FThread.FreeOnTerminate := True;
    FThread.Resume;
  end;
end;

procedure TGLSDLWindow.StopThread;
begin
  if Assigned(FThread) then
  begin
    vSDLCS.Enter;
    try
      TSDLEventThread(FThread).Owner := nil;
      FThread.Terminate;
    finally
      vSDLCS.Leave;
    end;
  end;
end;

procedure TGLSDLWindow.PollEvents;
var
  event: TSDL_Event;
begin
  if Active then
  begin
    while SDL_PollEvent(@event) > 0 do
    begin
      case event.type_ of
        SDL_QUITEV:
          begin
            Close;
            Break;
          end;
        SDL_VIDEORESIZE:
          begin
            FWidth := event.resize.w;
            FHeight := event.resize.h;
            if voOpenGL in Options then
              ResizeGLWindow
            else
            begin
              CreateOrRecreateSDLSurface;
              if not Assigned(FSDLSurface) then
                RaiseSDLError('Could not get a surface after resize.');
            end;
            if Assigned(FOnResize) then
              FOnResize(Self);
          end;
      else
        if Assigned(FOnSDLEvent) then
          FOnSDLEvent(Self, event);
      end;
    end;
    if Active then
      if Assigned(FOnEventPollDone) then
        FOnEventPollDone(Self);
  end;
end;

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
initialization

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------

// We DON'T free this stuff manually,
// automatic release will take care of this
vSDLCS := TCriticalSection.Create;

end.
