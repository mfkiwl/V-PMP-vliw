library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity PMP_data_RAM is
  
  Port ( 

         clk         : in std_logic;
         reset       : in std_logic;

         -- Read 
         read_add_0  : in std_logic_vector(7 downto 0);
         data_out_0  : out std_logic_vector(31 downto 0);
         read_add_1  : in std_logic_vector(7 downto 0);
         data_out_1  : out std_logic_vector(31 downto 0); 
         read_add_2  : in std_logic_vector(7 downto 0);
         data_out_2  : out std_logic_vector(31 downto 0);  
         read_add_3  : in std_logic_vector(7 downto 0);
         data_out_3  : out std_logic_vector(31 downto 0);  
         read_add_4  : in std_logic_vector(7 downto 0);
         data_out_4  : out std_logic_vector(31 downto 0);  
         read_add_5  : in std_logic_vector(7 downto 0);
         data_out_5  : out std_logic_vector(31 downto 0);  
         read_add_6  : in std_logic_vector(7 downto 0);
         data_out_6  : out std_logic_vector(31 downto 0);  
         read_add_7  : in std_logic_vector(7 downto 0);
         data_out_7  : out std_logic_vector(31 downto 0);
         
         read_add_dma : in std_logic_vector(4 downto 0); 
         data_out_dma : out std_logic_vector(255 downto 0); 

         --Write
         wrt_add_0   : in std_logic_vector(7 downto 0);
         wrt_en_0    : in std_logic;
         data_in_0   : in std_logic_vector(31 downto 0);  
         wrt_add_1   : in std_logic_vector(7 downto 0);
         wrt_en_1    : in std_logic;
         data_in_1   : in std_logic_vector(31 downto 0);
         wrt_add_2   : in std_logic_vector(7 downto 0);
         wrt_en_2    : in std_logic;
         data_in_2   : in std_logic_vector(31 downto 0);
         wrt_add_3   : in std_logic_vector(7 downto 0);
         wrt_en_3    : in std_logic;
         data_in_3   : in std_logic_vector(31 downto 0);
         wrt_add_4   : in std_logic_vector(7 downto 0);
         wrt_en_4    : in std_logic;
         data_in_4   : in std_logic_vector(31 downto 0);
         wrt_add_5   : in std_logic_vector(7 downto 0);
         wrt_en_5    : in std_logic;
         data_in_5   : in std_logic_vector(31 downto 0);
         wrt_add_6   : in std_logic_vector(7 downto 0);
         wrt_en_6    : in std_logic;
         data_in_6   : in std_logic_vector(31 downto 0);
         wrt_add_7   : in std_logic_vector(7 downto 0);
         wrt_en_7    : in std_logic;
         data_in_7   : in std_logic_vector(31 downto 0)

       );

end PMP_data_RAM;

architecture Behavioral of PMP_data_RAM is

  type RAM_type is array(0 to 31) of std_logic_vector(31 downto 0);
  
  impure function InitRamFromFile (RamFileName : in string) return RAM_type is
      FILE ramfile : text is in RamFileName;
      variable RamFileLine : line;
      variable ram : RAM_type;
          begin
              for i in RAM_type'range loop
                  readline(ramfile, RamFileLine);
                  hread(RamFileLine, ram(i));
              end loop;
      return ram;
  end function;

  signal data_RAM_0 : RAM_type:=InitRamFromFile("./data_ram_0.txt");                                                     
  signal data_RAM_1 : RAM_type:=InitRamFromFile("./data_ram_1.txt");                                                     
  signal data_RAM_2 : RAM_type:=InitRamFromFile("./data_ram_2.txt");                                                     
  signal data_RAM_3 : RAM_type:=InitRamFromFile("./data_ram_3.txt");                                                     
  signal data_RAM_4 : RAM_type:=InitRamFromFile("./data_ram_4.txt");                                                     
  signal data_RAM_5 : RAM_type:=InitRamFromFile("./data_ram_5.txt");                                                     
  signal data_RAM_6 : RAM_type:=InitRamFromFile("./data_ram_6.txt");                                                     
  signal data_RAM_7 : RAM_type:=InitRamFromFile("./data_ram_7.txt");                                                     

  signal error_s            : std_logic;

