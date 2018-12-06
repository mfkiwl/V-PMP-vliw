library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;
-- This unit goes only on syllable 0

entity control is

    Port ( 
             ctrl_select     : in std_logic; 

             syllable         : in std_logic_vector(63 downto 0);
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             offset           : in std_logic_vector(15 downto 0);

             PC_addr          : out std_logic_vector(15 downto 0); --address to add to PC
             PC_add           : out std_logic;
             PC_stop          : out std_logic;
             PC_load          : out std_logic

);

end control;

architecture Behavioral of control is

    signal opc : std_logic_vector(7 downto 0);
    signal opc_string : string(1 to 6);

begin

    opc <= syllable(7 downto 0);

    process(ctrl_select, opc, immediate, operand_src, operand_dst, offset)

    begin
 
    PC_addr <= (others => '0');
    PC_load <= '0';
    PC_add <= '0';
    PC_stop <= '0';

        if (ctrl_select = '0') then

            PC_addr <= (others => '0');
            PC_load <= '0';
            PC_add <= '0';
            PC_stop <= '0';

        else 

            case opc is

                when JA_OPC =>
                    opc_string <= "____JA";
                    PC_addr <= offset;
                    PC_add <= '1';

                when JEQI_OPC =>
                    opc_string <= "__JEQI";
                    if (operand_dst(31 downto 0) = immediate) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JEQ_OPC =>
                    opc_string <= "___JEQ";
                    if (operand_dst = operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JGTI_OPC =>
                    opc_string <= "__JGTI";
                    if (operand_dst(31 downto 0) > immediate) then
                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JGT_OPC =>
                    opc_string <= "___JGT";
                    if (operand_dst > operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JGEI_OPC =>
                    opc_string <= "__JGEI";
                    if (operand_dst(31 downto 0) >= immediate) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JGE_OPC =>
                    opc_string <= "___JGE";
                    if (operand_dst >= operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JLTI_OPC =>
                    opc_string <= "__JLTI";
                    if (operand_dst(31 downto 0) < immediate) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JLT_OPC =>
                    opc_string <= "___JLT";
                    if (operand_dst < operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JLEI_OPC =>
                    opc_string <= "__JLEI";
                    if (operand_dst(31 downto 0) <= immediate) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JLE_OPC =>
                    opc_string <= "___JLE";
                    if (operand_dst <= operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSETI_OPC =>
                    opc_string <= "_JSETI";
                    if ((operand_dst(31 downto 0) and immediate) /= x"00000000") then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSET_OPC =>
                    opc_string <= "__JSET";
                    if ((operand_dst and operand_src) /= x"00000000") then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JNEI_OPC =>
                    opc_string <= "__JNEI";
                    if (operand_dst(31 downto 0) /= immediate) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JNE_OPC =>
                    opc_string <= "___JNE";
                    if (operand_dst /= operand_src) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSGTIS_OPC =>
                    opc_string <= "JSGTIS";
                    if (signed(operand_dst(31 downto 0)) > signed(immediate)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSGTS_OPC =>
                    opc_string <= "JSGTS_";
                    if (signed(operand_dst) > signed(operand_src)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSGEIS_OPC =>
                    opc_string <= "JSGEIS";
                    if (signed(operand_dst(31 downto 0)) >= signed(immediate)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSGES_OPC =>
                    opc_string <= "_JSGES";
                    if (signed(operand_dst) >= signed(operand_src)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSLTIS_OPC =>
                    opc_string <= "JSLTIS";
                    if (signed(operand_dst(31 downto 0)) < signed(immediate)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSLTS_OPC =>
                    opc_string <= "JSLTS_";
                    if (signed(operand_dst) < signed(operand_src)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSLEIS_OPC =>
                    opc_string <= "JSLEIS";
                    if (signed(operand_dst(31 downto 0)) <= signed(immediate)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when JSLES_OPC =>
                    opc_string <= "_JSLES";
                    if (signed(operand_dst) <= signed(operand_src)) then

                        PC_addr <= offset;
                        PC_add <= '1';

                    end if;

                when CALL_OPC =>
                    opc_string <= "_CALL_";
                    PC_addr <= immediate(15 downto 0);
                    PC_load <= '1';

                when EXIT_OPC =>
                    opc_string <= "_EXIT_";
                    PC_addr <= immediate(15 downto 0);
                    PC_stop <= '1';

                when others =>
                    opc_string <= "OTHERS";
                    PC_addr <= (others => '0');
                    PC_load <= '0';
                    PC_add <= '0';
                    PC_stop <= '0';

            end case;

        end if;

    end process;

end Behavioral;
