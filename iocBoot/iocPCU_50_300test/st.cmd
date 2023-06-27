#!../../bin/linux-x86_64/PCU50_300test

############################################################################### 
# Set up environment 
< envPaths 
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TOP)/db" 

############################################################################### 
# Allow PV name prefixes and serial port name to be set from the environment 
epicsEnvSet "P" "$(P=PCU50_300)" 
epicsEnvSet "R" "$(R=test)" 
#epicsEnvSet "HOST" "$(HOST=10.0.0.105)"
#epicsEnvSet "PORT" "$(PORT=5025)"

############################################################################### 
## Register all support components 
cd "${TOP}" 
dbLoadDatabase "dbd/PCU50_300test.dbd" 
PCU50_300test_registerRecordDeviceDriver pdbbase 

############################################################################### 
# Set up ASYN ports
#drvAsynIPPortConfigure("LAN0","$(HOST):$(PORT)",0,0,0)
#1st argument is the port's name
#2nd argument is the "IP address: port num"
#3rd argument is priority; 0 means medium
#4th argument is noAutoConnect; 0 means yes, autoconnect
#5th argument is noProcessEOS; 0 something complicated, 1 also complicated

drvAsynSerialPortConfigure("USB0","/dev/ttyUSB0",0,0,0)
asynSetOption("USB0",-1,"baud","9600")
asynSetOption("USB0",-1,"bits","8")
asynSetOption("USB0",-1,"parity","none")
asynSetOption("USB0",-1,"stop","2")

# Set output and input end of command terminators to be newlines.
asynOctetSetOutputEos("USB0", 0, "\r")
asynOctetSetInputEos("USB0", 0, "\n\r")
############################################################################### 

# asynSetTraceIOMask("USB0", 0, "ESCAPE")
# asynSetTraceMask("USB0", 0, "ERROR|DRIVER")

var streamError 1
var streamDebug 1
var streamDebugColored 1
var streamErrorDeadTime 30
var streamMsgTimeStamped 1
streamSetLogfile("logfile.txt")

############################################################################### 
## Load record instances 
dbLoadRecords("db/devPCU50_300.db","P=$(P),R=$(R),PORT=USB0,A=0") 

############################################################################### 
## Start EPICS 
cd "${TOP}/iocBoot/${IOC}" 
iocInit
