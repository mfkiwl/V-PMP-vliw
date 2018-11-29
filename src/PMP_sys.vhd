library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PMP_sys is
  Generic ( RESET_ACTIVE_LOW : boolean := false); 

  Port ( 

         clk    : in std_logic;
         reset  : in std_logic;

         -- Ports of AXI-Stream bus interface
         M0_AXIS_TVALID  : out std_logic;
         M0_AXIS_TREADY  : in std_logic;
         M0_AXIS_TDATA   : out std_logic_vector(255 downto 0);
         M0_AXIS_TKEEP   : out std_logic_vector(31 downto 0);
         M0_AXIS_TLAST   : out std_logic;
         M0_AXIS_TUSER   : out std_logic_vector(127 downto 0);

         S0_AXIS_TDATA   : in std_logic_vector(255 downto 0);
         S0_AXIS_TUSER   : in std_logic_vector(127 downto 0);
         S0_AXIS_TVALID  : in std_logic;
         S0_AXIS_TREADY  : out std_logic;


         -- Ports of Axi Slave Bus Interface S_AXI
         S_AXI_ACLK        : in std_logic;  
         S_AXI_ARESETN     : in std_logic;                                     
         S_AXI_AWADDR      : in std_logic_vector(31 downto 0);     
         S_AXI_AWVALID     : in std_logic; 
         S_AXI_WDATA       : in std_logic_vector(31 downto 0); 
         S_AXI_WSTRB       : in std_logic_vector(3 downto 0);   
         S_AXI_WVALID      : in std_logic;                                    
         S_AXI_BREADY      : in std_logic;                                    
         S_AXI_ARADDR      : in std_logic_vector(31 downto 0);
         S_AXI_ARVALID     : in std_logic;                                     
         S_AXI_RREADY      : in std_logic;                                     
         S_AXI_ARREADY     : out std_logic;             
         S_AXI_RDATA       : out std_logic_vector(31 downto 0);
         S_AXI_RRESP       : out std_logic_vector(1 downto 0);
         S_AXI_RVALID      : out std_logic;                                   
         S_AXI_WREADY      : out std_logic; 
         S_AXI_BRESP       : out std_logic_vector(1 downto 0);                         
         S_AXI_BVALID      : out std_logic;                                    
         S_AXI_AWREADY     : out std_logic 

       );

end PMP_sys;

