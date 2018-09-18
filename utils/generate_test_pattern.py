#!/usr/bin/python3

import sys
import os

print ("Everything in HEX!");

opcode = input("Insert opcode: ");
immediate = input("Insert immediate: ");
src_addr = input("Insert source address: ");
dst_addr = input("Insert destination address: ");

scale = 16

#immediate printing

immediate_bin = bin(int(immediate, scale))[2:].zfill(32)
print(immediate_bin, end='');
