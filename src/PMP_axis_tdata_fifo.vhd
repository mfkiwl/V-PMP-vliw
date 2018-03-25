library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

-- Input AXI-S data RAM
entity AXI_DATA_RAM is

  port(
    
        clk             : in std_logic;
    
        S0_AXIS_TDATA   : in std_logic_vector(255 downto 0);
        S0_AXIS_TVALID  : in std_logic;
        
        read_add_0      : in std_logic_vector(31 downto 0);
        read_add_1      : in std_logic_vector(31 downto 0);
        read_add_2      : in std_logic_vector(31 downto 0);
        read_add_3      : in std_logic_vector(31 downto 0);
        read_add_4      : in std_logic_vector(31 downto 0);
        read_add_5      : in std_logic_vector(31 downto 0); 
        read_add_6      : in std_logic_vector(31 downto 0); 
        read_add_7      : in std_logic_vector(31 downto 0); 
        
        write_add       : out std_logic_vector(5 downto 0); -- to TUSER ram
        
        data_out_0      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_1      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_2      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_3      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_4      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_5      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_6      : out std_logic_vector(31 downto 0); -- data to PMP
        data_out_7      : out std_logic_vector(31 downto 0); -- data to PMP

        -- DMA port
        
        read_add_dma    : in std_logic_vector(8 downto 0);
        data_out_dma    : out std_logic_vector(255 downto 0);
        
        start           : out std_logic -- start signal to PMP
   
    );

end AXI_DATA_RAM;


architecture behavioral of AXI_DATA_RAM is

type RAM_type is array(0 to 63) of std_logic_vector(255 downto 0);

signal AXI_DATA_RAM_s : RAM_type := (others => (others => '0'));                                                     

signal temp_0        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_1        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_2        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_3        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_4        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_5        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_6        : std_logic_vector(255 downto 0) := (others => '0');
signal temp_7        : std_logic_vector(255 downto 0) := (others => '0');

signal write_add_s : std_logic_vector(5 downto 0) := (others => '0');


begin

--read process
--process(clk)

--begin
--    if(rising_edge(clk)) then
            temp_0 <= AXI_DATA_RAM_s(conv_integer(read_add_0(5 downto 3)));
            temp_1 <= AXI_DATA_RAM_s(conv_integer(read_add_1(5 downto 3)));
            temp_2 <= AXI_DATA_RAM_s(conv_integer(read_add_2(5 downto 3)));
            temp_3 <= AXI_DATA_RAM_s(conv_integer(read_add_3(5 downto 3)));
            temp_4 <= AXI_DATA_RAM_s(conv_integer(read_add_4(5 downto 3)));
            temp_5 <= AXI_DATA_RAM_s(conv_integer(read_add_5(5 downto 3)));
            temp_6 <= AXI_DATA_RAM_s(conv_integer(read_add_6(5 downto 3)));
            temp_7 <= AXI_DATA_RAM_s(conv_integer(read_add_7(5 downto 3)));
            
            data_out_dma <= AXI_DATA_RAM_s(conv_integer(read_add_dma(5 downto 0)));

  --  end if;


data_out_0 <= temp_0(255 downto 224) when read_add_0(2 downto 0)="111" else
              temp_0(223 downto 192) when read_add_0(2 downto 0)="110" else
              temp_0(191 downto 160) when read_add_0(2 downto 0)="101" else
              temp_0(159 downto 128) when read_add_0(2 downto 0)="100" else
              temp_0(127 downto 96)  when read_add_0(2 downto 0)="011" else
              temp_0(95 downto 64)   when read_add_0(2 downto 0)="010" else
              temp_0(63 downto 32)   when read_add_0(2 downto 0)="001" else
              temp_0(31 downto 0);
 
 data_out_1 <= temp_1(255 downto 224) when read_add_1(2 downto 0)="111" else 
               temp_1(223 downto 192) when read_add_1(2 downto 0)="110" else    
               temp_1(191 downto 160) when read_add_1(2 downto 0)="101" else    
               temp_1(159 downto 128) when read_add_1(2 downto 0)="100" else    
               temp_1(127 downto 96)  when read_add_1(2 downto 0)="011" else    
               temp_1(95 downto 64)   when read_add_1(2 downto 0)="010" else    
               temp_1(63 downto 32)   when read_add_1(2 downto 0)="001" else    
               temp_1(31 downto 0);                                             
                      
