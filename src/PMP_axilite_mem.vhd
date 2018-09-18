library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity AXI4tomem is
  Generic (C_BASEADDR  : std_logic_vector(31 downto 0)   := x"00000000"); 
  Port ( 
  
         --AXI/mem interface
         we: out std_logic;
         addr : out std_logic_vector(10 downto 0); 
         data_to_mem : out std_logic_vector(31 downto 0);
         data_from_mem : in std_logic_vector(31 downto 0);
                      
         -- Ports of Axi Slave Bus Interface S_AXI
         S_AXI_ACLK        : in std_logic;  
         S_AXI_ARESETN    : in std_logic;                                     
         S_AXI_AWADDR    : in std_logic_vector(31 downto 0);     
         S_AXI_AWVALID    : in std_logic; 
         S_AXI_WDATA     : in std_logic_vector(31 downto 0); 
         S_AXI_WSTRB     : in std_logic_vector(3 downto 0);   
         S_AXI_WVALID    : in std_logic;                                    
         S_AXI_BREADY    : in std_logic;                                    
         S_AXI_ARADDR    : in std_logic_vector(31 downto 0);
         S_AXI_ARVALID    : in std_logic;                                     
         S_AXI_RREADY    : in std_logic;                                     
         S_AXI_ARREADY    : out std_logic;             
         S_AXI_RDATA    : out std_logic_vector(31 downto 0);
         S_AXI_RRESP    : out std_logic_vector(1 downto 0);
         S_AXI_RVALID    : out std_logic;                                   
         S_AXI_WREADY    : out std_logic; 
         S_AXI_BRESP    : out std_logic_vector(1 downto 0);                         
         S_AXI_BVALID    : out std_logic;                                    
         S_AXI_AWREADY  : out std_logic 
         
         
  );
  
end AXI4tomem;


architecture Behavioral of AXI4tomem is
-- ----------------------------------------------------------------------------
-- signals for AXI Lite
-- ----------------------------------------------------------------------------

--type axi_states is (addr_wait, read_state, write_state, response_state);
--signal axi_state : axi_states;
    signal axi_state :std_logic_vector(2 downto 0);
    signal address : std_logic_vector(31 downto 0);
    signal reg_test0 : std_logic_vector(31 downto 0);
    signal write_enable: std_logic;
    signal read_enable: std_logic;
    signal int_S_AXI_BVALID: std_logic;

begin 
-- unused signals
    S_AXI_BRESP <= "00";
    S_AXI_RRESP <= "00";

    -- axi-lite slave state machine
    AXI_SLAVE_FSM: process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN='0' then -- slave reset state
                S_AXI_RVALID <= '0';
                int_S_AXI_BVALID <= '0';
                S_AXI_ARREADY <= '0';
                S_AXI_WREADY <= '0';
                S_AXI_AWREADY <= '0';
                --axi_state <= addr_wait;
                axi_state <= "000";
                address <= (others=>'0');
                write_enable <= '0';
            else
                case axi_state is
                    --when addr_wait => 
                    when "000" => 
                        S_AXI_AWREADY <= '1';
                        S_AXI_ARREADY <= '1';
                        S_AXI_WREADY <= '0';
                        S_AXI_RVALID <= '0';
                        int_S_AXI_BVALID <= '0';
                        read_enable <= '0';
                        write_enable <= '0';
                        -- wait for a read or write address and latch it in
                        if S_AXI_ARVALID = '1' then -- read
                            --axi_state <= read_state;
                            axi_state <= "001";
                            address <= S_AXI_ARADDR - C_BASEADDR;
                            read_enable <= '1';
                        elsif (S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then -- write
                            --axi_state <= write_state;
                            axi_state <= "100";
                            address <= S_AXI_AWADDR - C_BASEADDR;
                        else
                            --axi_state <= addr_wait;
                            axi_state <= "000";
                        end if;

                    --when read_state (wait1) =>
                    when "001" =>
                        read_enable <= '1';
                        S_AXI_AWREADY <= '0';
                        S_AXI_ARREADY <= '0';
                        -- place correct data on bus and generate valid pulse
                        int_S_AXI_BVALID <= '0';
                        S_AXI_RVALID <= '0';
                        --axi_state <= read_wait2;
                        axi_state <= "010";

                    --when read_state (wait2) =>
                    when "010" =>
                        read_enable <= '1';
                        S_AXI_AWREADY <= '0';
                        S_AXI_ARREADY <= '0';
                        -- place correct data on bus and generate valid pulse
                        int_S_AXI_BVALID <= '0';
                        S_AXI_RVALID <= '0';
                        --axi_state <= response_state;
                        axi_state <= "011";

                    --when read_state =>
                    when "011" =>
                        read_enable <= '1';
                        S_AXI_AWREADY <= '0';
                        S_AXI_ARREADY <= '0';
                        -- place correct data on bus and generate valid pulse
                        int_S_AXI_BVALID <= '0';
                        S_AXI_RVALID <= '1';
                        --axi_state <= response_state;
                        axi_state <= "111";

                    --when write_state =>
                    when "100" =>
                        -- generate a write pulse
                        write_enable <= '1';
                        S_AXI_AWREADY <= '0';
                        S_AXI_ARREADY <= '0';
                        S_AXI_WREADY <= '1';
                        int_S_AXI_BVALID <= '1';
                        --axi_state <= response_state;
                        axi_state <= "111";

                    --when response_state =>
                    when "111" =>
                        read_enable <= '0';
                        write_enable <= '0';
                        S_AXI_AWREADY <= '0';
                        S_AXI_ARREADY <= '0';
                        S_AXI_WREADY <= '0';
                        -- wait for response from master
                        if (S_AXI_RREADY = '1') or (int_S_AXI_BVALID = '1' and S_AXI_BREADY = '1') then
                            S_AXI_RVALID <= '0';
                            int_S_AXI_BVALID <= '0';
                            --axi_state <= addr_wait;
                            axi_state <= "000";
                        else
                            --axi_state <= response_state;
                            axi_state <= "111";
                        end if;
                    when others =>
                        null; 
                end case;
            end if;
        end if;
    end process;
    S_AXI_BVALID <= int_S_AXI_BVALID;


    REG_WRITE_PROCESS: process(S_AXI_ACLK)
    begin
        if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
            if (S_AXI_ARESETN = '0') then
                reg_test0      <= x"bebababe";
            elsif (write_enable='1') then
                if (address(31 downto 4)=x"0000fff") then
                    reg_test0 <= S_AXI_WDATA;
                end if;
            end if;
        end if;
    end process;

    REG_READ_PROCESS: process(reg_test0,address,data_from_mem)
    begin
        if address(31 downto 4) = x"0000fff" then
            S_AXI_RDATA <= reg_test0;
        else
            S_AXI_RDATA <= data_from_mem;
        end if;
    end process;
    
    
we <= write_enable when (address(31 downto 13)="000000000000000000") else '0';
addr <= address(12 downto 2);
data_to_mem <= S_AXI_WDATA;

end architecture;
