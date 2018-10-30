library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;

entity mem_pmp is

  Port ( 
    
         mem_select_n  : in std_logic;  --negate

         syllable      : in std_logic_vector(31 downto 0);

         mem_dest_reg  : in std_logic_vector(4 downto 0); -- destination rtegister for load
         mem_l_s       : in std_logic;
         mem_data_w    : in std_logic_vector(31 downto 0); -- data to store
         data_from_mem : in std_logic_vector(31 downto 0); -- data from mem
         mem_add_dec   : in std_logic_vector(31 downto 0); -- addres from decode stage, used only in store operation since load has been prefetched

         mem_add       : out std_logic_vector(31 downto 0); -- address memory
         data_out      : out std_logic_vector(31 downto 0); -- data to write in mem
         wrt_amnt      : out std_logic_vector(4  downto 0); -- number of bits written
         mem_w_e       : out std_logic;

         gr_cont       : out std_logic_vector(31 downto 0);  -- data loaded
         gr_add        : out std_logic_vector(4 downto 0);   -- destination register address
         gr_w_e        : out std_logic

       );
end mem_pmp;

architecture Behavioral of mem_pmp is


begin

MEM_UNIT:process (mem_select_n, syllable, mem_dest_reg, mem_l_s, mem_data_w, data_from_mem, mem_add_dec)               

  begin

    mem_add  <= (others => '0'); 
    data_out <= (others => '0');              
    mem_w_e     <= '0';                 
    gr_cont     <= (others => '0');                 
    gr_add       <= (others => '0');                
    gr_w_e        <= '0';               
    wrt_amnt <= (others => '0');

    if (mem_select_n = '0') then 

      if (syllable(31 downto 26) >= LDW_OPC and syllable(31 downto 26) <= SLB_OPC) then

        if (mem_l_s = '0') then

          gr_add <= mem_dest_reg;
          gr_w_e <= '1';

          case syllable(31 downto 26) is

            when LDW_OPC => gr_cont <= data_from_mem;

            when LUH_OPC => gr_cont <= x"0000" & data_from_mem(31 downto 16);

            when LLH_OPC => gr_cont <= x"0000" & data_from_mem(15 downto 0);

            when LFB_OPC => gr_cont <= x"000000" & data_from_mem(7 downto 0);

            when LSB_OPC => gr_cont <= x"000000" & data_from_mem(15 downto 8);

            when LTB_OPC => gr_cont <= x"000000" & data_from_mem(23 downto 16);

            when LLB_OPC => gr_cont <= x"000000" & data_from_mem(31 downto 24);

            when others => gr_cont <= (others => '0');

          end case;

        else -- Store

          mem_add <= mem_add_dec;
          mem_w_e <= '1';

          case syllable(31 downto 26) is

            when STW_OPC => 

              data_out <= mem_data_w;
              wrt_amnt <= (others => '1');

            when SUH_OPC => 

              data_out <= x"0000" & mem_data_w(31 downto 16);
              wrt_amnt <= "01111";

            when SLH_OPC => 

              data_out <= x"0000" & mem_data_w(15 downto 0);
              wrt_amnt <= "01111";

            when SFB_OPC => 

              data_out <= x"000000" & mem_data_w(7 downto 0);
              wrt_amnt <= "00111";

            when SSB_OPC => 

              data_out <= x"000000" & mem_data_w(15 downto 8);
              wrt_amnt <= "00111";

            when STB_OPC => 

              data_out <= x"000000" & mem_data_w(23 downto 16);
              wrt_amnt <= "00111";

            when SLB_OPC => 

              data_out <= x"000000" & mem_data_w(31 downto 24);
              wrt_amnt <= "00111";

            when others => 

              data_out <= (others => '0');
              wrt_amnt <= (others => '0');

          end case;

        end if;

      end if;

    end if;

  end process;

end Behavioral;
