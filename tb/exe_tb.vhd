library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exe_tb is
  Port (
  
        mem_add_wrt  : out std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0);
        mem_w_e      : out std_logic;
        
        gr_add_w     : out std_logic_vector(4 downto 0);
        gr_data_w    : out std_logic_vector(31 downto 0);
        gr_w_e       : out std_logic;
        
        br_add_w       : out std_logic_vector( 4 downto 0);
        br_data_w      : out std_logic;
        br_w_e         : out std_logic;
       
        branch_add     : out std_logic_vector(7 downto 0);
        branch_valid   : out std_logic
   );
end exe_tb;

architecture Behavioral of exe_tb is

signal clk      : std_logic := '0';
signal reset    : std_logic := '1';
signal exe_opc  : std_logic_vector(1 downto 0);
signal syllable : std_logic_vector(31 downto 0);
signal alu_oper_0 : std_logic_vector(31 downto 0);
signal alu_oper_1 : std_logic_vector(31 downto 0);
signal alu_imm : std_logic_vector(31 downto 0);
signal alu_shamt : std_logic_vector(4 downto 0);
signal alu_gr_dest_add : std_logic_vector(4 downto 0);
signal mem_dest_reg : std_logic_vector(4 downto 0);
signal mem_store_data : std_logic_vector(31 downto 0);
signal mem_l_s : std_logic;
signal mem_add_dec : std_logic_vector(31 downto 0);
signal alu_br_dest_add : std_logic_vector(4 downto 0);
signal jump_add : std_logic_vector(7 downto 0);
signal alu_br_cont : std_logic;
signal mem_data_in : std_logic_vector(31 downto 0);

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

