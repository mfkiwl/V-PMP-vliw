#!/usr/bin/python3

import sys
import os

print ("Everything in HEX!");

opcode = input("Insert opcode: ");
offset = input("Insert offset: ");
immediate = input("Insert immediate: ");
src_addr = input("Insert source address: ");
dst_addr = input("Insert destination address: ");

scale = 16

#immediate printing

immediate_bin = bin(int(immediate, scale))[2:].zfill(32)
print(immediate_bin, end='');
offset_bin = bin(int(offset, scale))[2:].zfill(16)
print(offset_bin, end='');
src_addr_bin = bin(int(src_addr, scale))[2:].zfill(4)
print(src_addr_bin, end='');
dst_addr_bin = bin(int(dst_addr, scale))[2:].zfill(4)
print(dst_addr_bin, end='');
opcode_bin = bin(int(opcode, scale))[2:].zfill(8)
print(opcode_bin);
