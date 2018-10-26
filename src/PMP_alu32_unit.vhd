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
        result_gr(63 downto 32) <= (others => '0');


        if (alu64_select = '1') then -- START EXECUTING

            case opc is 

                when NOP_OPC =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

                when ADDI_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0)(31 downto 0) + (immediate);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ADD_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) + operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when SUBI_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) - (immediate);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when SUB_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) - operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MULI_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(immediate)*signed(operand_dst(31 downto 0)));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MUL_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_src(31 downto 0))*signed(operand_dst(31 downto 0)));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when DIVI_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(to_signed(to_integer(signed(operand_dst(31 downto 0)) / signed(immediate)),64));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when DIVI_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(to_signed(to_integer(signed(operand_dst(31 downto 0)) / signed(operand_src(31 downto 0))),64));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ORI_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) or immediate;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when OR_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) or operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ANDI_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) and immediate;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when AND_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) and operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when LSHI_OPC =>

                    result_gr(31 downto 0) <= shift_left(unsigned(operand_dst(31 downto 0)),unsigned(immediate));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when LSH_OPC =>

                    result_gr(31 downto 0) <= shift_left(unsigned(operand_dst(31 downto 0)),unsigned(operand_src(31 downto 0)));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when RSHI_OPC =>

                    result_gr(31 downto 0) <= shift_right(unsigned(operand_dst(31 downto 0)),unsigned(immediate));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when RSH_OPC =>

                    result_gr(31 downto 0) <= shift_right(unsigned(operand_dst(31 downto 0)),unsigned(operand_src(31 downto 0)));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when NEG_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0))*-1);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MODI_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0)) mod signed(immediate));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MOD_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0)) mod signed(operand_src(31 downto 0))));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when XORI_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) xor immediate;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when XOR_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) xor operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MOVI_OPC =>

                    result_gr(31 downto 0) <= immediate;
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when MOV_OPC =>

                    result_gr(31 downto 0) <= operand_src(31 downto 0);
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSHI_OPC =>

                    result_gr(31 downto 0) <= shift_right(signed(operand_dst(31 downto 0)),unsigned(immediate));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSH_OPC =>

                    result_gr(31 downto 0) <= shift_right(signed(operand_dst(31 downto 0)),unsigned(operand_src(31 downto 0)));
                    gr_add_wrt <= gr_add_dst;
                    w_e_gr <= '1';

                when others =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

            end case;

        end if;

    end process alu_control;



end Behavioral;
