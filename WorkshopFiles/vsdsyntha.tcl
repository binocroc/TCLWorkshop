#! /bin/env tclsh

#........................................................................#
#............Checks whether vsdsynth usage is correct or not.............#
#........................................................................#

set enable_prelayout_timing 1
set working_dir [exec pwd]
set vsd_array_length [llength [split [lindex $argv 0].]]
set input [lindex [split [lindex $argv 0].] $vsd_array_length-1]

if {![regexp {csv+} $input] || $argc!=1 } {
	puts "Error in usage"
	puts "Usage: ./vsdsynth <.csv>"
	puts "where <.csv> file has below inputs"
	exit
} else {
#........................................................................#
#............converts .csv to matrix and creates init vars...............#
#...............usage of puts command to report vars.....................#
#........................................................................#
	set filename [lindex $argv 0]
	package require csv
	package require struct::matrix
	struct::matrix m
	set f [open $filename]
	csv::read2matrix $f m , auto
	close $f
	set columns [m columns]
	m link my_arr
	set rows [m rows]
	set i 0
	while {$i < $rows} {
		puts "\nInfo: Setting $my_arr(0,$i) as '$my_arr(1,$i)'"
		if {$i == 0} {
			set [string map {" " ""} $my_arr(0,$i)] $my_arr(1,$i)
		} else {
			set [string map {" " ""} $my_arr(0,$i)] [file normalize $my_arr(1,$i)]
		}
		set i [expr ($i+1)]
	}	
}

puts "\nInfo: Below are the list of initial variables and their values. User can use the variables for further debug. Use 'puts <variable name>' command to query value of below variables"

puts "DesignName = $DesignName"
puts "OutputDirectory = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath = $LateLibraryPath"
puts "ConstraintsFile = $ConstraintsFile"



#........................................................................#
#..........Checks whether dir and files mentioned exist or not...........#
#........................................................................#

if {! [file isdirectory $OutputDirectory] } {
        puts "\nError : Cannot find RTL Netlist Directory in $OutputDirectory .creating $OutputDirectory "
        file mkdir $OutputDirectory
} else {
        puts "\nInfo :Output directory found at path $OutputDirectory."
}

if {! [file isdirectory $NetlistDirectory] } {
        puts "\nError : Cannot find RTL Netlist Directory in $NetlistDirectory. Exiting ------- "
        exit
} else {
        puts "\nInfo : RTL netlist directory  found in $NetlistDirectory."
}

if {! [file exists $EarlyLibraryPath] } {
        puts "\nError : Cannot find early cell library in $EarlyLibraryPath. Exiting ------- "
        exit
} else {
        puts "\nInfo : early cell library found in $EarlyLibraryPath"
}

if {! [file exists $LateLibraryPath] } {
        puts "\nError : Cannot find late cell library in $LateLibraryPath. Exiting ------- "
        exit
} else {
        puts "\nInfo : late cell library found in $LateLibraryPath"
}

if {! [file exists $ConstraintsFile] } {
        puts "\nError : Cannot find Constraints file in $ConstraintsFile. Exiting ------- "
        exit
} else {
        puts "\nInfo : Constraints File found in $ConstraintsFile"
}


#........................................................................#
#.........................Constraint FILE Creation.......................#
#.................................SDC Format.............................#
#........................................................................#

puts "\ninfo : Dumping SDC constraints for $DesignName"
struct::matrix constraints
set chan [open $ConstraintsFile]
csv::read2matrix $chan constraints , auto
close $chan
set number_of_rows [constraints rows]
set number_of_columns [constraints columns]

#puts "\nConstraint matirx parameters"
#puts "\nr = $number_of_rows" 
#puts "\nc = $number_of_columns"

#................Check row number for "clocks" and column number for "IO delays and slew section" in constraints.csv.................#
set clock_start [lindex [lindex [constraints search all CLOCKS] 0] 1]
set clock_start_column [lindex [lindex [constraints search all CLOCKS] 0] 0]

#................Check row number for "inputs" section in constraints.csv.................#
set input_ports_start [lindex [lindex [constraints search all INPUTS] 0] 1]

#................Check row number for "outputs" section in constraints.csv.................#
set output_ports_start [lindex [lindex [constraints search all OUTPUTS] 0] 1]

