library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity gr_regfile is

  Port (

         clk      : in std_logic;
         rst      : in std_logic;

        -- syllable 0 in-out
         add_0_0  : in std_logic_vector(3 downto 0); -- address of syllable 0 first operand  
         add_0_1  : in std_logic_vector(3 downto 0); -- address of syllable 0 second operand
         add_0_d  : in std_logic_vector(3 downto 0); -- address of syllable 0 result from writeback stage
         w_e_0    : in std_logic;
         cont_0_0 : out std_logic_vector(63 downto 0); -- syllable 0 first operand
         cont_0_1 : out std_logic_vector(63 downto 0); -- syllable 0 second operand
         cont_0_d : in std_logic_vector(63 downto 0);  -- syllable 0 result from writeback stage

        -- syllable 1 in-out
         add_1_0  : in std_logic_vector(3 downto 0); -- address of syllable 0 first operand  
         add_1_1  : in std_logic_vector(3 downto 0); -- address of syllable 0 second operand
         add_1_d  : in std_logic_vector(3 downto 0); -- address of syllable 0 result from writeback stage
         w_e_1    : in std_logic;
         cont_1_0 : out std_logic_vector(63 downto 0); -- syllable 1 first operand
         cont_1_1 : out std_logic_vector(63 downto 0); -- syllable 1 second operand
         cont_1_d : in std_logic_vector(63 downto 0);  -- syllable 1 result from writeback stage

        -- syllable 2 in-out
         add_2_0  : in std_logic_vector(3 downto 0); -- address of syllable 1 first operand  
         add_2_1  : in std_logic_vector(3 downto 0); -- address of syllable 1 second operand
         add_2_d  : in std_logic_vector(3 downto 0); -- address of syllable 1 result from writeback stage
         w_e_2    : in std_logic;
         cont_2_0 : out std_logic_vector(63 downto 0); -- syllable 2 first operand
         cont_2_1 : out std_logic_vector(63 downto 0); -- syllable 2 second operand
         cont_2_d : in std_logic_vector(63 downto 0);  -- syllable 2 result from writeback stage

        -- syllable 3 in-out
         add_3_0  : in std_logic_vector(3 downto 0); -- address of syllable 2 first operand  
         add_3_1  : in std_logic_vector(3 downto 0); -- address of syllable 2 second operand
         add_3_d  : in std_logic_vector(3 downto 0); -- address of syllable 2 result from writeback stage
         w_e_3    : in std_logic;
         cont_3_0 : out std_logic_vector(63 downto 0); -- syllable 3 first operand
         cont_3_1 : out std_logic_vector(63 downto 0); -- syllable 3 second operand
         cont_3_d : in std_logic_vector(63 downto 0);  -- syllable 3 result from writeback stage

        -- syllable 4 in-out
         add_4_0  : in std_logic_vector(3 downto 0); -- address of syllable 4 first operand  
         add_4_1  : in std_logic_vector(3 downto 0); -- address of syllable 4 second operand
         add_4_d  : in std_logic_vector(3 downto 0); -- address of syllable 4 result from writeback stage
         w_e_4    : in std_logic;
         cont_4_0 : out std_logic_vector(63 downto 0); -- syllable 4 first operand
         cont_4_1 : out std_logic_vector(63 downto 0); -- syllable 4 second operand
         cont_4_d : in std_logic_vector(63 downto 0);  -- syllable 4 result from writeback stage

        -- syllable 5 in-out
         add_5_0  : in std_logic_vector(3 downto 0); -- address of syllable 5 first operand  
         add_5_1  : in std_logic_vector(3 downto 0); -- address of syllable 5 second operand
         add_5_d  : in std_logic_vector(3 downto 0); -- address of syllable 5 result from writeback stage
         w_e_5    : in std_logic;
         cont_5_0 : out std_logic_vector(63 downto 0); -- syllable 5 first operand
         cont_5_1 : out std_logic_vector(63 downto 0); -- syllable 5 second operand
         cont_5_d : in std_logic_vector(63 downto 0);  -- syllable 5 result from writeback stage

        -- syllable 6 in-out
         add_6_0  : in std_logic_vector(3 downto 0); -- address of syllable 6 first operand  
         add_6_1  : in std_logic_vector(3 downto 0); -- address of syllable 6 second operand
         add_6_d  : in std_logic_vector(3 downto 0); -- address of syllable 6 result from writeback stage
         w_e_6    : in std_logic;
         cont_6_0 : out std_logic_vector(63 downto 0); -- syllable 6 first operand
         cont_6_1 : out std_logic_vector(63 downto 0); -- syllable 6 second operand
         cont_6_d : in std_logic_vector(63 downto 0);  -- syllable 6 result from writeback stage

        -- syllable 7 in-out
         add_7_0  : in std_logic_vector(3 downto 0); -- address of syllable 7 first operand  
         add_7_1  : in std_logic_vector(3 downto 0); -- address of syllable 7 second operand
         add_7_d  : in std_logic_vector(3 downto 0); -- address of syllable 7 result from writeback stage
         w_e_7    : in std_logic;
         cont_7_0 : out std_logic_vector(63 downto 0); -- syllable 7 first operand
         cont_7_1 : out std_logic_vector(63 downto 0); -- syllable 7 second operand
         cont_7_d : in std_logic_vector(63 downto 0)  -- syllable 7 result from writeback stage

       );
