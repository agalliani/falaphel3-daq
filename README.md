# falaphel3-daq
Codebase for the firmware and software DAQ system of the FALAPHEL3 chip


The system is composed of the motherboard that hosts the chip, glued and wire-bonded to a daughter board. 
The motherboard is responsible to manage the DC levels, powering and communication to the FPGA, which is used to program the digital part of the chip through SPI interface.
Finally a python software is responsible to control the entire setup in order to characterize the chip.