library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;

entity alu64_tb is

    port (

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)
         );   

end alu64_tb;

architecture Behavioral of alu64_tb is

    signal alu64_select : std_logic := '0';
    signal syllable     : std_logic_vector(63 downto 0):= (others => '0'); 
    signal operand_src  : std_logic_vector(63 downto 0):= (others => '0');
    signal operand_dst  : std_logic_vector(63 downto 0):= (others => '0');
    signal immediate    : std_logic_vector(31 downto 0):= (others => '0');
    signal gr_add_dst   : std_logic_vector(3 downto 0):= (others => '0');
 
begin

   
    ALU64: entity work.alu64 port map (

                                          alu64_select => alu64_select,
                                          syllable => syllable,
                                          operand_src => operand_src,
                                          operand_dst => operand_dst,
                                          immediate => immediate,
                                          gr_add_dst => gr_add_dst,
                                          gr_add_w => gr_add_w,
                                          w_e_gr => w_e_gr,
                                          result_gr => result_gr
                                      );
 
    alu64_select <= '1' after 20ns;

    operand_src <= x"0000000000000003" after 10ns;
    operand_dst <= x"0000000000000005" after 10ns;
    immediate <= x"0000000A" after 10ns;


    syllable <= x"FFFFFFFFFFFFFFFF" after 10ns,
                x"0000000000000007" after 20ns,
                x"000000000000000F" after 30ns,
                x"0000000000000017" after 40ns,
                x"000000000000001F" after 50ns,
                x"0000000000000027" after 60ns,
                x"000000000000002F" after 70ns,
                x"0000000000000037" after 80ns,
                x"000000000000003F" after 90ns,
                x"0000000000000047" after 100ns,
                x"000000000000004F" after 110ns,
                x"0000000000000057" after 120ns,
                x"000000000000005F" after 130ns,
                x"0000000000000067" after 140ns,
                x"000000000000006F" after 150ns,
                x"0000000000000077" after 160ns,
                x"000000000000007F" after 170ns,
                x"0000000000000087" after 180ns,
                x"0000000000000097" after 190ns,
                x"000000000000009F" after 200ns,
                x"00000000000000A7" after 210ns,
                x"00000000000000AF" after 220ns,
                x"00000000000000B7" after 230ns,
                x"00000000000000BF" after 240ns,
                x"00000000000000C7" after 250ns,
                x"00000000000000CF" after 260ns;

end architecture;