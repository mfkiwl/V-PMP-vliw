library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_tb is
    Port (

             exe_operand           : out std_logic_vector(63 downto 0); 
             exe_immediate         : out std_logic_vector(31 downto 0);
             exe_opc               : out std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
             exe_dest_reg          : out std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
             exe_offset            : out std_logic_vector(15 downto 0);
             dbus_addr_read        : out std_logic_vector(63 downto 0)

);
end decode_tb;

architecture Behavioral of decode_tb is

    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal syllable     : std_logic_vector(63 downto 0);
    signal branch       : std_logic := '0';
    signal src_reg_add  : std_logic_vector(3 downto 0) := "0000";
    signal src_reg_cont : std_logic_vector(63 downto 0) := (others => '0');
    signal exe_result   : std_logic_vector(63 downto 0) := x"000000000000000A";
    signal wb_reg_add   : std_logic_vector(3 downto 0) := x"a";


begin

    DECODE_STAGE: entity work.decode_stage port map (         
                                                        clk                 => clk,
                                                        reset               => reset,
                                                        branch              => branch,

                                                        syllable            => syllable,

                                                        src_reg_add         => src_reg_add,
                                                        src_reg_cont        => src_reg_cont,

                                                        exe_operand         => exe_operand,
                                                        exe_immediate       => exe_immediate,
                                                        exe_opc             => exe_opc,
                                                        exe_dest_reg        => exe_dest_reg,
                                                        exe_offset          => exe_offset,
                                                        
                                                        dbus_addr_read => dbus_addr_read,

                                                        -- LANE FORWARDING
                                                        exe_result          => exe_result,
                                                        wb_reg_add          => wb_reg_add
                                                    );

    clk <= not(clk) after 10ns;
    reset <= '0' after 15ns;
    branch <= '1' after 150ns, '0' after 170ns;
    wb_reg_add <= x"0" after 50ns;
    syllable <= "0000000000000000000000000000000000000000000000010000000000011000";

end behavioral; 
