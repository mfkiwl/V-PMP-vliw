library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
  Port (
  
            result_valid : out std_logic;
            result_gr       : out std_logic_vector(31 downto 0);
            result_br     : out std_logic
  
   );
end alu_tb;

architecture Behavioral of alu_tb is

signal clk       : std_logic := '0';
signal reset     : std_logic := '1';
signal syllable  : std_logic_vector(31 downto 0);
signal operand_0 : std_logic_vector(31 downto 0);
signal operand_1 : std_logic_vector(31 downto 0);
signal immediate : std_logic_vector(31 downto 0);
signal shamt     : std_logic_vector(4 downto 0);

begin

ALU: entity work.alu_pmp port map (
                                    clk,
                                    reset,
                                    syllable,
                                    operand_0,
                                    operand_1,
                                    immediate,
                                    shamt,
                                    result_gr,
                                    result_br,
                                    result_valid
                                            );

clk <= not(clk) after 10ns;
reset <= '0' after 40ns;
syllable <= "010011" & --opcode
            "00000" & -- operand_0 register address
            "00000" & -- operand_1 register address
            "00000" & -- result register address
            "00001" & -- shmat
            "000000"; -- function TODO: Remove this
         
operand_1 <= x"AAAAAAAA";
operand_0 <= x"DDDDDDDD";
immediate <= x"CCCCCCCC";
shamt <= syllable(10 downto 6);
end Behavioral;
