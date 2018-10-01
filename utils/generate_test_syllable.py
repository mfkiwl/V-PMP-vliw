#!/usr/bin/python3

import sys
import os

print ("Everything in HEX!");

#OPCODE
opcode = input("Insert opcode(1 byte): ");

while (len(opcode) > 2):
    print("Too Big");
    opcode = input("Insert opcode(1 byte): ");

while (len(opcode) < 2):
    print("Too Small");
    opcode = input("Insert opcode(1 byte): ");

#OFFSET
offset = input("Insert offset(2 byte): ");

while (len(offset) > 4):
    print("Too Big");
    offset = input("Insert offset(2 byte): ");

while (len(offset) < 4):
    print("Too Small");
    opcode = input("Insert offset(2 byte): ");

#IMMEDIATE
immediate = input("Insert immediate(4 byte): ");

while (len(immediate) > 8):
    print("Too Big");
    immediate = input("Insert immediate(4 byte): ");

while (len(immediate) < 8):
    print("Too Small");
    immediate = input("Insert immediate(4 byte): ");

#SRC ADDRESS
src_addr = input("Insert source address(1 nibble): ");

while (len(src_addr) > 1):
    print("Too Big");
    src_addr = input("Insert source address(1 nibble): ");

while (len(src_addr) < 1):
    print("Too Small");
    src_addr = input("Insert source address(1 nibble): ");

#DEST ADDRESS
dst_addr = input("Insert destination address(1 nibble): ");

while (len(dst_addr) > 1):
    print("Too Big");
    dst_addr = input("Insert destination address(1 nibble): ");

while (len(dst_addr) < 1):
    print("Too Small");
    dst_addr = input("Insert destination address(1 nibble): ");


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
