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
     
   ![logo](https://github.com/binocroc/TCLWorkshop/assets/59701387/a1b1ac8d-5723-422f-8233-8c580ca93f56)

   - No Argument:

   ![noarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/3a78717a-037e-47c6-a38a-5ce81147f8f4)

   - Wrong/Non-existent Argument:
  
   ![incorrarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/4094eb49-1b87-4ab9-a419-e56c579aa9b1)

   - '-help' Argument:
  
   ![helparg](https://github.com/binocroc/TCLWorkshop/assets/59701387/c41b79ae-7944-4f13-9abc-6ac6d97af2fb)

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





 