#puts "\nclock_start_rows = $clock_start"
#puts "\nclock_start_column = $clock_start_column"
#puts "\ninput_port_start = $input_start"
#puts "\noutput_port_start = $output_start"

#........................................................................#
#...........................Clock Constraints............................#
#........................................................................#

#......................Clock Latency Constraints.........................#

set clock_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_rise_delay] 0] 0]
set clock_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_fall_delay] 0] 0]
set clock_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_rise_delay] 0] 0]
set clock_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_fall_delay] 0] 0]


#........................Clock Transition Constraints.........................#

set clock_early_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_rise_slew] 0] 0]
set clock_early_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_fall_slew] 0] 0]
set clock_late_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_rise_slew] 0] 0]
set clock_late_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_fall_slew] 0] 0]

set sdc_file [open $OutputDirectory/$DesignName.sdc "w"]
set i  [expr {$clock_start+1}]
set end_of_ports [expr {$input_ports_start-1}]
puts "\nInfo-SDC: Working on clock constraints......................."
while { $i < $end_of_ports } {
	puts -nonewline $sdc_file "\ncreate_clock -name [constraints get cell 0 $i] -period [constraints get cell 1 $i] -waveform \{0 [expr {[constraints get cell 1 $i]*[constraints get cell 2 $i]/100}]\} \get_ports [constraints get cell 0 $i]\]"

	puts -nonewline $sdc_file "\nset_clock_latency -source -early -rise [constraints get cell $clock_early_rise_delay_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -early -fall [constraints get cell $clock_early_fall_delay_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -late -rise [constraints get cell $clock_late_rise_delay_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -late -fall [constraints get cell $clock_late_fall_delay_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -rise -min [constraints get cell $clock_early_rise_slew_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -fall -min [constraints get cell $clock_early_fall_slew_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -rise -max [constraints get cell $clock_late_rise_slew_start $i] \get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -fall -max [constraints get cell $clock_late_fall_slew_start $i] \get_clocks [constraints get cell 0 $i]\]"
	set i [expr {$i+1}]
}


#........................................................................#
#............Create Input Delay and Slew Constraints.....................#
#........................................................................#

set input_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_rise_delay] 0] 0]
set input_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_fall_delay] 0] 0]
set input_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_rise_delay] 0] 0]
set input_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_fall_delay] 0] 0]

set input_early_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_rise_slew] 0] 0]
set input_early_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_fall_slew] 0] 0]
set input_late_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_rise_slew] 0] 0]
set input_late_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_fall_slew] 0] 0]

set related_clock [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] clocks] 0] 0]

set i [expr {$input_ports_start+1}]
set end_of_ports [expr {$output_ports_start-1}]
puts "\nInfo-SDC: Working on IO Constraints------"
puts "\nInfo-SDC: Categorizing input ports as bits and bussed"

while { $i < $end_of_ports } {

set netlist [glob -dir $NetlistDirectory *.v]
set tmp_file [open /tmp/1 w]
foreach f $netlist {
	set fd [open $f]
	while {[gets $fd line] != -1} {
		set pattern1 " [constraints get cell 0 $i]"
		if {[regexp -all -- $pattern1 $line]} {
#			puts "pattern1 \"$pattern1\" found and matching line in verilog file \"$f\" is \"$line\""
			set pattern2 [lindex [split $line ";"] 0]
#			puts "creating pattern2 by splitting pattern1 using semicolon as delimiter => \"$pattern2\""
			if {[regexp -all {input} [lindex [split $pattern2 "\S+"] 0]]} {
#				puts "out of all patterns, \"$pattern2\" has matching string \"input\". So preserving this line and ignoring others"
				set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
#				puts "printing first 3 elements of pattern2 as \"$s1\" using space as delimiter"
				puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
#				puts "replace multiple spaces in s1 by single space and reformat as \"[regsub -all {\s+} $s1 " "]\""
				}

        	}
	}
close $fd
}
close $tmp_file
set tmp_file [open /tmp/1 r]
set tmp2_file [open /tmp/2 w]
puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
close $tmp_file
close $tmp2_file
set tmp2_file [open /tmp/2 r]
set count [llength [read $tmp2_file]]
#puts "splitting content of tmp_2 using space and counting number of elements as $count"
if {$count > 2} {
	set inp_ports [concat [constraints get cell 0 $i]*]
#	puts "bussed"
} else {
	set inp_ports [constraints get cell 0 $i]
#	puts "not bussed"
}
#	puts "input port name is $inp_ports since count is $count\n"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_delay_start $i] \[get_ports $inp_ports\]"

	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_slew_start $i] \[get_ports $inp_ports\]"


	set i [expr {$i+1}]
}
close $tmp2_file

