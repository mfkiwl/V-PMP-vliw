library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PMP_core is

  Port ( 
         clk           : in std_logic;
         reset         : in std_logic;
         start         : in std_logic;
            -- Instruction Memory Interface
         imem_addr     : out std_logic_vector(7 downto 0);
         imem_instr    : in std_logic_vector(255 downto 0);            

            -- Data Bus Interface

         dbus_data_in_0  : in std_logic_vector(31 downto 0);
         dbus_data_in_1  : in std_logic_vector(31 downto 0);
         dbus_data_in_2  : in std_logic_vector(31 downto 0);
         dbus_data_in_3  : in std_logic_vector(31 downto 0);
         dbus_data_in_4  : in std_logic_vector(31 downto 0);
         dbus_data_in_5  : in std_logic_vector(31 downto 0);
         dbus_data_in_6  : in std_logic_vector(31 downto 0);
         dbus_data_in_7  : in std_logic_vector(31 downto 0);

         dbus_data_out_0 : out std_logic_vector(31 downto 0); 
         dbus_data_out_1 : out std_logic_vector(31 downto 0);  
         dbus_data_out_2 : out std_logic_vector(31 downto 0);  
         dbus_data_out_3 : out std_logic_vector(31 downto 0);  
         dbus_data_out_4 : out std_logic_vector(31 downto 0);  
         dbus_data_out_5 : out std_logic_vector(31 downto 0);  
         dbus_data_out_6 : out std_logic_vector(31 downto 0);
         dbus_data_out_7 : out std_logic_vector(31 downto 0);
         
         dbus_data_amnt_0 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_1 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_2 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_3 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_4 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_5 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_6 : out std_logic_vector(4 downto 0);
         dbus_data_amnt_7 : out std_logic_vector(4 downto 0);  

         dbus_addr_read_0    : out std_logic_vector(31 downto 0);
         dbus_addr_read_1    : out std_logic_vector(31 downto 0);
         dbus_addr_read_2    : out std_logic_vector(31 downto 0);
         dbus_addr_read_3    : out std_logic_vector(31 downto 0);
         dbus_addr_read_4    : out std_logic_vector(31 downto 0);
         dbus_addr_read_5    : out std_logic_vector(31 downto 0);
         dbus_addr_read_6    : out std_logic_vector(31 downto 0);
         dbus_addr_read_7    : out std_logic_vector(31 downto 0);

         dbus_addr_wrt_0   : out std_logic_vector(31 downto 0); -- base addresses to write (set the starting bit)
         dbus_addr_wrt_1   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_2   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_3   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_4   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_5   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_6   : out std_logic_vector(31 downto 0);
         dbus_addr_wrt_7   : out std_logic_vector(31 downto 0);

         dbus_wrt_en_0      : out std_logic;
         dbus_wrt_en_1      : out std_logic;
         dbus_wrt_en_2      : out std_logic;
         dbus_wrt_en_3      : out std_logic;
         dbus_wrt_en_4      : out std_logic;
         dbus_wrt_en_5      : out std_logic;
         dbus_wrt_en_6      : out std_logic;
         dbus_wrt_en_7      : out std_logic;

            -- Clock cycles
         cycles        : out std_logic_vector(31 downto 0)

       );
end PMP_core;

