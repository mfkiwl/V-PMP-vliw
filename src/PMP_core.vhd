library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PMP_core is

    Port ( 
             clk           : in std_logic;
             reset         : in std_logic;
             start         : in std_logic;
             -- Instruction Memory Interface
             imem_addr     : out std_logic_vector(7 downto 0);
             imem_instr    : in std_logic_vector(511 downto 0);            

             -- Data Bus Interface

             dbus_data_in_0  : in std_logic_vector(63 downto 0);
             dbus_data_in_1  : in std_logic_vector(63 downto 0);
             dbus_data_in_2  : in std_logic_vector(63 downto 0);
             dbus_data_in_3  : in std_logic_vector(63 downto 0);
             dbus_data_in_4  : in std_logic_vector(63 downto 0);
             dbus_data_in_5  : in std_logic_vector(63 downto 0);
             dbus_data_in_6  : in std_logic_vector(63 downto 0);
             dbus_data_in_7  : in std_logic_vector(63 downto 0);

             dbus_data_out_0 : out std_logic_vector(63 downto 0); 
             dbus_data_out_1 : out std_logic_vector(63 downto 0);  
             dbus_data_out_2 : out std_logic_vector(63 downto 0);  
             dbus_data_out_3 : out std_logic_vector(63 downto 0);  
             dbus_data_out_4 : out std_logic_vector(63 downto 0);  
             dbus_data_out_5 : out std_logic_vector(63 downto 0);  
             dbus_data_out_6 : out std_logic_vector(63 downto 0);
             dbus_data_out_7 : out std_logic_vector(63 downto 0);

             --dbus_data_amnt_0 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_1 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_2 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_3 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_4 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_5 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_6 : out std_logic_vector(4 downto 0);
             --dbus_data_amnt_7 : out std_logic_vector(4 downto 0);  

             dbus_addr_read_0    : out std_logic_vector(63 downto 0);
             dbus_addr_read_1    : out std_logic_vector(63 downto 0);
             dbus_addr_read_2    : out std_logic_vector(63 downto 0);
             dbus_addr_read_3    : out std_logic_vector(63 downto 0);
             dbus_addr_read_4    : out std_logic_vector(63 downto 0);
             dbus_addr_read_5    : out std_logic_vector(63 downto 0);
             dbus_addr_read_6    : out std_logic_vector(63 downto 0);
             dbus_addr_read_7    : out std_logic_vector(63 downto 0);

             dbus_addr_wrt_0   : out std_logic_vector(63 downto 0); -- base addresses to write (set the starting bit)
             dbus_addr_wrt_1   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_2   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_3   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_4   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_5   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_6   : out std_logic_vector(63 downto 0);
             dbus_addr_wrt_7   : out std_logic_vector(63 downto 0);

             dbus_wrt_en_0      : out std_logic;
             dbus_wrt_en_1      : out std_logic;
             dbus_wrt_en_2      : out std_logic;
             dbus_wrt_en_3      : out std_logic;
             dbus_wrt_en_4      : out std_logic;
             dbus_wrt_en_5      : out std_logic;
             dbus_wrt_en_6      : out std_logic;
             dbus_wrt_en_7      : out std_logic;

             -- Clock cycles
             cycles        : out std_logic_vector(31 downto 0)

         );
end PMP_core;

