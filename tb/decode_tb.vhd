library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_tb is
  Port (
      
        decode_ready  : out std_logic;
        decode_done   : out std_logic;
        
        alu_op_0      : out std_logic_vector(31 downto 0);
        alu_op_1      : out std_logic_vector(31 downto 0);
        alu_immediate : out std_logic_vector(10 downto 0);
        alu_opc       : out std_logic_vector(1 downto 0);
        alu_dest      : out std_logic_vector(4 downto 0);
        alu_shamt     : out std_logic_vector(4 downto 0);

        mem_store_d  : out std_logic_vector(31 downto 0);
        mem_l_s      : out std_logic;
        mem_r_add    : out std_logic_vector(31 downto 0);
        
        jump_add     : out std_logic_vector(7 downto 0);
        br_cont_out  : out std_logic
      
       );
end decode_tb;


architecture Behavioral of decode_tb is

signal clk         : std_logic := '0';
signal reset       : std_logic := '1';
signal stop        : std_logic := '1';
signal exe_rdy     : std_logic := '0';
signal fetch_compl : std_logic := '0';
signal syllable    : std_logic_vector(31 downto 0);
signal operand_0   : std_logic_vector(31 downto 0);
signal operand_1   : std_logic_vector(31 downto 0);
signal br_cont_in  : std_logic := '1';
signal stall       : std_logic := '0';
signal mem_dest_reg       : std_logic_vector(4 downto 0);
signal br_reg_add  : std_logic_vector(4 downto 0);
signal branch      : std_logic := '0';

begin

  DECODE_STAGE: entity work.decode_stage port map (
                                                   clk        , 
                                                   reset      ,
                                                   stop       ,
                                                   branch,
                                                   syllable   ,
                                                   operand_0  ,
                                                   operand_1  ,
                                                   br_cont_in ,
                                                   decode_ready, 
                                                   decode_done  ,
                                                    
                                                   alu_op_0 ,    
                                                   alu_op_1  ,   
                                                   alu_immediate,
                                                   alu_opc      ,
                                                   alu_dest     ,
                                                   alu_shamt    ,
                                                                
                                                   mem_dest_reg,
                                                   mem_store_d  ,                                                 
                                                   mem_l_s      ,
                                                   mem_r_add    ,
                                                   
                                                   br_reg_add,
                                                   jump_add  ,   
                                                   br_cont_out 
                                                 );

clk <= not(clk) after 10ns;
reset <= '0' after 15ns;
branch <= '1' after 150ns, '0' after 170ns;
stop <= '0' after 5ns;
syllable <= "010000" & --opcode
            "00000" & -- register add that contains data (store) or target register (load)
            "00000" & -- register add that contains base address
            "0000000000000111"; -- immeiate offset
            
operand_0 <= x"AAAAAAAA";
operand_1 <= x"0000000B";


end behavioral; 
