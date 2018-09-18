library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity branch_reg is
  Port (

         clk : in std_logic;
         reset  : in std_logic;

        -- syllable 0 add an in 
         br_add_0_r : in std_logic_vector(4 downto 0);
         br_add_0_w : in std_logic_vector(4 downto 0);
         br_in_0    : in std_logic;
         w_e_0      : in std_logic;
         br_out_0 : out std_logic;

        -- syllable 1 add an in 
         br_add_1_w : in std_logic_vector(4 downto 0);
         br_in_1  : in std_logic;
         w_e_1   : in std_logic;

        -- syllable 2 add an in 
         br_add_2_w : in std_logic_vector(4 downto 0);
         br_in_2  : in std_logic;
         w_e_2    : in std_logic;

        -- syllable 3 add an in 
         br_add_3_w : in std_logic_vector(4 downto 0);
         br_in_3  : in std_logic;
         w_e_3    : in std_logic;

        -- syllable 4 add an in 
         br_add_4_w : in std_logic_vector(4 downto 0);
         br_in_4  : in std_logic;
         w_e_4    : in std_logic;

        -- syllable 5 add an in 
         br_add_5_w : in std_logic_vector(4 downto 0);
         br_in_5  : in std_logic;
         w_e_5    : in std_logic;

        -- syllable 6 add an in 
         br_add_6_w : in std_logic_vector(4 downto 0);
         br_in_6  : in std_logic;
         w_e_6    : in std_logic;

        -- syllable 7 add an in         
         br_add_7_w : in std_logic_vector(4 downto 0);
         br_in_7  : in std_logic;
         w_e_7    : in std_logic

       );
end branch_reg;

architecture Behavioral of branch_reg is

  signal br_reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- write process

  process (clk, reset)

  begin

    if (reset = '1') then

      br_reg <= (others => '0');

    elsif rising_edge(clk) then

      if (w_e_0 = '1') then

        br_reg(conv_integer(br_add_0_w)) <= br_in_0;

      end if;

      if (w_e_1= '1') then

        br_reg(conv_integer(br_add_1_w)) <= br_in_1;

      end if;

      if (w_e_2 = '1') then

        br_reg(conv_integer(br_add_2_w)) <= br_in_2;

      end if;

      if (w_e_3 = '1') then

        br_reg(conv_integer(br_add_3_w)) <= br_in_3;

      end if;

      if (w_e_4 = '1') then

        br_reg(conv_integer(br_add_4_w)) <= br_in_4;

      end if;

      if (w_e_5 = '1') then

        br_reg(conv_integer(br_add_5_w)) <= br_in_5;

      end if;

      if (w_e_6 = '1') then

        br_reg(conv_integer(br_add_6_w)) <= br_in_6;

      end if;

      if (w_e_7 = '1') then

        br_reg(conv_integer(br_add_7_w)) <= br_in_7;

      end if;

    end if;

  end process;
            -- read process


  process (clk)
  begin

    if rising_edge(clk) then
      br_out_0 <= br_reg(conv_integer(br_add_0_r));
    end if;

  end process;




end Behavioral;
