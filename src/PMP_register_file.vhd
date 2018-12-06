library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity gr_regfile is

    Port (

             clk      : in std_logic;
             rst      : in std_logic;

             -- syllable 0 in-out
             add_src_0        : in std_logic_vector(3 downto 0); -- address of syllable 0 source operand  
             add_dst_0_exe    : in std_logic_vector(3 downto 0); -- address of syllable 0 result from execution stage
             add_dst_0_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 0 dst reg from fetch stage
             w_e_0            : in std_logic;
             cont_src_0       : out std_logic_vector(63 downto 0); -- syllable 0 source operand
             cont_dst_0_exe   : in std_logic_vector(63 downto 0);  -- syllable 0 result from execution stage
             cont_dst_0_fetch : out std_logic_vector(63 downto 0);  -- syllable 0 preftech from fetch stage

             -- syllable 1 in-out
             add_src_1        : in std_logic_vector(3 downto 0); -- address of syllable 1 source operand  
             add_dst_1_exe    : in std_logic_vector(3 downto 0); -- address of syllable 1 result from execution stage
             add_dst_1_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 1 dst reg from fetch stage
             w_e_1            : in std_logic;
             cont_src_1       : out std_logic_vector(63 downto 0); -- syllable 1 source operand
             cont_dst_1_exe   : in std_logic_vector(63 downto 0);  -- syllable 1 result from execution stage
             cont_dst_1_fetch : out std_logic_vector(63 downto 0);  -- syllable 1 preftech from fetch stage

             -- syllable 2 in-out
             add_src_2        : in std_logic_vector(3 downto 0); -- address of syllable 2 source operand  
             add_dst_2_exe    : in std_logic_vector(3 downto 0); -- address of syllable 2 result from execution stage
             add_dst_2_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 2 dst reg from fetch stage
             w_e_2            : in std_logic;
             cont_src_2       : out std_logic_vector(63 downto 0); -- syllable 2 source operand
             cont_dst_2_exe   : in std_logic_vector(63 downto 0);  -- syllable 2 result from execution stage
             cont_dst_2_fetch : out std_logic_vector(63 downto 0);  -- syllable 2 preftech from fetch stage

             -- syllable 3 in-out
             add_src_3        : in std_logic_vector(3 downto 0); -- address of syllable 3 source operand  
             add_dst_3_exe    : in std_logic_vector(3 downto 0); -- address of syllable 3 result from execution stage
             add_dst_3_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 3 dst reg from fetch stage
             w_e_3            : in std_logic;
             cont_src_3       : out std_logic_vector(63 downto 0); -- syllable 3 source operand
             cont_dst_3_exe   : in std_logic_vector(63 downto 0);  -- syllable 3 result from execution stage
             cont_dst_3_fetch : out std_logic_vector(63 downto 0);  -- syllable 3 preftech from fetch stage

             -- syllable 4 in-out
             add_src_4        : in std_logic_vector(3 downto 0); -- address of syllable 4 source operand  
             add_dst_4_exe    : in std_logic_vector(3 downto 0); -- address of syllable 4 result from execution stage
             add_dst_4_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 4 dst reg from fetch stage
             w_e_4            : in std_logic;
             cont_src_4       : out std_logic_vector(63 downto 0); -- syllable 4 source operand
             cont_dst_4_exe   : in std_logic_vector(63 downto 0);  -- syllable 4 result from execution stage
             cont_dst_4_fetch : out std_logic_vector(63 downto 0);  -- syllable 4 preftech from fetch stage

             -- syllable 5 in-out
             add_src_5        : in std_logic_vector(3 downto 0); -- address of syllable 5 source operand  
             add_dst_5_exe    : in std_logic_vector(3 downto 0); -- address of syllable 5 result from execution stage
             add_dst_5_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 5 dst reg from fetch stage
             w_e_5            : in std_logic;
             cont_src_5       : out std_logic_vector(63 downto 0); -- syllable 5 source operand
             cont_dst_5_exe   : in std_logic_vector(63 downto 0);  -- syllable 5 result from execution stage
             cont_dst_5_fetch : out std_logic_vector(63 downto 0);  -- syllable 5 preftech from fetch stage

             -- syllable 6 in-out
             add_src_6        : in std_logic_vector(3 downto 0); -- address of syllable 6 source operand  
             add_dst_6_exe    : in std_logic_vector(3 downto 0); -- address of syllable 6 result from execution stage
             add_dst_6_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 6 dst reg from fetch stage
             w_e_6            : in std_logic;
             cont_src_6       : out std_logic_vector(63 downto 0); -- syllable 6 source operand
             cont_dst_6_exe   : in std_logic_vector(63 downto 0);  -- syllable 6 result from execution stage
             cont_dst_6_fetch : out std_logic_vector(63 downto 0);  -- syllable 6 preftech from fetch stage

             -- syllable 7 in-out
             add_src_7        : in std_logic_vector(3 downto 0); -- address of syllable 7 source operand  
             add_dst_7_exe    : in std_logic_vector(3 downto 0); -- address of syllable 7 result from execution stage
             add_dst_7_fetch  : in std_logic_vector(3 downto 0); -- address of syllable 7 dst reg from fetch stage
             w_e_7            : in std_logic;
             cont_src_7       : out std_logic_vector(63 downto 0); -- syllable 7 source operand
             cont_dst_7_exe   : in std_logic_vector(63 downto 0);  -- syllable 7 result from execution stage
             cont_dst_7_fetch : out std_logic_vector(63 downto 0)  -- syllable 7 preftech from fetch stage

);

