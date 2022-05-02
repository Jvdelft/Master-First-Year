This file contains information on building SALOME 9.3.0.

1. SALOME Content

SALOME contains:

   MODULES   - This directory contains SALOME modules. Sub-directory SRC 
               contains sources of all SALOME modules. INSTALL 
               sub-directory contains binaries and libraries builded with 
               Microsoft Visual Studio Community 2015 (x64). Also each module
               contains header and other development files requried to build 
               third-party SALOME-based modules.
   
   PRODUCTS  - This directory contains all 3rd-party pre-requisite products 
               required for SALOME plus environment file. All products are built
               in RELEASE mode.
               
   SAMPLES   - SALOME sample data files.
   
   TMP       - This directory is used for storing of the temporary files used by
               SALOME in run-time. Initially it is empty.
         
   WORK      - This directory contains the script files that should be used for 
               compilation and launching of SALOME.
  
2. How to build and run SALOME 9.3.0

To build SALOME, you will additionally need Microsoft Visual Studio 
Community 2015 (x64).

SALOME can be built in Release mode. For this, SALOME provides 3rd-party products 
built with Microsoft Visual Studio Community 2015 (x64) in release mode. After unpacking 
SALOME archive, the directory SALOME-9.3.0-WIN64\PRODUCTS will contain 3rd-party 
products compiled in the release mode.

To build and install SALOME modules, please follow below described steps.
      
  - Unpack the archive with SALOME to some local directory on your computer,
    for example C:\SALOME.
    Important note: If your full path to SALOME PARAVIS module  contains symbols:
                    ^ $ [ ] [^ ] * + ? | ( ), compilation of  PARAVIS module 
                    will fail. Please avoid using such symbols in the path.
    
  - In case of manually  changing location of SALOME-9.3.0-WIN64 folder use
    SALOME-9.3.0-WIN64\WORK\prepare.bat to replace some hard-coded paths 
    in 3rd-party configuration files environment.
        
  - To build SALOME modules in the Microsoft Visual Studio Community 2015 (x64) IDE:
 
      1. Execute generate_one.bat <module_name> command, 
      where <module_name> is name of the SALOME module you want to build.
      As result, a Microsoft Visual Studio project will be created in the 
      C:\SALOME\SALOME-9.3.0-WIN64\MODULES\BUILD\<module_name>\RELEASE\<module_name>_BUILD
      directory.
    
      2. To open generated project in the Microsoft Visual Studio, execute the 
      command open_in_VC14.bat <module_name>.

      3. Make sure that selected "Solution configuration" corresponds to the "Release">.
    
      4. To compile the module invoke "Build" menu command on the ALL_BUILD 
      project in the Microsoft Visual Studio.
    
      5. Optionally you can generate developer documentation for the 
      module by building the projects usr_docs and dev_docs.
    
      6. To install module binaries, run "Build" menu command on the INSTALL 
      project in the Microsoft Visual Studio. As result, the module will be 
      installed to the C:\SALOME\MODULES\INSTALL\<module_name>\Release\<module_name>_INSTALL
      directory.
      
      Important note: SALOME modules should be built according to their 
      inter-dependencies. For example, SMESH module requires KERNEL, GUI, MED 
      and GEOM modules to be built beforehand. This means that all above 
      mentioned steps should be applied first to the module KERNEL, then GUI,
      then for MED and GEOM. See below for the list of module dependencies.      
          
  -  Alternatively, you can build SALOME modules in the batch mode:
  
      1. Execute compile.bat command to build all SALOME modules at once.
      This conmmand will build and install all modules one by one.
      
      2. To build and install specific module(s) use the following command
      compile.bat [MODULE1 MODULE2 ... MODULEN]
      where MODULE1 MODULE2 ... MODULEN are names of the SALOME modules 
      you want to build.
      
      Note that you can specify modules in the command line in appropriate
      order, they will be automatically built in the order of the 
      inter-dependencies.
    
APPENDIX

   A1. Modules inter-dependencies.
   
   The table below provides a list of dependencies for all SALOME modules.

   * LIBBATCH      : no dependencies
   * CONFIGURATION : no dependencies

   Main SALOME modules:

   * KERNEL -> CONFIGURATION, LIBBATCH (optional dependence)
   * GUI -> CONFIGURATION, KERNEL
   * GEOM -> CONFIGURATION, KERNEL, GUI
   * MEDCOUPLING -> CONFIGURATION
   * FIELDS ->  CONFIGURATION, MEDCOUPLING, KERNEL, GUI
   * SMESH ->  CONFIGURATION, KERNEL, GUI, GEOM
   * YACS ->  CONFIGURATION, KERNEL, GUI
   * PARAVIS -> CONFIGURATION, KERNEL, GUI, GEOM (optional dependence), 
                MEDCOUPLING / FIELDS (optional dependence), 
                SMESH (optional dependence)
   * HEXABLOCK -> CONFIGURATION, KERNEL, GUI, GEOM
   * JOBMANAGER -> CONFIGURATION, KERNEL, GUI

   SMESH plugins:

   * NETGENPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH
   * GHS3DPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH
   * BLSURFPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH
   * HexoticPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH, BLSURFPLUGIN 
   * HEXABLOCKPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH, HEXABLOCK
   * HYBRIDPLUGIN -> CONFIGURATION, KERNEL, GUI, GEOM, SMESH

   Sample modules:

   * COMPONENT -> CONFIGURATION, KERNEL, FIELDS
   * CALCULATOR -> CONFIGURATION, KERNEL, FIELDS
   * PYCALCULATOR -> CONFIGURATION, KERNEL, FIELDS
   * HELLO -> CONFIGURATION, KERNEL, GUI
   * PYHELLO -> CONFIGURATION, KERNEL, GUI
   * LIGHT -> CONFIGURATION, KERNEL, GUI
   * PYLIGHT -> CONFIGURATION, KERNEL, GUI
   * ATOMIC -> CONFIGURATION, KERNEL, GUI
   * ATOMGEN -> CONFIGURATION, KERNEL, GUI
   * ATOMSOLV -> CONFIGURATION, KERNEL, GUI, ATOMGEN
   * RANDOMIZER -> CONFIGURATION, KERNEL
   * SIERPINSKY -> CONFIGURATION, KERNEL, GUI, RANDOMIZER, SMESH

4. Known problems
 - In the SALOME sometimes operating with STL collections is done in not fully valid way. 
