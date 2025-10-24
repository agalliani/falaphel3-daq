import os
import pyvisa
from contextlib import contextmanager
import time
from Singleton import Singleton


class WaveformService(metaclass=Singleton):

    def __init__(self):
        self.rm = pyvisa.ResourceManager()
        self.resources = self.rm.list_resources()
        self.instrument = self.rm.open_resource(self.resources[0])
        print("CONNECTED TO INSTRUMENT:")
        print(self.instrument.query("*IDN?"))
        self.instrument.write("*RCL 0") # recall saved memory setup

        #Channel 1 settings
        self.instrument.write("SOURce1:VOLTage:LEVel:IMMediate:AMPLitude 900mVpp")
        self.instrument.write("SOURce1:FREQuency:FIXed 300Hz")
        self.instrument.write("OUTPut1:IMPedance 50")

        #Channel 2 settings
        self.instrument.write("SOURce2:VOLTage:LEVel:IMMediate:AMPLitude 200mVpp")
        self.instrument.write("SOURce2:FREQuency:FIXed 300Hz")
        self.instrument.write("OUTPut2:IMPedance 25")


        self.instrument.write("SOURce1:PHASe:INITiate")

    def onOutWaveform(self):
        self.instrument.write("OUTPut1:STATe ON")
        self.instrument.write("OUTPut2:STATe ON")

    def offOutWaveform(self):
        self.instrument.write("OUTPut1:STATe OFF")
        self.instrument.write("OUTPut2:STATe OFF")

    def setInjectionApmlitudeWaveform(self,amp):
        self.instrument.write("SOURce2:VOLTage:LEVel:IMMediate:AMPLitude "+amp+"mVpp")