rem global
SET UnityBin="D:\Program Files\Unity\2020.3.21f1c1\Editor\Unity.exe"

rem prepare build cmd
SET ScriptPath=%~dp0
SET ScriptPath=%ScriptPath:~0,-1%

SET ProjectPath=%ScriptPath%
SET BuildCmd=%UnityBin% -quit -buildTarget android -batchmode -projectPath "%ProjectPath%" 

rem ==========================================================================================
rem build version1 patch
rem ==========================================================================================
@echo "start to build version1"

cd %ProjectPath%
git checkout version1
del %ProjectPath%\Assets\AndroidIl2cppPatchDemo\PrebuiltPatches\AllAndroidPatchFiles_Version1.zip
%BuildCmd% -executeMethod AndroidBuilder.BuildPatch
if not exist "%ProjectPath%\Assets\AndroidIl2cppPatchDemo\PrebuiltPatches\AllAndroidPatchFiles_Version1.zip" (
    echo "Build Version1 Failed!"
	pause
	exit -1
)

rem ==========================================================================================
rem build version2 patch
rem ==========================================================================================
@echo "start to build version2"

cd %ProjectPath%
git checkout version2
del %ProjectPath%\Assets\AndroidIl2cppPatchDemo\PrebuiltPatches\AllAndroidPatchFiles_Version2.zip
%BuildCmd% -executeMethod AndroidBuilder.BuildPatch
if not exist "%ProjectPath%\Assets\AndroidIl2cppPatchDemo\PrebuiltPatches\AllAndroidPatchFiles_Version2.zip" (
    echo "Build Version2 Failed!"
	pause
	exit -1
)

rem ==========================================================================================
rem build base apk
rem ==========================================================================================
@echo "start to build base version apk"

cd %ProjectPath%
git checkout master
%BuildCmd% -executeMethod AndroidBuilder.BuildWithoutPatch
if not exist "%ProjectPath%\AndroidGradleProject\Test\src\main\bin\com.test.test.apk" (
    echo "Build Failed! Please Rerun %ProjectPath%\AndroidGradleProject\Test\src\main\build_apk.bat to check the error."
	exit -1
)

copy /Y %ProjectPath%\AndroidGradleProject\Test\src\main\bin\com.test.test.apk  %ScriptPath%\Il2cppDemo_com.test.test.apk
echo "Done!"
exit 0