begin

    data_out_dma <= data_RAM_7(conv_integer(read_add_dma)) & data_RAM_6(conv_integer(read_add_dma)) & data_RAM_5(conv_integer(read_add_dma)) &
                        data_RAM_4(conv_integer(read_add_dma)) & data_RAM_3(conv_integer(read_add_dma)) & data_RAM_2(conv_integer(read_add_dma)) &
                        data_RAM_1(conv_integer(read_add_dma)) & data_RAM_0(conv_integer(read_add_dma));

  READ: process(read_add_0, read_add_1, read_add_2, read_add_3, read_add_4, read_add_5, read_add_6, read_add_7)
  begin

    --if rising_edge(clk) then

        case read_add_0(2 downto 0) is

          when "000" => data_out_0 <= data_RAM_0(conv_integer(read_add_0(7 downto 3)));
          when "001" => data_out_0 <= data_RAM_1(conv_integer(read_add_0(7 downto 3)));
          when "010" => data_out_0 <= data_RAM_2(conv_integer(read_add_0(7 downto 3)));
          when "011" => data_out_0 <= data_RAM_3(conv_integer(read_add_0(7 downto 3)));
          when "100" => data_out_0 <= data_RAM_4(conv_integer(read_add_0(7 downto 3)));
          when "101" => data_out_0 <= data_RAM_5(conv_integer(read_add_0(7 downto 3)));
          when "110" => data_out_0 <= data_RAM_6(conv_integer(read_add_0(7 downto 3)));
          when "111" => data_out_0 <= data_RAM_7(conv_integer(read_add_0(7 downto 3)));
          when others => data_out_0 <= (others => '0');

        end case;

        case read_add_1(2 downto 0) is

          when "000" => data_out_1 <= data_RAM_0(conv_integer(read_add_1(7 downto 3))); 
          when "001" => data_out_1 <= data_RAM_1(conv_integer(read_add_1(7 downto 3))); 
          when "010" => data_out_1 <= data_RAM_2(conv_integer(read_add_1(7 downto 3))); 
          when "011" => data_out_1 <= data_RAM_3(conv_integer(read_add_1(7 downto 3))); 
          when "100" => data_out_1 <= data_RAM_4(conv_integer(read_add_1(7 downto 3))); 
          when "101" => data_out_1 <= data_RAM_5(conv_integer(read_add_1(7 downto 3))); 
          when "110" => data_out_1 <= data_RAM_6(conv_integer(read_add_1(7 downto 3))); 
          when "111" => data_out_1 <= data_RAM_7(conv_integer(read_add_1(7 downto 3))); 
          when others => data_out_1 <= (others => '0');

        end case;

        case read_add_2(2 downto 0) is

          when "000" => data_out_2 <= data_RAM_0(conv_integer(read_add_2(7 downto 3))); 
          when "001" => data_out_2 <= data_RAM_1(conv_integer(read_add_2(7 downto 3))); 
          when "010" => data_out_2 <= data_RAM_2(conv_integer(read_add_2(7 downto 3))); 
          when "011" => data_out_2 <= data_RAM_3(conv_integer(read_add_2(7 downto 3))); 
          when "100" => data_out_2 <= data_RAM_4(conv_integer(read_add_2(7 downto 3))); 
          when "101" => data_out_2 <= data_RAM_5(conv_integer(read_add_2(7 downto 3))); 
          when "110" => data_out_2 <= data_RAM_6(conv_integer(read_add_2(7 downto 3))); 
          when "111" => data_out_2 <= data_RAM_7(conv_integer(read_add_2(7 downto 3))); 
          when others => data_out_2 <= (others => '0');

        end case;

        case read_add_3(2 downto 0) is

          when "000" => data_out_3 <= data_RAM_0(conv_integer(read_add_3(7 downto 3))); 
          when "001" => data_out_3 <= data_RAM_1(conv_integer(read_add_3(7 downto 3))); 
          when "010" => data_out_3 <= data_RAM_2(conv_integer(read_add_3(7 downto 3))); 
          when "011" => data_out_3 <= data_RAM_3(conv_integer(read_add_3(7 downto 3))); 
          when "100" => data_out_3 <= data_RAM_4(conv_integer(read_add_3(7 downto 3))); 
          when "101" => data_out_3 <= data_RAM_5(conv_integer(read_add_3(7 downto 3))); 
          when "110" => data_out_3 <= data_RAM_6(conv_integer(read_add_3(7 downto 3))); 
          when "111" => data_out_3 <= data_RAM_7(conv_integer(read_add_3(7 downto 3))); 
          when others => data_out_3 <= (others => '0');

        end case;

        case read_add_4(2 downto 0) is

          when "000" => data_out_4 <= data_RAM_0(conv_integer(read_add_4(7 downto 3))); 
          when "001" => data_out_4 <= data_RAM_1(conv_integer(read_add_4(7 downto 3))); 
          when "010" => data_out_4 <= data_RAM_2(conv_integer(read_add_4(7 downto 3))); 
          when "011" => data_out_4 <= data_RAM_3(conv_integer(read_add_4(7 downto 3))); 
          when "100" => data_out_4 <= data_RAM_4(conv_integer(read_add_4(7 downto 3))); 
          when "101" => data_out_4 <= data_RAM_5(conv_integer(read_add_4(7 downto 3))); 
          when "110" => data_out_4 <= data_RAM_6(conv_integer(read_add_4(7 downto 3))); 
          when "111" => data_out_4 <= data_RAM_7(conv_integer(read_add_4(7 downto 3))); 
          when others => data_out_4 <= (others => '0');

        end case;

        case read_add_5(2 downto 0) is

          when "000" => data_out_5 <= data_RAM_0(conv_integer(read_add_5(7 downto 3))); 
          when "001" => data_out_5 <= data_RAM_1(conv_integer(read_add_5(7 downto 3))); 
          when "010" => data_out_5 <= data_RAM_2(conv_integer(read_add_5(7 downto 3))); 
          when "011" => data_out_5 <= data_RAM_3(conv_integer(read_add_5(7 downto 3))); 
          when "100" => data_out_5 <= data_RAM_4(conv_integer(read_add_5(7 downto 3))); 
          when "101" => data_out_5 <= data_RAM_5(conv_integer(read_add_5(7 downto 3))); 
          when "110" => data_out_5 <= data_RAM_6(conv_integer(read_add_5(7 downto 3))); 
          when "111" => data_out_5 <= data_RAM_7(conv_integer(read_add_5(7 downto 3))); 
          when others => data_out_5 <= (others => '0');

        end case;

        case read_add_6(2 downto 0) is

          when "000" => data_out_6 <= data_RAM_0(conv_integer(read_add_6(7 downto 3))); 
          when "001" => data_out_6 <= data_RAM_1(conv_integer(read_add_6(7 downto 3))); 
          when "010" => data_out_6 <= data_RAM_2(conv_integer(read_add_6(7 downto 3))); 
          when "011" => data_out_6 <= data_RAM_3(conv_integer(read_add_6(7 downto 3))); 
          when "100" => data_out_6 <= data_RAM_4(conv_integer(read_add_6(7 downto 3))); 
          when "101" => data_out_6 <= data_RAM_5(conv_integer(read_add_6(7 downto 3))); 
          when "110" => data_out_6 <= data_RAM_6(conv_integer(read_add_6(7 downto 3))); 
          when "111" => data_out_6 <= data_RAM_7(conv_integer(read_add_6(7 downto 3))); 
          when others => data_out_6 <= (others => '0');

        end case;

        case read_add_7(2 downto 0) is

          when "000" => data_out_7 <= data_RAM_0(conv_integer(read_add_7(7 downto 3))); 
          when "001" => data_out_7 <= data_RAM_1(conv_integer(read_add_7(7 downto 3))); 
          when "010" => data_out_7 <= data_RAM_2(conv_integer(read_add_7(7 downto 3))); 
          when "011" => data_out_7 <= data_RAM_3(conv_integer(read_add_7(7 downto 3))); 
          when "100" => data_out_7 <= data_RAM_4(conv_integer(read_add_7(7 downto 3))); 
          when "101" => data_out_7 <= data_RAM_5(conv_integer(read_add_7(7 downto 3))); 
          when "110" => data_out_7 <= data_RAM_6(conv_integer(read_add_7(7 downto 3))); 
          when "111" => data_out_7 <= data_RAM_7(conv_integer(read_add_7(7 downto 3))); 
          when others => data_out_7 <= (others => '0');

        end case;
 
       -- end if;
      

      end process;

      WRITE: process(clk)
      begin

        if rising_edge(clk) then

          error_s <= '0';

          if (wrt_en_0 = '1') then

            case wrt_add_0(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "001" => data_RAM_1(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "010" => data_RAM_2(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "011" => data_RAM_3(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "100" => data_RAM_4(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "101" => data_RAM_5(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "110" => data_RAM_6(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0;
              when "111" => data_RAM_7(conv_integer(wrt_add_0(7 downto 3))) <= data_in_0; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_1 = '1') then

            case wrt_add_1(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "001" => data_RAM_1(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "010" => data_RAM_2(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "011" => data_RAM_3(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "100" => data_RAM_4(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "101" => data_RAM_5(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "110" => data_RAM_6(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1;
              when "111" => data_RAM_7(conv_integer(wrt_add_1(7 downto 3))) <= data_in_1; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_2 = '1') then

            case wrt_add_2(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "001" => data_RAM_1(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "010" => data_RAM_2(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "011" => data_RAM_3(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "100" => data_RAM_4(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "101" => data_RAM_5(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "110" => data_RAM_6(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2;
              when "111" => data_RAM_7(conv_integer(wrt_add_2(7 downto 3))) <= data_in_2; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_3 = '1') then

            case wrt_add_3(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "001" => data_RAM_1(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "010" => data_RAM_2(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "011" => data_RAM_3(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "100" => data_RAM_4(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "101" => data_RAM_5(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "110" => data_RAM_6(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3;
              when "111" => data_RAM_7(conv_integer(wrt_add_3(7 downto 3))) <= data_in_3; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_4 = '1') then

            case wrt_add_4(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "001" => data_RAM_1(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "010" => data_RAM_2(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "011" => data_RAM_3(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "100" => data_RAM_4(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "101" => data_RAM_5(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "110" => data_RAM_6(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4;
              when "111" => data_RAM_7(conv_integer(wrt_add_4(7 downto 3))) <= data_in_4; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_5 = '1') then

            case wrt_add_5(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "001" => data_RAM_1(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "010" => data_RAM_2(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "011" => data_RAM_3(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "100" => data_RAM_4(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "101" => data_RAM_5(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "110" => data_RAM_6(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5;
              when "111" => data_RAM_7(conv_integer(wrt_add_5(7 downto 3))) <= data_in_5; 
              when others => error_s <= '1';                                                      

            end case;
          end if;

          if (wrt_en_6 = '1') then

            case wrt_add_6(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "001" => data_RAM_1(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "010" => data_RAM_2(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "011" => data_RAM_3(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "100" => data_RAM_4(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "101" => data_RAM_5(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "110" => data_RAM_6(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6;
              when "111" => data_RAM_7(conv_integer(wrt_add_6(7 downto 3))) <= data_in_6; 
              when others => error_s <= '1';                                                      

            end case;
          end if;


          if (wrt_en_7 = '1') then

            case wrt_add_7(2 downto 0) is

              when "000" => data_RAM_0(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "001" => data_RAM_1(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "010" => data_RAM_2(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "011" => data_RAM_3(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "100" => data_RAM_4(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "101" => data_RAM_5(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "110" => data_RAM_6(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7;
              when "111" => data_RAM_7(conv_integer(wrt_add_7(7 downto 3))) <= data_in_7; 
              when others => error_s <= '1';                                                      

            end case;
          end if;
        end if;
      end process;

    end Behavioral;
