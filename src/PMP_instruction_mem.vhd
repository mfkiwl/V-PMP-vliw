library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.salutil.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity i_mem is

  generic (init_file: string:="./i_mem.bin");

  port ( 
       --AXI/mem interface
         axi_clock : in std_logic;
         we: in std_logic;
         axi_addr : in std_logic_vector(10 downto 0); 
         axi_data_in : in std_logic_vector(31 downto 0);
         axi_data_out : out std_logic_vector(31 downto 0);

             -- AXIS interface
         clock : in std_logic;
         reset : in std_logic;
         addr  : in std_logic_vector(7 downto 0);
         data_out : out std_logic_vector(511 downto 0)
       );

end i_mem;

architecture behavioral of i_mem is

  type mem_type is array (0 to 255) of std_logic_vector(511 downto 0) ;

  impure function InitRamFromFile (RamFileName : in string) return mem_type is
    FILE ramfile : text is in RamFileName;
    variable RamFileLine : line;
    variable ram : mem_type;
  begin
    for i in mem_type'range loop
      readline(ramfile, RamFileLine);
      hread(RamFileLine, ram(i));
    end loop;
    return ram;
  end function;

  signal mem1: mem_type:=InitRamFromFile(init_file);
  signal word_data_out: std_logic_vector(511 downto 0);

begin


--dual port ram

--process(axi_clock)
--    begin
--	if axi_clock'event and axi_clock = '1' then
--			if (we = '1') then
--			    case axi_addr(2 downto 0) is
--				when "000" => mem1(conv_integer(axi_addr(10 downto 3)))(31  downto   0) <= axi_data_in;
--				when "001" => mem1(conv_integer(axi_addr(10 downto 3)))(63  downto  32) <= axi_data_in;
--				when "010" => mem1(conv_integer(axi_addr(10 downto 3)))(95  downto  64) <= axi_data_in;
--				when "011" => mem1(conv_integer(axi_addr(10 downto 3)))(127 downto  96) <= axi_data_in;
--				when "100" => mem1(conv_integer(axi_addr(10 downto 3)))(159 downto 128) <= axi_data_in;
--				when "101" => mem1(conv_integer(axi_addr(10 downto 3)))(191 downto 160) <= axi_data_in;
--				when "110" => mem1(conv_integer(axi_addr(10 downto 3)))(223 downto 192) <= axi_data_in;
--				when "111" => mem1(conv_integer(axi_addr(10 downto 3)))(255 downto 224) <= axi_data_in;
--				when others => null;
--			    end case; 
--			else
--			    word_data_out <= mem1(conv_integer(axi_addr(9 downto 3)));
--            end if;
--	end if;			
--end process;


  --axi_data_out<= word_data_out(31  downto   0) when axi_addr(2 downto 0)="000" else
  --               word_data_out(63  downto  32) when axi_addr(2 downto 0)="001" else
  --              word_data_out(95  downto  64) when axi_addr(2 downto 0)="010" else
  --               word_data_out(127 downto  96) when axi_addr(2 downto 0)="011" else
  --               word_data_out(159 downto 128) when axi_addr(2 downto 0)="100" else
  --               word_data_out(191 downto 160) when axi_addr(2 downto 0)="101" else
  --               word_data_out(223 downto 192) when axi_addr(2 downto 0)="110" else
  --               word_data_out(255 downto 224);


  process(clock)
  
  begin
  
    if rising_edge(clock) then
  
      if (reset = '1') then
  
        data_out <= (others => '0');
  
      else
  
        data_out <= mem1(conv_integer(addr(7 downto 0)));
  
      end if;
  
    end if;			
  
  end process;


end behavioral;

