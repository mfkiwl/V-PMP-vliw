library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ctrl_tb is
  Port (
  
        branch_add   : out std_logic_vector(7 downto 0);
        branch_valid : out std_logic
  
   );
end ctrl_tb;

architecture Behavioral of ctrl_tb is

signal clk             : std_logic := '0';
signal reset           : std_logic := '1';
signal branch_reg_cont : std_logic := '0';
signal syllable        : std_logic_vector(31 downto 0);

begin

CONTROL_UNIT: entity work.ctrl_pmp port map (
                                                clk,
                                                reset,
                                                branch_reg_cont,
                                                syllable,       
                                                               
                                                branch_add,     
                                                branch_valid
                                                );
                                                
clk <= not(clk) after 10ns; 
--reset <= '0' after 40ns;

syllable <=  "100010" & --opcode
             "00000"  & -- address of branch register
             "0000000000000"& --padding
             "00000111"; -- address to jump

branch_reg_cont <= '0';

end Behavioral;
