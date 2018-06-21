library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity gr_regfile is

  Port (

         clk      : in std_logic;
         rst      : in std_logic;

         -- syllable 0 in-out
         add_src_0  : in std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
         add_dst_0  : in std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
         w_e_0      : in std_logic;
         cont_src_0 : out std_logic_vector(63 downto 0); -- syllable 0 source operand
         cont_dst_0 : in std_logic_vector(63 downto 0);  -- syllable 0 result from execution stage

         -- syllable 1 in-out
         add_src_1  : in std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
         add_dst_1  : in std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
         w_e_1      : in std_logic;
         cont_src_1 : out std_logic_vector(63 downto 0); -- syllable 1 source operand
         cont_dst_1 : in std_logic_vector(63 downto 0);  -- syllable 1 result from execution stage

         -- syllable 2 in-out
         add_src_2  : in std_logic_vector(3 downto 0); -- address of syllable 1 source operand  
         add_dst_2  : in std_logic_vector(3 downto 0); -- address of syllable 1 result from execution stage
         w_e_2      : in std_logic;
         cont_src_2 : out std_logic_vector(63 downto 0); -- syllable 2 source operand
         cont_dst_2 : in std_logic_vector(63 downto 0);  -- syllable 2 result from execution stage

         -- syllable 3 in-out
         add_src_3  : in std_logic_vector(3 downto 0); -- address of syllable 2 source operand  
         add_dst_3  : in std_logic_vector(3 downto 0); -- address of syllable 2 result from execution stage
         w_e_3      : in std_logic;
         cont_src_3 : out std_logic_vector(63 downto 0); -- syllable 3 source operand
         cont_dst_3 : in std_logic_vector(63 downto 0);  -- syllable 3 result from execution stage

         -- syllable 4 in-out
         add_src_4  : in std_logic_vector(3 downto 0); -- address of syllable 4 source operand  
         add_dst_4  : in std_logic_vector(3 downto 0); -- address of syllable 4 result from execution stage
         w_e_4      : in std_logic;
         cont_src_4 : out std_logic_vector(63 downto 0); -- syllable 4 source operand
         cont_dst_4 : in std_logic_vector(63 downto 0);  -- syllable 4 result from execution stage

         -- syllable 5 in-out
         add_src_5  : in std_logic_vector(3 downto 0); -- address of syllable 5 source operand  
         add_dst_5  : in std_logic_vector(3 downto 0); -- address of syllable 5 result from execution stage
         w_e_5      : in std_logic;
         cont_src_5 : out std_logic_vector(63 downto 0); -- syllable 5 source operand
         cont_dst_5 : in std_logic_vector(63 downto 0);  -- syllable 5 result from execution stage

         -- syllable 6 in-out
         add_src_6  : in std_logic_vector(3 downto 0); -- address of syllable 6 source operand  
         add_dst_6  : in std_logic_vector(3 downto 0); -- address of syllable 6 result from execution stage
         w_e_6      : in std_logic;
         cont_src_6 : out std_logic_vector(63 downto 0); -- syllable 6 source operand
         cont_dst_6 : in std_logic_vector(63 downto 0);  -- syllable 6 result from execution stage

         -- syllable 7 in-out
         add_src_7  : in std_logic_vector(3 downto 0); -- address of syllable 7 source operand  
         add_dst_7  : in std_logic_vector(3 downto 0); -- address of syllable 7 result from execution stage
         w_e_7      : in std_logic;
         cont_src_7 : out std_logic_vector(63 downto 0); -- syllable 7 source operand
         cont_dst_7 : in std_logic_vector(63 downto 0)  -- syllable 7 result from execution stage

       );

end gr_regfile;

architecture Behavioral of gr_regfile is

  type gpr_type is array (15 downto 0) of std_logic_vector(63 downto 0);

  signal reg_file : gpr_type := (others => x"0000000000000000"); 


--attribute mark_debug: string;
--attribute keep:string;
--attribute mark_debug of reg_file :signal is "TRUE";
--attribute keep of reg_file :signal is "TRUE";


begin

  -- read process

  process(clk)

  begin

    if rising_edge(clk) then

      cont_src_0 <= reg_file(conv_integer(add_src_0));
      cont_src_1 <= reg_file(conv_integer(add_src_0));
      cont_src_2 <= reg_file(conv_integer(add_src_0));
      cont_src_3 <= reg_file(conv_integer(add_src_0));
      cont_src_4 <= reg_file(conv_integer(add_src_0));
      cont_src_5 <= reg_file(conv_integer(add_src_0));
      cont_src_6 <= reg_file(conv_integer(add_src_0));
      cont_src_7 <= reg_file(conv_integer(add_src_0));

    end if;

  end process;
  
  -- write process

  process(clk)
  begin


    if rising_edge(clk) then

      if (rst = '1') then

        reg_file <= (others => x"0000000000000000"); 

      else


        if (w_e_0 = '1') then

          reg_file(conv_integer(add_dst_0)) <= cont_dst_0;

        end if;

        if (w_e_1 = '1') then

          reg_file(conv_integer(add_dst_1)) <= cont_dst_1;

        end if;

        if (w_e_2 = '1') then

          reg_file(conv_integer(add_dst_2)) <= cont_dst_2;

        end if;

        if (w_e_3 = '1') then

          reg_file(conv_integer(add_dst_3)) <= cont_dst_3;

        end if;

        if (w_e_4 = '1') then

          reg_file(conv_integer(add_dst_4)) <= cont_dst_4;

        end if;

        if (w_e_5 = '1') then

          reg_file(conv_integer(add_dst_5)) <= cont_dst_5;

        end if;

        if (w_e_6 = '1') then

          reg_file(conv_integer(add_dst_6)) <= cont_dst_6;

        end if;

        if (w_e_7 = '1') then

          reg_file(conv_integer(add_dst_7)) <= cont_dst_7;

        end if;

      end if;
    end if;
  end process;


end Behavioral;
