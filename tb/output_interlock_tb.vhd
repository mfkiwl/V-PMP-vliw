library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_interlock_tb is
  Port ( 
  
  M_AXIS_TDATA_OUT : out std_logic_vector(255 downto 0);
  M_AXIS_TUSER_OUT : out std_logic_vector(127 downto 0) 

  );
end output_interlock_tb;

architecture Behavioral of output_interlock_tb is

signal clk    :  std_logic := '0';                            
signal reset  :  std_logic := '1';  
signal tvalid :  std_logic := '0';                            
signal tlast  :  std_logic := '0';
signal valid_out :  std_logic := '0';                            
signal last_out  :  std_logic := '0';                              
                                                  
signal pmp_in_data_0 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_1 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_2 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_3 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_4 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_5 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_6 :  std_logic_vector(31 downto 0); 
signal pmp_in_data_7 :  std_logic_vector(31 downto 0); 
                                                
signal pmp_in_addr_0 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_1 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_2 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_3 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_4 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_5 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_6 :  std_logic_vector(4 downto 0); 
signal pmp_in_addr_7 :  std_logic_vector(4 downto 0); 
                                                
signal pmp_in_amnt_0 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_1 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_2 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_3 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_4 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_5 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_6 :  std_logic_vector(4 downto 0);  
signal pmp_in_amnt_7 :  std_logic_vector(4 downto 0);  
                                                  
signal w_e_tdata_0     :  std_logic := '0';                   
signal w_e_tdata_1     :  std_logic := '0';                   
signal w_e_tdata_2     :  std_logic := '0';                   
signal w_e_tdata_3     :  std_logic := '0';                   
signal w_e_tdata_4     :  std_logic := '0';                   
signal w_e_tdata_5     :  std_logic := '0';                   
signal w_e_tdata_6     :  std_logic := '0';                   
signal w_e_tdata_7     :  std_logic := '0';                   
                                                
signal w_e_tuser_0     :  std_logic;                   
signal w_e_tuser_1     :  std_logic;                   
signal w_e_tuser_2     :  std_logic;                   
signal w_e_tuser_3     :  std_logic;                   
signal w_e_tuser_4     :  std_logic;                   
signal w_e_tuser_5     :  std_logic;                   
signal w_e_tuser_6     :  std_logic;                   
signal w_e_tuser_7     :  std_logic;                   

begin

INTERLOCK: entity work.m_axis_interlock port map (
                                                    clk             ,
                                                    reset           ,
                                                    tvalid,
                                                    tlast,
                                                    
                                                                   
                                                    pmp_in_data_0   ,
                                                    pmp_in_data_1   ,
                                                    pmp_in_data_2   ,
                                                    pmp_in_data_3   ,
                                                    pmp_in_data_4   ,
                                                    pmp_in_data_5   ,
                                                    pmp_in_data_6   ,
                                                    pmp_in_data_7   ,
                                                                    
                                                    pmp_in_addr_0   ,
                                                    pmp_in_addr_1   ,
                                                    pmp_in_addr_2   ,
                                                    pmp_in_addr_3   ,
                                                    pmp_in_addr_4   ,
                                                    pmp_in_addr_5   ,
                                                    pmp_in_addr_6   ,
                                                    pmp_in_addr_7   ,
                                                                   
                                                    pmp_in_amnt_0   ,
                                                    pmp_in_amnt_1   ,
                                                    pmp_in_amnt_2   ,
                                                    pmp_in_amnt_3   ,
                                                    pmp_in_amnt_4   ,
                                                    pmp_in_amnt_5   ,
                                                    pmp_in_amnt_6   ,
                                                    pmp_in_amnt_7   ,
                                                                    
                                                    w_e_tdata_0     ,
                                                    w_e_tdata_1     ,
                                                    w_e_tdata_2     ,
                                                    w_e_tdata_3     ,
                                                    w_e_tdata_4     ,
                                                    w_e_tdata_5     ,
                                                    w_e_tdata_6     ,
                                                    w_e_tdata_7     ,
                                                                    
                                                    w_e_tuser_0     ,
                                                    w_e_tuser_1     ,
                                                    w_e_tuser_2     ,
                                                    w_e_tuser_3     ,
                                                    w_e_tuser_4     ,
                                                    w_e_tuser_5     ,
                                                    w_e_tuser_6     ,
                                                    w_e_tuser_7     ,
                                                                    
                                                    M_AXIS_TDATA_OUT,
                                                    valid_out,
                                                    last_out,
                                                    M_AXIS_TUSER_OUT
                );

clk <= not(clk) after 10ns;
reset <= '0' after 20ns;

pmp_in_data_0 <= x"ffffffff";
pmp_in_data_1 <= x"11111111";
pmp_in_addr_0 <= (others => '0');
pmp_in_addr_1 <= "00001";
w_e_tdata_0 <= '1' after 30ns;
w_e_tdata_1 <= '1' after 30ns;
--w_e_tuser_0 <= '1' after 30ns, '0' after 50ns;
pmp_in_amnt_0 <= "00111";
pmp_in_amnt_1 <= "01111";


--pmp_in_data_1 <= x"ffffffff";
----pmp_in_addr_1 <= x"60";
--w_e_tdata_1 <= '1' after 30ns, '0' after 50ns;
--w_e_tuser_1 <= '1' after 30ns, '0' after 50ns;
--pmp_in_amnt_1 <= "11111";


end Behavioral;
