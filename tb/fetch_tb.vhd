library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

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

    file file_VECTORS : text;
    file file_RESULTS_syllable : text;
    file file_RESULTS_src_reg : text;
    file file_RESULTS_dst_reg : text;


    signal clk        : std_logic := '0';
    signal reset      : std_logic;
    signal branch     : std_logic;
    signal start      : std_logic;
    signal stop       : std_logic := '1';
    signal PC         : std_logic_vector (7 downto 0) := (others => '0');
    signal instr      : std_logic_vector (511 downto 0);
    signal pc_inc_s   : std_logic := '0';
    signal branch_add : std_logic_vector (7 downto 0) := (others => '0');
    signal cycles_s : std_logic_vector (31 downto 0) := (others => '0');

    signal syllable_0_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_1_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_2_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_3_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_4_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_5_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_6_s : std_logic_vector(63 downto 0) := (others => '0');
    signal syllable_7_s : std_logic_vector(63 downto 0) := (others => '0');

    -- syllable 0
    signal add_src_0  :  std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
    signal add_dst_0_exe    :  std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
    signal add_dst_0_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_0      :  std_logic;
    signal cont_src_0 :  std_logic_vector(63 downto 0); -- syllable 0 source operand
    signal cont_dst_0_exe :  std_logic_vector(63 downto 0);  -- syllable 0 result from execution stage
    signal cont_dst_0_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 1 -
    signal add_src_1  :  std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
    signal add_dst_1_exe  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
    signal add_dst_1_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_1      :  std_logic;
    signal cont_src_1 :  std_logic_vector(63 downto 0); -- syllable 1 source operand
    signal cont_dst_1_exe :  std_logic_vector(63 downto 0);  -- syllable 1 result from execution stage
    signal cont_dst_1_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 2 -
    signal add_src_2  :  std_logic_vector(3 downto 0); -- address of syllable 1 source operand  
    signal add_dst_2_exe  :  std_logic_vector(3 downto 0); -- address of syllable 1 result from execution stage
    signal add_dst_2_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_2      :  std_logic;
    signal cont_src_2 :  std_logic_vector(63 downto 0); -- syllable 2 source operand
    signal cont_dst_2_exe :  std_logic_vector(63 downto 0);  -- syllable 2 result from execution stage
    signal cont_dst_2_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 3 -
    signal add_src_3  :  std_logic_vector(3 downto 0); -- address of syllable 2 source operand  
    signal add_dst_3_exe  :  std_logic_vector(3 downto 0); -- address of syllable 2 result from execution stage
    signal add_dst_3_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_3      :  std_logic;
    signal cont_src_3 :  std_logic_vector(63 downto 0); -- syllable 3 source operand
    signal cont_dst_3_exe :  std_logic_vector(63 downto 0);  -- syllable 3 result from execution stage
    signal cont_dst_3_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 4 -
    signal add_src_4  :  std_logic_vector(3 downto 0); -- address of syllable 4 source operand  
    signal add_dst_4_exe  :  std_logic_vector(3 downto 0); -- address of syllable 4 result from execution stage
    signal add_dst_4_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_4      :  std_logic;
    signal cont_src_4 :  std_logic_vector(63 downto 0); -- syllable 4 source operand
    signal cont_dst_4_exe :  std_logic_vector(63 downto 0);  -- syllable 4 result from execution stage
    signal cont_dst_4_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 5 -
    signal add_src_5  :  std_logic_vector(3 downto 0); -- address of syllable 5 source operand  
    signal add_dst_5_exe  :  std_logic_vector(3 downto 0); -- address of syllable 5 result from execution stage
    signal add_dst_5_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_5      :  std_logic;
    signal cont_src_5 :  std_logic_vector(63 downto 0); -- syllable 5 source operand
    signal cont_dst_5_exe :  std_logic_vector(63 downto 0);  -- syllable 5 result from execution stage
    signal cont_dst_5_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 6 -
    signal add_src_6  :  std_logic_vector(3 downto 0); -- address of syllable 6 source operand  
    signal add_dst_6_exe  :  std_logic_vector(3 downto 0); -- address of syllable 6 result from execution stage
    signal add_dst_6_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_6      :  std_logic;
    signal cont_src_6 :  std_logic_vector(63 downto 0); -- syllable 6 source operand
    signal cont_dst_6_exe :  std_logic_vector(63 downto 0);  -- syllable 6 result from execution stage
    signal cont_dst_6_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage

    -- syllable 7 -
    signal add_src_7  :  std_logic_vector(3 downto 0); -- address of syllable 7 source operand  
    signal add_dst_7_exe  :  std_logic_vector(3 downto 0); -- address of syllable 7 result from execution stage
    signal add_dst_7_fetch  :  std_logic_vector(3 downto 0); -- address of syllable 0 result from fetch stage
    signal w_e_7      :  std_logic;
    signal cont_src_7 :  std_logic_vector(63 downto 0); -- syllable 7 source operand
    signal cont_dst_7_exe :  std_logic_vector(63 downto 0);  -- syllable 7 result from execution stage
    signal cont_dst_7_fetch :  std_logic_vector(63 downto 0);  -- syllable 0 result from fetch stage


    signal instr_valid : std_logic;

