library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lanes is

  port ( 
         clk        :in std_logic;
         reset      :in std_logic;
         stop       :in std_logic;        

         syllable_0 :in std_logic_vector(31 downto 0);   
         syllable_1 :in std_logic_vector(31 downto 0);
         syllable_2 :in std_logic_vector(31 downto 0);
         syllable_3 :in std_logic_vector(31 downto 0);
         syllable_4 :in std_logic_vector(31 downto 0);
         syllable_5 :in std_logic_vector(31 downto 0);
         syllable_6 :in std_logic_vector(31 downto 0);
         syllable_7 :in std_logic_vector(31 downto 0);

         br_data_in :in std_logic;  -- branch register data in for jump

         br_data_0  : out std_logic;  -- branch register data out
         br_data_1  : out std_logic;
         br_data_2  : out std_logic;
         br_data_3  : out std_logic;
         br_data_4  : out std_logic;
         br_data_5  : out std_logic;
         br_data_6  : out std_logic;
         br_data_7  : out std_logic;

         br_add_wrt_0 :out std_logic_vector(4 downto 0);
         br_add_wrt_1 :out std_logic_vector(4 downto 0);
         br_add_wrt_2 :out std_logic_vector(4 downto 0);
         br_add_wrt_3 :out std_logic_vector(4 downto 0);
         br_add_wrt_4 :out std_logic_vector(4 downto 0);
         br_add_wrt_5 :out std_logic_vector(4 downto 0);
         br_add_wrt_6 :out std_logic_vector(4 downto 0);
         br_add_wrt_7 :out std_logic_vector(4 downto 0);

         br_wrt_en_0  :out std_logic;
         br_wrt_en_1  :out std_logic;
         br_wrt_en_2  :out std_logic;
         br_wrt_en_3  :out std_logic;
         br_wrt_en_4  :out std_logic;
         br_wrt_en_5  :out std_logic;
         br_wrt_en_6  :out std_logic;
         br_wrt_en_7  :out std_logic;         

         gr_0_0 : in std_logic_vector(31 downto 0);  -- operands data
         gr_0_1 : in std_logic_vector(31 downto 0);
         gr_1_0 : in std_logic_vector(31 downto 0);
         gr_1_1 : in std_logic_vector(31 downto 0);
         gr_2_0 : in std_logic_vector(31 downto 0);
         gr_2_1 : in std_logic_vector(31 downto 0);
         gr_3_0 : in std_logic_vector(31 downto 0);
         gr_3_1 : in std_logic_vector(31 downto 0);
         gr_4_0 : in std_logic_vector(31 downto 0);
         gr_4_1 : in std_logic_vector(31 downto 0);
         gr_5_0 : in std_logic_vector(31 downto 0);
         gr_5_1 : in std_logic_vector(31 downto 0);
         gr_6_0 : in std_logic_vector(31 downto 0);
         gr_6_1 : in std_logic_vector(31 downto 0);
         gr_7_0 : in std_logic_vector(31 downto 0);
         gr_7_1 : in std_logic_vector(31 downto 0);

         gr_add_0_0 : in std_logic_vector(4 downto 0); -- operands address
         gr_add_0_1 : in std_logic_vector(4 downto 0);
         gr_add_1_0 : in std_logic_vector(4 downto 0);
         gr_add_1_1 : in std_logic_vector(4 downto 0);
         gr_add_2_0 : in std_logic_vector(4 downto 0);
         gr_add_2_1 : in std_logic_vector(4 downto 0);
         gr_add_3_0 : in std_logic_vector(4 downto 0);
         gr_add_3_1 : in std_logic_vector(4 downto 0);
         gr_add_4_0 : in std_logic_vector(4 downto 0);
         gr_add_4_1 : in std_logic_vector(4 downto 0);
         gr_add_5_0 : in std_logic_vector(4 downto 0);
         gr_add_5_1 : in std_logic_vector(4 downto 0);
         gr_add_6_0 : in std_logic_vector(4 downto 0);
         gr_add_6_1 : in std_logic_vector(4 downto 0);
         gr_add_7_0 : in std_logic_vector(4 downto 0);
         gr_add_7_1 : in std_logic_vector(4 downto 0);


         gr_add_0 : out std_logic_vector(4 downto 0);  --addresses for destination
         gr_add_1 : out std_logic_vector(4 downto 0);
         gr_add_2 : out std_logic_vector(4 downto 0);
         gr_add_3 : out std_logic_vector(4 downto 0);
         gr_add_4 : out std_logic_vector(4 downto 0);
         gr_add_5 : out std_logic_vector(4 downto 0);
         gr_add_6 : out std_logic_vector(4 downto 0);
         gr_add_7 : out std_logic_vector(4 downto 0);

         gr_rsl_0 : out std_logic_vector(31 downto 0); -- results to destination
         gr_rsl_1 : out std_logic_vector(31 downto 0);
         gr_rsl_2 : out std_logic_vector(31 downto 0);
         gr_rsl_3 : out std_logic_vector(31 downto 0);
         gr_rsl_4 : out std_logic_vector(31 downto 0);
         gr_rsl_5 : out std_logic_vector(31 downto 0);
         gr_rsl_6 : out std_logic_vector(31 downto 0);
         gr_rsl_7 : out std_logic_vector(31 downto 0);

         gr_wrt_en_0 : out std_logic; -- write enable for destination 
         gr_wrt_en_1 : out std_logic;
         gr_wrt_en_2 : out std_logic;
         gr_wrt_en_3 : out std_logic;
         gr_wrt_en_4 : out std_logic;
         gr_wrt_en_5 : out std_logic;
         gr_wrt_en_6 : out std_logic;
         gr_wrt_en_7 : out std_logic;

         -- Memory
         mem_add_wrt_0  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_0 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_0 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_0 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_0  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_0      : out std_logic;                     -- memory write enable

         mem_add_wrt_1  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_1 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_1 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_1 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_1  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_1      : out std_logic;                     -- memory write enable

         mem_add_wrt_2  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_2 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_2 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_2 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_2 : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_2      : out std_logic;                     -- memory write enable

         mem_add_wrt_3  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_3 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_3 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_3 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_3  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_3      : out std_logic;                     -- memory write enable

         mem_add_wrt_4  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_4 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_4 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_4 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_4 : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_4      : out std_logic;                     -- memory write enable

         mem_add_wrt_5  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_5 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_5 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_5 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_5  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_5      : out std_logic;                     -- memory write enable

         mem_add_wrt_6  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_6 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_6 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_6 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_6 : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_6      : out std_logic;                     -- memory write enable

         mem_add_wrt_7  : out std_logic_vector(31 downto 0); -- write address for memory
         mem_add_read_7 : out std_logic_vector(31 downto 0); -- read address for memory
         mem_data_out_7 : out std_logic_vector(31 downto 0); -- data to write to memory
         mem_wrt_amnt_7 : out std_logic_vector(4 downto 0);  -- number of bits written to memory
         mem_data_in_7  : in std_logic_vector(31 downto 0);  -- Data from memory
         mem_w_e_7      : out std_logic;                     -- memory write enable

         -- Program counter
         branch_add   : out std_logic_vector(7 downto 0);  -- Branch address for program counter
         branch_valid : out std_logic                      -- Branch valid for PC


       );
