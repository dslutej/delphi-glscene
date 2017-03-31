//
// This unit is part of the GLScene Project, http://glscene.org
//
//
{
  Include File for GLScene
  The history is logged in a former GLS version of the unit
}

{$DEFINE GLSCENE}

//
// Additionnal support & dependencies
//

// Activate support for Alex Denissov's Graphics32 library (http://www.g32.org)
{.$DEFINE GLS_Graphics32_SUPPORT}

// Activate support for some optimizations by disabling checks that occur very often
// Warning: it will disable some options (like ShowAxis and OptSaveGLStack)
{.$DEFINE GLS_OPTIMIZATIONS}

// Activate assembly routines - Warning! Some components not working!!!
{.$DEFINE GLS_ASM}

// Activate inline directive
{$DEFINE GLS_INLINE}

// De-Activate regions
{.$DEFINE GLS_NO_REGIONS}

// Activate Logging
{.$DEFINE GLS_LOGGING}

// Activate OpenGL debug mode
{.$DEFINE GLS_OPENGL_DEBUG}

// Activate Multithread support
{.$DEFINE GLS_MULTITHREAD}

// Enable service rendering context, which automatically activate GLS_MULTITHREAD
// This work only on windows platform with modern compilers (XE2 and FPC or higher}
{.$DEFINE GLS_SERVICE_CONTEXT}

{$IFDEF GLS_MULTITHREAD}
  {$DEFINE MULTITHREADOPENGL}
{$ENDIF}

{$IFDEF GLS_SERVICE_CONTEXT}
  // Activate Multithread support
  {$DEFINE GLS_MULTITHREAD}
{$ENDIF}

// Activate support of Windows
{$DEFINE MSWINDOWS}

// Activate support of Linux
{.$DEFINE LINUX}

// Activate support of Mac OS
{.$DEFINE MACOS}

// Activate support of iOS
{.$DEFINE iOS}

// Activate support of Android
{.$DEFINE ANDROID}

// Activate support X Window System
{.$DEFINE GLS_X11_SUPPORT}

// Activate OpenGL ES
{.$DEFINE GLS_OPENGL_ES}

//
// Platform Specific
//

// by default, GLX is not supported on windows, although windows implementations
// do exist
{$IFDEF MSWINDOWS}
  {$UNDEF SUPPORT_GLX}
  {$UNDEF GLS_X11_SUPPORT}
  {$DEFINE SUPPORT_WGL}
{$ENDIF}

{$IFDEF LINUX}
  {$UNDEF SUPPORT_WGL}
  {$UNDEF GLS_ASM}
  {$DEFINE UNIX}
  {$DEFINE SUPPORT_GLX}
  {$DEFINE GLS_X11_SUPPORT}
{$ENDIF}

// .NET
{$IFDEF CLR}
  {$UNDEF GLS_ASM}
  {$UNSAFECODE ON}
{$ENDIF}

{$UNDEF GLS_UNSUPPORTED}
{$IFDEF GLS_UNSUPPORTED}
  Error: unsupported version, requires at least Delphi XE2
{$ENDIF}

{$IFDEF GLS_ASM}
  {$IFDEF GLS_INLINE}
    {$DEFINE GLS_INLINE_VICE_ASM}
  {$ENDIF}
{$ENDIF}

{$DEFINE GLS_INLINE_VICE_ASM}

{$IFNDEF GLS_NO_REGIONS}
  {$DEFINE GLS_REGIONS}
{$ENDIF}

{$DEFINE GLS_DEPRECATED}
{
  This defines if the compiler should use deprecated stuff or not.
  by default headers use deprecated stuff.
}

