library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_tb is

port (
	     syllable_0 : out std_logic_vector(31 downto 0); -- syllable 0
	     syllable_1 : out std_logic_vector(31 downto 0); -- syllable 1
	     syllable_2 : out std_logic_vector(31 downto 0); -- syllable 2
	     syllable_3 : out std_logic_vector(31 downto 0); -- syllable 3
	     syllable_4 : out std_logic_vector(31 downto 0); -- syllable 4 
         syllable_5 : out std_logic_vector(31 downto 0); -- syllable 5 
         syllable_6 : out std_logic_vector(31 downto 0); -- syllable 6 
         syllable_7 : out std_logic_vector(31 downto 0); -- syllable 7 

         br_0       : out std_logic_vector (4 downto 0);
         br_1       : out std_logic_vector (4 downto 0);
         br_2       : out std_logic_vector (4 downto 0);
         br_3       : out std_logic_vector (4 downto 0);
         br_4       : out std_logic_vector (4 downto 0);
         br_5       : out std_logic_vector (4 downto 0);
         br_6       : out std_logic_vector (4 downto 0);
         br_7       : out std_logic_vector (4 downto 0);

	     cycles     : out std_logic_vector(31 downto 0); -- number of clock cycles the execution took
         pc_inc    : out std_logic;  
	     fetch_ready: out std_logic;                     -- 1 when ready to fetch another instruction
	     fetch_done : out std_logic);                    -- '1' when syllables are valid

  end fetch_tb;

architecture Behavioral of fetch_tb is

  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal branch     : std_logic := '0';
  signal start      : std_logic := '0';
  signal stop       : std_logic := '1';
  signal PC         : std_logic_vector (7 downto 0) := (others => '0');
  signal instr      : std_logic_vector (255 downto 0);
  signal stall_s    : std_logic := '0';
  signal pc_inc_s   : std_logic := '0';
  signal branch_add : std_logic_vector (7 downto 0) := (others => '0');

signal  add_0_0  : std_logic_vector(4 downto 0);
signal  add_0_1  : std_logic_vector(4 downto 0);
signal  add_0_d  : std_logic_vector(4 downto 0);
signal  w_e_0    : std_logic;
signal  cont_0_0 : std_logic_vector(31 downto 0);
signal  cont_0_1 : std_logic_vector(31 downto 0);
signal  cont_0_d : std_logic_vector(31 downto 0);

signal  add_1_0  : std_logic_vector(4 downto 0);
signal  add_1_1  : std_logic_vector(4 downto 0);
signal  add_1_d  : std_logic_vector(4 downto 0);
signal  w_e_1    : std_logic;
signal  cont_1_0 : std_logic_vector(31 downto 0);
signal  cont_1_1 : std_logic_vector(31 downto 0);
signal  cont_1_d : std_logic_vector(31 downto 0);

signal  add_2_0  : std_logic_vector(4 downto 0);
signal  add_2_1  : std_logic_vector(4 downto 0);
signal  add_2_d  : std_logic_vector(4 downto 0);
signal  w_e_2    : std_logic;
signal  cont_2_0 : std_logic_vector(31 downto 0);
signal  cont_2_1 : std_logic_vector(31 downto 0);
signal  cont_2_d : std_logic_vector(31 downto 0);

signal  add_3_0  : std_logic_vector(4 downto 0);
signal  add_3_1  : std_logic_vector(4 downto 0);
signal  add_3_d  : std_logic_vector(4 downto 0);
signal  w_e_3    : std_logic;
signal  cont_3_0 : std_logic_vector(31 downto 0);
signal  cont_3_1 : std_logic_vector(31 downto 0);
signal  cont_3_d : std_logic_vector(31 downto 0);

signal  add_4_0  : std_logic_vector(4 downto 0);
signal  add_4_1  : std_logic_vector(4 downto 0);
signal  add_4_d  : std_logic_vector(4 downto 0);
signal  w_e_4    : std_logic;
signal  cont_4_0 : std_logic_vector(31 downto 0);
signal  cont_4_1 : std_logic_vector(31 downto 0);
signal  cont_4_d : std_logic_vector(31 downto 0);

