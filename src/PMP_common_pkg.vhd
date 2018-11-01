 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--  +------------------------+----------------+--------+--------+--------+
--  |immediate               |offset          |src     |dst     |opcode  |
--  +------------------------+----------------+--------+--------+--------+
--   63                    32 31            16 15    12 11     8 7       0

package common_pkg is

  -- Group class of opcodes

  constant ALU64 : std_logic_vector(7 downto 0) := "-----111"; 
  constant ALU32 : std_logic_vector(7 downto 0) := "-----100"; -- including byteswap OPCs
  constant MEM   : std_logic_vector(7 downto 0) := "0----0--";
  constant BRCH  : std_logic_vector(7 downto 0) := "-----101";

  -- NOP opcode (not in official eBPF instruction set)

  constant NOP_OPC  : std_logic_vector(7 downto 0)   := "00000000";
  constant NOP32_OPC  : std_logic_vector(7 downto 0) := "00000000";
  
  -- ALU-64 OPCODES

  constant ADDI_OPC  : std_logic_vector(7 downto 0) := "00000111"; --0x07
  constant ADD_OPC   : std_logic_vector(7 downto 0) := "00001111"; --0x0F
  constant SUBI_OPC  : std_logic_vector(7 downto 0) := "00010111"; --0x17
  constant SUB_OPC   : std_logic_vector(7 downto 0) := "00011111"; --0x1F
  constant MULI_OPC  : std_logic_vector(7 downto 0) := "00100111"; --0x27
  constant MUL_OPC   : std_logic_vector(7 downto 0) := "00101111"; --0x2F
  constant DIVI_OPC  : std_logic_vector(7 downto 0) := "00110111"; --0x37
  constant DIV_OPC   : std_logic_vector(7 downto 0) := "00111111"; --0x3F
  constant ORI_OPC   : std_logic_vector(7 downto 0) := "01000111"; --0x47
  constant OR_OPC    : std_logic_vector(7 downto 0) := "01001111"; --0x4F
  constant ANDI_OPC  : std_logic_vector(7 downto 0) := "01010111"; --0x57
  constant AND_OPC   : std_logic_vector(7 downto 0) := "01011111"; --0x5F
  constant LSHI_OPC  : std_logic_vector(7 downto 0) := "01100111"; --0x67
  constant LSH_OPC   : std_logic_vector(7 downto 0) := "01101111"; --0x6F
  constant RSHI_OPC  : std_logic_vector(7 downto 0) := "01110111"; --0x77
  constant RSH_OPC   : std_logic_vector(7 downto 0) := "01111111"; --0x7F
  constant NEG_OPC   : std_logic_vector(7 downto 0) := "10000111"; --0x87
  constant MODI_OPC  : std_logic_vector(7 downto 0) := "10010111"; --0x97
  constant MOD_OPC   : std_logic_vector(7 downto 0) := "10011111"; --0x9F
  constant XORI_OPC  : std_logic_vector(7 downto 0) := "10100111"; --0xA7
  constant XOR_OPC   : std_logic_vector(7 downto 0) := "10101111"; --0xAF
  constant MOVI_OPC  : std_logic_vector(7 downto 0) := "10110111"; --0xB7
  constant MOV_OPC   : std_logic_vector(7 downto 0) := "10111111"; --0xBF
  constant ARSHI_OPC : std_logic_vector(7 downto 0) := "11000111"; --0xC7
  constant ARSH_OPC  : std_logic_vector(7 downto 0) := "11001111"; --0xCF

  -- ALU-32 OPCODES

  constant ADDI32_OPC  : std_logic_vector(7 downto 0) := "00000100"; --0x04
  constant ADD32_OPC   : std_logic_vector(7 downto 0) := "00001100"; --0x0C
  constant SUBI32_OPC  : std_logic_vector(7 downto 0) := "00010100"; --0x14
  constant SUB32_OPC   : std_logic_vector(7 downto 0) := "00011100"; --0x1C
  constant MULI32_OPC  : std_logic_vector(7 downto 0) := "00100100"; --0x24
  constant MUL32_OPC   : std_logic_vector(7 downto 0) := "00101100"; --0x2C
  constant DIVI32_OPC  : std_logic_vector(7 downto 0) := "00110100"; --0x34
  constant DIV32_OPC   : std_logic_vector(7 downto 0) := "00111100"; --0x3C
  constant ORI32_OPC   : std_logic_vector(7 downto 0) := "01000100"; --0x44
  constant OR32_OPC    : std_logic_vector(7 downto 0) := "01001100"; --0x4C
  constant ANDI32_OPC  : std_logic_vector(7 downto 0) := "01010100"; --0x54
  constant AND32_OPC   : std_logic_vector(7 downto 0) := "01011100"; --0x5C
  constant LSHI32_OPC  : std_logic_vector(7 downto 0) := "01100100"; --0x64
  constant LSH32_OPC   : std_logic_vector(7 downto 0) := "01101100"; --0x6C
  constant RSHI32_OPC  : std_logic_vector(7 downto 0) := "01110100"; --0x74
  constant RSH32_OPC   : std_logic_vector(7 downto 0) := "01111100"; --0x7C
  constant NEG32_OPC   : std_logic_vector(7 downto 0) := "10000100"; --0x84
  constant MODI32_OPC  : std_logic_vector(7 downto 0) := "10010100"; --0x94
  constant MOD32_OPC   : std_logic_vector(7 downto 0) := "10011100"; --0x9C
  constant XORI32_OPC  : std_logic_vector(7 downto 0) := "10100100"; --0xA4
  constant XOR32_OPC   : std_logic_vector(7 downto 0) := "10101100"; --0xAC
  constant MOVI32_OPC  : std_logic_vector(7 downto 0) := "10110100"; --0xB4
  constant MOV32_OPC   : std_logic_vector(7 downto 0) := "10111100"; --0xBC
  constant ARSHI32_OPC : std_logic_vector(7 downto 0) := "11000100"; --0xC4
  constant ARSH32_OPC  : std_logic_vector(7 downto 0) := "11001100"; --0xCC

  -- Byteswap OPCODES

  constant LE_OPC      : std_logic_vector(7 downto 0) := "11010100"; --0xD4
  constant BE_OPC      : std_logic_vector(7 downto 0) := "11011100"; --0xDC
  
  -- Memory OPCODES
  
  constant LDDW_OPC    : std_logic_vector(7 downto 0) := "00011000";
  constant LDABSW_OPC  : std_logic_vector(7 downto 0) := "00100000";
  constant LDABSH_OPC  : std_logic_vector(7 downto 0) := "00101000";
  constant LDABSB_OPC  : std_logic_vector(7 downto 0) := "00110000";
  constant LDABSDW_OPC : std_logic_vector(7 downto 0) := "00111000";
  constant LDINDW_OPC  : std_logic_vector(7 downto 0) := "01000000";
  constant LDINDH_OPC  : std_logic_vector(7 downto 0) := "01001000";
  constant LDINDB_OPC  : std_logic_vector(7 downto 0) := "01010000";
  constant LDINDDW_OPC : std_logic_vector(7 downto 0) := "01011000";
  constant LDXW_OPC    : std_logic_vector(7 downto 0) := "01100001";
  constant LDXH_OPC    : std_logic_vector(7 downto 0) := "01101001";
  constant LDXB_OPC    : std_logic_vector(7 downto 0) := "01110001";
  constant LDXDW_OPC   : std_logic_vector(7 downto 0) := "01111001";
  constant STW_OPC     : std_logic_vector(7 downto 0) := "01100010";
  constant STH_OPC     : std_logic_vector(7 downto 0) := "01101010";
  constant STB_OPC     : std_logic_vector(7 downto 0) := "01110010";
  constant STDW_OPC    : std_logic_vector(7 downto 0) := "01111010";
  constant STXW_OPC    : std_logic_vector(7 downto 0) := "01100011";
  constant STXH_OPC    : std_logic_vector(7 downto 0) := "01101011";
  constant STXB_OPC    : std_logic_vector(7 downto 0) := "01110011";
  constant STXDW_OPC   : std_logic_vector(7 downto 0) := "01111011";
  
  -- Branch OPCODES

  constant JA_OPC     : std_logic_vector(7 downto 0) := "00000101";
  constant JEQI_OPC   : std_logic_vector(7 downto 0) := "00010101";
  constant JEQ_OPC    : std_logic_vector(7 downto 0) := "00011101";
  constant JGTI_OPC   : std_logic_vector(7 downto 0) := "00100101";
  constant JGT_OPC    : std_logic_vector(7 downto 0) := "00101101";
  constant JGEI_OPC   : std_logic_vector(7 downto 0) := "00110101";
  constant JGE_OPC    : std_logic_vector(7 downto 0) := "00111101";
  constant JLTI_OPC   : std_logic_vector(7 downto 0) := "10100101";
  constant JLT_OPC    : std_logic_vector(7 downto 0) := "10101101";
  constant JLEI_OPC   : std_logic_vector(7 downto 0) := "10110101";
  constant JLE_OPC    : std_logic_vector(7 downto 0) := "10111101";
  constant JSETI_OPC  : std_logic_vector(7 downto 0) := "01000101";
  constant JSET_OPC   : std_logic_vector(7 downto 0) := "01001101";
  constant JNEI_OPC   : std_logic_vector(7 downto 0) := "01010101";
  constant JNE_OPC    : std_logic_vector(7 downto 0) := "01011101";
  constant JSGTIS_OPC : std_logic_vector(7 downto 0) := "01100101";
  constant JSGTS_OPC  : std_logic_vector(7 downto 0) := "01101101";
  constant JSGEIS_OPC : std_logic_vector(7 downto 0) := "01110101";
  constant JSGES_OPC  : std_logic_vector(7 downto 0) := "01111101";
  constant JSLTIS_OPC : std_logic_vector(7 downto 0) := "11000101";
  constant JSLTS_OPC  : std_logic_vector(7 downto 0) := "11001101";
  constant JSLEIS_OPC : std_logic_vector(7 downto 0) := "11010101";
  constant JSLES_OPC  : std_logic_vector(7 downto 0) := "11011101";
  constant CALL_OPC   : std_logic_vector(7 downto 0) := "10000101";
  constant EXIT_OPC   : std_logic_vector(7 downto 0) := "10010101";

end common_pkg;

