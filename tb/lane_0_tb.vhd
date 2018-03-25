library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;

-- lane for syllable 0

entity lane_0_tb is
  Port ( 
        -- Memory interface                                                                       
        mem_add_wrt  : out std_logic_vector(31 downto 0); -- write address for memory  
        mem_add_read : out std_logic_vector(31 downto 0);           
        mem_data_out : out std_logic_vector(31 downto 0); -- data to write to memory              
-- as a signal        mem_data_in  : in std_logic_vector(31 downto 0);  -- Data from memory                     
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
end lane_0_tb;

architecture Behavioral of lane_0_tb is

signal clk         : std_logic := '0';
signal reset       : std_logic := '1';
signal stop        : std_logic := '1';
signal fetch_compl : std_logic := '0';
signal syllable_0   : std_logic_vector(31 downto 0);

signal cont_0_0    : std_logic_vector(31 downto 0);
signal cont_0_1    : std_logic_vector(31 downto 0);
signal br_cont_0   : std_logic;
signal mem_data_in : std_logic_vector(31 downto 0);


begin

LANE_0: entity work.lane_0 port map (clk        ,
                                     reset      ,
                                     stop       ,
                                     
                                     syllable_0  ,
                                     
                                     cont_0_0   ,
                                     cont_0_1   ,
                                     br_cont_0  ,
                                     
                                     mem_add_wrt ,
                                     mem_add_read,
                                     mem_data_out,
                                     mem_data_in ,
                                     mem_w_e     ,
                 
                                     gr_add_w    ,
                                     gr_data_w   ,
                                     br_add_w    ,
                                     br_data_w   ,
                                     gr_w_e      ,
                                     br_w_e      ,
                                     
                                     branch_add  ,
                                     branch_valid
                                     );
                                     
clk <= not(clk) after 10ns;
reset <= '0' after 20ns;
stop <= '0' after 30ns;
fetch_compl <= '1' after 40ns;

syllable_0 <= 
                "000111" & --opcode
                "00000" & -- oper0 reg add 
                "00000" & -- oper1 reg add          -- Uncomment to test R-TYPE Instructions
                "00011" & -- dest reg add
                "00010" & -- shamt
                "000000" after 80ns, -- func
              
--syllable_0 <= 
                "010111" & --opcode
                "00000" & -- oper0 reg add 
                "00000" & -- oper1 reg add           -- Uncomment to test I-Type Instructions
                "00011" & -- dest reg add
                "00000000000"  after 100ns,-- imediate 
 
--syllable_0 <= 
              "100010" & --opcode       
              "00000" & -- branch register address
              "000000000000001000000"     after 120ns;    

cont_0_0 <= x"aaaaaaaa";
cont_0_1 <= x"cccccccc";
br_cont_0 <= '0';
mem_data_in <= x"bbbbbbbb";           
        
                                     
end Behavioral;