signal  add_5_0  : std_logic_vector(4 downto 0);
signal  add_5_1  : std_logic_vector(4 downto 0);
signal  add_5_d  : std_logic_vector(4 downto 0);
signal  w_e_5    : std_logic;
signal  cont_5_0 : std_logic_vector(31 downto 0);
signal  cont_5_1 : std_logic_vector(31 downto 0);
signal  cont_5_d : std_logic_vector(31 downto 0);

signal  add_6_0  : std_logic_vector(4 downto 0);
signal  add_6_1  : std_logic_vector(4 downto 0);
signal  add_6_d  : std_logic_vector(4 downto 0);
signal  w_e_6    : std_logic;
signal  cont_6_0 : std_logic_vector(31 downto 0);
signal  cont_6_1 : std_logic_vector(31 downto 0);
signal  cont_6_d : std_logic_vector(31 downto 0);
  
signal  add_7_0  : std_logic_vector(4 downto 0);
signal  add_7_1  : std_logic_vector(4 downto 0);
signal  add_7_d  : std_logic_vector(4 downto 0);
signal  w_e_7    : std_logic;
signal  cont_7_0 : std_logic_vector(31 downto 0);
signal  cont_7_1 : std_logic_vector(31 downto 0);
signal  cont_7_d : std_logic_vector(31 downto 0);

signal instr_valid : std_logic;

begin


	GPR_FILE: entity work.gr_regfile port map (
											   clk,
											   reset,
											   add_0_0 ,
											   add_0_1 ,
											   add_0_d ,
											   w_e_0   ,
											   cont_0_0,
											   cont_0_1,
											   cont_0_d,
											           											 
											   add_1_0 ,
											   add_1_1 ,
											   add_1_d ,
											   w_e_1   ,
											   cont_1_0,
											   cont_1_1,
											   cont_1_d,
											           
											   add_2_0 ,
											   add_2_1 ,
											   add_2_d ,
											   w_e_2   ,
											   cont_2_0,
											   cont_2_1,
											   cont_2_d,
											           
											   add_3_0 ,
											   add_3_1 ,
											   add_3_d ,
											   w_e_3   ,
											   cont_3_0,
											   cont_3_1,
											   cont_3_d,
											           
											   add_4_0 ,
											   add_4_1 ,
											   add_4_d ,
											   w_e_4   ,
											   cont_4_0,
											   cont_4_1,
											   cont_4_d,
											           
											   add_5_0 ,
											   add_5_1 ,
											   add_5_d ,
											   w_e_5   ,
											   cont_5_0,
											   cont_5_1,
											   cont_5_d,
											           
											   add_6_0 ,
											   add_6_1 ,
											   add_6_d ,
											   w_e_6   ,
											   cont_6_0,
											   cont_6_1,
											   cont_6_d,
											           
											   add_7_0 ,
											   add_7_1 ,
											   add_7_d ,
											   w_e_7   ,
											   cont_7_0,
											   cont_7_1,
											   cont_7_d
											   );
	
	


  PROGRAM_COUNTER: entity work.pc port map (
  											clk,
  											pc_inc_s,
  											reset,
  											branch,
  											branch_add,
  											PC
  											);

  FETCH_STAGE: entity work.fetch_stage port map (clk,        
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
                                                                  
                                                      
                                                       add_0_0,     
                                                       add_0_1,	    
                                                    
                                                       add_1_0,     
                                                       add_1_1,	    
                                                      
                                                       add_2_0,     
                                                       add_2_1,	    
                                                       
                                                       add_3_0,     
                                                       add_3_1,	    
                                                        
                                                       add_4_0,     
                                                       add_4_1,	    
                                                       add_5_0,     
                                                       add_5_1,	    
                                                            
                                                       add_6_0,     
                                                       add_6_1,	    
                                                            
                                                       add_7_0,     
                                                       add_7_1,	    
                                                       
                                                       br_0,       
                                                                  
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
         
         

