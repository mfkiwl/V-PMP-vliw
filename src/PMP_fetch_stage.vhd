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
         instr      : in std_logic_vector(255 downto 0); -- instruction (4 or 8 syllables)
         start      : in std_logic; -- '1' when to start execution of PMP
         stop       : in std_logic; -- '1' when STOP syllable is decoded
         branch     : in std_logic; -- '1' when flush pipeline because branch


         syllable_0 : out std_logic_vector(31 downto 0); -- syllable 0
         syllable_1 : out std_logic_vector(31 downto 0); -- syllable 1
         syllable_2 : out std_logic_vector(31 downto 0); -- syllable 2
         syllable_3 : out std_logic_vector(31 downto 0); -- syllable 3
         syllable_4 : out std_logic_vector(31 downto 0); -- syllable 4 
         syllable_5 : out std_logic_vector(31 downto 0); -- syllable 5 
         syllable_6 : out std_logic_vector(31 downto 0); -- syllable 6 
         syllable_7 : out std_logic_vector(31 downto 0); -- syllable 7 

         -- General purpose registers prefetch

         gr_0_0     : out std_logic_vector (4 downto 0); -- address of first operand of syllable 0
         gr_0_1	    : out std_logic_vector (4 downto 0); -- address of second operand of syllable 0
         
         gr_1_0     : out std_logic_vector (4 downto 0);
         gr_1_1	    : out std_logic_vector (4 downto 0);
         
         gr_2_0     : out std_logic_vector (4 downto 0);
         gr_2_1	    : out std_logic_vector (4 downto 0);

         gr_3_0     : out std_logic_vector (4 downto 0);
         gr_3_1	    : out std_logic_vector (4 downto 0);

         gr_4_0     : out std_logic_vector (4 downto 0); 
         gr_4_1	    : out std_logic_vector (4 downto 0); 

         gr_5_0     : out std_logic_vector (4 downto 0);
         gr_5_1	    : out std_logic_vector (4 downto 0);
         
         gr_6_0     : out std_logic_vector (4 downto 0);
         gr_6_1	    : out std_logic_vector (4 downto 0);

         gr_7_0     : out std_logic_vector (4 downto 0);
         gr_7_1	    : out std_logic_vector (4 downto 0);

         -- branch register prefetch
         br_0       : out std_logic_vector (4 downto 0); -- address of branch register for syllable 0
         
         cycles     : out std_logic_vector(31 downto 0); -- number of clock cycles the execution took
         pc_inc     : out std_logic                     -- increment Program Counter

       );

end entity fetch_stage;

architecture behavioural of fetch_stage is

  signal running_s   : std_logic := '0';
  signal run_s       : std_logic := '0';
  signal cycles_i    : std_logic_vector(31 downto 0) :=(others => '0');
  signal stop_i      : std_logic := '0';
  signal out_valid_i : std_logic := '0';

begin	

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

    gr_0_0 <= (others => '0');                    
    gr_0_1 <= (others => '0');                    

    gr_1_0 <= (others => '0');                     
    gr_1_1 <= (others => '0');                      

    gr_2_0 <= (others => '0');                     
    gr_2_1 <= (others => '0');                     

    gr_3_0 <= (others => '0');
    gr_3_1 <= (others => '0'); 


    gr_4_0 <= (others => '0');
    gr_4_1 <= (others => '0'); 

    gr_5_0 <= (others => '0');
    gr_5_1 <= (others => '0'); 

    gr_6_0 <= (others => '0');
    gr_6_1 <= (others => '0'); 

    gr_7_0 <= (others => '0');
    gr_7_1 <= (others => '0');    

    br_0  <= (others => '0');
    pc_inc <= '0';
    
    running_s <= '0';

    if (start = '1' and reset = '0') then    
       
        pc_inc <= '1';        
        running_s <= '1';

        syllable_0 <= instr(31 downto 0);
        syllable_1 <= instr(63 downto 32);
        syllable_2 <= instr(95 downto 64);
        syllable_3 <= instr(127 downto 96);
        syllable_4 <= instr(159 downto 128);      
        syllable_5 <= instr(191 downto 160);
        syllable_6 <= instr(223 downto 192);
        syllable_7 <= instr(255 downto 224);


        -- Syllable 0 prefetch and handling  
        if (std_match(instr(31 downto 26), "0-----")) or (std_match(instr(31 downto 26), "10----")) then

        gr_0_0 <= instr (25 downto 21); -- operand 0
        gr_0_1 <= instr (20 downto 16); -- operand 1

      elsif (std_match(instr(31 downto 26), J_TYPE) ) then

        br_0 <= instr (25 downto 21);
        

      end if;
        -- End syllable 0 handling       

        -- Syllable 1 prefetch and handling  
      

      gr_1_0 <= instr (57 downto 53);
      gr_1_1 <= instr (52 downto 48);


    
        -- End syllable 1 handling       

        -- Syllable 2 prefetch and handling  
   

    gr_2_0 <= instr(89 downto 85);
    gr_2_1 <= instr(84 downto 80);
  
        -- End syllable 2 handling       

        -- Syllable 3 prefetch and handling  
  

  gr_3_0 <= instr(121 downto 117);
  gr_3_1 <= instr(116 downto 112);

        -- End syllable 3 handling       

        -- Syllable 4 prefetch and handling  

gr_4_0 <= instr(153 downto 149);
gr_4_1 <= instr(148 downto 144);

        -- End syllable 4 handling       

        -- Syllable 5 prefetch and handling  
       

        gr_5_0 <= instr(185 downto 181);
        gr_5_1 <= instr(180 downto 176);
 
        -- End syllable 5 handling       

        -- Syllable 6 prefetch and handling  
    

      gr_6_0 <= instr(217 downto 213);
      gr_6_1 <= instr(212 downto 208);
   
        -- End syllable 6 handling       

        -- Syllable 7 prefetch and handling  
  

    gr_7_0 <= instr(249 downto 245);
    gr_7_1 <= instr(244 downto 240);

    -- End syllable 7 handling       
   end if;
end if;
  end process fetch_out;

  -- Controls syllable fetch stage
  

end architecture behavioural;

