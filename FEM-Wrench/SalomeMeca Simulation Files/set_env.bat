IF "%ENV_Win64%"=="1" GOTO END
@ECHO OFF

@REM ---------------------------------
@REM Automatic preparation third-party products if need
IF EXIST "%~dp0\prepare.bat" (
START /wait /D "%~dp0" prepare.bat
) ELSE (
ECHO ERROR! Prepare.bat file is not exist! 
ECHO May be problems with compilation or/and using SALOME as third-party product.
echo Please, check existing of %~dp0\prepare.bat and try again!
)
@REM ---------------------------------

@REM -----edit-if-necessary-----------
@REM Architecture
@SET ARCH=Win64
@REM ---------------------------------

@REM -----edit-if-necessary-----------
@REM Compile mode
@SET BUILD_MODE=Release
@REM ---------------------------------

@REM ---------------------------------
@REM Getting absolute path for SALOME ROOT DIRECTORY
@cd %~dp0..
@SET SALOME_ROOT_DIR=%cd%
@cd %~dp0
@REM ---------------------------------

@REM ---------------------------------
@REM SALOME PRODUCTS DIRECTORY
@IF "%BUILD_MODE%" == "Release" (
  @SET PDIR=%SALOME_ROOT_DIR%\PRODUCTS
  @SET DESTINATION_DIR=RELEASE
) ELSE (
  @SET PDIR=%SALOME_ROOT_DIR%\PRODUCTSD
  @SET DESTINATION_DIR=DEBUG
)

@REM ---------------------------------

@REM ---------------------------------
@REM HOME DIRECTORY
@SET HOME=%userprofile%
@SET SALOME_TMP_DIR=%SALOME_ROOT_DIR%\TMP
@REM ---------------------------------

@REM ---------------------------------
@REM SALOME DATA DIRECTORY
@SET DATA_DIR=%SALOME_ROOT_DIR%\SAMPLES

@SET list=(LIBBATCH KERNEL GUI GEOM MEDCOUPLING FIELDS SMESH SHAPER YACS JOBMANAGER PARAVIS HEXABLOCK HEXABLOCKPLUGIN NETGENPLUGIN GHS3DPLUGIN HEXOTICPLUGIN BLSURFPLUGIN ATOMGEN ATOMIC ATOMSOLV PYCALCULATOR CALCULATOR COMPONENT LIGHT PYLIGHT RANDOMIZER SIERPINSKY PYHELLO HELLO HYBRIDPLUGIN ASTERSTUDY)
for %%i in %list% do ( 
  
  SET %%i_ROOT=%SALOME_ROOT_DIR%\MODULES\INSTALL\%%i\%DESTINATION_DIR%
  SET %%i_BUILD_DIR=%SALOME_ROOT_DIR%\MODULES\BUILD\%%i\%DESTINATION_DIR%\%%i_BUILD
    
  setlocal ENABLEDELAYEDEXPANSION
    IF NOT EXIST "!%%i_BUILD_DIR!" mkdir "!%%i_BUILD_DIR!"
    cd "!%%i_BUILD_DIR!"
  endlocal

  SET %%i_ROOT_DIR=%SALOME_ROOT_DIR%\MODULES\INSTALL\%%i\%DESTINATION_DIR%\%%i_INSTALL
  SET %%i_SRC_DIR=%SALOME_ROOT_DIR%\MODULES\SRC\%%i_SRC
)

SET CONFIGURATION_ROOT_DIR=%SALOME_ROOT_DIR%\MODULES\SRC\CONFIGURATION
@REM IF NOT EXIST "%CONFIGURATION_ROOT_DIR%" mkdir "%CONFIGURATION_ROOT_DIR%"
rem SET PATH=%LIBBATCH_ROOT_DIR%\lib;%PATH%
rem SET PATH=%MEDCOUPLING_ROOT_DIR%\lib;%PATH%
@SET PYTHONPATH=%MEDCOUPLING_ROOT_DIR%\lib\python3.6\site-packages;%PYTHONPATH%
@SET PYTHONPATH=%MEDCOUPLING_ROOT_DIR%\bin;%PYTHONPATH%
SET VTK_AUTOLOAD_PATH=%GUI_ROOT_DIR%\lib\paraview
@SET PV_PLUGIN_PATH=%PV_PLUGIN_PATH%;%PARAVIS_ROOT_DIR%\lib\paraview

REM ================================
rem Setting PATH, PYTHONPATH for modules.
rem Only for KERNEL, GUI, FIELDS, PARAVIS modules environment will be set automatically.
rem If you need to set the environment for some other modules, edit env_m_list.
rem Full env_m_list is (KERNEL GUI GEOM FIELDS SMESH YACS JOBMANAGER PARAVIS HEXABLOCK HEXABLOCKPLUGIN NETGENPLUGIN GHS3DPLUGIN HexoticPLUGIN BLSURFPLUGIN ATOMGEN ATOMIC ATOMSOLV PYCALCULATOR CALCULATOR COMPONENT LIGHT PYLIGHT RANDOMIZER SIERPINSKY PYHELLO HELLO)

SET env_m_list=(KERNEL, GUI, FIELDS, PARAVIS)
FOR %%j in %env_m_list% DO (
  call "set_one_module_env.bat" %%j
)

@REM -------------------------
@REM Customize list of the modules for Windows
SET SalomeAppConfig=%SALOME_ROOT_DIR%\WORK
@REM --------------------------

@SET PATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\exe;%PATH%
@SET PATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\dll;%PATH%

@REM -------------------------
@REM To avoid double loading of the file
@SET ENV_Win64=1
@REM --------------------------
:END
