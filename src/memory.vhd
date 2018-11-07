library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;


entity memory is
    Port (
          mem_enable       : in std_logic;
          we               : in std_logic;
          clk              : in std_logic;
          reset            : in std_logic;
          
          syllable         : in std_logic_vector (63 downto 0);
          immediate        : in std_logic_vector(31 downto 0);
          offset           : in std_logic_vector(15 downto 0);
          operand_src      : in std_logic_vector (63 downto 0);
          src              : in std_logic_vector (3 downto 0);
          dst              : in std_logic_vector (3 downto 0);
          
          operand_dst      : out std_logic_vector (63 downto 0)
         );
end memory;

architecture Behavioral of memory is

type ram_type is array (0 to 7) of std_logic_vector (63 downto 0);
signal ram_s       : ram_type;
signal loc         : integer;

signal opc         : std_logic_vector(7 downto 0);
signal addr        : std_logic_vector(3 downto 0);
signal datain      : std_logic_vector(63 downto 0);

begin

opc <= syllable(7 downto 0);
    
RAM_MEMORY : process (clk)
begin
if (rising_edge(clk)) then
 if (mem_enable = '1') then
  if (reset = '1') then operand_dst <= x"0000000000000000";
                        addr <= x"0";
                        datain <= x"0000000000000000";
  else
  
  case opc is
  
  when LDDW_OPC => operand_dst<= x"00000000" & immediate;
  
  when LDXW_OPC => operand_dst <= x"00000000" & ram_s(loc)(31 downto 0);
                   addr    <= src + offset;
                   
  when LDXH_OPC => operand_dst <= x"000000000000" & ram_s(loc)(15 downto 0);
                   addr <= src + offset;
                   loc <= conv_integer(addr);
                   
  when LDXB_OPC => operand_dst <= x"00000000000000" & ram_s(loc)(7 downto 0);
                   addr <= src + offset;
                   loc <= conv_integer(addr);
                   
  when LDXDW_OPC => operand_dst <= ram_s(loc);
                    addr <= src + offset;
                    loc <= conv_integer(addr);
                    
  when STW_OPC   => addr <= dst + offset;
                    if (we = '1') then
                    datain  <= x"00000000" & immediate;
                    end if;
                    
  when STH_OPC   => loc <= conv_integer(addr);
                    addr <= dst + offset;
                    if (we = '1') then
                    datain <= x"000000000000" & immediate(15 downto 0);
                    end if;
                    
  when STB_OPC   => addr <= dst + offset;
                    loc <= conv_integer(addr);
                    if (we = '1') then
                    datain <= x"00000000000000" & immediate(7 downto 0);
                    end if;
                    
  when STDW_OPC  => addr <= dst + offset;
                    loc <= conv_integer(addr);
                    if (we = '1') then
                    datain <= x"00000000" & immediate;
                    end if;
                    
  when STXW_OPC  => operand_dst <= ram_s(loc);
                    loc <= conv_integer(addr);
                    addr <= dst + offset;
                    if (we = '1') then
                    datain <= x"00000000" & operand_src;
                    end if;
                    
  when STXH_OPC  => operand_dst <= ram_s(loc);
                    loc <= conv_integer(addr);
                    addr <= dst + offset;
                    if (we = '1') then
                    datain <= x"000000000000" & operand_src(15 downto 0);
                    end if;
                    
  when STXB_OPC  => operand_dst <= ram_s(loc);
                    loc <= conv_integer(addr);
                    addr <= dst + offset; 
                    if (we = '1') then
                    datain <= x"00000000000000" & operand_src(7 downto 0);
                    end if;
                    
  when STXDW_OPC => operand_dst <= ram_s(loc);
                    loc <= conv_integer(addr);
                    addr <= dst + offset;
                    if (we = '1') then
                    datain <= operand_src;
                    end if;   
                    
  when others =>    operand_dst <= x"0000000000000000";
                    addr <= x"0";                      
                    datain <= x"0000000000000000";
  end case;
  end if;
 end if;
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
