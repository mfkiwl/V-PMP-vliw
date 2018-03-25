library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity exe_stage_complete is
 
  Port (
        reset          : in std_logic;
        exe_opc        : in std_logic_vector(1 downto 0);
        
        syllable        : in std_logic_vector(31 downto 0);
        alu_oper_0      : in std_logic_vector(31 downto 0);
        alu_oper_1      : in std_logic_vector(31 downto 0);
        alu_imm         : in std_logic_vector(10 downto 0);
        alu_gr_dest_add : in std_logic_vector(4 downto 0);
        
        mem_dest_reg   : in std_logic_vector(4 downto 0);
        mem_store_data : in std_logic_vector(31 downto 0);
        mem_l_s        : in std_logic;
        mem_add_dec    : in std_logic_vector(31 downto 0);
        
        alu_br_dest_add : in std_logic_vector(4 downto 0);  --destination address of branch register to be written
        jump_add        : in std_logic_vector( 7 downto 0); -- address to jump
        alu_br_cont     : in std_logic; -- branch register content
        -- Memory interface
        mem_add_wrt     : out std_logic_vector(31 downto 0); -- used only to store
        mem_data_out    : out std_logic_vector(31 downto 0); -- data to write in mem
        mem_wrt_amnt    : out std_logic_vector(4 downto 0);  -- number of bits written to memory
        mem_data_in     : in std_logic_vector(31 downto 0);  -- data from memory
        mem_w_e         : out std_logic;                     -- memory write enable
        -- GR File interface
        gr_add_w       : out std_logic_vector(4 downto 0);
        gr_data_w      : out std_logic_vector(31 downto 0);
        gr_w_e         : out std_logic;
        -- BR File Interface
        br_add_w       : out std_logic_vector( 4 downto 0);
        br_data_w      : out std_logic;
        br_w_e         : out std_logic;
        --PC Interface
        branch_add     : out std_logic_vector(7 downto 0);
        branch_valid   : out std_logic
  
  
   );

end exe_stage_complete;

architecture Behavioral of exe_stage_complete is

signal alu_gr_result_s : std_logic_vector(31 downto 0);
signal alu_br_result_s : std_logic;
signal alu_gr_add_s    : std_logic_vector(4 downto 0);
signal alu_br_add_s    : std_logic_vector(4 downto 0);
signal alu_gr_w_e_s    : std_logic;
signal alu_br_w_e_s    : std_logic;

signal mem_gr_result_s : std_logic_vector(31 downto 0);
signal mem_gr_add_s    : std_logic_vector(4 downto 0);
signal mem_gr_w_e_s    : std_logic;

signal mem_select_n_s       : std_logic;
signal alu_select_n_s       : std_logic;
signal ctrl_select_n_s      : std_logic;
signal alu_immediate_s : std_logic_vector(31 downto 0);

begin



ALU: entity work.alu_pmp port map (
                                    alu_select_n_s,
                                    
                                    syllable,
                                    alu_oper_0,
                                    alu_oper_1,
                                    alu_immediate_s,
                                    alu_gr_dest_add,
                                    alu_br_dest_add,
                                    
                                    alu_gr_add_s,
                                    alu_br_add_s,
                                    alu_gr_w_e_s,
                                    alu_br_w_e_s,
                                    alu_gr_result_s,
                                    alu_br_result_s

                                    );

MEM: entity work.mem_pmp port map (
                                    mem_select_n_s,
                                    
                                    syllable,
                                    mem_dest_reg,
                                    mem_l_s,
                                    mem_store_data,
                                    mem_data_in,
                                    mem_add_dec,
                                    mem_add_wrt,
                                    mem_data_out,
                                    mem_wrt_amnt,
                                    mem_w_e,
                                    mem_gr_result_s,
                                    mem_gr_add_s,
                                    mem_gr_w_e_s

                                   );
                                   
  
CTRL: entity work.ctrl_pmp port map (
                                    ctrl_select_n_s,
                                    alu_br_cont,
                                    syllable,
                                    branch_add,
                                    branch_valid

                                    );  

alu_immediate_s <= x"00000" & '0' & alu_imm;    
gr_add_w  <= alu_gr_add_s when exe_opc = "00" else
             mem_gr_add_s when exe_opc = "10" else
             (others => '0');
             
gr_data_w <= alu_gr_result_s when exe_opc = "00" else
             mem_gr_result_s when exe_opc = "10" else
             (others => '0');
             
gr_w_e <= alu_gr_w_e_s  when exe_opc = "00" else
          mem_gr_w_e_s when exe_opc = "10" else
          '0';

alu_select_n_s <= '0' when exe_opc = "00" else
                '1';
 
mem_select_n_s <= '0' when exe_opc = "10" else
             '1';
    
ctrl_select_n_s <= '0' when exe_opc = "01" else
              '1';                


br_add_w <= alu_br_add_s;
br_data_w <= alu_br_result_s;
br_w_e <= alu_br_w_e_s;

                                     
end Behavioral;
