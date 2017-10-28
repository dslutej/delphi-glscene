//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  Provides on demand state of any key on the keyboard as well as a set of
  utility functions for working with virtual keycodes.

  Note that windows maps the mouse buttons to virtual key codes too, and you
  can use the functions/classes in this unit to check mouse buttons too.
  See "Virtual-Key Codes" in the Win32 programmers r�ferences for a list of
  key code constants (VK_* constants are declared in the "Windows" unit).

  History :
  03/08/00 - Egg - Creation, partly based Silicon Commander code
  The whole history is logged in previous version of the unit
}

unit GLKeyboard;

interface

{$I GLScene.inc}

uses
  Winapi.Windows,
  System.SysUtils;

type
  TVirtualKeyCode = Integer;

const
  // pseudo wheel keys (we squat F23/F24), see KeyboardNotifyWheelMoved
  VK_MOUSEWHEELUP = VK_F23;
  VK_MOUSEWHEELDOWN = VK_F24;

  { Check if the key corresponding to the given Char is down.
    The character is mapped to the <i>main keyboard</i> only, and not to the
    numeric keypad.
    The Shift/Ctrl/Alt state combinations that may be required to type the
    character are ignored (ie. 'a' is equivalent to 'A', and on my french
    keyboard, '5' = '(' = '[' since they all share the same physical key). }
function IsKeyDown(c: Char): Boolean; overload;
  { Check if the given virtual key is down.
  This function is just a wrapper for GetAsyncKeyState. }
function IsKeyDown(vk: TVirtualKeyCode): Boolean; overload;
  { Returns the first pressed key whose virtual key code is >= to minVkCode.
  If no key is pressed, the return value is -1, this function does NOT
  wait for user input.
  If you don't care about multiple key presses, just don't use the parameter. }
function KeyPressed(minVkCode: TVirtualKeyCode = 0): TVirtualKeyCode;

  { Converts a virtual key code to its name.
  The name is expressed using the locale windows options. }
function VirtualKeyCodeToKeyName(vk: TVirtualKeyCode): String;
  { Converts a key name to its virtual key code.
  The comparison is **NOT** case-sensitive, if no match is found, returns -1.
  The name is expressed using the locale windows options, except for mouse
  buttons which are translated to 'LBUTTON', 'MBUTTON' and 'RBUTTON'. }
function KeyNameToVirtualKeyCode(const keyName: String): TVirtualKeyCode;
  { Returns the virtual keycode corresponding to the given char.
  The returned code is untranslated, f.i. 'a' and 'A' will give the same
  result. A return value of -1 means that the characted cannot be entered
  using the keyboard. }
function CharToVirtualKeyCode(c: Char): TVirtualKeyCode;

  { Use this procedure to notify a wheel movement and have it resurfaced as key stroke.
  Honoured by IsKeyDown and KeyPressed }
procedure KeyboardNotifyWheelMoved(wheelDelta: Integer);

var
  vLastWheelDelta: Integer;

  // ---------------------------------------------------------------------
  // ---------------------------------------------------------------------
  // ---------------------------------------------------------------------
implementation

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------