architecture Behavioral of PMP_sys is

  signal reset_s             : std_logic;
  signal imem_addr_s         : std_logic_vector(15 downto 0);
  signal imem_instr_s        : std_logic_vector(511 downto 0);

  signal dbus_data_out_0_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_1_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_2_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_3_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_4_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_5_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_6_s     : std_logic_vector(63 downto 0);
  signal dbus_data_out_7_s     : std_logic_vector(63 downto 0);

  signal dbus_data_amnt_0_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_1_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_2_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_3_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_4_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_5_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_6_s : std_logic_vector(4 downto 0);
  signal dbus_data_amnt_7_s : std_logic_vector(4 downto 0);

  signal dbus_data_in_0_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_1_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_2_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_3_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_4_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_5_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_6_s    : std_logic_vector(63 downto 0);
  signal dbus_data_in_7_s    : std_logic_vector(63 downto 0);

  signal dbus_addr_read_0_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_1_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_2_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_3_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_4_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_5_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_6_s  : std_logic_vector(63 downto 0);
  signal dbus_addr_read_7_s  : std_logic_vector(63 downto 0);

  signal dbus_add_wrt_0_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_1_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_2_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_3_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_4_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_5_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_6_s      : std_logic_vector(63 downto 0);
  signal dbus_add_wrt_7_s      : std_logic_vector(63 downto 0);

  signal dbus_w_e_0_s          : std_logic;
  signal dbus_w_e_1_s          : std_logic;
  signal dbus_w_e_2_s          : std_logic;
  signal dbus_w_e_3_s          : std_logic;
  signal dbus_w_e_4_s          : std_logic;
  signal dbus_w_e_5_s          : std_logic;
  signal dbus_w_e_6_s          : std_logic;
  signal dbus_w_e_7_s          : std_logic;

  signal start_s             : std_logic;
  signal stop_s              : std_logic;
  signal cycles_s            : std_logic_vector(31 downto 0);

  signal axis_data_read_0_s  : std_logic_vector(63 downto 0); -- addresses for AXIS_DATA_RAM
  signal axis_data_read_1_s  : std_logic_vector(63 downto 0);
  signal axis_data_read_2_s  : std_logic_vector(63 downto 0);
  signal axis_data_read_3_s  : std_logic_vector(63 downto 0);
  signal axis_data_read_4_s  : std_logic_vector(63 downto 0); 
  signal axis_data_read_5_s  : std_logic_vector(63 downto 0);
  signal axis_data_read_6_s  : std_logic_vector(63 downto 0);
  signal axis_data_read_7_s  : std_logic_vector(63 downto 0);

  signal axis_data_out_0_s   : std_logic_vector(63 downto 0); -- data from AXIS_DATA_RAM
  signal axis_data_out_1_s   : std_logic_vector(63 downto 0);
  signal axis_data_out_2_s   : std_logic_vector(63 downto 0);
  signal axis_data_out_3_s   : std_logic_vector(63 downto 0);
  signal axis_data_out_4_s   : std_logic_vector(63 downto 0); 
  signal axis_data_out_5_s   : std_logic_vector(63 downto 0);
  signal axis_data_out_6_s   : std_logic_vector(63 downto 0);
  signal axis_data_out_7_s   : std_logic_vector(63 downto 0);

  signal axis_wrt_add_s      : std_logic_vector(5 downto 0);  -- write address from data ram to tuser ram of axis

  signal axis_tuser_read_0_s : std_logic_vector(63 downto 0); -- read addresses for tuser
  signal axis_tuser_read_1_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_2_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_3_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_4_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_5_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_6_s : std_logic_vector(63 downto 0);
  signal axis_tuser_read_7_s : std_logic_vector(63 downto 0);

  signal axis_tuser_out_0_s  : std_logic_vector(63 downto 0); -- data from tuser out
  signal axis_tuser_out_1_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_2_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_3_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_4_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_5_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_6_s  : std_logic_vector(63 downto 0);
  signal axis_tuser_out_7_s  : std_logic_vector(63 downto 0);

  signal data_ram_addr_read_0 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_1 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_2 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_3 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_4 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_5 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_6 : std_logic_vector(7 downto 0);
  signal data_ram_addr_read_7 : std_logic_vector(7 downto 0);

  signal data_ram_addr_wrt_0 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_1 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_2 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_3 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_4 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_5 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_6 : std_logic_vector(7 downto 0);
  signal data_ram_addr_wrt_7 : std_logic_vector(7 downto 0);

  signal data_ram_data_out_0 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_1 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_2 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_3 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_4 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_5 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_6 : std_logic_vector(63 downto 0);
  signal data_ram_data_out_7 : std_logic_vector(63 downto 0);

  signal data_ram_data_in_0 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_1 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_2 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_3 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_4 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_5 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_6 : std_logic_vector(63 downto 0);
  signal data_ram_data_in_7 : std_logic_vector(63 downto 0);

  signal data_ram_wrt_en_0 : std_logic;
  signal data_ram_wrt_en_1 : std_logic;
  signal data_ram_wrt_en_2 : std_logic;
  signal data_ram_wrt_en_3 : std_logic;
  signal data_ram_wrt_en_4 : std_logic;
  signal data_ram_wrt_en_5 : std_logic;
  signal data_ram_wrt_en_6 : std_logic;
  signal data_ram_wrt_en_7 : std_logic;

  signal m_axis_addr_0_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_1_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_2_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_3_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_4_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_5_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_6_s      : std_logic_vector(4 downto 0);
  signal m_axis_addr_7_s      : std_logic_vector(4 downto 0);

  signal m_axis_tready_s       : std_logic;

  signal m_wrt_en_tdata_0_s    : std_logic;
  signal m_wrt_en_tdata_1_s    : std_logic;
  signal m_wrt_en_tdata_2_s    : std_logic;
  signal m_wrt_en_tdata_3_s    : std_logic;
  signal m_wrt_en_tdata_4_s    : std_logic;
  signal m_wrt_en_tdata_5_s    : std_logic;
  signal m_wrt_en_tdata_6_s    : std_logic;
  signal m_wrt_en_tdata_7_s    : std_logic;

  signal m_wrt_en_tuser_0_s    : std_logic;
  signal m_wrt_en_tuser_1_s    : std_logic;
  signal m_wrt_en_tuser_2_s    : std_logic;
  signal m_wrt_en_tuser_3_s    : std_logic;
  signal m_wrt_en_tuser_4_s    : std_logic;
  signal m_wrt_en_tuser_5_s    : std_logic;
  signal m_wrt_en_tuser_6_s    : std_logic;
  signal m_wrt_en_tuser_7_s    : std_logic;

  signal m_axis_tvalid : std_logic;
  signal m_axis_tlast  : std_logic;
  signal m_axis_tkeep  : std_logic_vector(31 downto 0);
  signal tvalid_interlock : std_logic;
  signal tkeep_interlock    : std_logic_vector(31 downto 0);
  signal tlast_interlock    : std_logic;

  signal bytes_amount_dma_s : std_logic_vector(15 downto 0);
  signal start_addr_dma_s   : std_logic_vector(8 downto 0);
  signal start_dma_s        : std_logic;
  signal data_in_dma_axis_s      : std_logic_vector(255 downto 0);
  signal data_in_dma_data_s      : std_logic_vector(255 downto 0);
  signal out_addr_dma_axis_s     : std_logic_vector(8 downto 0); -- TO AXIS TDATA FIFO
  signal out_addr_dma_data_s     : std_logic_vector(4 downto 0); -- TO AXIS TDATA FIFO
  signal tkeep_dma_s        : std_logic_vector(31 downto 0); -- TO OUT INTERFACE
  signal tvalid_dma_s       : std_logic; -- TO OUT INTERFCAE
  signal done_dma_s         : std_logic; -- TO BRANCH REGISTER
  signal w_e_dma_s          : std_logic; -- TO OUT INTERFACE
  signal data_out_dma_s     : std_logic_vector(255 downto 0); -- TO OUT INTERFACE
  signal dma_tlast_end      : std_logic; -- TLAST WHEN FINISHED TRANSFERRING
  signal dma_tlast          : std_logic; -- TLAST to OUT INTERFACE


  signal mem_we:       std_logic;
  signal mem_addr:     std_logic_vector(10 downto 0); 
  signal mem_data_in:  std_logic_vector(31 downto 0);
  signal mem_data_out: std_logic_vector(31 downto 0);


begin