data_out_2 <= temp_2(255 downto 224) when read_add_2(2 downto 0)="111" else 
              temp_2(223 downto 192) when read_add_2(2 downto 0)="110" else    
              temp_2(191 downto 160) when read_add_2(2 downto 0)="101" else    
              temp_2(159 downto 128) when read_add_2(2 downto 0)="100" else    
              temp_2(127 downto 96)  when read_add_2(2 downto 0)="011" else    
              temp_2(95 downto 64)   when read_add_2(2 downto 0)="010" else    
              temp_2(63 downto 32)   when read_add_2(2 downto 0)="001" else    
              temp_2(31 downto 0);                                             
 
 data_out_3 <= temp_3(255 downto 224) when read_add_3(2 downto 0)="111" else 
               temp_3(223 downto 192) when read_add_3(2 downto 0)="110" else    
               temp_3(191 downto 160) when read_add_3(2 downto 0)="101" else    
               temp_3(159 downto 128) when read_add_3(2 downto 0)="100" else    
               temp_3(127 downto 96)  when read_add_3(2 downto 0)="011" else    
               temp_3(95 downto 64)   when read_add_3(2 downto 0)="010" else    
               temp_3(63 downto 32)   when read_add_3(2 downto 0)="001" else    
               temp_3(31 downto 0);                                             

data_out_4 <= temp_4(255 downto 224) when read_add_4(2 downto 0)="111" else
              temp_4(223 downto 192) when read_add_4(2 downto 0)="110" else
              temp_4(191 downto 160) when read_add_4(2 downto 0)="101" else
              temp_4(159 downto 128) when read_add_4(2 downto 0)="100" else
              temp_4(127 downto 96)  when read_add_4(2 downto 0)="011" else
              temp_4(95 downto 64)   when read_add_4(2 downto 0)="010" else
              temp_4(63 downto 32)   when read_add_4(2 downto 0)="001" else
              temp_4(31 downto 0);
 
 data_out_5 <= temp_5(255 downto 224) when read_add_5(2 downto 0)="111" else 
               temp_5(223 downto 192) when read_add_5(2 downto 0)="110" else    
               temp_5(191 downto 160) when read_add_5(2 downto 0)="101" else    
               temp_5(159 downto 128) when read_add_5(2 downto 0)="100" else    
               temp_5(127 downto 96)  when read_add_5(2 downto 0)="011" else    
               temp_5(95 downto 64)   when read_add_5(2 downto 0)="010" else    
               temp_5(63 downto 32)   when read_add_5(2 downto 0)="001" else    
               temp_5(31 downto 0);                                             
                      
data_out_6 <= temp_6(255 downto 224) when read_add_6(2 downto 0)="111" else 
              temp_6(223 downto 192) when read_add_6(2 downto 0)="110" else    
              temp_6(191 downto 160) when read_add_6(2 downto 0)="101" else    
              temp_6(159 downto 128) when read_add_6(2 downto 0)="100" else    
              temp_6(127 downto 96)  when read_add_6(2 downto 0)="011" else    
              temp_6(95 downto 64)   when read_add_6(2 downto 0)="010" else    
              temp_6(63 downto 32)   when read_add_6(2 downto 0)="001" else    
              temp_6(31 downto 0);                                             
 
 data_out_7 <= temp_7(255 downto 224) when read_add_7(2 downto 0)="111" else 
               temp_7(223 downto 192) when read_add_7(2 downto 0)="110" else    
               temp_7(191 downto 160) when read_add_7(2 downto 0)="101" else    
               temp_7(159 downto 128) when read_add_7(2 downto 0)="100" else    
               temp_7(127 downto 96)  when read_add_7(2 downto 0)="011" else    
               temp_7(95 downto 64)   when read_add_7(2 downto 0)="010" else    
               temp_7(63 downto 32)   when read_add_7(2 downto 0)="001" else    
               temp_7(31 downto 0);                                           
 
 -- write process          
process(clk)
begin
        
        if rising_edge(clk) then
           
            if(S0_AXIS_TVALID = '1') then
           
                AXI_DATA_RAM_s(conv_integer(write_add_s)) <= S0_AXIS_TDATA;
           
            end if;
            
    end if;
    
end process;

-- write address generation process
process(clk)
begin

    if rising_edge(clk) then 
    
        if (S0_AXIS_TVALID = '1') then 
        
            write_add_s <= write_add_s + 1;
            
        end if;
    
    end if;
 end process;
 
 start <= '1' when S0_AXIS_TVALID = '1' else
          '0';
          
          
 write_add <= write_add_s;
    
end behavioral;
