library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exe_tb is
    Port (
         reset             : in std_logic;
         syllable          : in std_logic_vector(63 downto 0);

         exe_operand_src   : in std_logic_vector(63 downto 0); -- SRC reg content
         exe_operand_dst   : in std_logic_vector(63 downto 0); -- DST reg content
         exe_immediate     : in std_logic_vector(31 downto 0); -- immediate in the instruction
         exe_opc           : in std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
         exe_dst_addr      : in std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
         exe_offset        : in std_logic_vector(15 downto 0); -- offset inside instruction

         -- GPR REGISTERS INTERFACE
         exe_result        : out std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding and writeback
         w_e_wb            : out std_logic;
         wb_reg_add        : out std_logic_vector(3 downto 0);   -- current register address in writeback from exe stage   

         -- MEMORY INTERFACE
         mem_data_in      : in std_logic_vector (63 downto 0);
         mem_data_out     : out std_logic_vector (63 downto 0);
         mem_wrt_addr     : out std_logic_vector (63 downto 0);
         mem_wrt_en       : out std_logic;
         mem_wrt_amount   : out std_logic_vector(8 downto 0);

         -- PROGRAM COUNTER INTERFACE
         pc_addr          : out std_logic_vector(15 downto 0); -- branch address from control unit
         pc_add           : out std_logic;    
         pc_stop          : out std_logic;
         pc_load          : out std_logic

     );
end exe_tb;

architecture Behavioral of exe_tb is

    signal alu32_gr_result_s : std_logic_vector(63 downto 0);
    signal alu32_gr_add_s    : std_logic_vector(3 downto 0);
    signal alu32_gr_w_e_s    : std_logic;

    -- ALU64 SIGNALS
    signal alu64_gr_result_s : std_logic_vector(63 downto 0);
    signal alu64_gr_add_s    : std_logic_vector(3 downto 0);
    signal alu64_gr_w_e_s    : std_logic;

    -- MEM SIGNALS
    signal mem_data_out_s     : std_logic_vector (63 downto 0);
    signal mem_read_addr_s    : std_logic_vector (63 downto 0);
    signal mem_wrt_addr_s     : std_logic_vector (63 downto 0);
    signal mem_wrt_en_s       : std_logic;
    signal mem_gr_result_s    : std_logic_vector(63 downto 0);
    signal mem_gr_add_s       : std_logic_vector(3 downto 0);
    signal mem_gr_w_e_s       : std_logic;

    --CTRL SIGNALS
    signal ctrl_pc_address_s  : std_logic_vector(15 downto 0);
    signal ctrl_pc_add_s      : std_logic;
    signal ctrl_pc_stop_s     : std_logic;
    signal ctrl_pc_load_s     : std_logic;

    -- SELECT SIGNALS
    signal mem_select_s       : std_logic;
    signal alu_32_select_s    : std_logic;
    signal alu_64_select_s    : std_logic;
    signal ctrl_select_s      : std_logic;

begin

EXECUTE: entity work.exe_stage port map (clk  ,          
                                        reset          ,
                                        exe_opc        ,
                                                       
                                        syllable       ,
                                        alu_oper_0     ,
                                        alu_oper_1     ,
                                        alu_imm        ,
                                        alu_shamt      ,
                                        alu_gr_dest_add,
                                                       
                                        mem_dest_reg   ,
                                        mem_store_data ,
                                        mem_l_s        ,
                                        mem_add_dec    ,
                                                       
                                        alu_br_dest_add,
                                        jump_add       ,
                                        alu_br_cont    ,
                                       
                                        mem_add_wrt    ,
                                        mem_data_out   ,
                                        mem_data_in    ,
                                        mem_w_e        ,
                                        
                                        gr_add_w       ,
                                        gr_data_w      ,
                                        gr_w_e         ,
                                 
                                        br_add_w       ,
                                        br_data_w      ,
                                        br_w_e         ,
                                       
                                        branch_add     ,
                                        branch_valid   );
                                        

ALU32: entity work.alu32 port map 
    (

        alu32_select => alu_32_select_s,
        syllable => syllable,
        operand_src => exe_operand_src,    
        operand_dst => exe_operand_dst,
        immediate => exe_immediate,
        gr_add_dst =>exe_dst_addr,

        gr_add_w => alu32_gr_add_s,
        w_e_gr => alu32_gr_w_e_s,
        result_gr => alu32_gr_result_s

    );