#........................................................................#
#............Create Output Delay and Load Constraints....................#
#........................................................................#

set output_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] early_rise_delay] 0] 0]
set output_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] early_fall_delay] 0] 0]
set output_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] late_rise_delay] 0] 0]
set output_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] late_fall_delay] 0] 0]

set output_load_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] load] 0] 0]

set related_clock [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] clocks] 0] 0]

set i [expr {$output_ports_start+1}]
set end_of_ports [expr {$number_of_rows}]
puts "\nInfo-SDC: Working on IO Constraints------"
puts "\nInfo-SDC: Categorizing output ports as bits and bussed"

while { $i < $end_of_ports } {

set netlist [glob -dir $NetlistDirectory *.v]
set tmp_file [open /tmp/1 w]
foreach f $netlist {
	set fd [open $f]
	while {[gets $fd line] != -1} {
		set pattern1 " [constraints get cell 0 $i]"
		if {[regexp -all -- $pattern1 $line]} {
#			puts "pattern1 \"$pattern1\" found and matching line in verilog file \"$f\" is \"$line\""
			set pattern2 [lindex [split $line ";"] 0]
#			puts "creating pattern2 by splitting pattern1 using semicolon as delimiter => \"$pattern2\""
			if {[regexp -all {input} [lindex [split $pattern2 "\S+"] 0]]} {
#				puts "out of all patterns, \"$pattern2\" has matching string \"input\". So preserving this line and ignoring others"
				set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
#				puts "printing first 3 elements of pattern2 as \"$s1\" using space as delimiter"
				puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
#				puts "replace multiple spaces in s1 by single space and reformat as \"[regsub -all {\s+} $s1 " "]\""
				}

        	}
	}
close $fd
}
close $tmp_file
set tmp_file [open /tmp/1 r]
set tmp2_file [open /tmp/2 w]
puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
close $tmp_file
close $tmp2_file
set tmp2_file [open /tmp/2 r]
set count [llength [read $tmp2_file]]
#puts "splitting content of tmp_2 using space and counting number of elements as $count"
if {$count > 2} {
	set op_ports [concat [constraints get cell 0 $i]*]
#	puts "bussed"
} else {
	set op_ports [constraints get cell 0 $i]
#	puts "not bussed"
}

#	puts "output port name is $inp_ports since count is $count\n"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $output_early_rise_delay_start $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $output_early_fall_delay_start $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $output_late_rise_delay_start $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $output_late_fall_delay_start $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_load [constraints get cell $output_load_start $i] \[get_ports $op_ports\]"
	
	set i [expr {$i+1}]
}
close $tmp2_file
close $sdc_file

puts "\nInfo: SDC Created. Please use the constraints path $OutputDirectory/$DesignName.sdc"



#........................................................................#
#...........................hierarchy Check..............................#
#........................................................................#

puts "\nInfo: Creating hierarchy Check Script to be used by Yosys\n"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${LateLibraryPath}"
set filename "$DesignName.hier.ys"
set fileID [open $OutputDirectory/$filename "w"]
puts -nonewline $fileID $data

set netlist [glob -dir $NetlistDirectory *.v]
foreach f $netlist {
	set data $f
#	puts "the data is $f"
	puts -nonewline $fileID "\nread_verilog $f"
}
puts -nonewline $fileID "\nhierarchy -check"
close $fileID


puts "\nChecking hierarchy -----------"

