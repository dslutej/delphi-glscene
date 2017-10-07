;-----------------------------------------------------------------------------
; Setup GLScene script for Inno Setup Compiler
;-----------------------------------------------------------------------------

#define GLSceneName "GLScene"
#define GLSceneVersion "v.1.5"
#define GLScenePublisher "GLSteam"
#define GLSceneURL "http://www.glscene.org/"

[Setup]
AppId={{8CF5F54E-C1FC-4716-BC82-908867D36AD6}
AppName={#GLSceneName}
AppVersion={#GLSceneVersion}
AppVerName=GLScene for Windows 10
AppCopyright=Copyright © 2000,2017 GLSteam
AppPublisher={#GLScenePublisher}
AppPublisherURL={#GLSceneURL}
AppSupportURL={#GLSceneURL}
AppUpdatesURL={#GLSceneURL}
;DefaultDirName={pf}\{#GLSceneName}
DefaultDirName=D:\Program Files\{#GLSceneName}
DefaultGroupName={#GLSceneName}
DisableProgramGroupPage=yes
OutputBaseFilename=SetupGLScene_{#GLSceneVersion}

; Source directory of files
; SourceDir=D:\GLScene
; Output directory for setup program
OutputDir=D:\GLS\Installation   

InfoBeforeFile=Help\en\Introduction.txt
InfoAfterFile=Samples\Samples.txt

Compression=lzma
SetupIconFile=Samples\media\gls.ico
SolidCompression=yes

;welcome image
WizardImageFile=Samples\media\GLSlogo.bmp  
WizardImageBackColor= clMaroon 
WizardImageStretch=yes
WizardSmallImageFile=Samples\media\GLS.bmp
WizardSmallImageBackColor=clNavy  

;background
WindowVisible=yes 
BackColor=clPurple
BackColor2=clMaroon
;BackColorDirection= lefttoright

;full screen installer
WindowShowCaption=no 
WindowStartMaximized=yes 

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "Help\en\License.txt"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; LicenseFile: "Help\ru\License.txt"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"; 
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"; 

[Types]
Name: "Full"; Description: "All comps"
Name: "Custom"; Description: "Choose comps"; Flags: iscustom

[Components]
;Name: "Samples"; Description: "Samples for Delphi&C++Builder"; Types: Full Custom 
;Name: "Utilities"; Description: "Utilities for GLScene"; Types: Full Custom 

[Code]

function InitializeSetup: Boolean;
begin
  Result := IsAdminLoggedOn;
  if (not Result) then
    MsgBox(SetupMessage(msgAdminPrivilegesRequired), mbCriticalError, MB_OK);
end;

function IsPackageDir: Boolean;
begin
//if DirExist()
//  then
//  begin
//  end;
end;

[Files]
Source: "CleanForRelease.bat"; DestDir: "{app}"; Flags: ignoreversion

Source: "C:\Users\Public\Documents\Embarcadero\Studio\17.0\Bpl\*"; DestDir: "{app}\bpl"; Flags: ignoreversion
Source: "C:\Users\Public\Documents\Embarcadero\Studio\18.0\Bpl\*"; DestDir: "{app}\bpl"; Flags: ignoreversion
Source: "C:\Users\Public\Documents\Embarcadero\Studio\19.0\Bpl\*"; DestDir: "{app}\bpl"; Flags: ignoreversion
Source: "external\*"; DestDir: "{app}\external"; Flags: ignoreversion
Source: "Help\*"; DestDir: "{app}\Help"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "include\*"; DestDir: "{app}\include"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "lib\*"; DestDir: "{app}\lib"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Packages\*"; DestDir: "{app}\Packages"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Resources\*"; DestDir: "{app}\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: "Samples\*"; DestDir: "{app}\Samples"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Source\*"; DestDir: "{app}\Source"; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: "Utilities\*"; DestDir: "{app}\Utilities"; Flags: ignoreversion recursesubdirs createallsubdirs

[Code]
function IsDadRegistryExist: Boolean;
begin
  if RegKeyExists(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\17.0') or    
     RegKeyExists(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\18.0') or
     RegKeyExists(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\19.0')
  then
  begin
    /// "Yes". Update 
  end  
  else
    begin
      if MsgBox('Do you really want to install GLScene?', mbError, MB_YESNO) = idYes
      then 
        /// Full installation
      else 
    end;
end;

[Registry]
; Parameters for GLScene
Root: HKCU; Subkey: "Software\GLScene"; ValueType: string; ValueName: "Version"; ValueData: {#GLSceneVersion}; Flags: createvalueifdoesntexist uninsdeletekey 
Root: HKCU; Subkey: "Software\GLScene"; ValueType: string; ValueName: InslallSettings; ValueData: "{src}\SetupGLScene.exe"; Flags: createvalueifdoesntexist uninsdeletekey 
Root: HKCU; Subkey: "Software\GLScene"; ValueType: string; ValueName: LibraryDir; ValueData: "{app}"; Flags: createvalueifdoesntexist uninsdeletekey 

; Parameters for RAD Studio   
; Auto Save
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Auto Save"; ValueType: string; ValueName: Desktop; ValueData: "True"; 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Auto Save"; ValueType: string; ValueName: Desktop; ValueData: "True"; 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Auto Save"; ValueType: string; ValueName: Desktop; ValueData: "True"; 

Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Auto Save"; ValueType: string; ValueName: Editor Files; ValueData: "True"; 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Auto Save"; ValueType: string; ValueName: Editor Files; ValueData: "True"; 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Auto Save"; ValueType: string; ValueName: Editor Files; ValueData: "True"; 
                     
; Environmental Variables, the ValueData needs to be changed from SourceDir to {app}   
; New user variable GLSCENEDIR
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Environment Variables"; ValueType: string; ValueName: GLSCENEDIR; ValueData: "{app}"; Flags: deletevalue 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Environment Variables"; ValueType: string; ValueName: GLSCENEDIR; ValueData: "{app}"; Flags: deletevalue 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Environment Variables"; ValueType: string; ValueName: GLSCENEDIR; ValueData: "{app}"; Flags: deletevalue 

; Delphi Options
; Library Paths to sources
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Library\Win32"; ValueType: string; ValueName: Search Path; ValueData: "{olddata};$(GLSCENEDIR)\Source;$(GLSCENEDIR)\Source\Basis;$(GLSCENEDIR)\Source\DesignTime;$(GLSCENEDIR)\Source\FileFormats;$(GLSCENEDIR)\Source\GameAPIs;$(GLSCENEDIR)\Source\ParallelAPIs;$(GLSCENEDIR)\Source\PhysicsAPIs;$(GLSCENEDIR)\Source\ScriptingAPIs;$(GLSCENEDIR)\Source\Shaders;$(GLSCENEDIR)\Source\SoundVideoAPIs";
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Library\Win32"; ValueType: string; ValueName: Search Path; ValueData: "{olddata};$(GLSCENEDIR)\Source;$(GLSCENEDIR)\Source\Basis;$(GLSCENEDIR)\Source\DesignTime;$(GLSCENEDIR)\Source\FileFormats;$(GLSCENEDIR)\Source\GameAPIs;$(GLSCENEDIR)\Source\ParallelAPIs;$(GLSCENEDIR)\Source\PhysicsAPIs;$(GLSCENEDIR)\Source\ScriptingAPIs;$(GLSCENEDIR)\Source\Shaders;$(GLSCENEDIR)\Source\SoundVideoAPIs";
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Library\Win32"; ValueType: string; ValueName: Search Path; ValueData: "{olddata};$(GLSCENEDIR)\Source;$(GLSCENEDIR)\Source\Basis;$(GLSCENEDIR)\Source\DesignTime;$(GLSCENEDIR)\Source\FileFormats;$(GLSCENEDIR)\Source\GameAPIs;$(GLSCENEDIR)\Source\ParallelAPIs;$(GLSCENEDIR)\Source\PhysicsAPIs;$(GLSCENEDIR)\Source\ScriptingAPIs;$(GLSCENEDIR)\Source\Shaders;$(GLSCENEDIR)\Source\SoundVideoAPIs";

; C++Builder Options
; Include Path to hpp headers
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\C++\Paths\Win32"; ValueType: string; ValueName: IncludePath; ValueData: "{olddata};$(GLSCENEDIR)\include";
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\C++\Paths\Win32"; ValueType: string; ValueName: IncludePath; ValueData: "{olddata};$(GLSCENEDIR)\include"; 
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\C++\Paths\Win32"; ValueType: string; ValueName: IncludePath; ValueData: "{olddata};$(GLSCENEDIR)\include"; 
; Library Path to LIB/BPI files
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\C++\Paths\Win32"; ValueType: string; ValueName: LibraryPath; ValueData: "{olddata};$(GLSCENEDIR)\lib";
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\C++\Paths\Win32"; ValueType: string; ValueName: LibraryPath; ValueData: "{olddata};$(GLSCENEDIR)\lib";
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\C++\Paths\Win32"; ValueType: string; ValueName: LibraryPath; ValueData: "{olddata};$(GLSCENEDIR)\lib";

; Known Packages
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Cg_DesignTime.bpl; ValueData: "GLScene Cg Shaders"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Parallel_DesignTime.bpl; ValueData: "GLScene GPU Computing"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_DesignTime.bpl; ValueData: "GLScene OpenGL 3D library"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Physics_DesignTime.bpl; ValueData: "GLScene Physics Managers"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\17.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Sounds_DesignTime.bpl; ValueData: "GLScene Sound Managers"; Flags: createvalueifdoesntexist uninsdeletevalue

Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Cg_DesignTime.bpl; ValueData: "GLScene Cg Shaders"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Parallel_DesignTime.bpl; ValueData: "GLScene GPU Computing"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_DesignTime.bpl; ValueData: "GLScene OpenGL 3D library"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Physics_DesignTime.bpl; ValueData: "GLScene Physics Managers"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\18.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Sounds_DesignTime.bpl; ValueData: "GLScene Sound Managers"; Flags: createvalueifdoesntexist uninsdeletevalue

Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Cg_DesignTime.bpl; ValueData: "GLScene Cg Shaders"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Parallel_DesignTime.bpl; ValueData: "GLScene GPU Computing"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_DesignTime.bpl; ValueData: "GLScene OpenGL 3D library"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Physics_DesignTime.bpl; ValueData: "GLScene Physics Managers"; Flags: createvalueifdoesntexist uninsdeletevalue
Root: HKCU; Subkey: "Software\Embarcadero\BDS\19.0\Known Packages"; ValueType: string; ValueName: $(BDSCOMMONDIR)\Bpl\Win32\GLScene_Sounds_DesignTime.bpl; ValueData: "GLScene Sound Managers"; Flags: createvalueifdoesntexist uninsdeletevalue

[Code]

function IsRegularUser(): Boolean;
begin
  Result := not (IsAdminLoggedOn or IsPowerUserLoggedOn)
end;
 
function GetDefRoot(Param: String): String;
begin
  if IsRegularUser then
    Result := ExpandConstant('{localappdata}')
  else
    Result := ExpandConstant('{pf}')
end;

[Run]
; Installation of DLLs in System32 and SysWOW64 directories 
Filename: "{app}\external\SetupDLLs.bat"
