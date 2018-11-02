library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;

entity mem_pmp is

    Port ( 

             mem_select  : in std_logic;

             syllable         : in std_logic_vector(63 downto 0); 
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register
             data_from_mem    : in std_logic_vector(63 downto 0);

             -- STORE
             data_to_mem      : out std_logic_vector(63 downto 0);
             addr_to_mem      : out std_logic_vector(63 downto 0);
             w_e_mem          : out std_logic;

             -- LOAD
             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)


         );
end mem_pmp;

architecture Behavioral of mem_pmp is

    signal opc: std_logic_vector(7 downto 0);

begin

    opc <= syllable(7 downto 0);

    process (mem_select, opc, data_from_mem, gr_add_dst,immediate, operand_dst, operand_src)               

    begin

        if(mem_select = '0') then

            data_to_mem <= (others => '0');  
            addr_to_mem <= (others => '0');
            w_e_mem     <= '0'; 

            gr_add_w    <= (others => '0'); 
            w_e_gr      <= '0';
            result_gr   <= (others => '0');


        else

            case opc is
                 -- LOAD
                when LDDW_OPC =>

                    -- POOR DOCUMENTATION => TODO

                when LDABSW_OPC =>

            end case;
        end if;
    end process;

end Behavioral;
