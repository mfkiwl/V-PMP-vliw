library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

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

                exe_operand   <= (others => '0');  
                exe_immediate <= (others => '0');
                exe_opc       <= (others => '0');
                exe_dest_reg  <= (others => '0');
                exe_offset    <= (others => '0');

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

                    exe_opc <= "00";

                elsif(std_match((syllable(7 downto 0)), ALU32)) then

                    exe_opc <= "01";

                elsif(std_match((syllable(7 downto 0)), MEM)) then

                    exe_opc <= "10";

                elsif(std_match((syllable(7 downto 0)), BRCH)) then

                    exe_opc <= "11";

                end if;

            end if;

        end if;

    end process;

end Behavioral;
