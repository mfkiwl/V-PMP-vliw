library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lanes is

    port ( 
             clk        :in std_logic;
             reset      :in std_logic;
             stop       :in std_logic;        

             -- SYLLABLES FROM FETCH STAGE
             syllable_0 :in std_logic_vector(63 downto 0);   
             syllable_1 :in std_logic_vector(63 downto 0);
             syllable_2 :in std_logic_vector(63 downto 0);
             syllable_3 :in std_logic_vector(63 downto 0);
             syllable_4 :in std_logic_vector(63 downto 0);
             syllable_5 :in std_logic_vector(63 downto 0);
             syllable_6 :in std_logic_vector(63 downto 0);
             syllable_7 :in std_logic_vector(63 downto 0);

             -- OPERANDS FROM GPR PREFETCHED
             gr_0_src : in std_logic_vector(63 downto 0);  -- operands data
             gr_0_dst : in std_logic_vector(63 downto 0);

             gr_1_src : in std_logic_vector(63 downto 0);
             gr_1_dst : in std_logic_vector(63 downto 0);

             gr_2_src : in std_logic_vector(63 downto 0);
             gr_2_dst : in std_logic_vector(63 downto 0);

             gr_3_src : in std_logic_vector(63 downto 0);
             gr_3_dst : in std_logic_vector(63 downto 0);

             gr_4_src : in std_logic_vector(63 downto 0);
             gr_4_dst : in std_logic_vector(63 downto 0);

             gr_5_src : in std_logic_vector(63 downto 0);
             gr_5_dst : in std_logic_vector(63 downto 0);

             gr_6_src : in std_logic_vector(63 downto 0);
             gr_6_dst : in std_logic_vector(63 downto 0);

             gr_7_src : in std_logic_vector(63 downto 0);
             gr_7_dst : in std_logic_vector(63 downto 0);

             -- ADDRESS OF OPERANDS FROM FETCH STAGE
             gr_add_0_s : in std_logic_vector(3 downto 0); -- operands address
             gr_add_0_d : in std_logic_vector(3 downto 0);

             gr_add_1_s : in std_logic_vector(3 downto 0);
             gr_add_1_d : in std_logic_vector(3 downto 0);

             gr_add_2_s : in std_logic_vector(3 downto 0);
             gr_add_2_d : in std_logic_vector(3 downto 0);

             gr_add_3_s : in std_logic_vector(3 downto 0);
             gr_add_3_d : in std_logic_vector(3 downto 0);

             gr_add_4_s : in std_logic_vector(3 downto 0);
             gr_add_4_d : in std_logic_vector(3 downto 0);

             gr_add_5_s : in std_logic_vector(3 downto 0);
             gr_add_5_d : in std_logic_vector(3 downto 0);

             gr_add_6_s : in std_logic_vector(3 downto 0);
             gr_add_6_d : in std_logic_vector(3 downto 0);

             gr_add_7_s : in std_logic_vector(3 downto 0);
             gr_add_7_d : in std_logic_vector(3 downto 0);

             -- GPR WRITEBACK ADDRESS
             gr_add_dst_wb_0 : out std_logic_vector(3 downto 0);  --addresses for destination
             gr_add_dst_wb_1 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_2 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_3 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_4 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_5 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_6 : out std_logic_vector(3 downto 0);
             gr_add_dst_wb_7 : out std_logic_vector(3 downto 0);

             -- GPR WRITEBACK RESULT
             gr_rsl_0 : out std_logic_vector(63 downto 0); -- results to destination
             gr_rsl_1 : out std_logic_vector(63 downto 0);
             gr_rsl_2 : out std_logic_vector(63 downto 0);
             gr_rsl_3 : out std_logic_vector(63 downto 0);
             gr_rsl_4 : out std_logic_vector(63 downto 0);
             gr_rsl_5 : out std_logic_vector(63 downto 0);
             gr_rsl_6 : out std_logic_vector(63 downto 0);
             gr_rsl_7 : out std_logic_vector(63 downto 0);

             -- GPR WRITEBACK ENABLE
             gr_wrt_en_0 : out std_logic; -- write enable for destination 
             gr_wrt_en_1 : out std_logic;
             gr_wrt_en_2 : out std_logic;
             gr_wrt_en_3 : out std_logic;
             gr_wrt_en_4 : out std_logic;
             gr_wrt_en_5 : out std_logic;
             gr_wrt_en_6 : out std_logic;
             gr_wrt_en_7 : out std_logic;

             -- MEMORY INTERFACE
             mem_add_wrt_0  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_0 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_0 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_0 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_0  : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_0      : out std_logic;                     -- memory write enable

             mem_add_wrt_1  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_1 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_1 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_1 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_1  : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_1      : out std_logic;                     -- memory write enable

             mem_add_wrt_2  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_2 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_2 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_2 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_2 : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_2      : out std_logic;                     -- memory write enable

             mem_add_wrt_3  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_3 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_3 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_3 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_3  : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_3      : out std_logic;                     -- memory write enable

             mem_add_wrt_4  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_4 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_4 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_4 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_4 : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_4      : out std_logic;                     -- memory write enable

             mem_add_wrt_5  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_5 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_5 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_5 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_5  : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_5      : out std_logic;                     -- memory write enable

             mem_add_wrt_6  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_6 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_6 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_6 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_6 : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_6      : out std_logic;                     -- memory write enable

             mem_add_wrt_7  : out std_logic_vector(63 downto 0); -- write address for memory
             mem_add_read_7 : out std_logic_vector(63 downto 0); -- read address for memory
             mem_data_out_7 : out std_logic_vector(63 downto 0); -- data to write to memory
             mem_wrt_amnt_7 : out std_logic_vector(15 downto 0);  -- number of bits written to memory
             mem_data_in_7  : in std_logic_vector(63 downto 0);  -- Data from memory
             mem_w_e_7      : out std_logic;                     -- memory write enable

             -- PROGRAM COUNTER INTERFACE

             PC_addr          : out std_logic_vector(15 downto 0); --address to add to PC
             PC_add           : out std_logic;
             PC_stop          : out std_logic;
             PC_load          : out std_logic

         );
