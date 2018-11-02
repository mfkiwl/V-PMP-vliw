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
             result_gr        : out std_logic_vector(63 downto 0)


);

end alu64;

architecture Behavioral of alu64 is

    signal opc : std_logic_vector(7 downto 0);

begin

    opc <= syllable(7 downto 0);
  
    alu_control : process(syllable, alu64_select, operand_src, operand_dst, immediate, gr_add_dst)

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

                    result_gr <= operand_dst + (x"00000000" & immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ADD_OPC =>

                    result_gr <= operand_dst + operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when SUBI_OPC =>

                    result_gr <= operand_dst - (x"00000000" & immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when SUB_OPC =>

                    result_gr <= operand_dst - operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MULI_OPC =>
                
                    result_gr <= std_logic_vector(unsigned(immediate)*unsigned(operand_dst(31 downto 0)));
--                    result_gr <= std_logic_vector(unsigned(immediate*unsigned(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MUL_OPC =>
                
                    result_gr <= std_logic_vector(unsigned(operand_src(31 downto 0))*unsigned(operand_dst(31 downto 0)));
--                    result_gr <= std_logic_vectorsigned(operand_src)*signed(operand_dst);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when DIVI_OPC =>

                    result_gr <= std_logic_vector(to_signed(to_integer(signed(operand_dst) / signed(immediate)),64));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when DIV_OPC => -- when DIVI_OPC

                    result_gr <= std_logic_vector(to_signed(to_integer(signed(operand_dst) / signed(operand_src)),64));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ORI_OPC =>

                    result_gr <= operand_dst or  x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when OR_OPC =>

                    result_gr <= operand_dst or operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ANDI_OPC =>

                    result_gr <= operand_dst and  x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when AND_OPC =>

                    result_gr <= operand_dst and operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LSHI_OPC =>

                    result_gr <= std_logic_vector(shift_left(unsigned(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LSH_OPC =>
                
                    result_gr <= std_logic_vector(shift_left(unsigned(operand_dst),to_integer(unsigned(operand_src))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when RSHI_OPC =>
                
                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when RSH_OPC =>

                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(operand_src))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when NEG_OPC =>
                
                    result_gr <= not(operand_dst) +1; --complemento a due
--                    result_gr <= std_logic_vector(signed(operand_dst)*(-1));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MODI_OPC =>

                    result_gr <= x"00000000" & std_logic_vector(signed(operand_dst) mod signed(immediate));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOD_OPC =>

                    result_gr <= std_logic_vector(signed(operand_dst) mod signed(operand_src));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when XORI_OPC =>

                    result_gr <= operand_dst xor x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when XOR_OPC =>

                    result_gr <= operand_dst xor operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOVI_OPC =>

                    result_gr <= x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when MOV_OPC =>

                    result_gr <= operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSHI_OPC =>

                    result_gr <= std_logic_vector(shift_right(signed(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when ARSH_OPC =>
                
                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(operand_src))));
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
