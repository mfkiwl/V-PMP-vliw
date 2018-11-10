library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;

entity pc is

    Port ( 

             clk        : in std_logic;
             inc        : in std_logic; -- '1' to increment program counter, from fetch stage
             rst        : in std_logic; -- '1' to reset program counter, from outside

         -- from the control unit
             pc_addr   : in std_logic_vector(15 downto 0); -- branch address from control unit
             pc_add    : in std_logic;    
             pc_stop   : in std_logic;
             pc_load   : in std_logic;

             PC         : out std_logic_vector(15 downto 0) -- program counter out
         );

end pc;

architecture Behavioral of pc is

    signal pc_s : std_logic_vector(15 downto 0) := (others =>'1');
    signal stop_toggle : std_logic:= '0';

begin

    TOGGLE_STOP:process(clk)
    begin
        if rising_edge(clk) then
           
            if (rst = '1') then

                stop_toggle <= '0';

            else

                if (pc_stop = '1') or (stop_toggle = '1') then

                    stop_toggle <= '1';

                end if;

            end if;

        end if;
    end process;


    process (clk)
    begin
        if rising_edge (clk) then

            if (rst = '0') then

                if (inc = '1') and (stop_toggle = '0') then

                    pc_s <= pc_s + 1;

                end if;

                if (pc_add = '1') then

                    pc_s <= pc_s + pc_addr;

                elsif (pc_load = '1') then

                    pc_s <= pc_addr;

                end if;

            else

                pc_s <= (others => '1');

            end if;

        end if;  

    end process;

    PC <= pc_s;

end Behavioral;
