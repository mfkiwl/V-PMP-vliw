library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


library work;
use work.common_pkg.all;

entity alu32 is
    Port ( 

             alu32_select     : in std_logic;

             syllable         : in std_logic_vector(63 downto 0); 
             operand_src      : in std_logic_vector(63 downto 0);
             operand_dst      : in std_logic_vector(63 downto 0);
             immediate        : in std_logic_vector(31 downto 0);
             gr_add_dst       : in std_logic_vector(3 downto 0); -- destination register

             gr_add_w         : out std_logic_vector(3 downto 0);
             w_e_gr           : out std_logic;
             result_gr        : out std_logic_vector(63 downto 0)

         );

end alu32;

architecture Behavioral of alu32 is

    signal opc : std_logic_vector(7 downto 0);
    signal result_gr_red : std_logic_vector(31 downto 0);
    signal opc_string : string(1 to 5);
    signal s_axis_divisor_tvalid : std_logic;
    signal s_axis_divisor_tdata: std_logic_vector(31 downto 0);
    signal s_axis_dividend_tvalid : std_logic;
    signal s_axis_dividend_tdata : std_logic_vector(31 downto 0);
    signal m_axis_dout_tvalid : std_logic;
    signal m_axis_dout_tdata : std_logic_vector(63 downto 0);
    signal quotient: std_logic_vector(31 downto 0);
    signal remainder: std_logic_vector(31 downto 0);

begin

DIV_32: entity work.divider_32 port map (
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
    opc <= syllable(7 downto 0);
    result_gr <= x"00000000" & result_gr_red;
    
    quotient <= m_axis_dout_tdata(63 downto 32) when m_axis_dout_tvalid = '1' else
                (others => '0');
                
    remainder <= m_axis_dout_tdata(63 downto 32) when m_axis_dout_tvalid = '1' else
                (others => '0');

    alu_control : process(opc, alu32_select, operand_src, operand_dst, immediate, gr_add_dst,m_axis_dout_tvalid,m_axis_dout_tdata)

    begin

        result_gr <= (others => '0');
        gr_add_w <= (others => '0');
        w_e_gr <= '0';
        opc_string <= "_____";
                s_axis_divisor_tdata <= (others => '0');
        s_axis_dividend_tdata <= (others => '0');
        s_axis_divisor_tvalid <= '0';
        s_axis_dividend_tvalid <= '0';

        if (alu32_select = '1') then -- START EXECUTING

            case opc is 

                when NOP32_OPC =>

                    result_gr_red <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';
                    opc_string <= "__NOP";

                when ADDI32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) + (immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ADDI";

                when ADD32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) + operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__ADD";

                when SUBI32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) - (immediate);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_SUBI";

                when SUB32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) - operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__SUB";

                when MULI32_OPC =>

                    result_gr_red <= std_logic_vector(signed(immediate(15 downto 0))*signed(operand_dst(15 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_MULI";

                when MUL32_OPC =>

                    result_gr_red <= std_logic_vector(signed(operand_src(15 downto 0))*signed(operand_dst(15 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__MUL";

                when DIVI32_OPC =>

                    opc_string <= "_DIVI";
                    result_gr_red <= quotient;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= immediate;
                    s_axis_dividend_tdata <= operand_dst(31 downto 0);
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when DIV32_OPC => 

                    opc_string <= "__DIV";
                    result_gr_red <= quotient;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= operand_src(31 downto 0);
                    s_axis_dividend_tdata <= operand_dst(31 downto 0);
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when ORI32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) or immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__ORI";

                when OR32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) or operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "___OR";

                when ANDI32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) and immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ANDI";

                when AND32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) and operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__AND";

                when LSHI32_OPC =>

                    result_gr_red <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)), to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_LSHI";

                when LSH32_OPC =>

                    result_gr_red <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__LSH";

                when RSHI32_OPC =>
                    result_gr_red <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_RSHI";

                when RSH32_OPC =>
                    result_gr_red <= std_logic_vector(shift_left(unsigned(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__RSH";

                when NEG32_OPC =>

                    result_gr_red <= std_logic_vector(-signed(operand_dst(31 downto 0)));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__NEG";

                when MODI32_OPC =>

                    opc_string <= "_MODI";
                    result_gr_red <=remainder;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= immediate;
                    s_axis_dividend_tdata <= operand_dst(31 downto 0);
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when MOD32_OPC =>

                    opc_string <= "__MOD";
                    result_gr_red <= remainder;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    s_axis_divisor_tdata <= operand_src(31 downto 0);
                    s_axis_dividend_tdata <= operand_dst(31 downto 0);
                    s_axis_divisor_tvalid <= '1';
                    s_axis_dividend_tvalid <= '1';

                when XORI32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) xor immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_XORI";

                when XOR32_OPC =>

                    result_gr_red <= operand_dst(31 downto 0) xor operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__XOR";

                when MOVI32_OPC =>

                    result_gr_red <= immediate;
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_MOVI";

                when MOV32_OPC =>

                    result_gr_red <= operand_src(31 downto 0);
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "__MOV";

                when ARSHI32_OPC =>

                    result_gr_red <= std_logic_vector(shift_right(signed(operand_dst(31 downto 0)),to_integer(unsigned(immediate))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "ARSHI";

                when ARSH32_OPC =>

                    result_gr_red <= std_logic_vector(shift_right(signed(operand_dst(31 downto 0)),to_integer(unsigned(operand_src(31 downto 0)))));
                    gr_add_w <= gr_add_dst;
                    w_e_gr <= '1';
                    opc_string <= "_ARSH";

                    -- MANCANO I BYTE SWAP
                when others =>

                    result_gr_red <= (others => '0');
                    gr_add_w <= (others => '0');
                    w_e_gr <= '0';

            end case;

        end if;

    end process alu_control;



end Behavioral;
