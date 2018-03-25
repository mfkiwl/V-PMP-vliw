library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;

entity pc is

  generic (

            I_MEM_WIDTH : integer := 8

          );

  Port ( 

         clk        : in std_logic;
         inc        : in std_logic; -- '1' to increment program counter, from fetch stage
         rst        : in std_logic; -- '1' to reset program counter, from outside

         branch_exe     : in std_logic; -- '1' to load the branch address, from exe stage
         branch_add_exe   : in std_logic_vector(I_MEM_WIDTH-1 downto 0); -- branch address from control unit

         PC         : out std_logic_vector(I_MEM_WIDTH-1 downto 0) -- program counter out
       );

end pc;

architecture Behavioral of pc is

  signal pc_s : std_logic_vector(I_MEM_WIDTH-1 downto 0) := (others =>'1');

attribute mark_debug: string;
attribute keep:string;
attribute mark_debug of pc_s :signal is "TRUE";
attribute keep of pc_s :signal is "TRUE";


begin

 process (clk)
 begin
    if rising_edge (clk) then
        
    if (rst = '0') then
        
        if (inc = '1') then
            
            pc_s <= pc_s + 1;
            
        end if;
            
        if (branch_exe = '1') then
        
            pc_s <= branch_add_exe;
        
        end if;
    
    else
            
        pc_s <= (others => '1');
      
    end if;
    
    end if;  
    
 end process;
    
  PC <= pc_s;

end Behavioral;