ALU64: entity work.alu64 port map 
    (

        alu64_select => alu_64_select_s,
        syllable => syllable,
        operand_src => exe_operand_src,    
        operand_dst => exe_operand_dst,
        immediate => exe_immediate,
        gr_add_dst =>exe_dst_addr,

        gr_add_w => alu64_gr_add_s,
        w_e_gr => alu64_gr_w_e_s,
        result_gr => alu64_gr_result_s

    );

MEM: entity work.memory_unit port map 
    (

        mem_select => mem_select_s,
        syllable => syllable,
        reset => reset,
        operand_src => exe_operand_src,    
        operand_dst => exe_operand_dst,
        immediate => exe_immediate,
        offset => exe_offset,
        gr_add_dst =>exe_dst_addr,

        mem_data_in => mem_data_in,
        mem_data_out => mem_data_out_s,
        mem_wrt_addr => mem_wrt_addr_s,
        mem_wrt_en => mem_wrt_en_s,
        mem_wrt_amount => mem_wrt_amount,

        gr_add_w => mem_gr_add_s,
        w_e_gr => mem_gr_w_e_s,
        result_gr => mem_gr_result_s

    );

CTRL: entity work.control port map 
    (

        ctrl_select => ctrl_select_s,
        syllable => syllable,
        operand_src => exe_operand_src,    
        operand_dst => exe_operand_dst,
        immediate => exe_immediate,
        offset => exe_offset,

        PC_addr => ctrl_pc_address_s,
        PC_add => ctrl_pc_add_s,
        PC_stop => ctrl_pc_stop_s,
        PC_load => ctrl_pc_load_s
    );

    -- SELECTING UNIT
    alu_64_select_s <= '1' when exe_opc = "00" else
                       '0';

    alu_32_select_s <= '1' when exe_opc = "01" else
                       '0';

    mem_select_s <= '1' when exe_opc = "10" else
                    '0';

    ctrl_select_s <= '1' when exe_opc = "11" else
                     '0';

    -- MUXING GPR ACCESS

    exe_result <= alu64_gr_result_s when exe_opc = "00" else
                  alu32_gr_result_s when exe_opc = "01" else
                  mem_gr_result_s when exe_opc = "10" else
                  (others => '0');

    w_e_wb <= alu64_gr_w_e_s when exe_opc = "00" else
              alu32_gr_w_e_s when exe_opc = "01" else
              mem_gr_w_e_s when exe_opc = "10" else
              '0';

    wb_reg_add <= alu64_gr_add_s when exe_opc = "00" else
                  alu32_gr_add_s when exe_opc = "01" else
                  mem_gr_add_s when exe_opc = "10" else
                  (others => '0');

    -- MUXING MEM ACCESS

    mem_data_out <= mem_data_out_s when exe_opc = "10" else
                    (others => '0');
    
    mem_wrt_addr <= mem_wrt_addr_s when exe_opc = "10" else
                    (others => '0');
    
    mem_wrt_en <= mem_wrt_en_s when exe_opc = "10" else
                  '0';

    -- MUXING PC ACCESS

    PC_addr <= ctrl_pc_address_s when exe_opc = "11" else
               (others => '0');
    
    PC_add <= ctrl_pc_add_s when exe_opc = "11" else
               '0';
    
    PC_stop <= ctrl_pc_stop_s when exe_opc = "11" else
               '0';
    
    PC_load <= ctrl_pc_load_s when exe_opc = "11" else
               '0';
                                                   

clk <= not(clk) after 10ns;
reset <= '0' after 20ns;
exe_opc <= "01";
syllable <= "100000" & --opcode
            "00001" & -- operand_0 register address
            "00011" & -- operand_1 register address
            "00000" & -- result register address
            "00000" & -- shmat
            "000010"; -- function TODO: Remove this

--alu_oper_0 <= x"AAAAAAAA" , x"77777777" after 40ns;
--alu_oper_1 <= x"88888888";
--alu_imm <= x"44444444";
--alu_shamt <= "00000";

--mem_dest_reg <= "00010";
--mem_l_s <= '1';
--mem_data_in <= x"aaaaaaaa";
--mem_add_dec <= x"33345674";
--mem_store_data <= x"12345678";

alu_br_cont <= '1';

end behavioral;