begin


    GPR_FILE: entity work.gr_regfile port map (

    clk,
    reset, 

    add_src_0,  
    add_dst_0_exe,   
    add_dst_0_fetch,   
    w_e_0,      
    cont_src_0, 
    cont_dst_0_exe, 
    cont_dst_0_fetch, 

    add_src_1,  
    add_dst_1_exe,   
    add_dst_1_fetch,   
    w_e_1,      
    cont_src_1, 
    cont_dst_1_exe, 
    cont_dst_1_fetch, 

    add_src_2,  
    add_dst_2_exe,   
    add_dst_2_fetch,   
    w_e_2,      
    cont_src_2, 
    cont_dst_2_exe, 
    cont_dst_2_fetch, 

    add_src_3,  
    add_dst_3_exe,   
    add_dst_3_fetch,   
    w_e_3,      
    cont_src_3, 
    cont_dst_3_exe, 
    cont_dst_3_fetch, 

    add_src_4,  
    add_dst_4_exe,   
    add_dst_4_fetch,   
    w_e_4,      
    cont_src_4, 
    cont_dst_4_exe, 
    cont_dst_4_fetch, 

    add_src_5,  
    add_dst_5_exe,   
    add_dst_5_fetch,   
    w_e_5,      
    cont_src_5, 
    cont_dst_5_exe, 
    cont_dst_5_fetch, 

    add_src_6,  
    add_dst_6_exe,   
    add_dst_6_fetch,   
    w_e_6,      
    cont_src_6, 
    cont_dst_6_exe, 
    cont_dst_6_fetch, 

    add_src_7,  
    add_dst_7_exe,   
    add_dst_7_fetch,   
    w_e_7,      
    cont_src_7, 
    cont_dst_7_exe, 
    cont_dst_7_fetch 


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

syllable_0_s , 
syllable_1_s , 
syllable_2_s ,
syllable_3_s ,
syllable_4_s ,
syllable_5_s ,
syllable_6_s ,
syllable_7_s ,

add_src_0,     
add_src_1,     
add_src_2,     
add_src_3,     
add_src_4,     
add_src_5,     
add_src_6,     
add_src_7,     

add_dst_0_fetch,     
add_dst_1_fetch,     
add_dst_2_fetch,     
add_dst_3_fetch,     
add_dst_4_fetch,     
add_dst_5_fetch,     
add_dst_6_fetch,     
add_dst_7_fetch,     

cycles_s,     
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
pc_inc <= pc_inc_s;

syllable_0 <= syllable_0_s; 
syllable_1 <= syllable_1_s;
syllable_2 <= syllable_2_s;
syllable_3 <= syllable_3_s;
syllable_4 <= syllable_4_s;
syllable_5 <= syllable_5_s;
syllable_6 <= syllable_6_s;
syllable_7 <= syllable_7_s;

cycles <= cycles_s;

file_open(file_VECTORS, "/home/marco/V-PMP/tb/stimuli/fetch_in.txt",  read_mode);
file_open(file_RESULTS_syllable, "/home/marco/V-PMP/tb/results/fetch/fetch_out_syllable.txt", write_mode);
file_open(file_RESULTS_src_reg, "/home/marco/V-PMP/tb/results/fetch/fetch_out_src_reg.txt", write_mode);
file_open(file_RESULTS_dst_reg, "/home/marco/V-PMP/tb/results/fetch/fetch_out_dst_reg.txt", write_mode);


process

    variable v_ILINE     : line;
    variable v_OLINE     : line;
    variable v_reset     : std_logic;
    variable v_start     : std_logic;
    variable v_stop      : std_logic;
    variable v_branch    : std_logic;
    variable v_br_add    : std_logic_vector(7 downto 0);
    variable v_SPACE     : character;

begin

    

    wait for 10ns;

    while (not endfile(file_VECTORS)) loop

        readline(file_VECTORS, v_ILINE);
        read(v_ILINE, v_reset);
        read(v_ILINE, v_SPACE);           -- read in the space character
        read(v_ILINE, v_start);
        read(v_ILINE, v_SPACE);           -- read in the space character
        read(v_ILINE, v_stop);
        read(v_ILINE, v_SPACE);           -- read in the space character
        read(v_ILINE, v_branch);
        read(v_ILINE, v_SPACE);           -- read in the space character
        read(v_ILINE, v_br_add);

        -- Pass the variable to a signal
        reset <= v_reset;    
        start <= v_start;    
        stop <= v_stop;
        branch <= v_branch;    
        branch_add <= v_br_add;

        
        -- write syllables to file
        hwrite(v_OLINE, cycles_s);
        write(v_OLINE, string'(" SYL "));
        hwrite(v_OLINE,syllable_0_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_1_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_2_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_3_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_4_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_5_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_6_s, right, 16);
        write(v_OLINE, string'(" "));
        hwrite(v_OLINE,syllable_7_s, right, 16);

        writeline(file_RESULTS_syllable,v_OLINE);
        
        -- write src_reg to file
        hwrite(v_OLINE, cycles_s);
        write(v_OLINE, string'(" S_R "));
        hwrite(v_OLINE,add_src_0, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_1, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_2, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_3, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_4, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_5, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_6, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_src_7, right, 15);

        writeline(file_RESULTS_src_reg,v_OLINE);
        
        -- write dst_reg to file
        hwrite(v_OLINE, cycles_s);
        write(v_OLINE, string'(" D_R "));
        hwrite(v_OLINE,add_dst_0_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_1_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_2_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_3_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_4_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_5_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_6_fetch, right, 15);
        write(v_OLINE, string'("  "));
        hwrite(v_OLINE,add_dst_7_fetch, right, 15);

        writeline(file_RESULTS_dst_reg,v_OLINE);

        wait for 20ns;
    end loop;

    file_close(file_VECTORS);
    file_close(file_RESULTS_syllable);
    file_close(file_RESULTS_src_reg);
    file_close(file_RESULTS_dst_reg);

end process;



end architecture behavioral;