end gr_regfile;

architecture Behavioral of gr_regfile is

  type gpr_type is array (63 downto 0) of std_logic_vector(15 downto 0);

  signal reg_file : gpr_type := (others => x"00000000"); 


--attribute mark_debug: string;
--attribute keep:string;
--attribute mark_debug of reg_file :signal is "TRUE";
--attribute keep of reg_file :signal is "TRUE";


begin
      -- Register 0 contain 0 costant
      -- Register 31 contains 40000000 constant for TUSER OUT addressing
      -- read process

  
  cont_0_0 <= reg_file(conv_integer(add_0_0));
  cont_0_1 <= reg_file(conv_integer(add_0_1));
  cont_1_0 <= reg_file(conv_integer(add_1_0));
  cont_1_1 <= reg_file(conv_integer(add_1_1));
  cont_2_0 <= reg_file(conv_integer(add_2_0));
  cont_2_1 <= reg_file(conv_integer(add_2_1));
  cont_3_0 <= reg_file(conv_integer(add_3_0));
  cont_3_1 <= reg_file(conv_integer(add_3_1));
  cont_4_0 <= reg_file(conv_integer(add_4_0));
  cont_4_1 <= reg_file(conv_integer(add_4_1));
  cont_5_0 <= reg_file(conv_integer(add_5_0));
  cont_5_1 <= reg_file(conv_integer(add_5_1));
  cont_6_0 <= reg_file(conv_integer(add_6_0));
  cont_6_1 <= reg_file(conv_integer(add_6_1));
  cont_7_0 <= reg_file(conv_integer(add_7_0));
  cont_7_1 <= reg_file(conv_integer(add_7_1));

  -- write process

  process(clk)
  begin


    if rising_edge(clk) then
    
        if (rst = '1') then
        
            reg_file <= (others => x"00000000"); 
        
        else
               
            
      if (w_e_0 = '1') then

        reg_file(conv_integer(add_0_d)) <= cont_0_d;

      end if;

      if (w_e_1 = '1') then

        reg_file(conv_integer(add_1_d)) <= cont_1_d;

      end if;

      if (w_e_2 = '1') then

        reg_file(conv_integer(add_2_d)) <= cont_2_d;

      end if;

      if (w_e_3 = '1') then

        reg_file(conv_integer(add_3_d)) <= cont_3_d;

      end if;

      if (w_e_4 = '1') then

        reg_file(conv_integer(add_4_d)) <= cont_4_d;

      end if;

      if (w_e_5 = '1') then

        reg_file(conv_integer(add_5_d)) <= cont_5_d;

      end if;

      if (w_e_6 = '1') then

        reg_file(conv_integer(add_6_d)) <= cont_6_d;

      end if;

      if (w_e_7 = '1') then

        reg_file(conv_integer(add_7_d)) <= cont_7_d;

      end if;

    end if;
    end if;
  end process;


end Behavioral;
