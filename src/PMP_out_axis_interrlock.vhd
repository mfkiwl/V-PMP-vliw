library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity m_axis_interlock is
  Port ( 
         clk             : in std_logic;
         reset           : in std_logic;
         m_axis_tvalid   : in std_logic;
         m_axis_tlast    : in std_logic;
         m_axis_tkeep    : in std_logic_vector(31 downto 0);

         pmp_in_data_0   : in std_logic_vector(31 downto 0);
         pmp_in_data_1   : in std_logic_vector(31 downto 0);
         pmp_in_data_2   : in std_logic_vector(31 downto 0);
         pmp_in_data_3   : in std_logic_vector(31 downto 0);
         pmp_in_data_4   : in std_logic_vector(31 downto 0);
         pmp_in_data_5   : in std_logic_vector(31 downto 0);
         pmp_in_data_6   : in std_logic_vector(31 downto 0);
         pmp_in_data_7   : in std_logic_vector(31 downto 0);

         pmp_in_addr_0   : in std_logic_vector(4 downto 0); -- addresses the byte
         pmp_in_addr_1   : in std_logic_vector(4 downto 0);
         pmp_in_addr_2   : in std_logic_vector(4 downto 0);
         pmp_in_addr_3   : in std_logic_vector(4 downto 0);
         pmp_in_addr_4   : in std_logic_vector(4 downto 0);
         pmp_in_addr_5   : in std_logic_vector(4 downto 0);
         pmp_in_addr_6   : in std_logic_vector(4 downto 0);
         pmp_in_addr_7   : in std_logic_vector(4 downto 0);

         pmp_in_amnt_0   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_1   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_2   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_3   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_4   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_5   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_6   : in std_logic_vector(4 downto 0);
         pmp_in_amnt_7   : in std_logic_vector(4 downto 0);

         w_e_tdata_0     : in std_logic;                               
         w_e_tdata_1     : in std_logic;
         w_e_tdata_2     : in std_logic;
         w_e_tdata_3     : in std_logic;
         w_e_tdata_4     : in std_logic;
         w_e_tdata_5     : in std_logic;
         w_e_tdata_6     : in std_logic;
         w_e_tdata_7     : in std_logic;

         w_e_tuser_0     : in std_logic;                               
         w_e_tuser_1     : in std_logic;
         w_e_tuser_2     : in std_logic;
         w_e_tuser_3     : in std_logic;
         w_e_tuser_4     : in std_logic;
         w_e_tuser_5     : in std_logic;
         w_e_tuser_6     : in std_logic;
         w_e_tuser_7     : in std_logic;
         
         -- DMA Interface
         
         tdata_in_dma    : in std_logic_vector(255 downto 0);
         w_e_dma         : in std_logic;
         
         -- MASTER OUTPUT INTERFACE

         M_AXIS_TDATA_OUT  : out std_logic_vector(255 downto 0);
         M_AXIS_TVALID_OUT : out std_logic;
         M_AXIS_TLAST_OUT  : out std_logic;
         M_AXIS_TKEEP_OUT  : out std_logic_vector(31 downto 0);
         M_AXIS_TUSER_OUT  : out std_logic_vector(127 downto 0) 

       );
end m_axis_interlock;

architecture Behavioral of m_axis_interlock is

signal data_buf : std_logic_vector(255 downto 0) := (others => '0');
signal data_buf_dma : std_logic_vector(255 downto 0) := (others => '0');

signal user_buf : std_logic_vector(127 downto 0) := (others => '0');

signal out_of_bounds_0 : std_logic;
signal out_of_bounds_1 : std_logic;
signal out_of_bounds_2 : std_logic;
signal out_of_bounds_3 : std_logic;
signal out_of_bounds_4 : std_logic;
signal out_of_bounds_5 : std_logic;
signal out_of_bounds_6 : std_logic;
signal out_of_bounds_7 : std_logic;

signal schedule_reset  : std_logic := '0';
signal reset_s : std_logic;



begin

reset_s <= reset or (schedule_reset and not(w_e_dma));


