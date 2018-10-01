library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.common_pkg.all;


entity decode_stage is

    Port (
             clk                   : in std_logic;
             reset                 : in std_logic;
             branch                : in std_logic;    

             syllable              : in std_logic_vector(63 downto 0);

             src_reg_add           : in std_logic_vector(3 downto 0);   -- from fetch stage
             src_reg_cont          : in std_logic_vector(63 downto 0);  -- from GP register file

             exe_operand           : out std_logic_vector(63 downto 0); 
             exe_immediate         : out std_logic_vector(31 downto 0);
             exe_opc               : out std_logic_vector(1 downto 0);  -- execution stage opc 00=alu64, 01=alu32, 10= mem, 11= branch
             exe_dest_reg          : out std_logic_vector(3 downto 0);  -- exe stage destination register for writeback 
             exe_offset            : out std_logic_vector(15 downto 0);

             -- READ BUS FOR PREFETCH
             dbus_addr_read        : out std_logic_vector(63 downto 0);  -- data bus address read for memory prefetch

             -- LANE FORWARDING
             exe_result            : in std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding
             wb_reg_add            : in std_logic_vector(3 downto 0)   -- current register address in writeback from exe stage  -> for lane forwrding   

         );

end decode_stage;

architecture Behavioral of decode_stage is

begin


    decode_output: process(clk)

    begin

        if rising_edge(clk) then

            if (reset = '1') then

                exe_operand    <= (others => '0');  
                exe_immediate  <= (others => '0');
                exe_opc        <= (others => '0');
                exe_dest_reg   <= (others => '0');
                exe_offset     <= (others => '0');

            else
                -- DECODING

                if (wb_reg_add = src_reg_add) then

                    exe_operand <= exe_result; -- LANE FORWARDING

                else

                    exe_operand   <= src_reg_cont;

                end if;

                exe_immediate <= syllable(63 downto 32);
                exe_dest_reg  <= syllable (15 downto 12);

                if(std_match((syllable(7 downto 0)), ALU64)) then

                    REPORT "ALU64";
                    exe_opc <= "00";

                elsif(std_match((syllable(7 downto 0)), ALU32)) then

                    REPORT "ALU32";
                    exe_opc <= "01";

                elsif(std_match((syllable(7 downto 0)), MEM)) then 

                    report "MEM";
                    exe_opc <= "10";

                    if (syllable(1)= '0') then

                        if (wb_reg_add = src_reg_add) then

                            dbus_addr_read <= exe_result + (x"000000000000" & syllable (31 downto 16)); -- PREFETCH with FORWARDING
                        else

                            dbus_addr_read <= src_reg_cont + (x"000000000000" & syllable (31 downto 16)); -- PREFETCH

                        end if;



                    end if;

                elsif(std_match((syllable(7 downto 0)), BRCH)) then

                    REPORT "BRCH";
                    exe_opc <= "11";

                end if;

            end if;

        end if;

    end process;


end Behavioral;
