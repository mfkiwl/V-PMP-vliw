library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


library work;
use work.common_pkg.all;

entity alu32 is
    Port ( 

             alu32_select     : in std_logic;

             syllable         : in std_logic_vector(63 downto 0); 
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)

);

end alu32;

architecture Behavioral of alu32 is

    signal opc : std_logic_vector(7 downto 0);
    
begin

    opc <= syllable(7 downto 0);

    alu_control : process(syllable, alu32_select, operand_src, operand_dst, immediate, gr_add_dst)

    begin

        result_gr <= (others => '0');
        gr_add_w <= (others => '0');
        w_e_gr <= '0';
        result_gr(63 downto 32) <= (others => '0');


        if (alu32_select = '1') then -- START EXECUTING

            case opc is 

                when NOP32_OPC =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

                when ADDI32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0)(31 downto 0) + (immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ADD32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) + operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when SUBI32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) - (immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when SUB32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) - operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MULI32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(immediate)*signed(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MUL32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_src(31 downto 0))*signed(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when DIVI32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(to_signed(to_integer(signed(operand_dst(31 downto 0)) / signed(immediate)),64));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when DIV32_OPC => -- when DIVI_OPC

                    result_gr(31 downto 0) <= std_logic_vector(to_signed(to_integer(signed(operand_dst(31 downto 0)) / signed(operand_src(31 downto 0))),64));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ORI32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) or immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when OR32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) or operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ANDI32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) and immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when AND32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) and operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LSHI32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)), to_integer(unsigned(immediate)))); -- result_gr PER USARE QUESTA FUNZIONE result_gr result_gr DEVE ESSERE unsigned no std_logic_vector
                    --result_gr(31 downto 0) <= shift_left(unsigned(operand_dst(31 downto 0)),unsigned(immediate)); -- result_gr PER USARE QUESTA FUNZIONE result_gr result_gr DEVE ESSERE unsigned no std_logic_vector
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LSH_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when RSHI32_OPC =>
                    result_gr(31 downto 0) <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(immediate))));
--                    result_gr(31 downto 0) <= std_logic_vector(shift_right(unsigned(operand_dst(31 downto 0)),o_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when RSH32_OPC =>
                    result_gr(31 downto 0) <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
--                    result_gr(31 downto 0) <= std_logic_vector(shift_right(unsigned(operand_dst(31 downto 0)),unsigned(operand_src(31 downto 0))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when NEG32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0))*(-1));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MODI32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0)) mod signed(immediate));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOD32_OPC =>

                    result_gr(31 downto 0) <= std_logic_vector(signed(operand_dst(31 downto 0)) mod signed(operand_src(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when XORI32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) xor immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when XOR32_OPC =>

                    result_gr(31 downto 0) <= operand_dst(31 downto 0) xor operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOVI32_OPC =>

                    result_gr(31 downto 0) <= immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOV32_OPC =>

                    result_gr(31 downto 0) <= operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSHI32_OPC =>
                
                    result_gr(31 downto 0) <= std_logic_vector(shift_right(signed(operand_dst(31 downto 0)),to_integer(unsigned(immediate))));
--                    result_gr(31 downto 0) <= shift_right(signed(operand_dst(31 downto 0)),unsigned(immediate));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSH32_OPC =>
                
                    result_gr(31 downto 0) <= std_logic_vector(shift_right(signed(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
--                    result_gr(31 downto 0) <= shift_right(signed(operand_dst(31 downto 0)),unsigned(operand_src(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when others =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

            end case;

        end if;

    end process alu_control;



end Behavioral;