tvalid_interlock <= (m_axis_tvalid) or (tvalid_dma_s);
tkeep_interlock <= (m_axis_tkeep) or (tkeep_dma_s);
tlast_interlock <= (m_axis_tlast) or (dma_tlast);

  PMP_CORE: entity work.PMP_core port map (
  clk,
  reset_s,
  start_s,

  imem_addr_s,
  imem_instr_s,

  dbus_data_in_0_s,
  dbus_data_in_1_s,
  dbus_data_in_2_s,
  dbus_data_in_3_s,
  dbus_data_in_4_s,
  dbus_data_in_5_s,
  dbus_data_in_6_s,
  dbus_data_in_7_s,

  dbus_data_out_0_s,
  dbus_data_out_1_s,
  dbus_data_out_2_s,
  dbus_data_out_3_s,
  dbus_data_out_4_s,
  dbus_data_out_5_s,
  dbus_data_out_6_s,
  dbus_data_out_7_s,

  dbus_data_amnt_0_s ,
  dbus_data_amnt_1_s ,
  dbus_data_amnt_2_s ,
  dbus_data_amnt_3_s ,
  dbus_data_amnt_4_s ,
  dbus_data_amnt_5_s ,
  dbus_data_amnt_6_s ,
  dbus_data_amnt_7_s ,

  dbus_addr_read_0_s,
  dbus_addr_read_1_s,
  dbus_addr_read_2_s,
  dbus_addr_read_3_s,
  dbus_addr_read_4_s,
  dbus_addr_read_5_s,
  dbus_addr_read_6_s,
  dbus_addr_read_7_s,

  dbus_add_wrt_0_s,
  dbus_add_wrt_1_s,
  dbus_add_wrt_2_s,
  dbus_add_wrt_3_s,
  dbus_add_wrt_4_s,
  dbus_add_wrt_5_s,
  dbus_add_wrt_6_s,
  dbus_add_wrt_7_s,

  dbus_w_e_0_s,
  dbus_w_e_1_s,
  dbus_w_e_2_s,
  dbus_w_e_3_s,
  dbus_w_e_4_s,
  dbus_w_e_5_s,
  dbus_w_e_6_s,
  dbus_w_e_7_s,

  cycles_s
);

AXIS_TDATA_FIFO: entity work.AXI_DATA_RAM port map(
clk,
S0_AXIS_TDATA,
S0_AXIS_TVALID,

axis_data_read_0_s,
axis_data_read_1_s,
axis_data_read_2_s,
axis_data_read_3_s,
axis_data_read_4_s,
axis_data_read_5_s,
axis_data_read_6_s,
axis_data_read_7_s,

axis_wrt_add_s,

axis_data_out_0_s,
axis_data_out_1_s,
axis_data_out_2_s,
axis_data_out_3_s,
axis_data_out_4_s,
axis_data_out_5_s,
axis_data_out_6_s,
axis_data_out_7_s,

out_addr_dma_axis_s,
data_in_dma_axis_s,

start_s
);

AXIS_TUSER_FIFO: entity work.axi_tuser_ram port map
(
clk,
S0_AXIS_TUSER,
S0_AXIS_TVALID,

axis_tuser_read_0_s,
axis_tuser_read_1_s,
axis_tuser_read_2_s,
axis_tuser_read_3_s,
axis_tuser_read_4_s,
axis_tuser_read_5_s,
axis_tuser_read_6_s,
axis_tuser_read_7_s,

axis_wrt_add_s,

axis_tuser_out_0_s,
axis_tuser_out_1_s,
axis_tuser_out_2_s,
axis_tuser_out_3_s,
axis_tuser_out_4_s,
axis_tuser_out_5_s,
axis_tuser_out_6_s,
axis_tuser_out_7_s 

                                              );

                                              AXIS_OUT_INTERFACE: entity work.m_axis_interlock port map
                                              (
                                              clk,
                                              reset_s,
                                              tvalid_interlock ,
                                              tlast_interlock,
                                              tkeep_interlock,

                                              dbus_data_out_0_s,
                                              dbus_data_out_1_s,
                                              dbus_data_out_2_s,
                                              dbus_data_out_3_s,
                                              dbus_data_out_4_s,
                                              dbus_data_out_5_s,
                                              dbus_data_out_6_s,
                                              dbus_data_out_7_s,

                                              m_axis_addr_0_s ,
                                              m_axis_addr_1_s ,
                                              m_axis_addr_2_s ,
                                              m_axis_addr_3_s ,
                                              m_axis_addr_4_s ,
                                              m_axis_addr_5_s ,
                                              m_axis_addr_6_s ,
                                              m_axis_addr_7_s ,

                                              dbus_data_amnt_0_s ,
                                              dbus_data_amnt_1_s ,
                                              dbus_data_amnt_2_s ,
                                              dbus_data_amnt_3_s ,
                                              dbus_data_amnt_4_s ,
                                              dbus_data_amnt_5_s ,
                                              dbus_data_amnt_6_s ,
                                              dbus_data_amnt_7_s ,

                                              m_wrt_en_tdata_0_s ,
                                              m_wrt_en_tdata_1_s ,
                                              m_wrt_en_tdata_2_s ,
                                              m_wrt_en_tdata_3_s ,
                                              m_wrt_en_tdata_4_s ,
                                              m_wrt_en_tdata_5_s ,
                                              m_wrt_en_tdata_6_s ,
                                              m_wrt_en_tdata_7_s ,

                                              m_wrt_en_tuser_0_s,
                                              m_wrt_en_tuser_1_s,
                                              m_wrt_en_tuser_2_s,
                                              m_wrt_en_tuser_3_s,
                                              m_wrt_en_tuser_4_s,
                                              m_wrt_en_tuser_5_s,
                                              m_wrt_en_tuser_6_s,
                                              m_wrt_en_tuser_7_s,

                                              data_out_dma_s,
                                              w_e_dma_s,

                                              M0_AXIS_TDATA,
                                              M0_AXIS_TVALID,
                                              M0_AXIS_TLAST,
                                              M0_AXIS_TKEEP,
                                              M0_AXIS_TUSER


                                            );

                                            PMP_INSTRUCTION_MEM: entity work.i_mem port map
                                            (
                                            --AXI/MEM interface
                                            S_AXI_ACLK,
                                            mem_we,
                                            mem_addr,
                                            mem_data_in,
                                            mem_data_out,

                                            clk,
                                            reset_s,
                                            imem_addr_s,
                                            imem_instr_s

                                          );

