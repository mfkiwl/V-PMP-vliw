library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;
use work.alu_operations.all;


entity alu_pmp is
  Port ( 

         alu_select_n   : in std_logic;   -- negate

         syllable     : in std_logic_vector(31 downto 0); 
         operand_0    : in std_logic_vector(31 downto 0);
         operand_1    : in std_logic_vector(31 downto 0);
         immediate    : in std_logic_vector(31 downto 0);
         gr_add_dec   : in std_logic_vector(4 downto 0); -- general purpose register destination from decode stage
         br_add_dec   : in std_logic_vector(4 downto 0); -- branch register destination fromdecode stage

         gr_add_w       : out std_logic_vector(4 downto 0);
         br_add_w       : out std_logic_vector(4 downto 0);
         w_e_gr       : out std_logic;
         w_e_br       : out std_logic;
         result_gr    : out std_logic_vector(31 downto 0);
         result_br    : out std_logic


       );

end alu_pmp;

architecture Behavioral of alu_pmp is

  signal alu_op : std_logic_vector(5 downto 0);

begin

  alu_op <= syllable(31 downto 26);

  alu_control : process(alu_op,syllable, alu_select_n, operand_0, operand_1, immediate, gr_add_dec, br_add_dec)

  begin

    result_gr <= (others => '0');
    result_br <= '0';
    gr_add_w <= (others => '0');
    br_add_w <= (others => '0'); 
    w_e_gr <= '0';
    w_e_br <= '0';


    if (alu_select_n = '1') then

      result_gr <= (others => '0');
      result_br <= '0';
      w_e_gr <= '0';
      w_e_br <= '0';
      gr_add_w <= (others => '0');
      br_add_w <= (others => '0');

    else


      if (syllable = x"00000000") then

        result_gr <= (others => '0'); 
        result_br <= '0';             
        w_e_gr <= '0';                
        w_e_br <= '0';                
        gr_add_w <= (others => '0');  
        br_add_w <= (others => '0');  

      else
        -- R-Type

        if std_match(alu_op, ADD_OPC) then
          result_gr <= f_ADD (operand_0, operand_1);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, AND_OPC) then
          result_gr <= f_AND (operand_0, operand_1);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, OR_OPC) then
          result_gr <= f_OR (operand_0, operand_1);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, SLL_OPC) then
          result_gr <= f_SHL (operand_0, immediate);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, SRL_OPC) then
          result_gr <= f_SHRU (operand_0, immediate);
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';  
          result_br <= '0';
          w_e_br <= '0';

        elsif std_match(alu_op, SUB_OPC) then
          result_gr <= f_SUB (operand_0, operand_1);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';                   

        elsif std_match(alu_op, XOR_OPC) then
          result_gr <= f_XOR (operand_0, operand_1);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, SLT_OPC) then -- destination branch register
          result_br <= f_SLT (operand_0, operand_1);
          result_gr <= (others => '0');
          gr_add_w <= (others =>'0');
          br_add_w <= br_add_dec;
          w_e_br <= '1';
          w_e_gr <= '0';


        -- I-Type
        elsif std_match(alu_op, ADDI_OPC) then
          result_gr <= f_ADD (operand_0, immediate);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, ANDI_OPC) then
          result_gr <= f_AND (operand_0, immediate);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, ORI_OPC) then
          result_gr <= f_OR (operand_0, immediate);
          result_br <= '0';
          gr_add_w <= gr_add_dec;
          br_add_w <= (others => '0');
          w_e_gr <= '1';
          w_e_br <= '0';

        elsif std_match(alu_op, SLTI_OPC) then -- destination branch register
          result_br <= f_SLT (operand_0, immediate);
          result_gr <= (others => '0');
          gr_add_w <= (others =>'0');
          br_add_w <= br_add_dec;    
          w_e_br <= '1';           
          w_e_gr <= '0';  

        else
          result_gr <= (others => '0'); 
          result_br <= '0';             
          w_e_gr <= '0';                
          w_e_br <= '0';                
          gr_add_w <= (others => '0');  
          br_add_w <= (others => '0');  

        end if;
      end if;
    end if;
  end process alu_control;

end Behavioral;
