#!/usr/bin/python

import sys
import inspect

#check on input filename
if len(sys.argv) < 2:
  
  print "Missing input filename!"
  print "Exiting..."
  exit(-1)

else:

  input_filename = sys.argv[1]


inst_dictionary=dict() #instruction dictionary

#parse the instruction set txt DB
with open ("ISA_DB.txt","r") as instruction_db:

  for line in instruction_db:

    current_line = line.split(",")
    opcode = current_line[0]
    mnemonic = current_line[1].rstrip()
    inst_dictionary[mnemonic] = opcode

#open input file
with open (input_filename,"r") as input_code:

  line_number = 0
  
  for line in input_code:
    
    current_line = line.split()
    
    #control if there is any instruction not present in dictionary
    if current_line[0] not in inst_dictionary:
      
      print "Syntax error on line", line_number, ": instruction", current_line[0], "not supported"
      exit(-1)

    print current_line  
    line_number += 1
    
