library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lane_noctrl is
    Port ( 
             clk        : in std_logic;
             reset      : in std_logic;
             stop       : in std_logic;   
             branch     : in std_logic;

             syllable_0 : in std_logic_vector(31 downto 0);

             add_src     : in std_logic_vector(3 downto 0);
             add_dst     : in std_logic_vector(3 downto 0);
             gr_src_cont : in std_logic_vector(63 downto 0); -- syllable 0 first operand               
             gr_dst_cont : in std_logic_vector(63 downto 0); -- syllable 0 second operand              

             -- GPR REGISTERS INTERFACE
             exe_result        : out std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding and writeback
             w_e_wb            : out std_logic;
             wb_reg_add        : out std_logic_vector(3 downto 0);   -- current register address in writeback from exe stage   

             -- MEMORY INTERFACE
             mem_data_in      : in std_logic_vector (63 downto 0);
             mem_data_out     : out std_logic_vector (63 downto 0);
             mem_read_addr    : out std_logic_vector (63 downto 0);
             mem_wrt_addr     : out std_logic_vector (63 downto 0);
             mem_wrt_en       : out std_logic

         );

end lane_noctrl;

architecture Behavioral of lane_noctrl is

    -- INTERFACE FROM DECODE TO EXE STAGE
    signal  exe_syllable_s    : std_logic_vector(63 downto 0);
    signal  exe_operand_src_s : std_logic_vector(63 downto 0);
    signal  exe_operand_dst_s : std_logic_vector(63 downto 0);
    signal  exe_immediate_s   : std_logic_vector(31 downto 0);
    signal  exe_opc_s         : std_logic_vector(1 downto 0);
    signal  exe_dest_reg_s    : std_logic_vector(3 downto 0);
    signal  exe_offset_s      : std_logic_vector(15 downto 0);

    -- OUTPUTS FROM EXECUTION
    signal exe_out_dst_addr_s     : std_logic_vector(3 downto 0); 
    signal exe_out_result_s       : std_logic_vector(63 downto 0); 

    -- LANE FORWARDING
    signal exe_forward_result : std_logic_vector(63 downto 0);
    signal exe_forward_addr   : std_logic_vector(3 downto 0);

begin

    DECODE: entity work.decode_stage port map 
    (

        clk => clk, 
        reset => reset,          
        branch => branch,        

        syllable => syllable_0,       

        src_reg_add => add_src ,  
        src_reg_cont => gr_src_cont,   
        dst_reg_add => add_dst,    
        dst_reg_cont => gr_dst_cont,   

        exe_operand_src => exe_operand_src_s, 
        exe_syllable => exe_syllable_s,
        exe_operand_dst => exe_operand_dst_s,
        exe_immediate   => exe_immediate_s,
        exe_opc         => exe_opc_s,       
        exe_dest_reg    => exe_dest_reg_s,
        exe_offset      => exe_offset_s,

        dbus_addr_read => mem_read_addr,

        exe_result => exe_forward_result,     
        wb_reg_add => exe_forward_addr    

    );

    EXECUTE: entity work.exe_stage_noctrl port map
    (
        reset  => reset,           
        syllable => exe_syllable_s,         

        exe_operand_src => exe_operand_src_s,  
        exe_operand_dst => exe_operand_dst_s,
        exe_immediate => exe_immediate_s,    
        exe_opc => exe_opc_s,          

        exe_dst_addr => exe_dest_reg_s,
        exe_offset => exe_offset_s ,     

        exe_result => exe_out_result_s,
        w_e_wb => w_e_wb,          
        wb_reg_add => exe_out_dst_addr_s,         

        mem_data_in => mem_data_in,      
        mem_data_out => mem_data_out,     
        mem_wrt_addr => mem_wrt_addr,
        mem_wrt_en => mem_wrt_en      

    );

    -- FORWARD

    exe_forward_result <= exe_out_result_s;
    exe_forward_addr <= exe_out_dst_addr_s;

    -- OUTPUTTING

    exe_result <= exe_out_result_s;
    wb_reg_add <= exe_out_dst_addr_s;

end Behavioral;