architecture Behavioral of PMP_core is

    signal stop_s        : std_logic := '0';
    signal reset_s       : std_logic;
    signal branch_s      : std_logic;

    signal syllable_0_s : std_logic_vector(63 downto 0);
    signal syllable_1_s : std_logic_vector(63 downto 0);
    signal syllable_2_s : std_logic_vector(63 downto 0);
    signal syllable_3_s : std_logic_vector(63 downto 0);
    signal syllable_4_s : std_logic_vector(63 downto 0);
    signal syllable_5_s : std_logic_vector(63 downto 0);
    signal syllable_6_s : std_logic_vector(63 downto 0);
    signal syllable_7_s : std_logic_vector(63 downto 0);

    signal branch       : std_logic;
    signal branch_add_s : std_logic_vector(7 downto 0);

    -- GPR INTERFACE
    signal add_src_0         : std_logic_vector(3 downto 0);
    signal add_dst_0_exe     : std_logic_vector(3 downto 0);
    signal add_dst_0_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_0      : std_logic_vector(3 downto 0);
    signal w_e_0             : std_logic;
    signal cont_src_0        : std_logic_vector(63 downto 0);
    signal cont_dst_0_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_0_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_0       : std_logic_vector(63 downto 0);

    signal add_src_1         : std_logic_vector(3 downto 0);
    signal add_dst_1_exe     : std_logic_vector(3 downto 0);
    signal add_dst_1_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_1      : std_logic_vector(3 downto 0);
    signal w_e_1             : std_logic;
    signal cont_src_1        : std_logic_vector(63 downto 0);
    signal cont_dst_1_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_1_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_1       : std_logic_vector(63 downto 0);

    signal add_src_2         : std_logic_vector(3 downto 0);
    signal add_dst_2_exe     : std_logic_vector(3 downto 0);
    signal add_dst_2_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_2      : std_logic_vector(3 downto 0);
    signal w_e_2             : std_logic;
    signal cont_src_2        : std_logic_vector(63 downto 0);
    signal cont_dst_2_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_2_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_2       : std_logic_vector(63 downto 0);

    signal add_src_3         : std_logic_vector(3 downto 0);
    signal add_dst_3_exe     : std_logic_vector(3 downto 0);
    signal add_dst_3_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_3      : std_logic_vector(3 downto 0);
    signal w_e_3             : std_logic;
    signal cont_src_3        : std_logic_vector(63 downto 0);
    signal cont_dst_3_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_4_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_3       : std_logic_vector(63 downto 0);

    signal add_src_4         : std_logic_vector(3 downto 0);
    signal add_dst_4_exe     : std_logic_vector(3 downto 0);
    signal add_dst_4_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_4      : std_logic_vector(3 downto 0);
    signal w_e_4             : std_logic;
    signal cont_src_4        : std_logic_vector(63 downto 0);
    signal cont_dst_4_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_4_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_4       : std_logic_vector(63 downto 0);

    signal add_src_5         : std_logic_vector(3 downto 0);
    signal add_dst_5_exe     : std_logic_vector(3 downto 0);
    signal add_dst_5_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_5      : std_logic_vector(3 downto 0);
    signal w_e_5             : std_logic;
    signal cont_src_5        : std_logic_vector(63 downto 0);
    signal cont_dst_5_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_5_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_5       : std_logic_vector(63 downto 0);

    signal add_src_6         : std_logic_vector(3 downto 0);
    signal add_dst_6_exe     : std_logic_vector(3 downto 0);
    signal add_dst_6_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_6      : std_logic_vector(3 downto 0);
    signal w_e_6             : std_logic;
    signal cont_src_6        : std_logic_vector(63 downto 0);
    signal cont_dst_6_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_6_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_6       : std_logic_vector(63 downto 0);

    signal add_src_7         : std_logic_vector(3 downto 0);
    signal add_dst_7_exe     : std_logic_vector(3 downto 0);
    signal add_dst_7_fetch   : std_logic_vector(3 downto 0);
    signal add_dst_wb_7      : std_logic_vector(3 downto 0);
    signal w_e_7             : std_logic;
    signal cont_src_7        : std_logic_vector(63 downto 0);
    signal cont_dst_7_exe    : std_logic_vector(63 downto 0);
    signal cont_dst_7_fetch  : std_logic_vector(63 downto 0);
    signal gr_result_7       : std_logic_vector(63 downto 0);

    -- PROGRAM COUNTER INTERFACE
    signal program_counter   : std_logic_vector(15 downto 0);
    signal PC_new_addr       : std_logic_vector(15 downto 0);
    signal PC_increment      : std_logic;
    signal PC_add            : std_logic;
    signal PC_stop           : std_logic;
    signal PC_load           : std_logic;