process(clk)
begin  
  if rising_edge(clk)  then
  
    out_of_bounds_0 <='0'; 
    out_of_bounds_1 <='0';
    out_of_bounds_2 <='0';
    out_of_bounds_3 <='0';
    out_of_bounds_4 <='0';
    out_of_bounds_5 <='0';
    out_of_bounds_6 <='0';
    out_of_bounds_7 <='0';

    if (m_axis_tvalid = '1') then
    
        schedule_reset <= '1';
        
    end if;
    
    if (reset_s = '1') then

      data_buf <= (others => '0');
      data_buf_dma <= (others => '0');
      user_buf <= (others => '0');
      schedule_reset <= '0';

    else
      -- port 0 
      if (w_e_tdata_0 = '1')  then

        case conv_integer(pmp_in_addr_0) is

          when 0 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_0(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_0(15 downto 0);

            else                                

              out_of_bounds_0 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_0(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_0 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              out_of_bounds_0 <= '1';

            else                                

              out_of_bounds_0 <= '1';



            end if;  
          when others => out_of_bounds_0 <= '1';                                                                                                                  
        end case;
      end if;
      -- port 1 
      if (w_e_tdata_1 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_1) is

          when 0 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_1(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_1(15 downto 0);

            else                                

              out_of_bounds_1 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_1(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_1 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              out_of_bounds_1 <= '1';

            else                                

              out_of_bounds_1 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_1 <= '1';
        end case;
      end if;
      -- port 2 
      if (w_e_tdata_2= '1') then                                                                                  

        case conv_integer(pmp_in_addr_2) is

          when 0 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_2(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_2(15 downto 0);

            else                                

              out_of_bounds_2 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_2(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_2 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              out_of_bounds_2 <= '1';

            else                                

              out_of_bounds_2 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_2 <= '1';
        end case;
      end if;

      -- port 3 
      if (w_e_tdata_3 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_3) is

          when 0 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_3(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_3(15 downto 0);

            else                                

              out_of_bounds_3 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_3(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_3 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              out_of_bounds_3 <= '1';

            else                                

              out_of_bounds_3 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_3 <= '1';
        end case;
      end if;
      -- port 4 
      if (w_e_tdata_4 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_4) is

          when 0 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_4(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_4(15 downto 0);

            else                                

              out_of_bounds_4 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_4(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_4 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              out_of_bounds_4 <= '1';

            else                                

              out_of_bounds_4 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_4 <= '1';
        end case;
      end if;
      -- port 5 
      if (w_e_tdata_5 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_5) is

          when 0 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_5(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_5(15 downto 0);

            else                                

              out_of_bounds_5 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_5(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_5 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              out_of_bounds_5 <= '1';

            else                                

              out_of_bounds_5 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_5 <= '1';
        end case;
      end if;

      -- port 6 
      if (w_e_tdata_6 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_6) is

          when 0 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_6(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_6(15 downto 0);

            else                                

              out_of_bounds_6 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_6(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_6 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              out_of_bounds_6 <= '1';

            else                                

              out_of_bounds_6 <= '1';

            end if;                                                                                                                    
          when others => out_of_bounds_6 <= '1';
        end case;
      end if;
      -- port 7 
      if (w_e_tdata_7 = '1') then

        case conv_integer(pmp_in_addr_7) is

          when 0 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(7 downto 0) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(15 downto 0) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(31 downto 0) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(15 downto 8) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(23 downto 8) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(39 downto 8) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(23 downto 16) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(31 downto 16) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(47 downto 16) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(31 downto 24) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(39 downto 24) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(55 downto 24) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(39 downto 32) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(47 downto 32) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(63 downto 32) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(47 downto 40) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(55 downto 40) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(71 downto 40) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(55 downto 48) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(63 downto 48) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(79 downto 48) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(63 downto 56) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(71 downto 56) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(87 downto 56) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(71 downto 64) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(79 downto 64) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(95 downto 64) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(79 downto 72) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(87 downto 72) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(103 downto 72) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(87 downto 80) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(95 downto 80) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(111 downto 80) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(95 downto 88) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(103 downto 88) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(119 downto 88) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(103 downto 96) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(111 downto 96) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(127 downto 96) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(111 downto 104) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(119 downto 104) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(135 downto 104) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(119 downto 112) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(127 downto 112) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(143 downto 112) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(127 downto 120) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(135 downto 120) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(151 downto 120) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 16 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(135 downto 128) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(143 downto 128) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(159 downto 128) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 17 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(143 downto 136) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(151 downto 136) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(167 downto 136) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 18 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(151 downto 144) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(159 downto 144) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(175 downto 144) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 19 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(159 downto 152) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(167 downto 152) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(183 downto 152) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 20 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(167 downto 160) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(175 downto 160) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(191 downto 160) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 21 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(175 downto 168) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(183 downto 168) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(199 downto 168) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 22 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(183 downto 176) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(191 downto 176) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(207 downto 176) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 23 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(191 downto 184) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(199 downto 184) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(215 downto 184) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 24 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(199 downto 192) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(207 downto 192) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(223 downto 192) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 25 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(207 downto 200) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(215 downto 200) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(231 downto 200) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 26 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(215 downto 208) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(223 downto 208) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(239 downto 208) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 27 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(223 downto 216) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(231 downto 216) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(247 downto 216) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 28 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(231 downto 224) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(239 downto 224) <= pmp_in_data_7(15 downto 0);

            else                                

              data_buf(255 downto 224) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 29 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(239 downto 232) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(247 downto 232) <= pmp_in_data_7(15 downto 0);

            else                                

              out_of_bounds_7 <= '1';

            end if;                                                                                                                    

          when 30 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(247 downto 240) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              data_buf(255 downto 240) <= pmp_in_data_7(15 downto 0);

            else                                


            end if;                                                                                                                    

          when 31 => 

            if (pmp_in_amnt_7 = "00111") then

              data_buf(255 downto 248) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              out_of_bounds_7 <= '1';

            else                                

              out_of_bounds_7 <= '1';

            end if; 

          when others => out_of_bounds_7 <= '1';

        end case;                                                                                                                   
      end if;


  --    TUSER

      if (w_e_tuser_0 = '1') then

        case conv_integer(pmp_in_addr_0) is

          when 0 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_0(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_0;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_0(15 downto 0);

            else                                

              out_of_bounds_0 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_0(15 downto 0);

            else                                

              out_of_bounds_0 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_0 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_0(7 downto 0);

            elsif(pmp_in_amnt_0 = "01111") then

              out_of_bounds_0 <= '1';

            else                                

              out_of_bounds_0 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_0 <= '1';                                                                                                                  
        end case;
      end if;

      if (w_e_tuser_1 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_1) is

          when 0 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_1(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_1;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_1(15 downto 0);

            else                                

              out_of_bounds_1 <= '1';
            
            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_1(15 downto 0);

            else                                

              out_of_bounds_1 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_1 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_1(7 downto 0);

            elsif(pmp_in_amnt_1 = "01111") then

              out_of_bounds_1 <= '1';

            else                                

              out_of_bounds_1 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_1 <= '1';                                                                                                                  
        end case;
      end if;


      if (w_e_tuser_2= '1') then                                                                                  

        case conv_integer(pmp_in_addr_2)  is

          when 0 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_2(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_2;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_2(15 downto 0);

            else                                

              out_of_bounds_2 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_2(15 downto 0);

            else                                

              out_of_bounds_2 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_2 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_2(7 downto 0);

            elsif(pmp_in_amnt_2 = "01111") then

              out_of_bounds_2 <= '1';

            else                                

              out_of_bounds_2 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_2 <= '1';                                                                                                                  
        end case;
      end if;


      if (w_e_tuser_3 = '1') then                                                                                  


        case conv_integer(pmp_in_addr_3)  is

          when 0 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_3(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_3;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_3(15 downto 0);

            else                                

              out_of_bounds_3 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_3(15 downto 0);

            else                                

              out_of_bounds_3 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_3 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_3(7 downto 0);

            elsif(pmp_in_amnt_3 = "01111") then

              out_of_bounds_3 <= '1';

            else                                

              out_of_bounds_3 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_3 <= '1';                                                                                                                  
        end case;
      end if;

      if (w_e_tuser_4 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_4)  is

          when 0 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_4(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_4;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_4(15 downto 0);

            else                                

              out_of_bounds_4 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_4(15 downto 0);

            else                                

              out_of_bounds_4 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_4 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_4(7 downto 0);

            elsif(pmp_in_amnt_4 = "01111") then

              out_of_bounds_4 <= '1';

            else                                

              out_of_bounds_4 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_4 <= '1';                                                                                                                  
        end case;
      end if;


      if (w_e_tuser_5 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_5)  is

          when 0 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_5(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_5;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_5(15 downto 0);

            else                                

              out_of_bounds_5 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_5(15 downto 0);

            else                                

              out_of_bounds_5 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_5 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_5(7 downto 0);

            elsif(pmp_in_amnt_5 = "01111") then

              out_of_bounds_5 <= '1';

            else                                

              out_of_bounds_5 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_5 <= '1';                                                                                                                  
        end case;
      end if;


      if (w_e_tuser_6 = '1') then                                                                                  

        case conv_integer(pmp_in_addr_6)  is

          when 0 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_6(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_6;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_6(15 downto 0);

            else                                

              out_of_bounds_6 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_6(15 downto 0);

            else                                

              out_of_bounds_6 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_6 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_6(7 downto 0);

            elsif(pmp_in_amnt_6 = "01111") then

              out_of_bounds_6 <= '1';

            else                                

              out_of_bounds_6 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_6 <= '1';                                                                                                                  
        end case;
      end if;


      if (w_e_tuser_7 = '1') then

        case conv_integer(pmp_in_addr_7) is

          when 0 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(7 downto 0) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(15 downto 0) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(31 downto 0) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 1 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(15 downto 8) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(23 downto 8) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(39 downto 8) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 2 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(23 downto 16) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(31 downto 16) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(47 downto 16) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 3 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(31 downto 24) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(39 downto 24) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(55 downto 24) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 4 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(39 downto 32) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(47 downto 32) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(63 downto 32) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 5 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(47 downto 40) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(55 downto 40) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(71 downto 40) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 6 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(55 downto 48) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(63 downto 48) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(79 downto 48) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 7 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(63 downto 56) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(71 downto 56) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(87 downto 56) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 8 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(71 downto 64) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(79 downto 64) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(95 downto 64) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 9 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(79 downto 72) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(87 downto 72) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(103 downto 72) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 10 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(87 downto 80) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(95 downto 80) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(111 downto 80) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 11 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(95 downto 88) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(103 downto 88) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(119 downto 88) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 12 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(103 downto 96) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(111 downto 96) <= pmp_in_data_7(15 downto 0);

            else                                

              user_buf(127 downto 96) <= pmp_in_data_7;

            end if;                                                                                                                    

          when 13 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(111 downto 104) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(119 downto 104) <= pmp_in_data_7(15 downto 0);

            else                                

              out_of_bounds_7 <= '1';

            end if;                                                                                                                    

          when 14 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(119 downto 112) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              user_buf(127 downto 112) <= pmp_in_data_7(15 downto 0);

            else                                

              out_of_bounds_7 <= '1';

            end if;                                                                                                                    

          when 15 => 

            if (pmp_in_amnt_7 = "00111") then

              user_buf(127 downto 120) <= pmp_in_data_7(7 downto 0);

            elsif(pmp_in_amnt_7 = "01111") then

              out_of_bounds_7 <= '1';

            else                                

              out_of_bounds_7 <= '1';

            end if;                                                                                                                    

          when others => out_of_bounds_7 <= '1';                                                                                                                  
        end case;
      end if;
    end if;
    
    if (w_e_tdata_0 = '1') and (w_e_tdata_1 = '1') and (w_e_tdata_2 = '1') and (w_e_tdata_3 = '1') and (w_e_tdata_4 = '1') and (w_e_tdata_5 = '1') and (w_e_tdata_6 = '1') and (w_e_tdata_7 = '1') and (w_e_dma = '0') then
      
      M_AXIS_TKEEP_OUT <= (others => '1');
      M_AXIS_TVALID_OUT <= '1';
    
    else
    
      M_AXIS_TKEEP_OUT <= m_axis_tkeep;
      M_AXIS_TVALID_OUT <= m_axis_tvalid;
      
    end if;
     
      if (w_e_dma = '1') then
    
          data_buf_dma <= tdata_in_dma;
    
        end if;

  end if;

end process; 

-- DMA Port handling
--process (clk) 
--begin

--  if rising_edge(clk) then
   
--      if (w_e_dma = '1') then

--      data_buf_dma <= tdata_in_dma;

--    end if;

--  end if;

--end process;
          
M_AXIS_TDATA_OUT <= data_buf or data_buf_dma;
                  


M_AXIS_TUSER_OUT <= user_buf ;

  --M_AXIS_TVALID_OUT <= m_axis_tvalid;
M_AXIS_TLAST_OUT <= m_axis_tlast; 


end Behavioral;
