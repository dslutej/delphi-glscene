@echo off

del *.bpl /s
del *.bpi /s
del *.lib /s
del *.obj /s
del *.dcu /s
del *.o /s
del *.~* /s
del *.log /s
del *.dsk /s
del *.dof /s
del *.bk? /s
del *.mps /s
del *.rst /s
del *.s /s
del *.a /s
del *.map /s
del *.rsm /s
del *.drc /s
del *.dcp /s

rem delete cpp builder files

del *.hpp /s

del *.#00 /s
del *.pch /s
del *.tds /s
del *.ilc /s
del *.ild /s
del *.ilf /s
del *.ils /s
del *.pdi /s
del *.vlb /s


echo delete all .svn directories with subdirectories and files 
for /r %1 %%R in (.svn) do if exist "%%R" (rd /s /q "%%R")
echo---------------------------------------------------------
echo delete debug and Platform directories with all subdirectories and files 
for /r %1 %%R in (Debug_Build) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (Debug) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (Release_Build) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (Release) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (staticobjs) do if exist "%%R" (rd /s /q "%%R")


