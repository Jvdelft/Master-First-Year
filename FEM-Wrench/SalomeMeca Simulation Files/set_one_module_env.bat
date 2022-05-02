@ECHO OFF

rem =========================================
rem Setting PATH, PYTHONPATH for module.
rem Usage: set_one_module_env.bat MODULE
rem        MODULE is name of SALOME module.
rem        Full list of names is 
rem        LIBBATCH KERNEL GUI GEOM FIELDS SMESH YACS JOBMANAGER PARAVIS
rem        HEXABLOCK HEXABLOCKPLUGIN NETGENPLUGIN GHS3DPLUGIN HexoticPLUGIN 
rem        BLSURFPLUGIN ATOMGEN ATOMIC ATOMSOLV PYCALCULATOR CALCULATOR 
rem        COMPONENT LIGHT PYLIGHT RANDOMIZER SIERPINSKY PYHELLO HELLO
rem        HYBRIDPLUGIN MEDCOUPLING
rem =========================================

rem @SET PATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\%1\%DESTINATION_DIR%\%1_INSTALL\bin\salome;%PATH%
rem @SET PATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\%1\%DESTINATION_DIR%\%1_INSTALL\lib\salome;%PATH%
@SET PYTHONPATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\%1\%DESTINATION_DIR%\%1_INSTALL\lib\salome;%PYTHONPATH%
@SET PYTHONPATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\%1\%DESTINATION_DIR%\%1_INSTALL\bin\salome;%PYTHONPATH%
@SET PYTHONPATH=%SALOME_ROOT_DIR%\MODULES\INSTALL\%1\%DESTINATION_DIR%\%1_INSTALL\lib\python3.6\site-packages\salome;%PYTHONPATH%
