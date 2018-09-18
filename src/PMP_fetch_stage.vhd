library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;
entity fetch_stage is

  port ( 
         clk        : in std_logic; -- system clock
         reset      : in std_logic; -- system reset
         instr      : in std_logic_vector(511 downto 0); -- instruction (4 or 8 syllables)
         start      : in std_logic; -- '1' when to start execution of PMP
         stop       : in std_logic; -- '1' when STOP syllable is decoded
         branch     : in std_logic; -- '1' when flush pipeline because branch

         syllable_0 : out std_logic_vector(63 downto 0); -- syllable 0
         syllable_1 : out std_logic_vector(63 downto 0); -- syllable 1
         syllable_2 : out std_logic_vector(63 downto 0); -- syllable 2
         syllable_3 : out std_logic_vector(63 downto 0); -- syllable 3
         syllable_4 : out std_logic_vector(63 downto 0); -- syllable 4 
         syllable_5 : out std_logic_vector(63 downto 0); -- syllable 5 
         syllable_6 : out std_logic_vector(63 downto 0); -- syllable 6 
         syllable_7 : out std_logic_vector(63 downto 0); -- syllable 7 

         -- General purpose registers prefetch

         gr_src_0     : out std_logic_vector (3 downto 0); -- address of first operand of syllable 0
         gr_src_1     : out std_logic_vector (3 downto 0);
         gr_src_2     : out std_logic_vector (3 downto 0);
         gr_src_3     : out std_logic_vector (3 downto 0); 
         gr_src_4     : out std_logic_vector (3 downto 0);
         gr_src_5     : out std_logic_vector (3 downto 0);
         gr_src_6     : out std_logic_vector (3 downto 0);
         gr_src_7     : out std_logic_vector (3 downto 0);

         cycles     : out std_logic_vector(31 downto 0); -- number of clock cycles the execution took
         pc_inc     : out std_logic                      -- increment Program Counter

       );

end entity fetch_stage;

architecture behavioural of fetch_stage is

  signal running_s   : std_logic := '0';
  signal run_s       : std_logic := '0';
  signal cycles_i    : std_logic_vector(31 downto 0) :=(others => '0');
  signal stop_i      : std_logic := '0';
  signal out_valid_i : std_logic := '0';

  signal  syllable_0_s : std_logic_vector(63 downto 0) := (others => '0');  
  signal  syllable_1_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_2_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_3_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_4_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_5_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_6_s : std_logic_vector(63 downto 0) := (others => '0');
  signal  syllable_7_s : std_logic_vector(63 downto 0) := (others => '0');

begin	

  -- chop instruction into syllables

  syllable_0_s <= instr(63 downto 0);
  syllable_1_s <= instr(127 downto 64);
  syllable_2_s <= instr(191 downto 128);
  syllable_3_s <= instr(255 downto 192);
  syllable_4_s <= instr(319 downto 256);      
  syllable_5_s <= instr(383 downto 320);
  syllable_6_s <= instr(447 downto 384);
  syllable_7_s <= instr(511 downto 448);


  cycles <= cycles_i;

  -- Counts running cycles
  cycle_counter : process(clk, reset)

  begin 

    if (reset = '1') then
      cycles_i <= (others => '0');

    elsif rising_edge(clk) then

      if (running_s = '1' and stop_i = '0') then

        cycles_i <= cycles_i + 1;

      else

        cycles_i <= cycles_i;

      end if;

    end if;

  end process cycle_counter;

  -- Output
  fetch_out : process(clk) is

  begin

    if rising_edge(clk) then

      -- Default case

      syllable_0 <= (others => '0');
      syllable_1 <= (others => '0');
      syllable_2 <= (others => '0');
      syllable_3 <= (others => '0');
      syllable_4 <= (others => '0');
      syllable_5 <= (others => '0');
      syllable_6 <= (others => '0');
      syllable_7 <= (others => '0');

      gr_src_0 <= (others => '0'); 
      gr_src_1 <= (others => '0'); 
      gr_src_2 <= (others => '0'); 
      gr_src_3 <= (others => '0'); 
      gr_src_4 <= (others => '0'); 
      gr_src_5 <= (others => '0'); 
      gr_src_6 <= (others => '0'); 
      gr_src_7 <= (others => '0'); 

      pc_inc <= '0';
      running_s <= '0';

      if (start = '1' and reset = '0') then    
      
        -- control signals to program counter
        pc_inc <= '1';        
        running_s <= '1';
      
        -- outputting the syllables
        syllable_0 <= syllable_0_s; 
        syllable_1 <= syllable_1_s; 
        syllable_2 <= syllable_2_s; 
        syllable_3 <= syllable_3_s; 
        syllable_4 <= syllable_4_s;      
        syllable_5 <= syllable_5_s; 
        syllable_6 <= syllable_6_s; 
        syllable_7 <= syllable_7_s; 

        -- source registers prefetch 
        gr_src_0 <= syllable_0_s(15 downto 12);
        gr_src_1 <= syllable_1_s(15 downto 12);
        gr_src_2 <= syllable_2_s(15 downto 12);
        gr_src_3 <= syllable_3_s(15 downto 12);
        gr_src_4 <= syllable_4_s(15 downto 12);
        gr_src_5 <= syllable_5_s(15 downto 12);
        gr_src_6 <= syllable_6_s(15 downto 12);
        gr_src_7 <= syllable_7_s(15 downto 12);

      end if;
    end if;
  end process fetch_out;

end architecture behavioural;