end gr_regfile;

architecture Behavioral of gr_regfile is

    type gpr_type is array (15 downto 0) of std_logic_vector(63 downto 0);

    signal reg_file : gpr_type; 


begin

    process(clk)
    begin


        if rising_edge(clk) then

            if (rst = '1') then

                reg_file <= (others => x"0000000000000000"); 

            else
            
                        cont_src_0 <= reg_file(conv_integer(add_src_0));
                        cont_src_1 <= reg_file(conv_integer(add_src_1));
                        cont_src_2 <= reg_file(conv_integer(add_src_2));
                        cont_src_3 <= reg_file(conv_integer(add_src_3));
                        cont_src_4 <= reg_file(conv_integer(add_src_4));
                        cont_src_5 <= reg_file(conv_integer(add_src_5));
                        cont_src_6 <= reg_file(conv_integer(add_src_6));
                        cont_src_7 <= reg_file(conv_integer(add_src_7));
            
                        cont_dst_0_fetch <= reg_file(conv_integer(add_dst_0_fetch));
                        cont_dst_1_fetch <= reg_file(conv_integer(add_dst_1_fetch));
                        cont_dst_2_fetch <= reg_file(conv_integer(add_dst_2_fetch));
                        cont_dst_3_fetch <= reg_file(conv_integer(add_dst_3_fetch));
                        cont_dst_4_fetch <= reg_file(conv_integer(add_dst_4_fetch));
                        cont_dst_5_fetch <= reg_file(conv_integer(add_dst_5_fetch));
                        cont_dst_6_fetch <= reg_file(conv_integer(add_dst_6_fetch));
                        cont_dst_7_fetch <= reg_file(conv_integer(add_dst_7_fetch));



                if (w_e_0 = '1') then

                    reg_file(conv_integer(add_dst_0_exe)) <= cont_dst_0_exe;

                end if;

                if (w_e_1 = '1') then

                    reg_file(conv_integer(add_dst_1_exe)) <= cont_dst_1_exe;

                end if;

                if (w_e_2 = '1') then

                    reg_file(conv_integer(add_dst_2_exe)) <= cont_dst_2_exe;

                end if;

                if (w_e_3 = '1') then

                    reg_file(conv_integer(add_dst_3_exe)) <= cont_dst_3_exe;

                end if;

                if (w_e_4 = '1') then

                    reg_file(conv_integer(add_dst_4_exe)) <= cont_dst_4_exe;

                end if;

                if (w_e_5 = '1') then

                    reg_file(conv_integer(add_dst_5_exe)) <= cont_dst_5_exe;

                end if;

                if (w_e_6 = '1') then

                    reg_file(conv_integer(add_dst_6_exe)) <= cont_dst_6_exe;

                end if;

                if (w_e_7 = '1') then

                    reg_file(conv_integer(add_dst_7_exe)) <= cont_dst_7_exe;

                end if;

            end if;
        end if;
    end process;


end Behavioral;
