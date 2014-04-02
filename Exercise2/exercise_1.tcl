#Create simulator
set ns [new Simulator]

$ns color 1 Red
$ns color 2 Blue
#trace file
set tf [open exercise_1.tr w]
$ns trace-all $tf

#nam tracefile
set nf [open exercise_1.nam w]
$ns namtrace-all $nf

proc finish {} {
	#finalize trace files
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf
	
	exec nam exercise_1.nam &
	exit 0
}

# create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#and links
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n3 10Mb 10ms DropTail
$ns duplex-link $n1 $n5 10Mb 10ms DropTail

$ns queue-limit $n0 $n1 20

for {set i 1} {$i < 121} {incr i} {
 set tcp($i) [new Agent/TCP]
$ns attach-agent $n5 $tcp($i)
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp($i) $sink
#$tcp($i) set fid_$i
#Setup a FTP over TCP connection
set ftp($i) [new Application/FTP]
$ftp($i) attach-agent $tcp($i)
}

set delay_init [newRandomVariable/Exponential]
$delay_init set avg_ 0.05

set RVSize [newRandomVariable/Pareto]
$RVSize setavg_ 150000
$RVSize set shape_ 1.5

set startT(0) = 5.0
for {set i 1}{$i < 41}{incr i} {
set Size($i) [expr [$RVSize value]]

set startT($i) [expr $startT(($i-1)) + [$delay_init value]]
 #Setup a TCP connection
$ns at $startT($i) "$ftp($i) send $Size($i)"
$ns at 7.0 "$ftp($i) stop"
}

set startT(0) = 10.0
for {set i 41}{$i < 81}{incr i} {
set Size($i) [expr [$RVSize value]]

set startT($i) [expr $startT(($i-1)) + [$delay_init value]]
 #Setup a TCP connection
$ns at $startT($i) "$ftp($i) send $Size($i)"
$ns at 12.0 "$ftp($i) stop"
}

set startT(0) = 15.0
for {set i 81}{$i < 121}{incr i} {
set Size($i) [expr [$RVSize value]]

set startT($i) [expr $startT(($i-1)) + [$delay_init value]]
 #Setup a TCP connection
$ns at $startT($i) "$ftp($i) send $Size($i)"
$ns at 17.0 "$ftp($i) stop"
}


$ns at 20 "finish"
$ns run
