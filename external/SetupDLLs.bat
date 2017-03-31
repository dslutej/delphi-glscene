@echo off
echo Copying DLLs to the Windows System32 and SysWOW64 directories
echo Copying nVidia CG DLLs
rem win64
copy cg.dll %SystemRoot%\System32\
copy cgGL.dll %SystemRoot%\System32\
rem win32
copy cg.dll %SystemRoot%\SysWOW64\
copy cgGL.dll %SystemRoot%\SysWOW64\

echo Copying SDL DLLs
rem win32
copy SDL2_32.dll %SystemRoot%\SysWOW64\SDL.dll
rem win64
copy SDL2_64.dll %SystemRoot%\System32\SDL.dll

echo Copying Sound DLLs
rem win32
copy bass.dll %SystemRoot%\SysWOW64\
copy fmod.dll %SystemRoot%\SysWOW64\
copy OpenAL32.dll %SystemRoot%\SysWOW64\
rem win64
copy bass.dll %SystemRoot%\System32\
copy fmod.dll %SystemRoot%\System32\
copy OpenAL64.dll %SystemRoot%\System32\

echo Copying ODE DLLs
rem win32
copy ode_single.dll %SystemRoot%\SysWOW64\
copy ode_singled.dll %SystemRoot%\SysWOW64\
copy ode_double.dll %SystemRoot%\SysWOW64\
copy ode_doubled.dll %SystemRoot%\SysWOW64\
rem win64
copy ode_single.dll %SystemRoot%\System32\
copy ode_singled.dll %SystemRoot%\System32\
copy ode_double.dll %SystemRoot%\System32\
copy ode_doubled.dll %SystemRoot%\System32\

echo Copying Newton DLLs
rem win32
copy newton.dll %SystemRoot%\SysWOW64\
copy dJointLibrary.dll %SystemRoot%\SysWOW64\
rem win64
copy newton64.dll %SystemRoot%\System32\
copy dJointLibrary64.dll %SystemRoot%\System32\

echo Copying nVidia PhysX DLLs
rem win32
copy PhysXwrap.dll %SystemRoot%\SysWOW64\
rem win64
copy PhysXwrap.dll %SystemRoot%\System32\

echo Copying CUDA and zlib1 DLLs
rem win32
copy cutil32.dll %SystemRoot%\SysWOW64\
copy zlib1.dll %SystemRoot%\SysWOW64\
rem win64
copy cutil64.dll %SystemRoot%\System32\
copy zlib1.dll %SystemRoot%\System32\

rem pause

cls