library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;


entity AXI_TUSER_RAM is
  Port (
        clk : in std_logic;
        
        S0_AXIS_TUSER    : in std_logic_vector(127 downto 0);
        S0_AXIS_TVALID   : in std_logic;
        
        read_add_0       : in std_logic_vector(31 downto 0);
        read_add_1       : in std_logic_vector(31 downto 0);
        read_add_2       : in std_logic_vector(31 downto 0);
        read_add_3       : in std_logic_vector(31 downto 0);
        read_add_4       : in std_logic_vector(31 downto 0);
        read_add_5       : in std_logic_vector(31 downto 0);
        read_add_6       : in std_logic_vector(31 downto 0);
        read_add_7       : in std_logic_vector(31 downto 0);
        
        write_add        : in std_logic_vector(5 downto 0);
  
        data_out_0       : out std_logic_vector(31 downto 0);
        data_out_1       : out std_logic_vector(31 downto 0);
        data_out_2       : out std_logic_vector(31 downto 0);
        data_out_3       : out std_logic_vector(31 downto 0);
        data_out_4       : out std_logic_vector(31 downto 0);
        data_out_5       : out std_logic_vector(31 downto 0);
        data_out_6       : out std_logic_vector(31 downto 0);
        data_out_7       : out std_logic_vector(31 downto 0) 
  
   );
   
   
end AXI_TUSER_RAM;

architecture Behavioral of AXI_TUSER_RAM is

type RAM_type is array(0 to 63) of std_logic_vector(127 downto 0);

signal TUSER_RAM_s : RAM_type;

signal temp_0 : std_logic_vector(127 downto 0);
signal temp_1 : std_logic_vector(127 downto 0);
signal temp_2 : std_logic_vector(127 downto 0);
signal temp_3 : std_logic_vector(127 downto 0);
signal temp_4 : std_logic_vector(127 downto 0);
signal temp_5 : std_logic_vector(127 downto 0);
signal temp_6 : std_logic_vector(127 downto 0);
signal temp_7 : std_logic_vector(127 downto 0);

begin

-- read process
    process(clk)
    begin
        
        if rising_edge(clk) then
        
            temp_0 <= TUSER_RAM_s(conv_integer("00" & read_add_0(5 downto 2)));
            temp_1 <= TUSER_RAM_s(conv_integer("00" & read_add_1(5 downto 2)));
            temp_2 <= TUSER_RAM_s(conv_integer("00" & read_add_2(5 downto 2)));
            temp_3 <= TUSER_RAM_s(conv_integer("00" & read_add_3(5 downto 2)));
            temp_4 <= TUSER_RAM_s(conv_integer("00" & read_add_4(5 downto 2)));
            temp_5 <= TUSER_RAM_s(conv_integer("00" & read_add_5(5 downto 2)));
            temp_6 <= TUSER_RAM_s(conv_integer("00" & read_add_6(5 downto 2)));
            temp_7 <= TUSER_RAM_s(conv_integer("00" & read_add_7(5 downto 2)));
            
        end if;
    end process;
 

data_out_0 <= temp_0(127 downto 96)   when read_add_0(1 downto 0)="11" else 
              temp_0(95 downto 64)   when read_add_0(1 downto 0)="10" else 
              temp_0(63 downto 32)   when read_add_0(1 downto 0)="01" else 
              temp_0(31 downto 0); 

data_out_1 <= temp_1(127 downto 96)   when read_add_1(1 downto 0)="11" else 
              temp_1(95 downto 64)   when read_add_1(1 downto 0)="10" else 
              temp_1(63 downto 32)   when read_add_1(1 downto 0)="01" else 
              temp_1(31 downto 0);               

data_out_2 <= temp_2(127 downto 96)   when read_add_2(1 downto 0)="11" else 
              temp_2(95 downto 64)   when read_add_2(1 downto 0)="10" else 
              temp_2(63 downto 32)   when read_add_2(1 downto 0)="01" else 
              temp_2(31 downto 0); 

data_out_3 <= temp_3(127 downto 96)   when read_add_3(1 downto 0)="11" else 
              temp_3(95 downto 64)   when read_add_3(1 downto 0)="10" else 
              temp_3(63 downto 32)   when read_add_3(1 downto 0)="01" else 
              temp_3(31 downto 0);               
              
data_out_4 <= temp_4(127 downto 96)   when read_add_4(1 downto 0)="11" else 
              temp_4(95 downto 64)   when read_add_4(1 downto 0)="10" else 
              temp_4(63 downto 32)   when read_add_4(1 downto 0)="01" else 
              temp_4(31 downto 0); 

data_out_5 <= temp_5(127 downto 96)   when read_add_5(1 downto 0)="11" else 
              temp_5(95 downto 64)   when read_add_5(1 downto 0)="10" else 
              temp_5(63 downto 32)   when read_add_5(1 downto 0)="01" else 
              temp_5(31 downto 0); 
              
data_out_6 <= temp_6(127 downto 96)   when read_add_6(1 downto 0)="11" else 
              temp_6(95 downto 64)   when read_add_6(1 downto 0)="10" else 
              temp_6(63 downto 32)   when read_add_6(1 downto 0)="01" else 
              temp_6(31 downto 0); 
                            
data_out_7 <= temp_7(127 downto 96)   when read_add_7(1 downto 0)="11" else 
              temp_7(95 downto 64)   when read_add_7(1 downto 0)="10" else 
              temp_7(63 downto 32)   when read_add_7(1 downto 0)="01" else 
              temp_7(31 downto 0);     
                                                     
 -- write process
 
     process(clk)
     begin
     
         if rising_edge(clk) then 
         
             if (S0_AXIS_TVALID = '1') then
             
                 TUSER_RAM_s(conv_integer(write_add)) <= S0_AXIS_TUSER;
                 
             end if;
         end if;
         
     end process;                                        


end Behavioral;
