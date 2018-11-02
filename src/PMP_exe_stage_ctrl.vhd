library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity exe_stage_complete is

    Port (

             reset                     : in std_logic;

             exe_operand_src           : in std_logic_vector(63 downto 0); -- SRC reg content
             exe_operand_dst           : in std_logic_vector(63 downto 0); -- DST reg content
             exe_immediate             : in std_logic_vector(31 downto 0); -- immediate in the instruction
             exe_opc                   : in std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
             exe_dst_addr              : in std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
             exe_offset                : in std_logic_vector(15 downto 0); -- offset inside instruction
             exe_data_from_mem         : in std_logic_vector(63 downto 0); -- data from mem prefetched by instruction decode

             exe_result                : out std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding and writeback
             wb_reg_add                : out std_logic_vector(3 downto 0)   -- current register address in writeback from exe stage  -> for lane forwrding   


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

    signal mem_select_s          : std_logic;
    signal alu_32_select_s       : std_logic;
    signal alu_64_select_s       : std_logic;
    signal ctrl_select_s         : std_logic;

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

    alu_64_select_s <= '1' when exe_opc = "00" else
                       '0';

    alu_32_select_s <= '1' when exe_opc = "01" else
                       '0';

    mem_select_s <= '1' when exe_opc = "10" else
                    '0';

    ctrl_select_s <= '1' when exe_opc = "11" else
                     '0';

end Behavioral;
