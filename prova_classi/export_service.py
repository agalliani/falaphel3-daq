
import os
import time
from Singleton import Singleton
import pandas


       
class ExportService(metaclass=Singleton):
    def __init__(self):
      self.directory = os.getcwd()+"\export"
      self.fileName = ""
      self.elaboratedDF = pandas.DataFrame([])
      
      self.thresholds = []
      self.noises = []
      
      
      self.rawPath=""
      self.elaboratedPath = ""
      
      
      
    
    def getDirectory(self):
       return self.directory
      
    """
    Create export text file for the data of the Charge Scan in TSV format
    """  
    def createCSTsvFile(self,prefix, type):
        setup_suffix = ""
      
        fileName = "\\"+prefix+"_charge_scan_"+setup_suffix+ time.strftime("%d-%m-%Y-%H%M%S")+".tsv"
        file = open(self.directory+fileName, "x")
        
        if("RAW" in type):
          file.write("Pixel\tVinj\thit_efficiency\n")
          self.rawPath = self.directory+fileName
      
        else:
          file.write("Pixel\tThreshold\tENC\n")
          self.elaboratedPath = self.directory+fileName

        file.close()
        

        
    def writeRawDataFile(self, pixelNum, Vinj, hitEff):             
        file = open(self.rawPath, "a")
        file.write(str(pixelNum) + "\t" + str(Vinj)  + "\t" + str(hitEff)+"\n") 
    
        file.close()
    
    def writeElaboratedRowFile(self, index, th, enc):
        file = open(self.elaboratedPath, "a")
        file.write(str(index) +"\t"+ str(float(th)) + "\t" + str(float(enc))+"\n") 
    
        file.close()

      
      
      
      

    
      
      
    
       
        
    
        
