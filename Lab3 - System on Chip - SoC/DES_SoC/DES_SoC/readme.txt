EEEN40280 Digital and Embedded Systems
System on Chip Assignment, using ARM Cortex-M0 DesignStart processor.

Suitable for Vivado 2015.2, but must use default synthesis settings
(run time optimised seems to warn of removing many useful signals).
However, FSM extraction should be set OFF.

This is the version for distribution - the system is incomplete.
ROM is included, and address decoder and wiring for RAM are present,
but RAM iteself is not.  GPIO and UART are also missing.

The ROM includes simple test software, and the source code for this
is in the software folder, as part of a complete Keil uVision 4 project.

Updated March 2018.
Synthesis and simulation runs were reset before the zip file was 
created, to reduce file size.