architecture Behavioral of PMP_core is

  signal stop_s       : std_logic := '0';
  signal reset_s     : std_logic;
  signal branch_s      : std_logic;

  signal syllable_0_s : std_logic_vector(31 downto 0);
  signal syllable_1_s : std_logic_vector(31 downto 0);
  signal syllable_2_s : std_logic_vector(31 downto 0);
  signal syllable_3_s : std_logic_vector(31 downto 0);
  signal syllable_4_s : std_logic_vector(31 downto 0);
  signal syllable_5_s : std_logic_vector(31 downto 0);
  signal syllable_6_s : std_logic_vector(31 downto 0);
  signal syllable_7_s : std_logic_vector(31 downto 0);
  signal br_add_0_r      : std_logic_vector(4 downto 0);
  signal br_add_0_w      : std_logic_vector(4 downto 0);
  signal br_add_1_w       : std_logic_vector(4 downto 0);
  signal br_add_2_w       : std_logic_vector(4 downto 0);
  signal br_add_3_w       : std_logic_vector(4 downto 0);
  signal br_add_4_w       : std_logic_vector(4 downto 0);
  signal br_add_5_w       : std_logic_vector(4 downto 0);
  signal br_add_6_w       : std_logic_vector(4 downto 0);
  signal br_add_7_w       : std_logic_vector(4 downto 0);
  signal pc_inc_s     : std_logic;
  signal branch       : std_logic;
  signal branch_add_s : std_logic_vector(7 downto 0);

  signal add_0_0      : std_logic_vector(4 downto 0);
  signal add_0_1      : std_logic_vector(4 downto 0);
  signal add_0_d      : std_logic_vector(4 downto 0);
  signal w_e_0        : std_logic;
  signal cont_0_0     : std_logic_vector(31 downto 0);
  signal cont_0_1     : std_logic_vector(31 downto 0);
  signal cont_0_d     : std_logic_vector(31 downto 0);

  signal  add_1_0      : std_logic_vector(4 downto 0);
  signal  add_1_1      : std_logic_vector(4 downto 0);
  signal  add_1_d      : std_logic_vector(4 downto 0);
  signal  w_e_1        : std_logic;                   
  signal cont_1_0      : std_logic_vector(31 downto 0);
  signal cont_1_1      : std_logic_vector(31 downto 0);
  signal cont_1_d      : std_logic_vector(31 downto 0);

  signal  add_2_0      : std_logic_vector(4 downto 0);
  signal  add_2_1      : std_logic_vector(4 downto 0);
  signal  add_2_d      : std_logic_vector(4 downto 0);
  signal  w_e_2        : std_logic;                   
  signal cont_2_0      : std_logic_vector(31 downto 0);
  signal cont_2_1      : std_logic_vector(31 downto 0);
  signal cont_2_d      : std_logic_vector(31 downto 0);

  signal  add_3_0      : std_logic_vector(4 downto 0);
  signal  add_3_1      : std_logic_vector(4 downto 0);
  signal  add_3_d      : std_logic_vector(4 downto 0);
  signal  w_e_3        : std_logic;                   
  signal cont_3_0      : std_logic_vector(31 downto 0);
  signal cont_3_1      : std_logic_vector(31 downto 0);
  signal cont_3_d      : std_logic_vector(31 downto 0);  

  signal  add_4_0      : std_logic_vector(4 downto 0);
  signal  add_4_1      : std_logic_vector(4 downto 0);
  signal  add_4_d      : std_logic_vector(4 downto 0);
  signal  w_e_4        : std_logic;                   
  signal cont_4_0      : std_logic_vector(31 downto 0);
  signal cont_4_1      : std_logic_vector(31 downto 0);
  signal cont_4_d      : std_logic_vector(31 downto 0); 

  signal  add_5_0      : std_logic_vector(4 downto 0);
  signal  add_5_1      : std_logic_vector(4 downto 0);
  signal  add_5_d      : std_logic_vector(4 downto 0);
  signal  w_e_5        : std_logic;                   
  signal cont_5_0      : std_logic_vector(31 downto 0);
  signal cont_5_1      : std_logic_vector(31 downto 0);
  signal cont_5_d      : std_logic_vector(31 downto 0); 

  signal  add_6_0      : std_logic_vector(4 downto 0);
  signal  add_6_1      : std_logic_vector(4 downto 0);
  signal  add_6_d      : std_logic_vector(4 downto 0);
  signal  w_e_6        : std_logic;                   
  signal cont_6_0      : std_logic_vector(31 downto 0);
  signal cont_6_1      : std_logic_vector(31 downto 0);
  signal cont_6_d      : std_logic_vector(31 downto 0);

  signal  add_7_0      : std_logic_vector(4 downto 0);
  signal  add_7_1      : std_logic_vector(4 downto 0);
  signal  add_7_d      : std_logic_vector(4 downto 0);
  signal  w_e_7        : std_logic;                   
  signal cont_7_0      : std_logic_vector(31 downto 0);
  signal cont_7_1      : std_logic_vector(31 downto 0);
  signal cont_7_d      : std_logic_vector(31 downto 0);

  signal br_wrt_data_0 : std_logic;                                  
  signal br_wrt_data_1 : std_logic;
  signal br_wrt_data_2 : std_logic;
  signal br_wrt_data_3 : std_logic;
  signal br_wrt_data_4 : std_logic;
  signal br_wrt_data_5 : std_logic;
  signal br_wrt_data_6 : std_logic;
  signal br_wrt_data_7 : std_logic;

  signal br_wrt_en_0   : std_logic;
  signal br_wrt_en_1   : std_logic;
  signal br_wrt_en_2   : std_logic;
  signal br_wrt_en_3   : std_logic;
  signal br_wrt_en_4   : std_logic;
  signal br_wrt_en_5   : std_logic;
  signal br_wrt_en_6   : std_logic;
  signal br_wrt_en_7   : std_logic;

  signal br_data_in_s  : std_logic;
  
  