const
  cLBUTTON = 'Left Mouse Button';
  cMBUTTON = 'Middle Mouse Button';
  cRBUTTON = 'Right Mouse Button';

  cUP = 'Up';
  cDOWN = 'Down';
  cRIGHT = 'Right';
  cLEFT = 'Left';
  cPAGEUP = 'Page up';
  cPAGEDOWN = 'Page down';
  cHOME = 'Home';
  cEND = 'End';
  cMOUSEWHEELUP = 'Mouse Wheel Up';
  cMOUSEWHEELDOWN = 'Mouse Wheel Down';

  cPAUSE = 'Pause';
  cSNAPSHOT = 'Print Screen';
  cNUMLOCK = 'Num Lock';
  cINSERT = 'Insert';
  cDELETE = 'Delete';
  cDIVIDE = 'Num /';

  cLWIN = 'Left Win';
  cRWIN = 'Right Win';
  cAPPS = 'Application Key';

  c0 = '~';
  c1 = '[';
  c2 = ']';
  c3 = ';';
  c4 = '''';
  c5 = '<';
  c6 = '>';
  c7 = '/';
  c8 = '\';

function IsKeyDown(c: Char): Boolean;
{$IFDEF MSWINDOWS}
var
  vk: Integer;
begin
  // '$FF' filters out translators like Shift, Ctrl, Alt
  vk := VkKeyScan(c) and $FF;
  if vk <> $FF then
    Result := (GetAsyncKeyState(vk) < 0)
  else
    Result := False;
end;
{$ELSE}

begin
  raise Exception.Create
    ('GLKeyboard.IsKeyDown(c : Char) not yet implemented for your platform!');
end;
{$ENDIF}

function IsKeyDown(vk: TVirtualKeyCode): Boolean;
begin
  case vk of
    VK_MOUSEWHEELUP:
      begin
        Result := vLastWheelDelta > 0;
        if Result then
          vLastWheelDelta := 0;
      end;

    VK_MOUSEWHEELDOWN:
      begin
        Result := vLastWheelDelta < 0;
        if Result then
          vLastWheelDelta := 0;
      end;
  else
{$IFDEF MSWINDOWS}
    Result := (GetAsyncKeyState(vk) < 0);
{$ELSE}
    raise Exception.Create
      ('GLKeyboard.IsKeyDown(vk : TVirtualKeyCode) not fully yet implemented for your platform!');
{$ENDIF}
  end;
end;

function KeyPressed(minVkCode: TVirtualKeyCode = 0): TVirtualKeyCode;
{$IFDEF MSWINDOWS}
var
  i: Integer;
  buf: TKeyboardState;
begin
  Assert(minVkCode >= 0);
  Result := -1;
  if GetKeyboardState(buf) then
  begin
    for i := minVkCode to High(buf) do
    begin
      if (buf[i] and $80) <> 0 then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;
  if vLastWheelDelta <> 0 then
  begin
    if vLastWheelDelta > 0 then
      Result := VK_MOUSEWHEELUP
    else
      Result := VK_MOUSEWHEELDOWN;
    vLastWheelDelta := 0;
  end;
end;
{$ELSE}

begin
  raise Exception.Create
    ('GLKeyboard.KeyPressed not yet implemented for your platform!');
end;
{$ENDIF}

function VirtualKeyCodeToKeyName(vk: TVirtualKeyCode): String;
{$IFDEF MSWINDOWS}
var
  nSize: Integer;
{$ENDIF}
begin
  // Win32 API can't translate mouse button virtual keys to string
  case vk of
    VK_LBUTTON:
      Result := cLBUTTON;
    VK_MBUTTON:
      Result := cMBUTTON;
    VK_RBUTTON:
      Result := cRBUTTON;
    VK_UP:
      Result := cUP;
    VK_DOWN:
      Result := cDOWN;
    VK_LEFT:
      Result := cLEFT;
    VK_RIGHT:
      Result := cRIGHT;
    VK_PRIOR:
      Result := cPAGEUP;
    VK_NEXT:
      Result := cPAGEDOWN;
    VK_HOME:
      Result := cHOME;
    VK_END:
      Result := cEND;
    VK_MOUSEWHEELUP:
      Result := cMOUSEWHEELUP;
    VK_MOUSEWHEELDOWN:
      Result := cMOUSEWHEELDOWN;

    VK_PAUSE:
      Result := cPAUSE;
    VK_SNAPSHOT:
      Result := cSNAPSHOT;
    VK_NUMLOCK:
      Result := cNUMLOCK;
    VK_INSERT:
      Result := cINSERT;
    VK_DELETE:
      Result := cDELETE;

    VK_DIVIDE:
      Result := cDIVIDE;

    VK_LWIN:
      Result := cLWIN;
    VK_RWIN:
      Result := cRWIN;
    VK_APPS:
      Result := cAPPS;

    192:
      Result := c0;
    219:
      Result := c1;
    221:
      Result := c2;
    186:
      Result := c3;
    222:
      Result := c4;
    188:
      Result := c5;
    190:
      Result := c6;
    191:
      Result := c7;
    220:
      Result := c8;

  else
{$IFDEF MSWINDOWS}
    nSize := 32; // should be enough
    SetLength(Result, nSize);
    vk := MapVirtualKey(vk, 0);
    nSize := GetKeyNameText((vk and $FF) shl 16, PChar(Result), nSize);
    SetLength(Result, nSize);
{$ELSE}
    raise Exception.Create
      ('GLKeyboard.VirtualKeyCodeToKeyName not yet fully implemented for your platform!');
{$ENDIF}
  end;
end;

function KeyNameToVirtualKeyCode(const keyName: String): TVirtualKeyCode;
{$IFDEF MSWINDOWS}
var
  i: Integer;
begin
  // ok, I admit this is plain ugly. 8)
  Result := -1;
  for i := 0 to 255 do
  begin
    if SameText(VirtualKeyCodeToKeyName(i), keyName) then
    begin
      Result := i;
      Break;
    end;
  end;
end;
{$ELSE}

var
  i: Integer;
  lExceptionWasRaised: Boolean;
begin
  // ok, I admit this is plain ugly. 8)
  Result := -1;
  lExceptionWasRaised := False;
  for i := 0 to 255 do
    try
      if SameText(VirtualKeyCodeToKeyName(i), keyName) then
      begin
        Result := i;
        Exit;
      end;
    finally
      lExceptionWasRaised := True;
      // DaStr: Since VirtualKeyCodeToKeyName is not fully implemented in non-Unix
      // systems, this function can thow exceptions, which we need to catch here.
    end;
  if (Result = -1) and lExceptionWasRaised then
    raise Exception.Create
      ('GLKeyboard.KeyNameToVirtualKeyCode not yet fully implemented for your platform or keyName wasn''t found!');
end;
{$ENDIF}

function CharToVirtualKeyCode(c: Char): TVirtualKeyCode;
begin
{$IFDEF MSWINDOWS}
  Result := VkKeyScan(c) and $FF;
  if Result = $FF then
    Result := -1;
{$ELSE}
  raise Exception.Create
    ('GLKeyboard.CharToVirtualKeyCode not yet implemented for your platform!');
{$ENDIF}
end;

procedure KeyboardNotifyWheelMoved(wheelDelta: Integer);
begin
  vLastWheelDelta := wheelDelta;
end;

end.
