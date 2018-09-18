library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lane_0 is
  Port ( 
         clk        : in std_logic;
         reset      : in std_logic;
         stop       : in std_logic;   

         syllable_0 : in std_logic_vector(31 downto 0);

         add_0_0    : in std_logic_vector(4 downto 0);
         add_0_1    : in std_logic_vector(4 downto 0);
         cont_0_0    : in std_logic_vector(31 downto 0); -- syllable 0 first operand               
         cont_0_1    : in std_logic_vector(31 downto 0); -- syllable 0 second operand              

         br_cont_0   : in std_logic;  -- content from branch register pointend in prefetch
         br_current_data_write : in std_logic;
         br_current_add_write  : in std_logic_vector(4 downto 0);

        -- Memory interface
         mem_add_wrt  : out std_logic_vector(31 downto 0); -- write address for data memory
         mem_add_read : out std_logic_vector(31 downto 0); -- read address for data memory
         mem_data_out : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt    : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e      : out std_logic;                     -- memory write enable
                                                           -- BR and GR interface        
         gr_add_w     : out std_logic_vector(4 downto 0);  -- address of GR register to be written
         gr_data_w    : out std_logic_vector(31 downto 0); -- data to write to GR
         br_add_w     : out std_logic_vector(4 downto 0);  -- address of BR register to be written
         br_data_w    : out std_logic;                     -- data to write to BR
         gr_w_e       : out std_logic;                     -- write enable for GR
         br_w_e       : out std_logic;                     -- write enable for BR
                                                           -- PC interface
         branch_add   : out std_logic_vector(7 downto 0);  -- Branch address for program counter
         branch_valid : out std_logic                      -- Branch valid for PC

       );

end lane_0;

architecture Behavioral of lane_0 is

  signal alu_oper_0_s : std_logic_vector(31 downto 0);
  signal alu_oper_1_s : std_logic_vector(31 downto 0);
  signal alu_immediate_s : std_logic_vector(10 downto 0);
  signal exe_opc_s       : std_logic_vector(1 downto 0); -- execution unit opcode
  signal alu_dest_s      : std_logic_vector(4 downto 0);
  signal alu_shamt_s     : std_logic_vector(4 downto 0);
  signal mem_dest_reg_s  : std_logic_vector(4 downto 0);
  signal mem_store_d_s   : std_logic_vector(31 downto 0);
  signal mem_offset_s    : std_logic_vector(15 downto 0);
  signal mem_base_add_s  : std_logic_vector(31 downto 0);
  signal mem_l_s_s       : std_logic;
  signal mem_add_s       : std_logic_vector(31 downto 0);
  signal br_exe_add_s    : std_logic_vector(4 downto 0);
  signal jump_add_s      : std_logic_vector(7 downto 0);
  signal br_0_cont_s     : std_logic;
  signal branch_valid_s  : std_logic;
  signal syllable_to_exe : std_logic_vector(31 downto 0);
  signal gr_add_w_s       : std_logic_vector(4 downto 0);
  signal gr_data_w_s : std_logic_vector(31 downto 0);
  signal br_add_w_s  : std_logic_vector(4 downto 0);
  signal br_data_w_s : std_logic;

begin

  mem_add_read <= mem_add_s;

  DECODE: entity work.decode_stage port map (
  clk,
  reset,
  stop,
  branch_valid_s,

  syllable_0,

  add_0_0,
  add_0_1,
  cont_0_0,
  cont_0_1,
  br_cont_0,
  br_data_w_s,
  br_add_w_s ,

  gr_data_w_s,
  alu_oper_0_s   ,
  alu_oper_1_s   ,
  alu_immediate_s,
  exe_opc_s      ,
  alu_dest_s     ,
  gr_add_w_s,

  mem_dest_reg_s  ,
  mem_store_d_s  ,
  mem_l_s_s      ,
  mem_add_s      , -- for read   

  gr_data_w_s,                                         

  br_exe_add_s   ,
  jump_add_s     ,
  br_0_cont_s  ,


  syllable_to_exe

);
EXECUTE: entity work.exe_stage_complete port map(
                                        --                                        clk,
reset,
exe_opc_s,
syllable_to_exe,

alu_oper_0_s,
alu_oper_1_s,
alu_immediate_s,
alu_dest_s,

mem_dest_reg_s,
mem_store_d_s,
mem_l_s_s,
mem_add_s, ---------------

br_exe_add_s,
jump_add_s,
br_0_cont_s,
mem_add_wrt,
mem_data_out,
mem_wrt_amnt,
mem_data_in,
mem_w_e,

gr_add_w_s,
gr_data_w_s,
gr_w_e,

br_add_w_s,
br_data_w_s,
br_w_e,

branch_add,
branch_valid_s

                                        );  


                                        branch_valid <= branch_valid_s; 
                                        gr_add_w <= gr_add_w_s;
                                        gr_data_w <= gr_data_w_s;   
                                        br_add_w <= br_add_w_s;
                                        br_data_w <= br_data_w_s;


                                        mem_add_read <= mem_add_s;                                        

                                      end Behavioral;
