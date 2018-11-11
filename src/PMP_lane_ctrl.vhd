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

             -- GPR REGISTERS INTERFACE
             exe_result        : out std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding and writeback
             w_e_wb            : out std_logic;
             wb_reg_add        : out std_logic_vector(3 downto 0);   -- current register address in writeback from exe stage   

             -- MEMORY INTERFACE
             mem_data_in      : in std_logic_vector (63 downto 0);
             mem_data_out     : out std_logic_vector (63 downto 0);
             mem_read_addr    : out std_logic_vector (63 downto 0);
             mem_wrt_en       : out std_logic;

             -- PROGRAM COUNTER INTERFACE
             pc_addr          : out std_logic_vector(15 downto 0); -- branch address from control unit
             pc_add           : out std_logic;    
             pc_stop          : out std_logic;
             pc_load          : out std_logic

         );

end lane_0;

architecture Behavioral of lane_0 is


begin

end Behavioral;