begin

  FETCH_STAGE: entity work.fetch_stage port map (
  clk => clk,
  reset => reset_s,
  instr => imem_instr,
  start => start,
  stop => stop_s,
  branch => branch_s,
  syllable_0 => syllable_0_s,
  syllable_1 => syllable_1_s,
  syllable_2 => syllable_2_s,
  syllable_3 => syllable_3_s,
  syllable_4 => syllable_4_s,
  syllable_5 => syllable_5_s,
  syllable_6 => syllable_6_s,
  syllable_7 => syllable_7_s,
  gr_0_0 => add_0_0,
  gr_0_1 => add_0_1,
  gr_1_0 => add_1_0,
  gr_1_1 => add_1_1,
  gr_2_0 => add_2_0,
  gr_2_1 => add_2_1,
  gr_3_0 => add_3_0,
  gr_3_1 => add_3_1,
  gr_4_0 => add_4_0,
  gr_4_1 => add_4_1,
  gr_5_0 => add_5_0,
  gr_5_1 => add_5_1,
  gr_6_0 => add_6_0,
  gr_6_1 => add_6_1,
  gr_7_0 => add_7_0,
  gr_7_1 => add_7_1,
  br_0 => br_add_0_r,
  
  cycles => cycles, 
  pc_inc => pc_inc_s
);  

