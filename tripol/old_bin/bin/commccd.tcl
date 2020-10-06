#!/usr/bin/tclsh

# commccd
# communicate with ccdserver

set myname [file tail $argv0]

# get address, port of ccd server
set server_addr [lindex $argv 0]
set server_port [lindex $argv 1]
if {"$server_addr" == "" || "$server_addr" == "-h"
  || "$server_port" == ""} {
	puts stderr "usage: $myname server_addr server_port \[command to ccd\]"
	exit 1
}

set argv [lreplace $argv 0 1]
incr argc -2
if {$argc > 0 && "[lindex $argv 0]" == "-debug"} {
	set debug 1
	puts stderr "debug=$debug"
	set argv [lreplace $argv 0 0]
	incr argc -1
} else {
	set debug 0
}

set ret 0

proc dialog command {
	global ret myname server_addr server_port debug
	# connect to server
	if {[catch {socket $server_addr $server_port} ccd]} {
		puts stderr "$myname: cannot connect to ccdserver ($server_addr:$server_port)"
		incr ret
		return
	}
	fconfigure $ccd -encoding ascii -buffering line \
			-blocking yes -translation lf

	if {[catch {puts $ccd $command}]} {
		puts stderr "send error"
		catch {close $ccd}
		incr ret
		return
	}
	catch {flush $ccd}
	if {$debug} {
		puts stderr ">>$command"
	}
	while {![eof $ccd]} {
		if {[catch {gets $ccd reply}]} {
			puts stderr "receive error"
			incr ret
			break
		}
		if {$debug} {
			puts stderr "<<$reply"
		}
		if {"$reply" == "server_message_end"} {
			break
		}
		puts stdout $reply
		flush stdout
	}
	catch {close $ccd}
}

if {$argc > 0} {
	# 1 command mode
	dialog $argv
	exit $ret
}
# else enter terminal mode
while {[gets stdin command] > 0} {
	dialog $command
}

exit $ret
