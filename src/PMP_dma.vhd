library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity PMP_dma is
  Port ( 
         clk            : in std_logic;
         reset          : in std_logic;

         bytes_amount   : in std_logic_vector(15 downto 0); -- amount of bytes to transfer
         start_addr     : in std_logic_vector(8 downto 0);  -- start address for transferring
         tlast_end      : in std_logic;
         start          : in std_logic;

         out_addr_axis       : out std_logic_vector(8 downto 0); -- addr to TDATA FIFO
         data_in_axis        : in std_logic_vector(255 downto 0); -- data from TDATA FIFO
         
         out_addr_data_ram   : out std_logic_vector(4 downto 0);
         data_in_data_ram    : in std_logic_vector(255 downto 0);

         tkeep          : out std_logic_vector(31 downto 0);
         tvalid         : out std_logic;
         tlast          : out std_logic;

         done_transfer  : out std_logic;  -- done transferring
         w_e            : out std_logic;
         data_out       : out std_logic_vector(255 downto 0) -- data to output interface


       );

end PMP_dma;

architecture Behavioral of PMP_dma is

  type state_type is (reset_state, waiting, transferring);

  signal state : state_type;
  signal bytes_to_wrt   : std_logic_vector(15 downto 0) := (others => '0');
  signal tdata_addr     : std_logic_vector(8 downto 0) := (others => '0');
  signal start_addr_s   : std_logic_vector(8 downto 0) := (others => '0');
  signal done_s         : std_logic := '0';
  signal tlast_end_s    : std_logic := '0';

begin

  -- FSM Transitions

  process(clk)
  begin
    if rising_edge(clk) then

      if (reset = '1') then

        state <= reset_state;

      end if;

      case state is 

        when reset_state =>     

          bytes_to_wrt <= (others => '0');
          tdata_addr <= (others => '0');
          done_s <= '0';
          out_addr_axis <= (others => '0');
          out_addr_data_ram <= (others => '0');
          tkeep <= ( others => '0');
          tvalid <= '0';
          done_transfer <= '0';
          data_out <= (others => '0');
          start_addr_s <= (others => '0');
          state <= waiting;
          tlast <= '0';
          w_e <= '0';

        when waiting =>         

          bytes_to_wrt <= (others => '0');
          tdata_addr <= (others => '0');
          done_s <= '0';
          out_addr_axis <= (others => '0');
          out_addr_data_ram <= (others => '0');
          tkeep <= ( others => '0');
          tvalid <= '0';
          done_transfer <= '0';
          data_out <= (others => '0');
          start_addr_s <= (others => '0');
          tlast <= '0';
          w_e <= '0';

          if (start = '1') then

            bytes_to_wrt <= bytes_amount;
            tdata_addr <= start_addr + 1;
            start_addr_s <= start_addr;
            bytes_to_wrt <= bytes_amount;
            state <= transferring; 
            tlast_end_s <= tlast_end;
            
            
            if (start_addr_s(8) = '0') then
            
                out_addr_axis <= start_addr;
                out_addr_data_ram <= (others => '0');
            
            else
            
                out_addr_axis <= (others => '0');
                out_addr_data_ram <= start_addr(4 downto 0);
                
            end if;

          end if;

        when transferring =>    

          data_out <= (others => '0');
          tkeep <= (others => '0');
          
          
          
          if (bytes_to_wrt = x"0000") then
          
            bytes_to_wrt <= (others => '0');
            tvalid <= '0';
            w_e <= '0';
            tdata_addr <= (others => '0');  
            done_transfer <= '1';
            tlast <= tlast_end_s;
            state <= waiting;
            
          elsif(bytes_to_wrt >= x"0020") then

            if (start_addr_s(8) = '0') then
                data_out <= data_in_axis; 
                out_addr_axis <= tdata_addr;
                
            else 
                  data_out <= data_in_data_ram; 
                  out_addr_data_ram <= tdata_addr(4 downto 0) ;
                  
            end if;    
                
                bytes_to_wrt <= bytes_to_wrt - x"0020" ;
                tvalid <= '1';
                tkeep <= x"ffffffff";
                w_e <= '1';
                tdata_addr <= tdata_addr+1;

          else -- less than maximum
          
            w_e <= '1';

            if (start_addr_s(8) = '0') then
            
                for I in 0 to 255 loop
                    
                    exit when I = conv_integer(bytes_to_wrt & "000")-1; 
                
                    data_out(I) <= data_in_axis(I);
                    
                  end loop;
            
            else
            
            for I in 0 to 255 loop
                                            
                exit when I = conv_integer(bytes_to_wrt & "000")-1; 
                            
                data_out(I) <= data_in_data_ram(I);
                
                end loop;
                
            end if;           
            
            
            for I in 0 to 31 loop
                
                exit when I = (conv_integer(bytes_to_wrt));
                tkeep(I) <= '1';
                
            end loop;
            
            bytes_to_wrt <= (others => '0');
            

          end if;

      end case;

    end if;

  end process;

end Behavioral;