PROGRAM_COUNTER: entity work.pc port map ( 
clk => clk,
inc => pc_inc_s,
rst => reset_s,
branch_exe => branch_s,
branch_add_exe => branch_add_s,
PC => imem_addr

                                          );  

                                          GPR_FILE: entity work.gr_regfile port map (
                                          clk,
                                          reset_s,
                                          add_0_0 ,
                                          add_0_1 ,
                                          add_0_d ,
                                          w_e_0   ,
                                          cont_0_0,
                                          cont_0_1,
                                          cont_0_d,

                                          add_1_0,
                                          add_1_1,
                                          add_1_d,
                                          w_e_1  ,
                                          cont_1_0,
                                          cont_1_1,
                                          cont_1_d,

                                          add_2_0,
                                          add_2_1,
                                          add_2_d,
                                          w_e_2  ,
                                          cont_2_0,
                                          cont_2_1,
                                          cont_2_d,

                                          add_3_0,
                                          add_3_1,
                                          add_3_d,
                                          w_e_3  ,
                                          cont_3_0,
                                          cont_3_1,
                                          cont_3_d,

                                          add_4_0,
                                          add_4_1,
                                          add_4_d,
                                          w_e_4  ,
                                          cont_4_0,
                                          cont_4_1,
                                          cont_4_d,

                                          add_5_0,
                                          add_5_1,
                                          add_5_d,
                                          w_e_5  ,
                                          cont_5_0,
                                          cont_5_1,
                                          cont_5_d,

                                          add_6_0,
                                          add_6_1,
                                          add_6_d,
                                          w_e_6  ,
                                          cont_6_0,
                                          cont_6_1,
                                          cont_6_d,

                                          add_7_0,
                                          add_7_1,
                                          add_7_d,
                                          w_e_7  ,
                                          cont_7_0,
                                          cont_7_1,
                                          cont_7_d
                                        );

                                        BR_FILE: entity work.branch_reg port map(
                                        clk,
                                        reset_s,

                                        br_add_0_r,
                                        br_add_0_w,
                                        br_wrt_data_0,
                                        br_wrt_en_0,
                                        br_data_in_s,

                                        br_add_1_w,
                                        br_wrt_data_1,
                                        br_wrt_en_1,

                                        br_add_2_w,
                                        br_wrt_data_2,
                                        br_wrt_en_2,

                                        br_add_3_w,
                                        br_wrt_data_3,
                                        br_wrt_en_3,

                                        br_add_4_w,
                                        br_wrt_data_4,
                                        br_wrt_en_4,

                                        br_add_5_w,
                                        br_wrt_data_5,
                                        br_wrt_en_5,

                                        br_add_6_w,
                                        br_wrt_data_6,
                                        br_wrt_en_6,

                                        br_add_7_w,
                                        br_wrt_data_7,
                                        br_wrt_en_7

                                      );

                                      LANES: entity work.lanes port map (
                                      clk,
                                      reset_s,
                                      stop_s,
                                      syllable_0_s,
                                      syllable_1_s,
                                      syllable_2_s,
                                      syllable_3_s,
                                      syllable_4_s,
                                      syllable_5_s,
                                      syllable_6_s,
                                      syllable_7_s,
                                      br_data_in_s,

                                      br_wrt_data_0,
                                      br_wrt_data_1,
                                      br_wrt_data_2,
                                      br_wrt_data_3,
                                      br_wrt_data_4,
                                      br_wrt_data_5,
                                      br_wrt_data_6,
                                      br_wrt_data_7,

                                      br_add_0_w,
                                      br_add_1_w,
                                      br_add_2_w,
                                      br_add_3_w,
                                      br_add_4_w,
                                      br_add_5_w,
                                      br_add_6_w,
                                      br_add_7_w,

                                      br_wrt_en_0,
                                      br_wrt_en_1,
                                      br_wrt_en_2,
                                      br_wrt_en_3,
                                      br_wrt_en_4,
                                      br_wrt_en_5,
                                      br_wrt_en_6,
                                      br_wrt_en_7,

                                      cont_0_0,
                                      cont_0_1,
                                      cont_1_0,
                                      cont_1_1,
                                      cont_2_0,
                                      cont_2_1,
                                      cont_3_0,
                                      cont_3_1,
                                      cont_4_0,
                                      cont_4_1,
                                      cont_5_0,
                                      cont_5_1,
                                      cont_6_0,
                                      cont_6_1,
                                      cont_7_0,
                                      cont_7_1,

                                      add_0_0,
                                      add_0_1,
                                      add_1_0,
                                      add_1_1,
                                      add_2_0,
                                      add_2_1,
                                      add_3_0,
                                      add_3_1,
                                      add_4_0,
                                      add_4_1,
                                      add_5_0,
                                      add_5_1,
                                      add_6_0,
                                      add_6_1,
                                      add_7_0,
                                      add_7_1,

                                      add_0_d,
                                      add_1_d,
                                      add_2_d,
                                      add_3_d,
                                      add_4_d,
                                      add_5_d,
                                      add_6_d,
                                      add_7_d,

                                      cont_0_d,
                                      cont_1_d,
                                      cont_2_d,
                                      cont_3_d,
                                      cont_4_d,
                                      cont_5_d,
                                      cont_6_d,
                                      cont_7_d,

                                      w_e_0,
                                      w_e_1,
                                      w_e_2,
                                      w_e_3,
                                      w_e_4,
                                      w_e_5,
                                      w_e_6,
                                      w_e_7,

                                      dbus_addr_wrt_0  ,
                                      dbus_addr_read_0,
                                      dbus_data_out_0 ,
                                      dbus_data_amnt_0,
                                      dbus_data_in_0  ,
                                      dbus_wrt_en_0      ,

                                      dbus_addr_wrt_1  ,
                                      dbus_addr_read_1,
                                      dbus_data_out_1 ,
                                      dbus_data_amnt_1,
                                      dbus_data_in_1  ,
                                      dbus_wrt_en_1      ,

                                      dbus_addr_wrt_2  ,
                                      dbus_addr_read_2,
                                      dbus_data_out_2 ,
                                      dbus_data_amnt_2,
                                      dbus_data_in_2 ,
                                      dbus_wrt_en_2     ,

                                      dbus_addr_wrt_3  ,
                                      dbus_addr_read_3,
                                      dbus_data_out_3 ,
                                      dbus_data_amnt_3,
                                      dbus_data_in_3  ,
                                      dbus_wrt_en_3      ,

                                      dbus_addr_wrt_4  ,
                                      dbus_addr_read_4,
                                      dbus_data_out_4 ,
                                      dbus_data_amnt_4,
                                      dbus_data_in_4  ,
                                      dbus_wrt_en_4      ,

                                      dbus_addr_wrt_5  ,
                                      dbus_addr_read_5,
                                      dbus_data_out_5,
                                      dbus_data_amnt_5,
                                      dbus_data_in_5  ,
                                      dbus_wrt_en_5      ,

                                      dbus_addr_wrt_6  ,
                                      dbus_addr_read_6,
                                      dbus_data_out_6 ,
                                      dbus_data_amnt_6,
                                      dbus_data_in_6  ,
                                      dbus_wrt_en_6      ,

                                      dbus_addr_wrt_7 ,
                                      dbus_addr_read_7,
                                      dbus_data_out_7 ,
                                      dbus_data_amnt_7,
                                      dbus_data_in_7  ,
                                      dbus_wrt_en_7      ,


                                      branch_add_s,
                                      branch_s

                                    );


reset_s <= reset;

                                  end Behavioral;
