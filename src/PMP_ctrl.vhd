library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;
-- This unit goes only on syllable 0

entity control is

    Port ( 
         --        clk  : in std_logic;
             ctrl_select     : in std_logic;  -- negate

             syllable        : in std_logic_vector(31 downto 0);
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)

         );

end control;

architecture Behavioral of control is

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