end lanes;

architecture Behavioral of lanes is

    signal branch_s : std_logic;
    signal stop_s : std_logic;

begin


    LANE_0: entity work.lane_0 port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable_0 => syllable_0,

        add_src    => gr_add_0_s, 
        add_dst    => gr_add_0_d,
        gr_src_cont => gr_0_src,              
        gr_dst_cont => gr_0_dst,              

        exe_result => gr_rsl_0,      
        w_e_wb  => gr_wrt_en_0,         
        wb_reg_add => gr_add_dst_wb_0,       

        mem_data_in  => mem_data_in_0,    
        mem_data_out => mem_data_out_0,    
        mem_read_addr => mem_add_read_0,     
        mem_wrt_addr  => mem_add_wrt_0,   
        mem_wrt_en  => mem_w_e_0,     
        mem_wrt_amount => mem_wrt_amnt_0,

        pc_addr => PC_addr,          
        pc_add => PC_add,              
        pc_stop => PC_stop,          
        pc_load => PC_load         

    );

    LANE_1: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_1,

        add_src    => gr_add_1_s, 
        add_dst    => gr_add_1_d,
        gr_src_cont => gr_1_src,              
        gr_dst_cont => gr_1_dst,              

        exe_result => gr_rsl_1,      
        w_e_wb  => gr_wrt_en_1,         
        wb_reg_add => gr_add_dst_wb_1,       

        mem_data_in  => mem_data_in_1,    
        mem_data_out => mem_data_out_1,    
        mem_read_addr => mem_add_read_1,     
        mem_wrt_addr  => mem_add_wrt_1,   
        mem_wrt_en  => mem_w_e_1  ,   
        mem_wrt_amount => mem_wrt_amnt_1

    );


    LANE_2: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_2,

        add_src    => gr_add_2_s, 
        add_dst    => gr_add_2_d,
        gr_src_cont => gr_2_src,              
        gr_dst_cont => gr_2_dst,              

        exe_result => gr_rsl_2,      
        w_e_wb  => gr_wrt_en_2,         
        wb_reg_add => gr_add_dst_wb_2,       

        mem_data_in  => mem_data_in_2,    
        mem_data_out => mem_data_out_2,    
        mem_read_addr => mem_add_read_2,     
        mem_wrt_addr  => mem_add_wrt_2,   
        mem_wrt_en  => mem_w_e_2,     
        mem_wrt_amount => mem_wrt_amnt_2

    );

    LANE_3: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_3,

        add_src    => gr_add_3_s, 
        add_dst    => gr_add_3_d,
        gr_src_cont => gr_3_src,              
        gr_dst_cont => gr_3_dst,              

        exe_result => gr_rsl_3,      
        w_e_wb  => gr_wrt_en_3,         
        wb_reg_add => gr_add_dst_wb_3,       

        mem_data_in  => mem_data_in_3,    
        mem_data_out => mem_data_out_3,    
        mem_read_addr => mem_add_read_3,     
        mem_wrt_addr  => mem_add_wrt_3,   
        mem_wrt_en  => mem_w_e_3 ,    
        mem_wrt_amount => mem_wrt_amnt_3

    );

    LANE_4: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_4,

        add_src    => gr_add_4_s, 
        add_dst    => gr_add_4_d,
        gr_src_cont => gr_4_src,              
        gr_dst_cont => gr_4_dst,              

        exe_result => gr_rsl_4,      
        w_e_wb  => gr_wrt_en_4,         
        wb_reg_add => gr_add_dst_wb_4,       

        mem_data_in  => mem_data_in_4,    
        mem_data_out => mem_data_out_4,    
        mem_read_addr => mem_add_read_4,     
        mem_wrt_addr  => mem_add_wrt_4,   
        mem_wrt_en  => mem_w_e_4 ,    
        mem_wrt_amount => mem_wrt_amnt_4

    );

    LANE_5: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_5,

        add_src    => gr_add_5_s, 
        add_dst    => gr_add_5_d,
        gr_src_cont => gr_5_src,              
        gr_dst_cont => gr_5_dst,              

        exe_result => gr_rsl_5,      
        w_e_wb  => gr_wrt_en_5,         
        wb_reg_add => gr_add_dst_wb_5,       

        mem_data_in  => mem_data_in_5,    
        mem_data_out => mem_data_out_5,    
        mem_read_addr => mem_add_read_5,     
        mem_wrt_addr  => mem_add_wrt_5,   
        mem_wrt_en  => mem_w_e_5  ,   
        mem_wrt_amount => mem_wrt_amnt_5

    );

    LANE_6: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_6,

        add_src    => gr_add_6_s, 
        add_dst    => gr_add_6_d,
        gr_src_cont => gr_6_src,              
        gr_dst_cont => gr_6_dst,              

        exe_result => gr_rsl_6,      
        w_e_wb  => gr_wrt_en_6,         
        wb_reg_add => gr_add_dst_wb_6,       

        mem_data_in  => mem_data_in_6,    
        mem_data_out => mem_data_out_6,    
        mem_read_addr => mem_add_read_6,     
        mem_wrt_addr  => mem_add_wrt_6,   
        mem_wrt_en  => mem_w_e_6 ,    
        mem_wrt_amount => mem_wrt_amnt_6

    );

    LANE_7: entity work.lane_noctrl port map 
    (

        clk   => clk,     
        reset => reset,     
        stop  => stop_s,        
        branch => branch_s,     

        syllable => syllable_7,

        add_src    => gr_add_7_s, 
        add_dst    => gr_add_7_d,
        gr_src_cont => gr_7_src,              
        gr_dst_cont => gr_7_dst,              

        exe_result => gr_rsl_7,      
        w_e_wb  => gr_wrt_en_7,         
        wb_reg_add => gr_add_dst_wb_7,       

        mem_data_in  => mem_data_in_7,    
        mem_data_out => mem_data_out_7,    
        mem_read_addr => mem_add_read_7,     
        mem_wrt_addr  => mem_add_wrt_7,   
        mem_wrt_en  => mem_w_e_7 ,    
        mem_wrt_amount => mem_wrt_amnt_7

    );

end Behavioral;
