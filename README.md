# **TCL Workshop**

 *Author: Srinivasa Yashwanth*

 ## **Introduction**

Tcl is a high-level, general-purpose, interpreted, dynamic programming language. It was designed with the goal of being very simple but powerful. Tcl casts everything into the mold of a command, even programming constructs like variable assignment and procedure definition.

Links to Navigate each day:
1. [DAY-1](#DAY-1)
2. [DAY-2](#DAY-2)
3. [DAY-3](#DAY-3)
   

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

Sub-Task: Converting inputs to format[1] and feeding it to yosys for synthesis, by creating variables and checking the existence of the directories

1. Creation of Variables:

![pic1](https://github.com/binocroc/TCLWorkshop/assets/59701387/d3a3d53d-1bea-4d47-84a4-9a5fd5056975)

2. Check the existence of directories/files in the obtained path post normalizing:

![pic2](https://github.com/binocroc/TCLWorkshop/assets/59701387/303ee154-5cbd-40f2-b765-a16042301cca)

3. Throw an Error out at the absence of directory/file at the mentioned path obtained:

![pic3](https://github.com/binocroc/TCLWorkshop/assets/59701387/401b9e66-5694-40a6-b0f4-7e5a858d0d06)

## DAY-3

Sub-Task: Read Constraints.csv file and convert to SDC format





 

