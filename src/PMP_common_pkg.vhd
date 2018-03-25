 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- R-Type Instruction structure
-- *---------*--------------*--------------*--------------*---------------*-------------*
-- | 6 Bits  |  5 Bits      |  5 Bits      |  5 Bits      |   5 Bits     |  6 Bits      |
-- |  OPC    | Oper0 regAdd | Oper1 regAdd | Dest regAdd  |    None      | none         | 
-- *---------*--------------*--------------*--------------*--------------*--------------*

-- J-Type Instruction structure
-- *---------*--------------*--------------*--------------*---------------*-------------*
-- | 6 Bits  |  5 Bits      |                      21 Bits                              |
-- |  OPC    | Branch regAd |                     Address to Jump                       | 
-- *---------*--------------*--------------*--------------*--------------*--------------*

-- I-Type Instruction structure
-- *---------*--------------*--------------*--------------*---------------*-------------*
-- | 6 Bits  |  5 Bits                               |  5 Bits      |  5 Bits      |             11 Bits         |
-- |  OPC    | Oper0 regAdd (Contains data to store) | Oper1 regAdd | Dest regAdd  |            Immediate        | 
-- *---------*--------------*--------------*--------------*--------------*--------------*

-- store: oper0 = data_to_store_to_mem ; oper1 = base_address;
-- load: dest_reg= data_loaded; oper1= base_address

package common_pkg is

  constant R_TYPE : std_logic_vector(5 downto 0) := "00----";
  constant I_TYPE_1 : std_logic_vector(5 downto 0) := "01----";
  constant I_TYPE_2 : std_logic_vector(5 downto 0) := "10----";
  constant J_TYPE : std_logic_vector(5 downto 0) := "11----";

  -- R_TYPE OPCODES

  constant ADD_OPC : std_logic_vector(5 downto 0) := "000000";
  constant SUB_OPC : std_logic_vector(5 downto 0) := "000001";
  constant AND_OPC : std_logic_vector(5 downto 0) := "000010";
  constant OR_OPC  : std_logic_vector(5 downto 0) := "000011";
  constant XOR_OPC : std_logic_vector(5 downto 0) := "000100";  
  constant SLT_OPC : std_logic_vector(5 downto 0) := "000111"; -- destination is branch register

  -- I_TYPE OPCOCDES

  constant ADDI_OPC : std_logic_vector(5 downto 0) := "010000";
  constant ANDI_OPC : std_logic_vector(5 downto 0) := "010001";
  constant ORI_OPC  : std_logic_vector(5 downto 0) := "010010";
  constant SLTI_OPC : std_logic_vector(5 downto 0) := "010011"; -- destination is branch register

  constant LDW_OPC  : std_logic_vector(5 downto 0) := "010100"; -- load word
  constant LUH_OPC  : std_logic_vector(5 downto 0) := "010101"; -- load upper halfword
  constant LLH_OPC  : std_logic_vector(5 downto 0) := "010110"; -- load lower halfword
  constant LFB_OPC  : std_logic_vector(5 downto 0) := "010111"; -- load first byte
  constant LSB_OPC  : std_logic_vector(5 downto 0) := "011000"; -- load second byte
  constant LTB_OPC  : std_logic_vector(5 downto 0) := "011001"; -- load third byte
  constant LLB_OPC  : std_logic_vector(5 downto 0) := "011010"; -- load last byte

  constant STW_OPC  : std_logic_vector(5 downto 0) := "011100"; -- store word
  constant SUH_OPC  : std_logic_vector(5 downto 0) := "011101"; -- store upper halfword
  constant SLH_OPC  : std_logic_vector(5 downto 0) := "011110"; -- store lower halfword
  constant SFB_OPC  : std_logic_vector(5 downto 0) := "011111"; -- store first byte
  constant SSB_OPC  : std_logic_vector(5 downto 0) := "100000"; -- store second byte
  constant STB_OPC  : std_logic_vector(5 downto 0) := "100001"; -- store third byte
  constant SLB_OPC  : std_logic_vector(5 downto 0) := "100010"; -- store last byte
  constant SLL_OPC  : std_logic_vector(5 downto 0) := "100101";
  constant SRL_OPC  : std_logic_vector(5 downto 0) := "100110";

  -- J_TYPE OPCODES

  constant BRT_OPC  : std_logic_vector(5 downto 0) := "110000";  -- branch on true condition
  constant BRF_OPC  : std_logic_vector(5 downto 0) := "110001";  -- branch on false condition
  constant JMP_OPC  : std_logic_vector(5 downto 0) := "110010";  -- goto

  -- MISC
  
  
  
end common_pkg;