begin

    FETCH_STAGE: entity work.fetch_stage port map 
    (

        clk  => clk,       
        reset => reset_s     
        instr => instruction_s,      
        start => start,     
        stop => stop,      
        branch => branch,     

        syllable_0 => syllable_0_s, 
        syllable_1 => syllable_1_s, 
        syllable_2 => syllable_2_s, 
        syllable_3 => syllable_3_s, 
        syllable_4 => syllable_4_s,  
        syllable_5 => syllable_5_s,  
        syllable_6 => syllable_6_s,  
        syllable_7 => syllable_7_s,  

        -- General purpose registers prefetch

        gr_src_0 =>  add_src_0, 
        gr_src_1 =>  add_src_1,
        gr_src_2 =>  add_src_2,
        gr_src_3 =>  add_src_3, 
        gr_src_4 =>  add_src_4,
        gr_src_5 =>  add_src_5,
        gr_src_6 =>  add_src_6,
        gr_src_7 =>  add_src_7,

        gr_dst_0 =>  add_dst_0_fetch,
        gr_dst_1 =>  add_dst_1_fetch,
        gr_dst_2 =>  add_dst_2_fetch,
        gr_dst_3 =>  add_dst_3_fetch,
        gr_dst_4 =>  add_dst_4_fetch,
        gr_dst_5 =>  add_dst_5_fetch,
        gr_dst_6 =>  add_dst_6_fetch,
        gr_dst_7 =>  add_dst_7_fetch,

        cycles => cycles,     
        pc_inc => PC_increment    

    );  

    PROGRAM_COUNTER: entity work.pc port map 
    ( 
        clk => clk,        
        inc => PC_increment,      
        rst => reset_s,       

        pc_addr => PC_new_addr,  
        pc_add => PC_add,     
        pc_stop => PC_stop,
        pc_load => PC_load, 

        PC => program_counter   
    );  

    GPR_FILE: entity work.gr_regfile port map 
    (
        clk => clk,
        rst => reset_s,

        add_src_0 => add_src_0,          
        add_dst_0_exe => add_dst_0_exe,    
        add_dst_0_fetch => add_dst_0_fetch,  
        w_e_0 => w_e_0,            
        cont_src_0 => cont_src_0,        
        cont_dst_0_exe => cont_dst_0_exe,    
        cont_dst_0_fetch => cont_dst_0_exe, 

        add_src_1 => add_src_1,          
        add_dst_1_exe => add_dst_1_exe,    
        add_dst_1_fetch => add_dst_1_fetch,  
        w_e_1 => w_e_1,            
        cont_src_1 => cont_src_1,        
        cont_dst_1_exe => cont_dst_1_exe,    
        cont_dst_1_fetch => cont_dst_1_exe, 

        add_src_2 => add_src_2,          
        add_dst_2_exe => add_dst_2_exe,    
        add_dst_2_fetch => add_dst_2_fetch,  
        w_e_2 => w_e_2,            
        cont_src_2 => cont_src_2,        
        cont_dst_2_exe => cont_dst_2_exe,    
        cont_dst_2_fetch => cont_dst_2_exe, 

        add_src_3 => add_src_3,          
        add_dst_3_exe => add_dst_3_exe,    
        add_dst_3_fetch => add_dst_3_fetch,  
        w_e_3 => w_e_3,            
        cont_src_3 => cont_src_3,        
        cont_dst_3_exe => cont_dst_3_exe,    
        cont_dst_3_fetch => cont_dst_3_exe, 

        add_src_4 => add_src_4,          
        add_dst_4_exe => add_dst_4_exe,    
        add_dst_4_fetch => add_dst_4_fetch,  
        w_e_4 => w_e_4,            
        cont_src_4 => cont_src_4,        
        cont_dst_4_exe => cont_dst_4_exe,    
        cont_dst_4_fetch => cont_dst_4_exe, 

        add_src_5 => add_src_5,          
        add_dst_5_exe => add_dst_5_exe,    
        add_dst_5_fetch => add_dst_5_fetch,  
        w_e_5 => w_e_5,            
        cont_src_5 => cont_src_5,        
        cont_dst_5_exe => cont_dst_5_exe,    
        cont_dst_5_fetch => cont_dst_5_exe, 

        add_src_6 => add_src_6,          
        add_dst_6_exe => add_dst_6_exe,    
        add_dst_6_fetch => add_dst_6_fetch,  
        w_e_6 => w_e_6,            
        cont_src_6 => cont_src_6,        
        cont_dst_6_exe => cont_dst_6_exe,    
        cont_dst_6_fetch => cont_dst_6_exe, 

        add_src_7 => add_src_7,          
        add_dst_7_exe => add_dst_7_exe,    
        add_dst_7_fetch => add_dst_7_fetch,  
        w_e_7 => w_e_7,            
        cont_src_7 => cont_src_7,        
        cont_dst_7_exe => cont_dst_7_exe,    
        cont_dst_7_fetch => cont_dst_7_exe, 


    );


    LANES: entity work.lanes port map 
    (

        clk => clk,
        reset => resset,
        stop => stop_s,        

        -- SYLLABLES FROM FETCH STAGE
        syllable_0 =>  syllable_0_s,  
        syllable_1 =>  syllable_1_s,
        syllable_2 =>  syllable_2_s,
        syllable_3 =>  syllable_3_s,
        syllable_4 =>  syllable_4_s,
        syllable_5 =>  syllable_5_s,
        syllable_6 =>  syllable_6_s,
        syllable_7 =>  syllable_7_s,

        -- OPERANDS FROM GPR PREFETCHED
        gr_0_src => cont_src_0,
        gr_0_dst => cont_dst_0_fetch,

        gr_1_src => cont_src_1,
        gr_1_dst => cont_dst_1_fetch,

        gr_2_src => cont_src_2,
        gr_2_dst => cont_dst_2_fetch,

        gr_3_src => cont_src_3,
        gr_3_dst => cont_dst_3_fetch,

        gr_4_src => cont_src_4,
        gr_4_dst => cont_dst_4_fetch,

        gr_5_src => cont_src_5,
        gr_5_dst => cont_dst_5_fetch,

        gr_6_src => cont_src_6,
        gr_6_dst => cont_dst_6_fetch,

        gr_7_src => cont_src_7,
        gr_7_dst => cont_dst_7_fetch,

        gr_add_0_s => add_src_0,  
        gr_add_0_d => add_dst_0_fetch,

        gr_add_1_s => add_src_1,  
        gr_add_1_d => add_dst_1_fetch,
        
        gr_add_2_s => add_src_2,  
        gr_add_2_d => add_dst_2_fetch,
        
        gr_add_3_s => add_src_3,  
        gr_add_3_d => add_dst_3_fetch,
        
        gr_add_4_s => add_src_4,  
        gr_add_4_d => add_dst_4_fetch,
        
        gr_add_5_s => add_src_5,  
        gr_add_5_d => add_dst_5_fetch,
        
        gr_add_6_s => add_src_6,  
        gr_add_6_d => add_dst_6_fetch,
        
        gr_add_7_s => add_src_7,  
        gr_add_7_d => add_dst_7_fetch,

        gr_add_dst_wb_0 => add_dst_0_exe,  
        gr_add_dst_wb_1 => add_dst_1_exe,  
        gr_add_dst_wb_2 => add_dst_2_exe,  
        gr_add_dst_wb_3 => add_dst_3_exe,  
        gr_add_dst_wb_4 => add_dst_4_exe,  
        gr_add_dst_wb_5 => add_dst_5_exe,  
        gr_add_dst_wb_6 => add_dst_6_exe,  
        gr_add_dst_wb_7 => add_dst_7_exe,  

        gr_rsl_0 => cont_dst_0_exe, 
        gr_rsl_1 => cont_dst_1_exe,
        gr_rsl_2 => cont_dst_2_exe,
        gr_rsl_3 => cont_dst_3_exe,
        gr_rsl_4 => cont_dst_4_exe,
        gr_rsl_5 => cont_dst_5_exe,
        gr_rsl_6 => cont_dst_6_exe,
        gr_rsl_7 => cont_dst_7_exe,

        gr_wrt_en_0 => w_e_0, 
        gr_wrt_en_1 => w_e_1,
        gr_wrt_en_2 => w_e_2,
        gr_wrt_en_3 => w_e_3,
        gr_wrt_en_4 => w_e_4,
        gr_wrt_en_5 => w_e_5,
        gr_wrt_en_6 => w_e_6,
        gr_wrt_en_7 => w_e_7,

        mem_add_wrt_0  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_0 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_0 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_0 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_0  : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_0      : out std_logic;                     -- memory write enable

        mem_add_wrt_1  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_1 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_1 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_1 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_1  : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_1      : out std_logic;                     -- memory write enable

        mem_add_wrt_2  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_2 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_2 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_2 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_2 : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_2      : out std_logic;                     -- memory write enable

        mem_add_wrt_3  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_3 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_3 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_3 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_3  : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_3      : out std_logic;                     -- memory write enable

        mem_add_wrt_4  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_4 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_4 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_4 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_4 : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_4      : out std_logic;                     -- memory write enable

        mem_add_wrt_5  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_5 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_5 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_5 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_5  : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_5      : out std_logic;                     -- memory write enable

        mem_add_wrt_6  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_6 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_6 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_6 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_6 : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_6      : out std_logic;                     -- memory write enable

        mem_add_wrt_7  : out std_logic_vector(63 downto 0); -- write address for memory
        mem_add_read_7 : out std_logic_vector(63 downto 0); -- read address for memory
        mem_data_out_7 : out std_logic_vector(63 downto 0); -- data to write to memory
        --mem_wrt_amnt_7 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in_7  : in std_logic_vector(63 downto 0);  -- Data from memory
        mem_w_e_7      : out std_logic;                     -- memory write enable

        -- PROGRAM COUNTER INTERFACE

        PC_addr          : out std_logic_vector(15 downto 0); --address to add to PC
        PC_add           : out std_logic;
        PC_stop          : out std_logic;
        PC_load          : out std_logic

    );


    reset_s <= reset;

end Behavioral;