end lanes;

architecture Behavioral of lanes is

  signal branch_s : std_logic;
  signal br_data_0_s : std_logic;
  signal br_add_wrt_0_s  : std_logic_vector( 4 downto 0);

begin

  LANE_0: entity work.lane_0 port map (
  clk,
  reset,
  stop,
  syllable_0,
  gr_add_0_0,
  gr_add_0_1,
  gr_0_0,
  gr_0_1,
  br_data_in,
  br_data_0_s,
  br_add_wrt_0_s,
  mem_add_wrt_0  ,
  mem_add_read_0,
  mem_data_out_0 ,
  mem_wrt_amnt_0,
  mem_data_in_0  ,
  mem_w_e_0      ,
  gr_add_0,
  gr_rsl_0,
  br_add_wrt_0_s,
  br_data_0_s,
  gr_wrt_en_0,
  br_wrt_en_0,
  branch_add,
  branch_s

);

LANE_1: entity work.lane_1_3 port map(clk,
reset,
stop,
branch_s,
syllable_1,
gr_add_1_0,
gr_add_1_1,

gr_1_0,
gr_1_1,
br_data_in,
mem_add_wrt_1  ,
mem_add_read_1,
mem_data_out_1 ,
mem_wrt_amnt_1,
mem_data_in_1  ,
mem_w_e_1      ,
gr_add_1,
gr_rsl_1,
br_add_wrt_1,
br_data_1,
gr_wrt_en_1,
br_wrt_en_1

                                   );

                                   LANE_2: entity work.lane_1_3 port map(clk,
                                   reset,
                                   stop,
                                   branch_s,
                                   syllable_2,
                                   gr_add_2_0,
                                   gr_add_2_1,


                                   gr_2_0,
                                   gr_2_1,
                                   br_data_in,
                                   mem_add_wrt_2  ,
                                   mem_add_read_2,
                                   mem_data_out_2 ,
                                   mem_wrt_amnt_2,
                                   mem_data_in_2  ,
                                   mem_w_e_2      ,
                                   gr_add_2,
                                   gr_rsl_2,
                                   br_add_wrt_2,
                                   br_data_2,
                                   gr_wrt_en_2,
                                   br_wrt_en_2

                                 );

                                 LANE_3: entity work.lane_1_3 port map(clk,
                                 reset,
                                 stop,
                                 branch_s,
                                 syllable_3,
                                 gr_add_3_0,
                                 gr_add_3_1,

                                 gr_3_0,
                                 gr_3_1,
                                 br_data_in,
                                 mem_add_wrt_3  ,
                                 mem_add_read_3,
                                 mem_data_out_3 ,
                                 mem_wrt_amnt_3,
                                 mem_data_in_3  ,
                                 mem_w_e_3      ,
                                 gr_add_3,
                                 gr_rsl_3,
                                 br_add_wrt_3,
                                 br_data_3,
                                 gr_wrt_en_3,
                                 br_wrt_en_3

                               );

                               LANE_4: entity work.lane_1_3 port map(clk,
                               reset,
                               stop,
                               branch_s,
                               syllable_4,
                               gr_add_4_0,
                               gr_add_4_1,

                               gr_4_0,
                               gr_4_1,
                               br_data_in,
                               mem_add_wrt_4  ,
                               mem_add_read_4,
                               mem_data_out_4 ,
                               mem_wrt_amnt_4,
                               mem_data_in_4  ,
                               mem_w_e_4      ,
                               gr_add_4,
                               gr_rsl_4,
                               br_add_wrt_4,
                               br_data_4,
                               gr_wrt_en_4,
                               br_wrt_en_4                                             
                             );

                             LANE_5: entity work.lane_1_3 port map(clk,
                             reset,
                             stop,
                             branch_s,
                             syllable_5,
                             gr_add_5_0,
                             gr_add_5_1,

                             gr_5_0,
                             gr_5_1,
                             br_data_in,
                             mem_add_wrt_5  ,
                             mem_add_read_5,
                             mem_data_out_5 ,
                             mem_wrt_amnt_5,
                             mem_data_in_5  ,
                             mem_w_e_5      ,
                             gr_add_5,
                             gr_rsl_5,
                             br_add_wrt_5,
                             br_data_5,
                             gr_wrt_en_5,
                             br_wrt_en_5

                           );

                           LANE_6: entity work.lane_1_3 port map(clk,
                           reset,
                           stop,
                           branch_s,
                           syllable_6,
                           gr_add_6_0,
                           gr_add_6_1,

                           gr_6_0,
                           gr_6_1,
                           br_data_in,
                           mem_add_wrt_6  ,
                           mem_add_read_6,
                           mem_data_out_6 ,
                           mem_wrt_amnt_6,
                           mem_data_in_6  ,
                           mem_w_e_6      ,
                           gr_add_6,
                           gr_rsl_6,
                           br_add_wrt_6,
                           br_data_6,
                           gr_wrt_en_6,
                           br_wrt_en_6

                         );

                         LANE_7: entity work.lane_1_3 port map(clk,
                         reset,
                         stop,
                         branch_s,
                         syllable_7,
                         gr_add_7_0,
                         gr_add_7_1,

                         gr_7_0,
                         gr_7_1,
                         br_data_in,
                         mem_add_wrt_7  ,
                         mem_add_read_7,
                         mem_data_out_7 ,
                         mem_wrt_amnt_7,
                         mem_data_in_7  ,
                         mem_w_e_7      ,
                         gr_add_7,
                         gr_rsl_7,
                         br_add_wrt_7,
                         br_data_7,
                         gr_wrt_en_7,
                         br_wrt_en_7

                       );

                       branch_valid <= branch_s;
                       br_data_0 <= br_data_0_s;
                       br_add_wrt_0 <= br_add_wrt_0_s;

                     end Behavioral;
