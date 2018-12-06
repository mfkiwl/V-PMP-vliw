library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

library work;
use work.common_pkg.all;

entity alu64 is
    Port ( 

             alu64_select     : in std_logic;

             syllable         : in std_logic_vector(63 downto 0); 
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)


         );

end alu64;

architecture Behavioral of alu64 is

    signal opc : std_logic_vector(7 downto 0);
    signal immediate_numeric : signed(31 downto 0);
    signal immediate_integer : integer;
    signal src_numeric : signed(63 downto 0);
    signal src_integer : integer;
    signal dst_numeric : signed(63 downto 0);
    signal dst_integer : integer;
    signal opc_string : string(1 to 5);
    signal s_axis_divisor_tvalid : std_logic;
    signal s_axis_divisor_tdata: std_logic_vector(63 downto 0);
    signal s_axis_dividend_tvalid : std_logic;
    signal s_axis_dividend_tdata : std_logic_vector(63 downto 0);
    signal m_axis_dout_tvalid : std_logic;
    signal m_axis_dout_tdata : std_logic_vector(127 downto 0);
    signal quotient: std_logic_vector(63 downto 0);
    signal remainder: std_logic_vector(63 downto 0);

begin

DIV_64: entity work.divider_64 port map (
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );

    opc <= syllable(7 downto 0);
    immediate_numeric <= signed(immediate);
    immediate_integer <= to_integer(signed(immediate));
    src_numeric <= signed(operand_src);
    src_integer <= to_integer(signed(operand_src));
    dst_numeric <= signed(operand_dst);
    dst_integer <= to_integer(signed(operand_dst));
    
    quotient <= m_axis_dout_tdata(127 downto 64) when m_axis_dout_tvalid = '1' else
                    (others => '0');
                    
    remainder <= m_axis_dout_tdata(63 downto 0) when m_axis_dout_tvalid = '1' else
                    (others => '0');
    


    alu_control : process(opc, alu64_select, operand_src, operand_dst, immediate, gr_add_dst, immediate_integer, dst_integer)

    begin
        result_gr <= (others => '0');
        gr_add_w <= (others => '0');
        w_e_gr <= '0';
        opc_string <= "_____";
        s_axis_divisor_tdata <= (others => '0');
        s_axis_dividend_tdata <= (others => '0');
        s_axis_divisor_tvalid <= '0';
        s_axis_dividend_tvalid <= '0';
        

        if (alu64_select = '1') then -- START EXECUTING

            case opc is 

                when NOP_OPC =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';
                    opc_string <= "__NOP";

                when ADDI_OPC =>

                    result_gr <= operand_dst + (x"00000000" & immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ADDI";


                when ADD_OPC =>

                    result_gr <= operand_dst + operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__ADD";

                when SUBI_OPC =>

                    result_gr <= operand_dst - (x"00000000" & immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_SUBI";

                when SUB_OPC =>

                    result_gr <= operand_dst - operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__SUB";

                when MULI_OPC =>

                    result_gr <= std_logic_vector(signed(immediate)*signed(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_MULI";

                when MUL_OPC =>

                    result_gr <= std_logic_vector(signed(operand_src(31 downto 0))*signed(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__MUL";

                when DIVI_OPC =>

                    opc_string <= "_DIVI";
                    result_gr <= quotient;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= x"00000000" & immediate;
                    s_axis_dividend_tdata <= operand_dst;
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when DIV_OPC => 

                    opc_string <= "__DIV";
                    result_gr <= quotient;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= operand_src;
                    s_axis_dividend_tdata <= operand_dst;
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when ORI_OPC =>

                    result_gr <= operand_dst or  x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__ORI";

                when OR_OPC =>

                    result_gr <= operand_dst or operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "___OR";

                when ANDI_OPC =>

                    result_gr <= operand_dst and  x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ANDI";

                when AND_OPC =>

                    result_gr <= operand_dst and operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__AND";

                when LSHI_OPC =>

                    result_gr <= std_logic_vector(shift_left(unsigned(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_LSHI";

                when LSH_OPC =>

                    result_gr <= std_logic_vector(shift_left(unsigned(operand_dst),to_integer(unsigned(operand_src))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__LSH";

                when RSHI_OPC =>

                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_RSHI";

                when RSH_OPC =>

                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(operand_src))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__RSH";

                when NEG_OPC =>

                    result_gr <= std_logic_vector(-signed(operand_dst));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__NEG";

                when MODI_OPC =>

                    opc_string <= "_MODI";
                    result_gr <=remainder;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= x"00000000" & immediate;
                    s_axis_dividend_tdata <= operand_dst;
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when MOD_OPC =>

                    opc_string <= "__MOD";
                    result_gr <= remainder;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= operand_src;
                    s_axis_dividend_tdata <= operand_dst;
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when XORI_OPC =>

                    result_gr <= operand_dst xor x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_XORI";

                when XOR_OPC =>

                    result_gr <= operand_dst xor operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__XOR";

                when MOVI_OPC =>

                    result_gr <= x"00000000" & immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_MOVI";

                when MOV_OPC =>

                    result_gr <= operand_src;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__MOV";

                when ARSHI_OPC =>

                    result_gr <= std_logic_vector(shift_right(signed(operand_dst),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "ARSHI";

                when ARSH_OPC =>

                    result_gr <= std_logic_vector(shift_right(unsigned(operand_dst),to_integer(unsigned(operand_src))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ARSH";

                -- MANCANO I BYTE SWAP

                when others =>

                    result_gr <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';
                    opc_string <= "-----";

                                  end case;

                end if;

            end process alu_control;



        end Behavioral;