if { [catch { exec yosys -s $OutputDirectory/$DesignName.hier.ys >& $OutputDirectory/$DesignName.hierarchy_check.log} msg]} {
	set filename "$OutputDirectory/$DesignName.hierarchy_check.log"
	set pattern {ERROR}
	set fid [open $filename r]
	while {[gets $fid line] != -1} {
		if {[regexp -all -- $pattern $line]} {
			puts "\nError: module [lindex $line 2] is not part of design $DesignName. Please correct RTL in the path '$NetlistDirectory'"
			puts "\Info: hierarchy Check FAIL"
		}
	}	
	close $fid
} else {
	puts "\nInfo: hierarchy Check PASS"
}
puts "\nInfo: Please find hierarchy check details in [file normalize $OutputDirectory/$DesignName.heirarchy_check.log] for more info"
cd $working_dir


#........................................................................#
#..........................Main Synthesis Script.........................#
#........................................................................#

puts "\nInfo: Creating main synthesis script to be used as Yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${LateLibraryPath}"
set filename "$DesignName.ys"
set fileID [open $OutputDirectory/$filename "w"]
puts -nonewline $fileID $data

set netlist [glob -dir $NetlistDirectory *.v]
foreach f $netlist {
	set data $f
	puts -nonewline $fileID "\nread_verilog $f"
}
puts -nonewline $fileID "\nhierarchy -top $DesignName"
puts -nonewline $fileID "\nsynth -top $DesignName"
puts -nonewline $fileID "\nsplitnets -ports -format __\ndfflibmap -liberty ${LateLibraryPath}\nopt"
puts -nonewline $fileID "\nabc -liberty ${LateLibraryPath} "
puts -nonewline $fileID "\nflatten"
puts -nonewline $fileID "\nclean -purge\niopadmap -outpad BUFX2 A:Y -bits\nopt\nclean"
puts -nonewline $fileID "\nwrite_verilog $OutputDirectory/$DesignName.synth.v"
close $fileID

puts "\nInfo: Synthesis script created and can be accessed from path $OutputDirectory/$DesignName.ys"

puts "\nInfo: Running Synthesis..............."


#........................................................................#
#....................Run Synthesis Script using yosys....................#
#........................................................................#

if { [catch { exec yosys -s $OutputDirectory/$DesignName.ys >& $OutputDirectory/$DesignName.synthesis.log} msg]} {
	puts "\nError: Synthesis failed due to errors. Please refer to log $OutputDirectory/$DesignName.synthesis.log for errors"
	exit
} else {
	puts "\nInfo: Synthesis finished Successfully"
}
puts "\nInfo: Please refer to log $OutputDirectory/$DesignName.synthesis.log"



#........................................................................#
#..............Edit synth.v to be usable by Opentimer....................#
#........................................................................#

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

puts "\nInfo: Please find the synthesized netlist for $DesignName at below path. You can use the netlist for STA or PnR"
puts "\n$OutputDirectory/$DesignName.final.synth.v"

#........................................................................#
#..............Static Timing Analysis using Opentimer....................#
#........................................................................#
puts "\nInfo: Timing Analysis Started..................."
puts "\nInfo: Initializing number of threads, libraries, sdc, verilog netlist path..."
source /home/vsduser/vsdsynth/procs/reopenStdout.proc 
source /home/vsduser/vsdsynth/procs/set_num_threads.proc
reopenStdout $OutputDirectory/$DesignName.conf
set_multi_cpu_usage -localCpu 4

source /home/vsduser/vsdsynth/procs/read_lib.proc
read_lib -early /home/vsduser/vsdsynth/osu018_stdcells.lib

read_lib -late /home/vsduser/vsdsynth/osu018_stdcells.lib

source /home/vsduser/vsdsynth/procs/read_verilog.proc
read_verilog $OutputDirectory/$DesignName.final.synth.v

source /home/vsduser/vsdsynth/procs/read_sdc.proc
read_sdc $OutputDirectory/$DesignName.sdc
reopenStdout /dev/tty



if {$enable_prelayout_timing == 1} {
	puts "\nInfo: enable_prelayout_timing is $enable_prelayout_timing. Enabling zero-wire load parastics"
	set spef_file [open $OutputDirectory/$DesignName.spef w]
puts $spef_file "*SPEF \"IEEE 1481-1998\" "
puts $spef_file "*DESIGN \"$DesignName\" "
puts $spef_file "*DATE \"Sun Jul 9 2023\" "
puts $spef_file "*VENDOR \"TAU 2015 Contest\" "
puts $spef_file "*PROGRAM \"Benchmark Parasitic Generator \" "
puts $spef_file "*VERSION \"0.0\" "
puts $spef_file "*DESIGN_FLOW \"NETLIST_TYPE_VERILOG\" "
puts $spef_file "*DIVIDER / "
puts $spef_file "*DELIMITER : "
puts $spef_file "*BUS_DELIMITER [ ] "
puts $spef_file "*T_UNIT 1 PS "
puts $spef_file "*C_UNIT 1 FF "
puts $spef_file "*R_UNIT 1 KOHM "
}
close $spef_file

