library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;

entity alu32_tb is

    port (

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)
         );   

end alu32_tb;

architecture Behavioral of alu32_tb is

    signal alu32_select : std_logic := '0';
    signal syllable     : std_logic_vector(63 downto 0):= (others => '0'); 
    signal operand_src  : std_logic_vector(63 downto 0):= (others => '0');
    signal operand_dst  : std_logic_vector(63 downto 0):= (others => '0');
    signal immediate    : std_logic_vector(31 downto 0):= (others => '0');
    signal gr_add_dst   : std_logic_vector(3 downto 0):= (others => '0');
 
begin

   
    ALU32: entity work.alu32 port map (

                                          alu32_select => alu32_select,
                                          syllable => syllable,
                                          operand_src => operand_src,
                                          operand_dst => operand_dst,
                                          immediate => immediate,
                                          gr_add_dst => gr_add_dst,
                                          gr_add_w => gr_add_w,
                                          w_e_gr => w_e_gr,
                                          result_gr => result_gr
                                      );
 
    alu32_select <= '1' after 20ns;

    operand_src <= x"0000000000000003" after 10ns;
    operand_dst <= x"0000000000000005" after 10ns;
    immediate <= x"0000000A" after 10ns;


    syllable <= x"FFFFFFFFFFFFFFFF" after 10ns,
                x"0000000000000004" after 20ns,
                x"000000000000000C" after 30ns,
                x"0000000000000014" after 40ns,
                x"000000000000001C" after 50ns,
                x"0000000000000024" after 60ns,
                x"000000000000002C" after 70ns,
                x"0000000000000034" after 80ns,
                x"000000000000003C" after 90ns,
                x"0000000000000044" after 100ns,
                x"000000000000004C" after 110ns,
                x"0000000000000054" after 120ns,
                x"000000000000005C" after 130ns,
                x"0000000000000064" after 140ns,
                x"000000000000006C" after 150ns,
                x"0000000000000074" after 160ns,
                x"000000000000007C" after 170ns,
                x"0000000000000084" after 180ns,
                x"0000000000000094" after 190ns,
                x"000000000000009C" after 200ns,
                x"00000000000000A4" after 210ns,
                x"00000000000000AC" after 220ns,
                x"00000000000000B4" after 230ns,
                x"00000000000000BC" after 240ns,
                x"00000000000000C4" after 250ns,
                x"00000000000000CC" after 260ns;

end architecture;
