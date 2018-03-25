library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI_DATA_RAM_tb is
  Port ( 
  
         data_out        : out std_logic_vector(31 downto 0); -- data to PMP 
         write_add       : out std_logic_vector(5 downto 0);
         start           : out std_logic -- start signal to PMP              

  );

end AXI_DATA_RAM_tb;

architecture Behavioral of AXI_DATA_RAM_tb is

signal clk           : std_logic := '0';
signal S0_AXIS_TDATA  : std_logic_vector(255 downto 0) := x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
signal S0_AXIS_TVALID : std_logic;
signal read_add      : std_logic_vector(31 downto 0);

begin

AXIS_DATA_RAM_i : entity work.AXI_DATA_RAM port map (
                                                     clk,
                                                     S0_AXIS_TDATA,
                                                     S0_AXIS_TVALID,
                                                     read_add,
                                                     write_add,
                                                     data_out,
                                                     start
                                                     );
                                                     
clk <= not(clk) after 10ns;
S0_AXIS_TVALID <= '1' after 60ns;
read_add <= x"0000000a";


end Behavioral;
