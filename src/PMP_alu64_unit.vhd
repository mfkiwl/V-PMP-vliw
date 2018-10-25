library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;

entity alu64 is
    Port ( 

             alu64_select     : in std_logic;

             syllable         : in std_logic_vector(63 downto 0); 
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0);


);

end alu64;

architecture Behavioral of alu64 is

    signal opc : std_logic_vector(7 downto 0);

begin

    opc <= syllable(7 downto 0);

    alu_control : process(syllable, alu64_select, operand, immediate, gr_add_dst)

    begin

        result_gr <= (others => '0');
        gr_add_w <= (others => '0');
        w_e_gr <= '0';


        if (alu64_select = '1') then -- START EXECUTING

            case opc is 

                when NOP_OPC =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

                when ADDI_OPC =>

                    result_gr <= operand_dst + (0x"00000000" & immediate);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ADD_OPC =>

                    result_gr <= operand_dst + operand_src;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when SUBI_OPC =>

                    result_gr <= operand_dst - (0x"00000000" & immediate);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when SUB_OPC =>

                    result_gr <= operand_dst - operand_src;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';



                end if;
            end process alu_control;



        end Behavioral;
