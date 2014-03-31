#Create simulator
set ns [new Simulator]

$ns color 1 Red
$ns color 2 Blue
#trace file
set tf [open exercise_1_2.tr w]
$ns trace-all $tf

#nam tracefile
set nf [open exercise_1_2.nam w]
$ns namtrace-all $nf

proc finish {} {
	#finalize trace files
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf
	
	exec nam exercise_1_2.nam &
	exit 0
}

# create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
#and links
$ns duplex-link $n0 $n2 10Mb 0.2ms DropTail
$ns duplex-link $n1 $n2 10Mb 0.2ms DropTail
$ns duplex-link $n2 $n3 10Mb 0.2ms DropTail

$ns simplex-link $n3 $n4 256Kb 0.2ms DropTail
$ns simplex-link $n4 $n3 4Mb 0.2ms DropTail

$ns duplex-link $n4 $n5 100Mb 0.3ms DropTail
$ns duplex-link $n5 $n6 100Mb 0.3ms DropTail
$ns duplex-link $n5 $n7 100Mb 0.3ms DropTail

$ns duplex-link-op $n3 $n4 queuePos 0.5
#Setup a TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n6 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n7 $null
$ns connect $udp $null
$udp set fid_ 2
#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1500


$ns at 3.0 "$cbr start"
$ns at 6.0 "$cbr stop"

$ns at 0.1 "$ftp start"
$ns at 9.9 "$ftp stop"

$ns at 10 "finish"
$ns run
