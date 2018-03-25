library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;
use work.alu_operations.all;
-- This unit goes only on syllable 0
entity ctrl_pmp is

  Port ( 
        --        clk  : in std_logic;
         ctrl_select_n   : in std_logic;  -- negate

         branch_reg_cont : in std_logic;
         syllable        : in std_logic_vector(31 downto 0);

         branch_add      : out std_logic_vector(7 downto 0);
         branch_valid    : out std_logic

       );

end ctrl_pmp;

architecture Behavioral of ctrl_pmp is

begin

  process(ctrl_select_n, branch_reg_cont, syllable)
    --        process(clk)
  begin

    if (ctrl_select_n = '1') then

      branch_add <= (others => '0');
      branch_valid <= '0';

    else 
            --        rising_edge(clk) then


      if (std_match(syllable(31 downto 26),BRT_OPC)) then

        branch_add <= syllable(7 downto 0);
        branch_valid <= branch_reg_cont;

      elsif (std_match(syllable(31 downto 26), BRF_OPC)) then

        branch_add <= syllable(7 downto 0);
        branch_valid <= not(branch_reg_cont);

      elsif (std_match(syllable(31 downto 26), JMP_OPC)) then

        branch_add <= syllable( 7 downto 0);
        branch_valid <= '1';

      else 

        branch_valid <= '0';
        branch_add <= (others => '0');

      end if;

    end if;

  end process;

end Behavioral;
