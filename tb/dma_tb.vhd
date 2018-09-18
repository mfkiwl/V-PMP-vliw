library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dma_tb is
  Port ( 
       
        out_addr_axis      : out std_logic_vector(8 downto 0);
        tkeep         : out std_logic_vector(31 downto 0);
        tvalid        : out std_logic;
        done_transfer : out std_logic;
        w_e           : out std_logic;
        data_out      : out std_logic_vector(255 downto 0)
       
       );
end dma_tb;

architecture Behavioral of dma_tb is

  signal clk : std_logic := '0';
  signal reset : std_logic := '1';

  signal bytes_amount : std_logic_vector(15 downto 0) := (others => '0');
  signal start_addr : std_logic_vector(8 downto 0) := (others => '0');
  signal start : std_logic := '0';

  signal data_in_axis : std_logic_vector(255 downto 0) := (others => '0');
  
  signal out_addr_data_ram   :  std_logic_vector(4 downto 0); 
  signal data_in_data_ram    :  std_logic_vector(255 downto 0);


begin

  DMA: entity work.PMP_dma port map

  (

  clk => clk,
  reset => reset,

  bytes_amount => bytes_amount,
  start_addr => start_addr,
  start => start,
  
  out_addr_data_ram => out_addr_data_ram,
  data_in_data_ram => data_in_data_ram,

  out_addr_axis => out_addr_axis,
  data_in_axis => data_in_axis,

  tkeep => tkeep,
  tvalid => tvalid,
  done_transfer => done_transfer,
  w_e => w_e,
  data_out => data_out

);

clk <= not(clk) after 10ns;
reset <= '0' after 40ns;
bytes_amount <= x"0030" after 20ns;
start_addr <= "100000001";
start <= '1' after 70ns, '0' after 90ns;
data_in_axis <= (others => '1');
data_in_data_ram <= x"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"; 


end Behavioral;
