library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;


entity memory is
    Port (
          clk              : in std_logic;
          reset            : in std_logic;
          syllable         : in std_logic_vector(63 downto 0);
          src              : in std_logic_vector(63 downto 0);
          dst              : out std_logic_vector(63 downto 0);
          immediate        : in std_logic_vector(31 downto 0);
          offset           : in std_logic_vector(15 downto 0);
          we               : in std_logic
         );
end memory;

architecture Behavioral of memory is

type ram_type is array (0 to 7) of std_logic_vector (63 downto 0);
signal ram_s : ram_type;
signal loc : integer;
signal dataout : std_logic_vector (63 downto 0);
signal datain : std_logic_vector (63 downto 0);

signal opc : std_logic_vector(7 downto 0);
signal opc_string : string(1 to 6);
signal addr : std_logic_vector(2 downto 0);

begin

RAM_MEMORY : process (clk)
begin
if (rising_edge(clk)) then
  if (we = '1') then
  dataout <= ram_s(loc);
  ram_s(loc) <= datain;
  loc <= conv_integer(addr);
  end if;
end if;
end process;
    
    opc <= syllable(7 downto 0);

    process(clk)

    begin
    
    if (rising_edge(clk)) then
                                                  
        case opc is                                                                    
                                                                                       
            when LDDW_OPC => operand_dst(31 downto 0) <= immediate;                                                                                                             
                                                                                       
--            when LDABSW_OPC =>      SEE KERNEL DOCUMENTATION                                                     
                                                                                       
--            when LDABSH_OPC =>                                                            
                                                                                                                                                                              
--            when LDABSB_OPC =>                                                           
                                                                                                                                                                              
--            when LDABSDW_OPC =>                                                            
                                                                                       
--            when LDINDW_OPC =>                                                           
                                                                                                                                          
--            when LDINDH_OPC =>                                                            
                                                                                                                                                                                                                                  
--            when LDINDB_OPC =>                                                           
                                                                                       
--            when LDINDDW_OPC =>                                                            
                                                                                                                                                                                                                                            
            when LDXW_OPC =>  operand_dst <= ram_s(loc)(31 downto 0);
                              loc <= conv_integer(operand_src + offset);                                                         
                                                                                       
            when LDXH_OPC =>  operand_dst <= ram_s(loc)(15 downto 0);                                                        
                              loc <= conv_integer(operand_src + offset);                                              
                                                                            
            when LDXB_OPC =>  operand_dst <= ram_s(loc)(7 downto 0);                                                                 
                              loc <= conv_integer(operand_src + offset);

            when LDXDW_OPC => operand_dst <= ram_s(loc); -- 64 bit                                                                  
                              loc <= conv_integer(operand_src + offset);                           
                                                                            
            when STW_OPC =>   if (we = '1') then
                              ram_s(loc)(31 downto 0) <= immediate;
                              loc <= conv_integer(operand_dst + offset);
                              end if;                                                          
                                                                                   
            when STH_OPC =>                                                            
                                                                                 
            when STB_OPC =>                                                         
                                                                                 
            when STDW_OPC =>                                                          
                                                                                 
            when STXW_OPC =>                                                         
                                                                                       
            when STXH_OPC =>                                                          
                                                                                       
            when STXB_OPC =>                                                         
                                                                                       
            when JSLTS_OPC =>                                                          
                                                                                                                                                                              
            when STXDW_OPC =>                                                                                                                 
                                                                                       
            when others =>                                                             
                                                     
        end case;                                                                      
                                                                                       
    end if;                                                                           

    end process;
   
end Behavioral;
