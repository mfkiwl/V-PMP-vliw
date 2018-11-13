library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;


entity memory_unit is

    Port (
             mem_select       : in std_logic;
             reset            : in std_logic;

             syllable         : in std_logic_vector (63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             offset           : in std_logic_vector(15 downto 0);
             operand_src      : in std_logic_vector (63 downto 0);
             operand_dst      : in std_logic_vector (63 downto 0);
             gr_add_dst       : in std_logic_vector (3 downto 0);

             -- MEMORY INTERFACE
             mem_data_in      : in std_logic_vector (63 downto 0);
             mem_data_out     : out std_logic_vector (63 downto 0);
             mem_wrt_addr     : out std_logic_vector (63 downto 0);
             mem_wrt_en       : out std_logic;
             mem_wrt_amount   : out std_logic_vector(8 downto 0);

             -- GPR INTERFACE
             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)
         );

end memory_unit;

architecture Behavioral of memory_unit is

    signal opc : std_logic_vector (7 downto 0);

begin

    opc <= syllable(7 downto 0);

    RAM_MEMORY : process (opc, mem_select, operand_src, operand_dst, immediate, gr_add_dst, reset)
    begin

        mem_data_out <= (others => '0');  
        mem_wrt_addr <= (others => '0');     
        mem_wrt_en  <= '0';
        gr_add_w <= (others => '0');
        w_e_gr <= '0';
        result_gr <= (others => '0');
        mem_wrt_amount <= (others => '0');

        if (mem_select = '1') and (reset = '0') then

            case opc is

                --LOAD
                when LDDW_OPC => 

                    result_gr <= mem_data_in;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LDXW_OPC => 

                    result_gr(31 downto 0) <= mem_data_in(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LDXH_OPC => 

                    result_gr(15 downto 0) <= mem_data_in(15 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LDXB_OPC => 

                    result_gr(7 downto 0) <= mem_data_in(7 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                when LDXDW_OPC => 

                    result_gr <= mem_data_in;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';

                -- STORE 
                when STW_OPC   => 

                    mem_data_out(31 downto 0) <= immediate;
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0100";


                when STH_OPC   => 

                    mem_data_out(15 downto 0) <= immediate(15 downto 0);
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0080";

                when STB_OPC   =>

                    mem_data_out(7 downto 0) <= immediate(7 downto 0);
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0008";

                when STDW_OPC  =>

                    mem_data_out <= x"00000000" & immediate;
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0200";

                when STXW_OPC  => 

                    mem_data_out(31 downto 0) <= operand_src(31 downto 0);
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0100";

                when STXH_OPC  => 

                    mem_data_out(15 downto 0) <= operand_src(15 downto 0);
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0080";

                when STXB_OPC  => 

                    mem_data_out(7 downto 0) <= operand_src(7 downto 0);
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0008";

                when STXDW_OPC => 

                    mem_data_out <= operand_src;
                    mem_wrt_addr <= operand_dst + x"0000000000" & offset;
                    mem_wrt_en <= '1';
                    mem_wrt_amount <= x"0200";

                when others =>    

                    mem_data_out <= (others => '0');  
                    mem_wrt_addr <= (others => '0');     
                    mem_wrt_en  <= '0';
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';
                    mem_wrt_amount <= (others => '0');
                    result_gr <= (others => '0');

            end case;

        end if;
    --when LDABSW_OPC =>      SEE KERNEL DOCUMENTATION                                                     
    --            when LDABSH_OPC =>                                                            
    --            when LDABSB_OPC =>                                                           
    --            when LDABSDW_OPC =>                                                            
    --            when LDINDW_OPC =>                                                           
    --            when LDINDH_OPC =>                                                            
    --            when LDINDB_OPC =>                                                           
    --            when LDINDDW_OPC =>     

    end process;
end Behavioral;
