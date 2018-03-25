library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PMP_core_tb is
  Port ( 
  
            imem_addr     : out std_logic_vector(7 downto 0);     
            dbus_data_out : out std_logic_vector(31 downto 0);
            
            dbus_addr_wrt     : out std_logic_vector(31 downto 0);
            dbus_addr_read_0  : out std_logic_vector(31 downto 0);
            dbus_addr_read_1  : out std_logic_vector(31 downto 0);
            dbus_addr_read_2  : out std_logic_vector(31 downto 0);
            dbus_addr_read_3  : out std_logic_vector(31 downto 0);
            dbus_wrt      : out std_logic;                        
            -- Clock cycles                                       
            cycles        : out std_logic_vector(31 downto 0)     
  
  
  );
end PMP_core_tb;

architecture Behavioral of PMP_core_tb is

signal clk : std_logic := '0';
signal reset : std_logic := '1';
signal start : std_logic := '0';
signal instr : std_logic_vector(255 downto 0) := (others => '0');
signal dbus_data_in_0 : std_logic_vector(31 downto 0);
signal dbus_data_in_1 : std_logic_vector(31 downto 0);
signal dbus_data_in_2 : std_logic_vector(31 downto 0);
signal dbus_data_in_3 : std_logic_vector(31 downto 0);

begin


CORE: entity work.pmp_core port map(
                                    clk,
                                    reset,
                                    start,
                                    imem_addr,
                                    instr,
                                    dbus_data_out,
                                    dbus_data_in_0,
                                    dbus_data_in_1,
                                    dbus_data_in_2,
                                    dbus_data_in_3,
                                
                                    dbus_addr_read_0,
                                    dbus_addr_read_1,
                                    dbus_addr_read_2,
                                    dbus_addr_read_3,
                                    dbus_addr_wrt,
                                    dbus_wrt,
                                    cycles

                                    );

clk <= not(clk) after 10ns;
reset <= '0' after 30ns;
start <= '1' after 50ns;

instr <= x"41004007"&
         x"40e03807"&
         x"40c03007"&
         x"40a02807"&
         x"40802007"&
         x"40601807"&
         x"40401007"&
         x"40200807" after 90ns;     -- add  
         
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"4c20080f" after 110ns, -- slt
         
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"00000000"&
--         x"8020003f" after 130ns, -- branch
         
--          x"00000000"&
--          x"00000000"&
--          x"00000000"&
--          x"00000000"&
--          x"00000000"&
--          x"00000000"&
--          x"00000000"&
--          x"5820000f" after 150ns; -- stw
         
        
dbus_data_in_0 <= x"aaaaaaaa"; 
dbus_data_in_1 <= x"bbbbbbbb";
dbus_data_in_2 <= x"cccccccc";
dbus_data_in_3 <= x"dddddddd";       

end Behavioral;
