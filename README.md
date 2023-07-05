# **TCL Workshop**

 *Author: Srinivasa Yashwanth*

 ## **Introduction**

Tcl is a high-level, general-purpose, interpreted, dynamic programming language. It was designed with the goal of being very simple but powerful. Tcl casts everything into the mold of a command, even programming constructs like variable assignment and procedure definition.

Links to Navigate each day:
1. [DAY-1](#DAY-1)
2. [DAY-2](#DAY-2)
   

## DAY-1

Sub-Task: Create a command (vsdsynth) and pass .csv file from UNIX Shell to TCL Script

1. Letting the system know that vsdsynth file is a shell script:
   
    ```#!/bin/tcsh -f```
2. Creating the Logo and if-else cases for each of three types of arguements:
   - LOGO:
     
   ![logo](https://github.com/binocroc/TCLWorkshop/assets/59701387/4810cbb8-61cf-400f-8e6f-f786b39d0e47)

   - No Argument:

   ![noarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/1e672b54-4457-49c4-900c-1a7232dbd8d6)

   - Wrong/Non-existent Argument:
  
   ![incorrarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/09ea5b45-3630-4789-a7dd-701f92f197e2)

   - '-help' Argument:
  
   ![helparg](https://github.com/binocroc/TCLWorkshop/assets/59701387/d410bf59-b5b5-4d0f-a5bd-f215aac2f675)

3. Source the UNIX shell to TCL script by passing the required .csv file:

   ```tclsh vsdsyntha.tcl $argv[1]```

## DAY-2



 

