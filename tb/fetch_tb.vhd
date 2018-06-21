library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_tb is

  port (
         syllable_0 : out std_logic_vector(63 downto 0); -- syllable 0
         syllable_1 : out std_logic_vector(63 downto 0); -- syllable 1
         syllable_2 : out std_logic_vector(63 downto 0); -- syllable 2
         syllable_3 : out std_logic_vector(63 downto 0); -- syllable 3
         syllable_4 : out std_logic_vector(63 downto 0); -- syllable 4 
         syllable_5 : out std_logic_vector(63 downto 0); -- syllable 5 
         syllable_6 : out std_logic_vector(63 downto 0); -- syllable 6 
         syllable_7 : out std_logic_vector(63 downto 0); -- syllable 7 

         cycles     : out std_logic_vector(31 downto 0); -- number of clock cycles the execution took
         pc_inc     : out std_logic

);   

end fetch_tb;

architecture Behavioral of fetch_tb is

  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal branch     : std_logic := '0';
  signal start      : std_logic := '0';
  signal stop       : std_logic := '1';
  signal PC         : std_logic_vector (7 downto 0) := (others => '0');
  signal instr      : std_logic_vector (511 downto 0);
  signal pc_inc_s   : std_logic := '0';
  signal branch_add : std_logic_vector (7 downto 0) := (others => '0');
  
  -- syllable 0
  signal add_src_0  :  std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
  signal add_dst_0  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
  signal w_e_0      :  std_logic;
  signal cont_src_0 :  std_logic_vector(63 downto 0); -- syllable 0 source operand
  signal cont_dst_0 :  std_logic_vector(63 downto 0);  -- syllable 0 result from execution stage

  -- syllable 1 -
  signal add_src_1  :  std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
  signal add_dst_1  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
  signal w_e_1      :  std_logic;
  signal cont_src_1 :  std_logic_vector(63 downto 0); -- syllable 1 source operand
  signal cont_dst_1 :  std_logic_vector(63 downto 0);  -- syllable 1 result from execution stage

  -- syllable 2 -
  signal add_src_2  :  std_logic_vector(3 downto 0); -- address of syllable 1 source operand  
  signal add_dst_2  :  std_logic_vector(3 downto 0); -- address of syllable 1 result from execution stage
  signal w_e_2      :  std_logic;
  signal cont_src_2 :  std_logic_vector(63 downto 0); -- syllable 2 source operand
  signal cont_dst_2 :  std_logic_vector(63 downto 0);  -- syllable 2 result from execution stage

  -- syllable 3 -
  signal add_src_3  :  std_logic_vector(3 downto 0); -- address of syllable 2 source operand  
  signal add_dst_3  :  std_logic_vector(3 downto 0); -- address of syllable 2 result from execution stage
  signal w_e_3      :  std_logic;
  signal cont_src_3 :  std_logic_vector(63 downto 0); -- syllable 3 source operand
  signal cont_dst_3 :  std_logic_vector(63 downto 0);  -- syllable 3 result from execution stage

  -- syllable 4 -
  signal add_src_4  :  std_logic_vector(3 downto 0); -- address of syllable 4 source operand  
  signal add_dst_4  :  std_logic_vector(3 downto 0); -- address of syllable 4 result from execution stage
  signal w_e_4      :  std_logic;
  signal cont_src_4 :  std_logic_vector(63 downto 0); -- syllable 4 source operand
  signal cont_dst_4 :  std_logic_vector(63 downto 0);  -- syllable 4 result from execution stage

  -- syllable 5 -
  signal add_src_5  :  std_logic_vector(3 downto 0); -- address of syllable 5 source operand  
  signal add_dst_5  :  std_logic_vector(3 downto 0); -- address of syllable 5 result from execution stage
  signal w_e_5      :  std_logic;
  signal cont_src_5 :  std_logic_vector(63 downto 0); -- syllable 5 source operand
  signal cont_dst_5 :  std_logic_vector(63 downto 0);  -- syllable 5 result from execution stage

  -- syllable 6 -
  signal add_src_6  :  std_logic_vector(3 downto 0); -- address of syllable 6 source operand  
  signal add_dst_6  :  std_logic_vector(3 downto 0); -- address of syllable 6 result from execution stage
  signal w_e_6      :  std_logic;
  signal cont_src_6 :  std_logic_vector(63 downto 0); -- syllable 6 source operand
  signal cont_dst_6 :  std_logic_vector(63 downto 0);  -- syllable 6 result from execution stage

  -- syllable 7 -
  signal add_src_7  :  std_logic_vector(3 downto 0); -- address of syllable 7 source operand  
  signal add_dst_7  :  std_logic_vector(3 downto 0); -- address of syllable 7 result from execution stage
  signal w_e_7      :  std_logic;
  signal cont_src_7 :  std_logic_vector(63 downto 0); -- syllable 7 source operand
  signal cont_dst_7 :  std_logic_vector(63 downto 0);  -- syllable 7 result from execution stage


  signal instr_valid : std_logic;

begin


  GPR_FILE: entity work.gr_regfile port map (

  clk,
  reset, 

  add_src_0,  
  add_dst_0,   
  w_e_0,      
  cont_src_0, 
  cont_dst_0, 

  add_src_1,  
  add_dst_1,   
  w_e_1,      
  cont_src_1, 
  cont_dst_1, 

  add_src_2,  
  add_dst_2,   
  w_e_2,      
  cont_src_2, 
  cont_dst_2, 

  add_src_3,  
  add_dst_3,   
  w_e_3,      
  cont_src_3, 
  cont_dst_3, 

  add_src_4,  
  add_dst_4,   
  w_e_4,      
  cont_src_4, 
  cont_dst_4, 

  add_src_5,  
  add_dst_5,   
  w_e_5,      
  cont_src_5, 
  cont_dst_5, 

  add_src_6,  
  add_dst_6,   
  w_e_6,      
  cont_src_6, 
  cont_dst_6, 

  add_src_7,  
  add_dst_7,   
  w_e_7,      
  cont_src_7, 
  cont_dst_7 


);

PROGRAM_COUNTER: entity work.pc port map (
clk,
pc_inc_s,
reset,
branch,
branch_add,
PC
                        );

                        FETCH_STAGE: entity work.fetch_stage port map (
                        
                        clk,        
                        reset,     
                        instr,

                        start,     
                        stop, 
                        branch,     

                        syllable_0, 
                        syllable_1, 
                        syllable_2 ,
                        syllable_3 ,
                        syllable_4 ,
                        syllable_5 ,
                        syllable_6 ,
                        syllable_7 ,

                        add_src_0,     
                        add_src_1,     
                        add_src_2,     
                        add_src_3,     
                        add_src_4,     
                        add_src_5,     
                        add_src_6,     
                        add_src_7,     

                        cycles,     
                        pc_inc_s                                                      
                      );

                      I_MEM: entity work.i_mem port map (
                                                          clock => clk,
                                                          reset => reset,
                                                          addr => PC,
                                                          data_out => instr,

                                                          axi_clock => '0',
                                                          we => '0',
                                                          axi_addr => (others => '0'),
                                                          axi_data_in => (others => '0')
                                                        );


                      clk <= not(clk) after 10ns;
                      reset <= '0' after 15ns;
                      start <= '1' after 13ns;
                      stop <= '0' after 5ns;
                      --branch <= '1' after 290ns, '0' after 310ns;
                      branch_add <= x"aa";
                      pc_inc <= pc_inc_s;



end architecture behavioral;



