# **TCL Workshop: From Introduction to Advanced Scripting Techniques in Design and Synthesis**

 *Author: Srinivasa Yashwanth*

 *Mail: yashwathm09@gmail.com*
 
 *_Acknowledgements: TCL Workshop by [Mr. Kunal Ghosh](https://github.com/kunalg123) , [VLSI System Design](https://www.vlsisystemdesign.com/)_*

 ## **Introduction**

Tcl is a high-level, general-purpose, interpreted, dynamic programming language. It was designed with the goal of being very simple but powerful. Tcl casts everything into the mold of a command, even programming constructs like variable assignment and procedure definition.

Links to Navigate each day:
1. [DAY-1](#DAY-1)
2. [DAY-2](#DAY-2)
3. [DAY-3](#DAY-3)
4. [DAY-4](#DAY-4)
5. [DAY-5](#DAY-5)
6. [CONCLUSION](#CONCLUSION)
   

## DAY-1

Sub-Task: Create a command (vsdsynth) and pass .csv file from UNIX Shell to TCL Script

1. Letting the system know that vsdsynth file is a shell script:
   
    ```
   #!/bin/tcsh -f
    ```
3. Creating the Logo and if-else cases for each of three types of arguements:
   - LOGO:
     
   ![logo](https://github.com/binocroc/TCLWorkshop/assets/59701387/a1b1ac8d-5723-422f-8233-8c580ca93f56)

   - No Argument:

   ![noarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/3a78717a-037e-47c6-a38a-5ce81147f8f4)

   - Wrong/Non-existent Argument:
  
   ![incorrarg](https://github.com/binocroc/TCLWorkshop/assets/59701387/4094eb49-1b87-4ab9-a419-e56c579aa9b1)

   - '-help' Argument:
  
   ![helparg](https://github.com/binocroc/TCLWorkshop/assets/59701387/c41b79ae-7944-4f13-9abc-6ac6d97af2fb)

4. Source the UNIX shell to TCL script by passing the required .csv file:

   ```
   tclsh vsdsyntha.tcl $argv[1]
   ```

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

2. Creation of Hierarchy Check script (.hier.ys) to assure proper instantiations of different modules in the top-module:

![Screenshot from 2023-07-08 16-02-38](https://github.com/binocroc/TCLWorkshop/assets/59701387/953683cb-af8e-4c74-8f59-a362167113e4)

3. Error Handling of Hierarchy Check script:

![Screenshot from 2023-07-08 19-30-19](https://github.com/binocroc/TCLWorkshop/assets/59701387/226037f8-8f34-4093-9e2b-64a4cb30a2e2)

## DAY-5

Sub-Task: Converting to an opentimer compatible format from a Yosys-synthesized netlist.

1. Creation of Synthesis Script (.ys) and running the synthesis script:

![Screenshot from 2023-07-09 21-47-29](https://github.com/binocroc/TCLWorkshop/assets/59701387/58aa8d84-82b5-41c9-8996-7f8cb025b4a2)

2. Conversion of synthesized file (.synth.v) to a format that Opentimer is compatible with:

The primary reason of this conversion is that Opentimer can't identify or doesnt need few syntaxes that .synth.v is susceptible to contain. Such as "*" and "//". 
So we have to process .synth.v file such that it no longer contains such symbols.

```
set fileID [open /tmp/1 "w"]
puts -nonewline $fileID [exec grep -v -w "*" $OutputDirectory/$DesignName.synth.v]
close $fileID

set output [open $OutputDirectory/$DesignName.final.synth.v "w"]

set filename "/tmp/1"
set fid [open $filename r]
	while {[gets $fid line] != -1} {
		puts -nonewline $output [string map {"\\" ""} $line]
		puts -nonewline $output "\n"
	}
close $fid
close $output

```
 - using a temporary file in write mode to extract the information apart from the information that is involved with "*" as it is not required, and copy the content to the .final.synth.v file.
 - open the .final.synth.v file in write mode and read the file till the end of the it ( [gets $fid line] != -1 ) to remove all the "//" symbols.
 - Hence by making it a format compatible to Opentimer (.final.synth.v).
   ![Screenshot from 2023-07-09 21-49-44](https://github.com/binocroc/TCLWorkshop/assets/59701387/e00f01c8-891c-4b56-ba3e-1ea19e15ca5f)

 - A Snap of .final.synth.v vs .synth.v :
   ![Screenshot from 2023-07-09 21-21-30](https://github.com/binocroc/TCLWorkshop/assets/59701387/78500e90-34c2-4bca-a7ce-9ea3df20cba8)

3. Static timing analysis using Opentimer:

- Usage of Procs:
  what is a proc? The proc file system acts as an interface to internal data structures in the kernel. It can be used to obtain information about the system and to change    certain kernel parameters at runtime.

  set_multi_cpu_usage proc:
  
  ![Screenshot from 2023-07-09 21-43-12](https://github.com/binocroc/TCLWorkshop/assets/59701387/7a4abe81-9476-4cb0-b4d5-baa4973f5052)

  usage of read_sdc proc to obtain parameters from .sdc file:

  ![Screenshot from 2023-07-09 21-59-04](https://github.com/binocroc/TCLWorkshop/assets/59701387/2c12c13c-b22b-4a24-beb7-c72e83bb2266)

  Execution of Procs to obtain .conf file:
  
  ![Screenshot from 2023-07-09 22-01-24](https://github.com/binocroc/TCLWorkshop/assets/59701387/997f2b4f-976a-4c64-9c7b-9f9a5e3a30f9)
  
4. Creation of .conf and .spef file:
 - .spef file:
   ![Screenshot from 2023-07-09 22-50-54](https://github.com/binocroc/TCLWorkshop/assets/59701387/aa5a1a5d-919a-410e-9603-b25c1b0a524f)

 - .conf file:
   ![Screenshot from 2023-07-09 22-51-19](https://github.com/binocroc/TCLWorkshop/assets/59701387/8b1afd18-f662-4062-8b58-34e8307914aa)

5. Quality of Results (QoR):

 Quality of Results is a term used in evaluating technological processes. In this case, we have different parameters with respect to instances such as setup violations, hold violations, worst negative slack and Run-time to determing the Quality of Results.

Display of Outputs after parameters are filed in .results file:

![Screenshot from 2023-07-09 22-58-20](https://github.com/binocroc/TCLWorkshop/assets/59701387/e4b36ad9-b6e8-4c06-96ed-e2b13a5d52a0)

6. Final Output of TCL Script:

![Screenshot from 2023-07-09 23-11-54](https://github.com/binocroc/TCLWorkshop/assets/59701387/e9784899-7da1-4c8b-a886-e0e584621529)

## CONCLUSION

- Usage of basic TCL syntax, variables, control structures, and procedures has been understood.
- Learned about various TCL commands and their functionalities. They explored commands for file handling, string manipulation, mathematical operations, and interacting  with the system.
- Learned Linux based Procs and its application in TCL Scripting.
- Learned effective scripting techniques using TCL and discovered techniques for error handling and debugging.



  
  






















 

