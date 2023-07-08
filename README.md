# **TCL Workshop**

 *Author: Srinivasa Yashwanth*

 ## **Introduction**

Tcl is a high-level, general-purpose, interpreted, dynamic programming language. It was designed with the goal of being very simple but powerful. Tcl casts everything into the mold of a command, even programming constructs like variable assignment and procedure definition.

Links to Navigate each day:
1. [DAY-1](#DAY-1)
2. [DAY-2](#DAY-2)
3. [DAY-3](#DAY-3)
4. [DAY-4](#DAY-4)
   

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

Sub-Task: Converting inputs to format[1] and for feeding it to yosys for synthesis, by creating variables and checking the existence of the directories

1. Creation of Variables:

![pic1](https://github.com/binocroc/TCLWorkshop/assets/59701387/d3a3d53d-1bea-4d47-84a4-9a5fd5056975)

2. Check the existence of directories/files in the obtained path post normalizing:

![pic2](https://github.com/binocroc/TCLWorkshop/assets/59701387/303ee154-5cbd-40f2-b765-a16042301cca)

3. Throw an Error out at the absence of directory/file at the path obtained:

![pic3](https://github.com/binocroc/TCLWorkshop/assets/59701387/401b9e66-5694-40a6-b0f4-7e5a858d0d06)

4. Read the Constraint file and proccess parameters for the SDC file:
   - Convert the constraint file into a matrix and define the SDC constraints

![pic 1](https://github.com/binocroc/TCLWorkshop/assets/59701387/04c90c7e-a751-46e3-9c0d-2cad715e94f9)

   - Categorization of each clocks, inputs and outputs features by porting their location in .csv file:

![pic 2](https://github.com/binocroc/TCLWorkshop/assets/59701387/69006650-bbda-49db-b872-9a2c350dc8d2)

## DAY-3

Sub-Task: Read the Constraint file and Convert to SDC file

1. Generation of Clock constraints:

![img1](https://github.com/binocroc/TCLWorkshop/assets/59701387/42734e38-2ed8-46f4-82da-b026174749a5)

- Snap of SDC file with Clock Constraints:
![img2](https://github.com/binocroc/TCLWorkshop/assets/59701387/1cb74c78-ca13-44b7-a94a-8d2e783c5377)

2. Generation of Input constraints, and classifying each input port whether they are bussed or not:

![Screenshot from 2023-07-08 12-26-49](https://github.com/binocroc/TCLWorkshop/assets/59701387/31218692-f8fe-4585-bffc-56ccbe284e96)

- Snap of SDC file with Input Constraints post processing:
  ![Screenshot from 2023-07-08 12-30-28](https://github.com/binocroc/TCLWorkshop/assets/59701387/1240a444-30ec-455f-bb66-52d100a3aa3d)

## DAY-4

Sub_Task: Obtain the final output constraints and feeding the SDC file, standard lib and RTL Netlist into the Yosys EDA tool for synthesizing

1. Generation of Output Constraints:

![Screenshot from 2023-07-08 13-08-50](https://github.com/binocroc/TCLWorkshop/assets/59701387/e04ad157-f0e9-4b81-abfb-f34a2f21cbd0)

- Snap of SDC file with Output Constraints:
![Screenshot from 2023-07-08 13-10-35](https://github.com/binocroc/TCLWorkshop/assets/59701387/01440e53-d0e2-4a42-ace7-c3da80322d4b)









 

