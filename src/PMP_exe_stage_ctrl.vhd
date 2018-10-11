library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity exe_stage_complete is
 
  Port (
        
        reset                 : in std_logic;
        
        exe_operand           : in std_logic_vector(63 downto 0); -- SRC reg content
        exe_immediate         : in std_logic_vector(31 downto 0); -- immediate in the instruction
        exe_opc               : in std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
        exe_dest_reg          : in std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
        exe_offset            : in std_logic_vector(15 downto 0);
        
        exe_result            : out std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding
        wb_reg_add            : out std_logic_vector(3 downto 0)   -- current register address in writeback from exe stage  -> for lane forwrding   
  
  
   );

end exe_stage_complete;

architecture Behavioral of exe_stage_complete is

--signal alu_gr_result_s : std_logic_vector(31 downto 0);
--signal alu_br_result_s : std_logic;
--signal alu_gr_add_s    : std_logic_vector(4 downto 0);
--signal alu_br_add_s    : std_logic_vector(4 downto 0);
--signal alu_gr_w_e_s    : std_logic;
--signal alu_br_w_e_s    : std_logic;

--signal mem_gr_result_s : std_logic_vector(31 downto 0);
--signal mem_gr_add_s    : std_logic_vector(4 downto 0);
--signal mem_gr_w_e_s    : std_logic;

--signal mem_select_n_s       : std_logic;
--signal alu_select_n_s       : std_logic;
--signal ctrl_select_n_s      : std_logic;
--signal alu_immediate_s : std_logic_vector(31 downto 0);

begin



--ALU: entity work.alu_pmp port map (
--                                    alu_select_n_s,
                                    
--                                    syllable,
--                                    alu_oper_0,
--                                    alu_oper_1,
--                                    alu_immediate_s,
--                                    alu_gr_dest_add,
--                                    alu_br_dest_add,
                                    
--                                    alu_gr_add_s,
--                                    alu_br_add_s,
--                                    alu_gr_w_e_s,
--                                    alu_br_w_e_s,
--                                    alu_gr_result_s,
--                                    alu_br_result_s

--                                    );

--MEM: entity work.mem_pmp port map (
--                                    mem_select_n_s,
                                    
--                                    syllable,
--                                    mem_dest_reg,
--                                    mem_l_s,
--                                    mem_store_data,
--                                    mem_data_in,
--                                    mem_add_dec,
--                                    mem_add_wrt,
--                                    mem_data_out,
--                                    mem_wrt_amnt,
--                                    mem_w_e,
--                                    mem_gr_result_s,
--                                    mem_gr_add_s,
--                                    mem_gr_w_e_s

--                                   );
                                   
  
--CTRL: entity work.ctrl_pmp port map (
--                                    ctrl_select_n_s,
--                                    alu_br_cont,
--                                    syllable,
--                                    branch_add,
--                                    branch_valid

--                                    );  


                                     
end Behavioral;
