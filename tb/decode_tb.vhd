library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_tb is
  Port (
      
--        decode_ready  : out std_logic;
--        decode_done   : out std_logic;
        
--        alu_op_0      : out std_logic_vector(31 downto 0);
--        alu_op_1      : out std_logic_vector(31 downto 0);
--        alu_immediate : out std_logic_vector(10 downto 0);
--        alu_opc       : out std_logic_vector(1 downto 0);
--        alu_dest      : out std_logic_vector(4 downto 0);
--        alu_shamt     : out std_logic_vector(4 downto 0);

--        mem_store_d  : out std_logic_vector(31 downto 0);
--        mem_l_s      : out std_logic;
--        mem_r_add    : out std_logic_vector(31 downto 0);
        
--        jump_add     : out std_logic_vector(7 downto 0);
--        br_cont_out  : out std_logic
        
        src_reg_add           : in std_logic_vector(3 downto 0);   -- from fetch stage
        src_reg_cont          : in std_logic_vector(63 downto 0);  -- from GP register file

        exe_operand           : out std_logic_vector(63 downto 0); 
        exe_immediate         : out std_logic_vector(31 downto 0);
        exe_opc               : out std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
        exe_dest_reg          : out std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
        exe_offset            : out std_logic_vector(15 downto 0);

        -- LANE FORWARDING
        exe_result            : in std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding
        wb_reg_add            : in std_logic_vector(3 downto 0)   -- current register address in writeback from exe stage  -> for lane forwrding  
      
       );
end decode_tb;

architecture Behavioral of decode_tb is

signal clk         : std_logic := '0';
signal reset       : std_logic := '1';
signal stop        : std_logic := '1';
signal exe_rdy     : std_logic := '0';
signal fetch_compl : std_logic := '0';
signal syllable    : std_logic_vector(63 downto 0);
signal operand_0   : std_logic_vector(31 downto 0);
signal operand_1   : std_logic_vector(31 downto 0);
signal br_cont_in  : std_logic := '1';
signal stall       : std_logic := '0';
signal mem_dest_reg       : std_logic_vector(4 downto 0);
signal br_reg_add  : std_logic_vector(4 downto 0);
signal branch      : std_logic := '0';

-- AGGIUNTI DENTRO PER ORA NON CI SERVONO
--signal src_reg_add_s : std_logic_vector(3 downto 0);
--signal src_reg_cont_s : std_logic_vector(63 downto 0);
--signal exe_result_s : std_logic_vector(63 downto 0);
--signal wb_reg_add_s : std_logic_vector(3 downto 0);

begin

  DECODE_STAGE: entity work.decode_stage port map (         
  clk                 => clk,
  reset               => reset,
  stop                => stop,
  branch              => branch,

  syllable            => syllable,

  src_reg_add         => src_reg_add,
  src_reg_cont        => src_reg_cont,

  exe_operand         => exe_operand,
  exe_immediate       => exe_immediate,
  exe_opc             => exe_opc,
  exe_dest_reg        => exe_dest_reg,
  exe_offset          => exe_offset,

  -- LANE FORWARDING
  exe_result          => exe_result,
  wb_reg_add          => wb_reg_add
  );

clk <= not(clk) after 10ns;
reset <= '0' after 15ns;
branch <= '1' after 150ns, '0' after 170ns;
stop <= '0' after 5ns;
syllable <= "1111111111111111111111111111111111111111111111111111111111111111";
            
operand_0 <= x"AAAAAAAA";
operand_1 <= x"0000000B";


end behavioral; 