set conf_file [open $OutputDirectory/$DesignName.conf a]
puts $conf_file "set_spef_fpath $OutputDirectory/$DesignName.spef"
puts $conf_file "init_timer "
puts $conf_file "report_timer "
puts $conf_file "report_wns "
puts $conf_file "report_worst_paths -numPaths 1000 "
close $conf_file

set tcl_precision 3
set time_elapsed_in_us [time {exec /home/vsduser/OpenTimer-1.0.5/bin/OpenTimer < $OutputDirectory/$DesignName.conf >& $OutputDirectory/$DesignName.results} 1]
set time_elapsed_in_sec "[expr {[lindex $time_elapsed_in_us 0]/100000}]sec"
puts "\nInfo: STA finished in $time_elapsed_in_sec seconds"
puts "\nInfo: Refer to $OutputDirectory/$DesignName.results for warnings and errors"

#-------------------------find worst output violation--------------------------------#
set worst_RAT_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r]
set pattern {RAT}
while {[gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set worst_RAT_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

#-------------------------find number of output violations--------------------------------#	
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while {[gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set Number_output_violations $count
close $report_file

#-------------------------find worst setup violation--------------------------------#
set worst_negative_setup_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r] 
set pattern {Setup}
while {[gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set worst_negative_setup_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

#-------------------------find number of setup violations--------------------------------#
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while {[gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set Number_of_setup_violations $count
close $report_file

#-------------------------find worst hold violation--------------------------------#
set worst_negative_hold_slack "-"
set report_file [open $OutputDirectory/$DesignName.results r] 
set pattern {Hold}
while {[gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set worst_negative_hold_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

#-------------------------find number of hold violations--------------------------------#
set report_file [open $OutputDirectory/$DesignName.results r]
set count 0
while {[gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set Number_of_hold_violations $count
close $report_file

#-------------------------find number of instances--------------------------------#

set pattern {Num of gates}
set report_file [open $OutputDirectory/$DesignName.results r] 
while {[gets $report_file line] != -1} {
	if {[regexp $pattern $line]} {
		set Instance_count "[lindex [join $line " "] 4 ]"
		break
	} else {
		continue
	}
}
close $report_file

puts "DesignName is \{$DesignName\}"
puts "time_elapsed_in_sec is \{$time_elapsed_in_sec\}"
puts "Instance_count is \{$Instance_count\}"
puts "worst_negative_setup_slack is \{$worst_negative_setup_slack\}"
puts "Number_of_setup_violations is \{$Number_of_setup_violations\}"
puts "worst_negative_hold_slack is \{$worst_negative_hold_slack\}"
puts "Number_of_hold_violations is \{$Number_of_hold_violations\}"
puts "worst_RAT_slack is \{$worst_RAT_slack\}"
puts "Number_output_violations is \{$Number_output_violations\}"

puts "\n"
puts "						****PRELAYOUT TIMING RESULTS**** 					"
set formatStr "%15s %15s %15s %15s %15s %15s %15s %15s %15s"

puts [format $formatStr "----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts [format $formatStr "DesignName" "Runtime" "Instance Count" "WNS Setup" "FEP Setup" "WNS Hold" "FEP Hold" "WNS RAT" "FEP RAT"]
puts [format $formatStr "----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
foreach design_name $DesignName runtime $time_elapsed_in_sec instance_count $Instance_count wns_setup $worst_negative_setup_slack fep_setup $Number_of_setup_violations wns_hold $worst_negative_hold_slack fep_hold $Number_of_hold_violations wns_rat $worst_RAT_slack fep_rat $Number_output_violations {
	puts [format $formatStr $design_name $runtime $instance_count $wns_setup $fep_setup $wns_hold $fep_hold $wns_rat $fep_rat]
}

puts [format $formatStr "----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts "\n"




















