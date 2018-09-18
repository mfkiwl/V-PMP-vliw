library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sys_tb is
  Port (

         S0_AXIS_TREADY  : out std_logic;
         M0_AXIS_TVALID  : out std_logic;
         M0_AXIS_TDATA   : out std_logic_vector(255 downto 0);
         M0_AXIS_TKEEP   : out std_logic_vector(31 downto 0);
         M0_AXIS_TLAST   : out std_logic;
         M0_AXIS_TUSER   : out std_logic_vector(127 downto 0);
         
         S_AXI_ARREADY     : out std_logic;                    
         S_AXI_RDATA       : out std_logic_vector(31 downto 0);
         S_AXI_RRESP       : out std_logic_vector(1 downto 0); 
         S_AXI_RVALID      : out std_logic;                    
         S_AXI_WREADY      : out std_logic;                    
         S_AXI_BRESP       : out std_logic_vector(1 downto 0); 
         S_AXI_BVALID      : out std_logic;                    
         S_AXI_AWREADY     : out std_logic                     

       );
end sys_tb;

architecture Behavioral of sys_tb is

  signal clk             : std_logic := '0';
  signal reset           : std_logic := '0'; --negato
  signal S0_AXIS_TDATA   : std_logic_vector(255 downto 0) := (others => '0');
  signal S0_AXIS_TUSER   : std_logic_vector(127 downto 0) := (others => '0');
  signal S0_AXIS_TVALID  : std_logic;
  signal M0_AXIS_TREADY  : std_logic := '1';
  
  signal S_AXI_ACLK        :  std_logic := 'Z';                     
  signal S_AXI_ARESETN     :  std_logic := 'Z';                     
  signal S_AXI_AWADDR      :  std_logic_vector(31 downto 0) := (others => 'Z'); 
  signal S_AXI_AWVALID     :  std_logic := 'Z';                     
  signal S_AXI_WDATA       :  std_logic_vector(31 downto 0) := (others => 'Z') ; 
  signal S_AXI_WSTRB       :  std_logic_vector(3 downto 0) := (others => 'Z');  
  signal S_AXI_WVALID      :  std_logic := 'Z';                     
  signal S_AXI_BREADY      :  std_logic := 'Z';                     
  signal S_AXI_ARADDR      :  std_logic_vector(31 downto 0) := (others => 'Z'); 
  signal S_AXI_ARVALID     :  std_logic := 'Z';                     
  signal S_AXI_RREADY      :  std_logic := 'Z';                     

begin


  SYSTEM: entity work.PMP_sys port map (
  clk,
  reset, 
  M0_AXIS_TVALID,
  M0_AXIS_TREADY,
  M0_AXIS_TDATA,
  M0_AXIS_TKEEP,
  M0_AXIS_TLAST,
  M0_AXIS_TUSER,

  S0_AXIS_TDATA,
  S0_AXIS_TUSER,
  S0_AXIS_TVALID,
  S0_AXIS_TREADY,
  
  S_AXI_ACLK    ,
  S_AXI_ARESETN ,
  S_AXI_AWADDR  ,
  S_AXI_AWVALID ,
  S_AXI_WDATA   ,
  S_AXI_WSTRB   ,
  S_AXI_WVALID  ,
  S_AXI_BREADY  ,
  S_AXI_ARADDR  ,
  S_AXI_ARVALID ,
  S_AXI_RREADY  ,
  S_AXI_ARREADY ,
  S_AXI_RDATA   ,
  S_AXI_RRESP   ,
  S_AXI_RVALID  ,
  S_AXI_WREADY  ,
  S_AXI_BRESP   ,
  S_AXI_BVALID  ,
  S_AXI_AWREADY 

);

clk <= not(clk) after 10ns;
reset <= '0' after 30ns;
S0_AXIS_TVALID <= '1' after 10 ns;

--S0_AXIS_TDATA <= x"20a0a0a0ccc0c6b6a10010004060008010006080ccc0c6b6a100ffffffffffff" after 10ns,
  --               x"0000000000000000000000000000000000000000000010a0a0a0a00000000000" after 30ns,
    --               (others => '0') after 70ns; ARP PACKET

S0_AXIS_TDATA <= x"8a0c26108a0ca93911080000d522440000540080f567ca96f848ffffffffffff" after 10ns,
                 x"5455478355357587556574241414f477b6453545f6052d260300b970d02cff10" after 30ns,
                 x"0000000000000000000000000000141524036424251645a433263793742514d4" after 50ns,
                 (others => '0') after 70ns; 



S0_AXIS_TUSER <= x"000000000000000000000000400100c8";



end Behavioral;