--                                          AXI_LITE_TO_INST_MEM: entity work.AXI4tomem generic map (C_BASEADDR => x"80000000")
--                                          port map
--                                          (

--                                            S_AXI_ACLK       => S_AXI_ACLK,  
--                                            S_AXI_ARESETN    => S_AXI_ARESETN,
--                                            S_AXI_AWADDR     => S_AXI_AWADDR, 
--                                            S_AXI_AWVALID    => S_AXI_AWVALID,
--                                            S_AXI_WDATA      => S_AXI_WDATA,
--                                            S_AXI_WSTRB      => S_AXI_WSTRB,
--                                            S_AXI_WVALID     => S_AXI_WVALID,
--                                            S_AXI_BREADY     => S_AXI_BREADY,
--                                            S_AXI_ARADDR     => S_AXI_ARADDR,
--                                            S_AXI_ARVALID    => S_AXI_ARVALID,
--                                            S_AXI_RREADY     => S_AXI_RREADY, 
--                                            S_AXI_ARREADY    => S_AXI_ARREADY,
--                                            S_AXI_RDATA      => S_AXI_RDATA, 
--                                            S_AXI_RRESP      => S_AXI_RRESP, 
--                                            S_AXI_RVALID     => S_AXI_RVALID,
--                                            S_AXI_WREADY     => S_AXI_WREADY,
--                                            S_AXI_BRESP      => S_AXI_BRESP, 
--                                            S_AXI_BVALID     => S_AXI_BVALID, 
--                                            S_AXI_AWREADY    => S_AXI_AWREADY,
--                                            we               => mem_we,
--                                            addr             => mem_addr,
--                                            data_to_mem      => mem_data_in,
--                                            data_from_mem    => mem_data_out

--                                          );

                                          DMA: ENTITY WORK.PMP_dma port map
                                          (

                                            clk => clk,
                                            reset => reset,
                                            bytes_amount => bytes_amount_dma_s,
                                            start_addr => start_addr_dma_s,
                                            start => start_dma_s,
                                            out_addr_axis => out_addr_dma_axis_s,
                                            data_in_axis => data_in_dma_axis_s,
                                            out_addr_data_ram => out_addr_dma_data_s,
                                            data_in_data_ram => data_in_dma_data_s,
                                            tkeep => tkeep_dma_s,
                                            tvalid => tvalid_dma_s,
                                            tlast => dma_tlast,
                                            tlast_end => dma_tlast_end,
                                            done_transfer => done_dma_s,
                                            w_e => w_e_dma_s,
                                            data_out => data_out_dma_s

                                          );

                                          DATA_RAM: entity work.PMP_data_RAM port map (

                                                                                        clk    => clk, 
                                                                                        reset  => reset_s,     

                                                                                        read_add_0  => data_ram_addr_read_0,
                                                                                        data_out_0  => data_ram_data_out_0,
                                                                                        read_add_1  => data_ram_addr_read_1,
                                                                                        data_out_1  => data_ram_data_out_1,
                                                                                        read_add_2  => data_ram_addr_read_2,
                                                                                        data_out_2  => data_ram_data_out_2,
                                                                                        read_add_3  => data_ram_addr_read_3, 
                                                                                        data_out_3  => data_ram_data_out_3,
                                                                                        read_add_4  => data_ram_addr_read_4,
                                                                                        data_out_4  => data_ram_data_out_4,
                                                                                        read_add_5  => data_ram_addr_read_5,
                                                                                        data_out_5  => data_ram_data_out_5,
                                                                                        read_add_6  => data_ram_addr_read_6, 
                                                                                        data_out_6  => data_ram_data_out_6,
                                                                                        read_add_7  => data_ram_addr_read_7,
                                                                                        data_out_7  => data_ram_data_out_7,
                                                                                        
                                                                                        read_add_dma => out_addr_dma_data_s,
                                                                                        data_out_dma => data_in_dma_data_s,

                                                                                        wrt_add_0   => data_ram_addr_wrt_0,
                                                                                        wrt_en_0    => data_ram_wrt_en_0,
                                                                                        data_in_0   => data_ram_data_in_0,
                                                                                        wrt_add_1   => data_ram_addr_wrt_1,
                                                                                        wrt_en_1    => data_ram_wrt_en_1,
                                                                                        data_in_1   => data_ram_data_in_1,
                                                                                        wrt_add_2   => data_ram_addr_wrt_2,
                                                                                        wrt_en_2    => data_ram_wrt_en_2,
                                                                                        data_in_2   => data_ram_data_in_2,
                                                                                        wrt_add_3   => data_ram_addr_wrt_3,
                                                                                        wrt_en_3    => data_ram_wrt_en_3,
                                                                                        data_in_3   => data_ram_data_in_3,
                                                                                        wrt_add_4   => data_ram_addr_wrt_4,
                                                                                        wrt_en_4    => data_ram_wrt_en_4,
                                                                                        data_in_4   => data_ram_data_in_4,
                                                                                        wrt_add_5   => data_ram_addr_wrt_5,
                                                                                        wrt_en_5    => data_ram_wrt_en_5,
                                                                                        data_in_5   => data_ram_data_out_5,
                                                                                        wrt_add_6   => data_ram_addr_wrt_6,
                                                                                        wrt_en_6    => data_ram_wrt_en_6,
                                                                                        data_in_6   => data_ram_data_in_6,
                                                                                        wrt_add_7   => data_ram_addr_wrt_7,
                                                                                        wrt_en_7    => data_ram_wrt_en_7,
                                                                                        data_in_7   => data_ram_data_in_7
                                                                                      );

                                          -- Muxing read addresses
                                          -- 00 = AXI DATA IN, 01= AXI TUSER IN

                                                                                        dbus_data_in_0_s <= axis_data_out_0_s when (dbus_addr_read_0_s < x"00000200") else
                                                                                                            axis_tuser_out_0_s when ((dbus_addr_read_0_s >= x"00000200") and (dbus_addr_read_0_s < x"00000400")) else
                                                                                                            data_ram_data_out_0 when ((dbus_addr_read_0_s >= x"00000400") and (dbus_addr_read_0_s < x"00000800")) else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_1_s <= axis_data_out_1_s when (dbus_addr_read_1_s < x"00000200") else
                                                                                                            axis_tuser_out_1_s when (dbus_addr_read_1_s >= x"00000200") and (dbus_addr_read_1_s < x"00000400") else
                                                                                                            data_ram_data_out_1 when (dbus_addr_read_1_s >= x"00000400") and (dbus_addr_read_1_s < x"00000800") else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_2_s <= axis_data_out_2_s when (dbus_addr_read_2_s < x"00000200") else
                                                                                                            axis_tuser_out_2_s when (dbus_addr_read_2_s >= x"00000200") and (dbus_addr_read_2_s < x"00000400") else
                                                                                                            data_ram_data_out_2 when (dbus_addr_read_2_s >= x"00000400") and (dbus_addr_read_2_s < x"00000800") else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_3_s <= axis_data_out_3_s when (dbus_addr_read_3_s < x"00000200") else 
                                                                                                            axis_tuser_out_3_s when (dbus_addr_read_3_s >= x"00000200") and (dbus_addr_read_3_s < x"00000400") else
                                                                                                            data_ram_data_out_3 when (dbus_addr_read_3_s >= x"00000400") and (dbus_addr_read_3_s < x"00000800") else
                                                                                                            x"00000000";                                                      

                                                                                        dbus_data_in_4_s <= axis_data_out_4_s when (dbus_addr_read_4_s < x"00000200") else
                                                                                                            axis_tuser_out_4_s when (dbus_addr_read_4_s >= x"00000200") and (dbus_addr_read_4_s < x"00000400") else
                                                                                                            data_ram_data_out_4 when (dbus_addr_read_4_s >= x"00000400") and (dbus_addr_read_4_s < x"00000800") else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_5_s <= axis_data_out_5_s when (dbus_addr_read_5_s < x"00000200") else
                                                                                                            axis_tuser_out_5_s when (dbus_addr_read_5_s >= x"00000200") and (dbus_addr_read_5_s < x"00000400") else
                                                                                                            data_ram_data_out_5 when (dbus_addr_read_5_s >= x"00000400") and (dbus_addr_read_5_s < x"00000800") else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_6_s <= axis_data_out_6_s when (dbus_addr_read_6_s < x"00000200") else
                                                                                                            axis_tuser_out_6_s when (dbus_addr_read_6_s >= x"00000200") and (dbus_addr_read_6_s < x"00000400") else
                                                                                                            data_ram_data_out_6 when (dbus_addr_read_6_s >= x"00000400") and (dbus_addr_read_6_s < x"00000800") else
                                                                                                            x"00000000";

                                                                                        dbus_data_in_7_s <= axis_data_out_7_s when (dbus_addr_read_7_s < x"00000200") else 
                                                                                                            axis_tuser_out_7_s when (dbus_addr_read_7_s >= x"00000200") and (dbus_addr_read_7_s < x"00000400") else
                                                                                                            data_ram_data_out_7 when (dbus_addr_read_7_s >= x"00000400") and (dbus_addr_read_7_s < x"00000800") else
                                                                                                            x"00000000";  

                                          --TDATA in RAM 0x00000000                                                                   
                                                                                        axis_data_read_0_s <= dbus_addr_read_0_s when (dbus_addr_read_0_s < x"00000200") else
                                                                                                              x"00000000";

                                                                                        axis_data_read_1_s <= dbus_addr_read_1_s when (dbus_addr_read_1_s < x"00000200") else
                                                                                                              x"00000000";

                                                                                        axis_data_read_2_s <= dbus_addr_read_2_s when (dbus_addr_read_2_s < x"00000200") else
                                                                                                              x"00000000";                                         

                                                                                        axis_data_read_3_s <= dbus_addr_read_3_s when (dbus_addr_read_3_s < x"00000200") else
                                                                                                              x"00000000";   

                                                                                        axis_data_read_4_s <= dbus_addr_read_4_s when (dbus_addr_read_4_s < x"00000200") else
                                                                                                              x"00000000";

                                                                                        axis_data_read_5_s <= dbus_addr_read_5_s when (dbus_addr_read_5_s < x"00000200") else
                                                                                                              x"00000000";

                                                                                        axis_data_read_6_s <= dbus_addr_read_6_s when (dbus_addr_read_6_s < x"00000200") else
                                                                                                              x"00000000";                                         

                                                                                        axis_data_read_7_s <= dbus_addr_read_7_s when (dbus_addr_read_7_s < x"00000200") else

                                                                                                              x"00000000";                                                                                                                                                  
                                          --DATA RAM

                                                                                        data_ram_addr_read_0 <= dbus_addr_read_0_s(7 downto 0) when (dbus_addr_read_0_s >= x"00000400") and (dbus_addr_read_0_s < x"00000800") else                                      
                                                                                                            x"00";

                                                                                        data_ram_addr_read_1 <= dbus_addr_read_1_s(7 downto 0) when (dbus_addr_read_1_s >= x"00000400") and (dbus_addr_read_1_s < x"00000800") else 
                                                                                                            x"00";                              

                                                                                        data_ram_addr_read_2 <= dbus_addr_read_2_s(7 downto 0)  when (dbus_addr_read_2_s >= x"00000400") and (dbus_addr_read_2_s < x"00000800") else 
                                                                                                            x"00";

                                                                                        data_ram_addr_read_3 <= dbus_addr_read_3_s(7 downto 0)  when (dbus_addr_read_3_s >= x"00000400") and (dbus_addr_read_3_s < x"00000800") else 
                                                                                                            x"00";  

                                                                                        data_ram_addr_read_4 <= dbus_addr_read_4_s(7 downto 0)  when (dbus_addr_read_4_s >= x"00000400") and (dbus_addr_read_4_s < x"00000800") else                                      
                                                                                                            x"00";

                                                                                        data_ram_addr_read_5 <= dbus_addr_read_5_s(7 downto 0)  when (dbus_addr_read_5_s >= x"00000400") and (dbus_addr_read_5_s < x"00000800") else 
                                                                                                            x"00";                              

                                                                                        data_ram_addr_read_6 <= dbus_addr_read_6_s(7 downto 0)  when (dbus_addr_read_6_s >= x"00000400") and (dbus_addr_read_6_s < x"00000800") else 
                                                                                                            x"00";

                                                                                        data_ram_addr_read_7 <= dbus_addr_read_7_s(7 downto 0)  when (dbus_addr_read_7_s >= x"00000400") and (dbus_addr_read_7_s < x"00000800") else 
                                                                                                               x"00";                         

                                                                                        -- TUSER RAM
                                                                                        axis_tuser_read_0_s <= dbus_addr_read_0_s when (dbus_addr_read_0_s >= x"00000200") and (dbus_addr_read_0_s < x"00000400") else                                      
                                                                                                               x"00000000";

                                                                                        axis_tuser_read_1_s <= dbus_addr_read_1_s  when (dbus_addr_read_1_s >= x"00000200") and (dbus_addr_read_1_s < x"00000400") else 
                                                                                                               x"00000000";                              

                                                                                        axis_tuser_read_2_s <= dbus_addr_read_2_s  when (dbus_addr_read_2_s >= x"00000200") and (dbus_addr_read_2_s < x"00000400") else 
                                                                                                               x"00000000";

                                                                                        axis_tuser_read_3_s <= dbus_addr_read_3_s  when (dbus_addr_read_3_s >= x"00000200") and (dbus_addr_read_3_s < x"00000400") else 
                                                                                                               x"00000000";  

                                                                                        axis_tuser_read_4_s <= dbus_addr_read_4_s  when (dbus_addr_read_4_s >= x"00000200") and (dbus_addr_read_4_s < x"00000400") else                                      
                                                                                                               x"00000000";

                                                                                        axis_tuser_read_5_s <= dbus_addr_read_5_s  when (dbus_addr_read_5_s >= x"00000200") and (dbus_addr_read_5_s < x"00000400") else 
                                                                                                               x"00000000";                              

                                                                                        axis_tuser_read_6_s <= dbus_addr_read_6_s  when (dbus_addr_read_6_s >= x"00000200") and (dbus_addr_read_6_s < x"00000400") else 
                                                                                                               x"00000000";

                                                                                        axis_tuser_read_7_s <= dbus_addr_read_7_s  when (dbus_addr_read_7_s >= x"00000200") and (dbus_addr_read_7_s < x"00000400") else 
                                                                                                               x"00000000";                         

                                          -- WRITE
                                          -- 00 = AXI OUT                     


                                                                                        m_wrt_en_tdata_0_s <= dbus_w_e_0_s when (dbus_add_wrt_0_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_1_s <= dbus_w_e_1_s when (dbus_add_wrt_1_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_2_s <= dbus_w_e_2_s when (dbus_add_wrt_2_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_3_s <= dbus_w_e_3_s when (dbus_add_wrt_3_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_4_s <= dbus_w_e_4_s when (dbus_add_wrt_4_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_5_s <= dbus_w_e_5_s when (dbus_add_wrt_5_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_6_s <= dbus_w_e_6_s when (dbus_add_wrt_6_s < x"000000FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tdata_7_s <= dbus_w_e_7_s when (dbus_add_wrt_7_s < x"000000FF") else
                                                                                                              '0';                  

                                                                                        m_wrt_en_tuser_0_s <= dbus_w_e_0_s when (dbus_add_wrt_0_s >= x"00000100") and  (dbus_add_wrt_0_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_1_s <= dbus_w_e_1_s when (dbus_add_wrt_1_s >= x"00000100") and  (dbus_add_wrt_1_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_2_s <= dbus_w_e_2_s when (dbus_add_wrt_2_s >= x"00000100") and  (dbus_add_wrt_2_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_3_s <= dbus_w_e_3_s when (dbus_add_wrt_3_s >= x"00000100") and  (dbus_add_wrt_3_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_4_s <= dbus_w_e_4_s when (dbus_add_wrt_4_s >= x"00000100") and  (dbus_add_wrt_4_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_5_s <= dbus_w_e_5_s when (dbus_add_wrt_5_s >= x"00000100") and  (dbus_add_wrt_5_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_6_s <= dbus_w_e_6_s when (dbus_add_wrt_6_s >= x"00000100") and  (dbus_add_wrt_6_s <= x"000001FF") else
                                                                                                              '0';
                                                                                        m_wrt_en_tuser_7_s <= dbus_w_e_7_s when (dbus_add_wrt_7_s >= x"00000100") and  (dbus_add_wrt_7_s <= x"000001FF") else
                                                                                                              '0';                                                                        
                                                                                        
                                                                                        data_ram_wrt_en_0 <= dbus_w_e_0_s when (dbus_add_wrt_0_s >= x"00000400") and  (dbus_add_wrt_0_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_1 <= dbus_w_e_1_s when (dbus_add_wrt_1_s >= x"00000400") and  (dbus_add_wrt_1_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_2 <= dbus_w_e_2_s when (dbus_add_wrt_2_s >= x"00000400") and  (dbus_add_wrt_2_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_3 <= dbus_w_e_3_s when (dbus_add_wrt_3_s >= x"00000400") and  (dbus_add_wrt_3_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_4 <= dbus_w_e_4_s when (dbus_add_wrt_4_s >= x"00000400") and  (dbus_add_wrt_4_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_5 <= dbus_w_e_5_s when (dbus_add_wrt_5_s >= x"00000400") and  (dbus_add_wrt_5_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_6 <= dbus_w_e_6_s when (dbus_add_wrt_6_s >= x"00000400") and  (dbus_add_wrt_6_s <= x"00000800") else
                                                                                                            '0';
                                                                                        data_ram_wrt_en_7 <= dbus_w_e_7_s when (dbus_add_wrt_7_s >= x"00000400") and  (dbus_add_wrt_7_s <= x"00000800") else
                                                                                                            '0';                                                                        

                                                                                        data_ram_addr_wrt_0 <=  dbus_add_wrt_0_s(7 downto 0);
                                                                                        data_ram_addr_wrt_1 <=  dbus_add_wrt_1_s(7 downto 0);
                                                                                        data_ram_addr_wrt_2 <=  dbus_add_wrt_2_s(7 downto 0);
                                                                                        data_ram_addr_wrt_3 <=  dbus_add_wrt_3_s(7 downto 0);
                                                                                        data_ram_addr_wrt_4 <=  dbus_add_wrt_4_s(7 downto 0);
                                                                                        data_ram_addr_wrt_5 <=  dbus_add_wrt_5_s(7 downto 0);
                                                                                        data_ram_addr_wrt_6 <=  dbus_add_wrt_6_s(7 downto 0);
                                                                                        data_ram_addr_wrt_7 <=  dbus_add_wrt_7_s(7 downto 0);

                                                                                        data_ram_data_in_0 <= dbus_data_out_0_s;
                                                                                        data_ram_data_in_1 <= dbus_data_out_1_s;
                                                                                        data_ram_data_in_2 <= dbus_data_out_2_s;
                                                                                        data_ram_data_in_3 <= dbus_data_out_3_s;
                                                                                        data_ram_data_in_4 <= dbus_data_out_4_s;
                                                                                        data_ram_data_in_5 <= dbus_data_out_5_s;
                                                                                        data_ram_data_in_6 <= dbus_data_out_6_s;
                                                                                        data_ram_data_in_7 <= dbus_data_out_7_s;


                                                                                        m_axis_addr_0_s <= dbus_add_wrt_0_s(4 downto 0);
                                                                                        m_axis_addr_1_s <= dbus_add_wrt_1_s(4 downto 0);
                                                                                        m_axis_addr_2_s <= dbus_add_wrt_2_s(4 downto 0);
                                                                                        m_axis_addr_3_s <= dbus_add_wrt_3_s(4 downto 0);
                                                                                        m_axis_addr_4_s <= dbus_add_wrt_4_s(4 downto 0);
                                                                                        m_axis_addr_5_s <= dbus_add_wrt_5_s(4 downto 0);
                                                                                        m_axis_addr_6_s <= dbus_add_wrt_6_s(4 downto 0);
                                                                                        m_axis_addr_7_s <= dbus_add_wrt_7_s(4 downto 0);

                                                                                        S0_AXIS_TREADY <= '1';

                                                                                        m_axis_tvalid <= dbus_w_e_0_s when dbus_add_wrt_0_s = x"00000200" else --0x00000200
                                                                                                         dbus_w_e_1_s when dbus_add_wrt_1_s = x"00000200" else
                                                                                                         dbus_w_e_2_s when dbus_add_wrt_2_s = x"00000200" else
                                                                                                         dbus_w_e_3_s when dbus_add_wrt_3_s = x"00000200" else
                                                                                                         dbus_w_e_4_s when dbus_add_wrt_4_s = x"00000200" else
                                                                                                         dbus_w_e_5_s when dbus_add_wrt_5_s = x"00000200" else
                                                                                                         dbus_w_e_6_s when dbus_add_wrt_6_s = x"00000200" else
                                                                                                         dbus_w_e_7_s when dbus_add_wrt_7_s = x"00000200" else
                                                                                                         '0'; 

                                                                                        m_axis_tlast  <=  dbus_w_e_0_s when dbus_add_wrt_0_s = x"00000201" else --0x00000201
                                                                                                          dbus_w_e_1_s when dbus_add_wrt_1_s = x"00000201" else
                                                                                                          dbus_w_e_2_s when dbus_add_wrt_2_s = x"00000201" else
                                                                                                          dbus_w_e_3_s when dbus_add_wrt_3_s = x"00000201" else
                                                                                                          dbus_w_e_4_s when dbus_add_wrt_4_s = x"00000201" else
                                                                                                          dbus_w_e_5_s when dbus_add_wrt_5_s = x"00000201" else
                                                                                                          dbus_w_e_6_s when dbus_add_wrt_6_s = x"00000201" else
                                                                                                          dbus_w_e_7_s when dbus_add_wrt_7_s = x"00000201" else
                                                                                                          '0';                                                    

                                                                                        m_axis_tkeep <= dbus_data_out_0_s when dbus_add_wrt_0_s = x"00000202" else --0x00000202
                                                                                                        dbus_data_out_1_s when dbus_add_wrt_1_s = x"00000202" else
                                                                                                        dbus_data_out_2_s when dbus_add_wrt_2_s = x"00000202" else
                                                                                                        dbus_data_out_3_s when dbus_add_wrt_3_s = x"00000202" else
                                                                                                        dbus_data_out_4_s when dbus_add_wrt_4_s = x"00000202" else
                                                                                                        dbus_data_out_5_s when dbus_add_wrt_5_s = x"00000202" else
                                                                                                        dbus_data_out_6_s when dbus_add_wrt_6_s = x"00000202" else
                                                                                                        dbus_data_out_7_s when dbus_add_wrt_7_s = x"00000202" else
                                                                                                        (others => '0');                                             

                                                                                        bytes_amount_dma_s <= dbus_data_out_0_s (15 downto 0) when dbus_add_wrt_0_s = x"00000203" else --0x00000203
                                                                                                              dbus_data_out_1_s (15 downto 0) when dbus_add_wrt_1_s = x"00000203" else
                                                                                                              dbus_data_out_2_s (15 downto 0) when dbus_add_wrt_2_s = x"00000203" else
                                                                                                              dbus_data_out_3_s (15 downto 0) when dbus_add_wrt_3_s = x"00000203" else
                                                                                                              dbus_data_out_4_s (15 downto 0) when dbus_add_wrt_4_s = x"00000203" else
                                                                                                              dbus_data_out_5_s (15 downto 0) when dbus_add_wrt_5_s = x"00000203" else
                                                                                                              dbus_data_out_6_s (15 downto 0) when dbus_add_wrt_6_s = x"00000203" else
                                                                                                              dbus_data_out_7_s (15 downto 0) when dbus_add_wrt_7_s = x"00000203" else
                                                                                                              (others => '0');                                             

                                                                                        start_addr_dma_s <= dbus_data_out_0_s (8 downto 0) when dbus_add_wrt_0_s = x"00000204" else --0x00000204
                                                                                                            dbus_data_out_1_s (8 downto 0) when dbus_add_wrt_1_s = x"00000204" else
                                                                                                            dbus_data_out_2_s (8 downto 0) when dbus_add_wrt_2_s = x"00000204" else
                                                                                                            dbus_data_out_3_s (8 downto 0) when dbus_add_wrt_3_s = x"00000204" else
                                                                                                            dbus_data_out_4_s (8 downto 0) when dbus_add_wrt_4_s = x"00000204" else
                                                                                                            dbus_data_out_5_s (8 downto 0) when dbus_add_wrt_5_s = x"00000204" else
                                                                                                            dbus_data_out_6_s (8 downto 0) when dbus_add_wrt_6_s = x"00000204" else
                                                                                                            dbus_data_out_7_s (8 downto 0) when dbus_add_wrt_7_s = x"00000204" else
                                                                                                            (others => '0');                                             

                                                                                        start_dma_s <=      dbus_w_e_0_s when dbus_add_wrt_0_s = x"00000205" else --0x00000205
                                                                                                            dbus_w_e_1_s when dbus_add_wrt_1_s = x"00000205" else
                                                                                                            dbus_w_e_2_s when dbus_add_wrt_2_s = x"00000205" else
                                                                                                            dbus_w_e_3_s when dbus_add_wrt_3_s = x"00000205" else
                                                                                                            dbus_w_e_4_s when dbus_add_wrt_4_s = x"00000205" else
                                                                                                            dbus_w_e_5_s when dbus_add_wrt_5_s = x"00000205" else
                                                                                                            dbus_w_e_6_s when dbus_add_wrt_6_s = x"00000205" else
                                                                                                            dbus_w_e_7_s when dbus_add_wrt_7_s = x"00000205" else
                                                                                                            '0';                                             

                                                                                        dma_tlast_end <=    dbus_w_e_0_s when dbus_add_wrt_0_s = x"00000206" else --0x00000206
                                                                                                            dbus_w_e_1_s when dbus_add_wrt_1_s = x"00000206" else
                                                                                                            dbus_w_e_2_s when dbus_add_wrt_2_s = x"00000206" else
                                                                                                            dbus_w_e_3_s when dbus_add_wrt_3_s = x"00000206" else
                                                                                                            dbus_w_e_4_s when dbus_add_wrt_4_s = x"00000206" else
                                                                                                            dbus_w_e_5_s when dbus_add_wrt_5_s = x"00000206" else
                                                                                                            dbus_w_e_6_s when dbus_add_wrt_6_s = x"00000206" else
                                                                                                            dbus_w_e_7_s when dbus_add_wrt_7_s = x"00000206" else
                                                                                                            '0';                                             



                                                                                        reset_s <= reset when RESET_ACTIVE_LOW = false else
                                                                                                   not(reset);

                                                                                      end Behavioral;
