@echo off
del *.dcr
BRCC32 -r -foGLScene.dcr GLScene.rc
BRCC32 -r -foGLSceneObjects.dcr GLSceneObjects.rc
BRCC32 -r -fononGLScene.dcr nonGLScene.rc
BRCC32 -r -foGLSceneBass.dcr GLSceneBass.rc
BRCC32 -r -foGLSceneFMod.dcr GLSceneFMod.rc
BRCC32 -r -foGLSceneOpenAL.dcr GLSceneOpenAL.rc
BRCC32 -r -foGLSceneODE.dcr GLSceneODE.rc
BRCC32 -r -foGLSceneNGD.dcr GLSceneNGD.rc
BRCC32 -r -foGLSceneSDL.dcr GLSceneSDL.rc
BRCC32 -r -foGLSceneCg.dcr GLSceneCg.rc
BRCC32 -r -foGLSceneCUDA.dcr GLSceneCUDA.rc
BRCC32 -r -foGLSceneDWS.dcr GLSceneDWS.rc
BRCC32 -r -foGLSceneRunTime.dcr GLSceneRunTime.rc
pause