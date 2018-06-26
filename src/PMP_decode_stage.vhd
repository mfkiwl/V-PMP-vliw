library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.common_pkg.all;


entity decode_stage is

  Port (
         clk                   : in std_logic;
         reset                 : in std_logic;
         stop                  : in std_logic; 
         branch                : in std_logic;    

         syllable              : in std_logic_vector(63 downto 0);

         src_reg_add           : in std_logic_vector(3 downto 0);
         src_reg_cont          : in std_logic_vector(63 downto 0);  -- from GP register file

         exe_result            : in std_logic_vector(63 downto 0);  -- result from EXE stage for lane forwarding
         alu_operand           : out std_logic_vector(63 downto 0);
         alu_immediate         : out std_logic_vector(10 downto 0);
         exe_opc               : out std_logic_vector(1 downto 0);  -- execution stage opc 00=alu, 01=control, 10= mem
         alu_dest_reg          : out std_logic_vector(3 downto 0);  -- alu destination register for writeback 
         wb_reg_add            : in std_logic_vector(3 downto 0);   -- current register address in writeback     

         mem_dest_reg_add      : out std_logic_vector(3 downto 0);  -- destination register for load
         mem_store_data        : out std_logic_vector(63 downto 0); -- data to store      
         mem_l_s               : out std_logic;                     -- '0' for load, '1' for store
         mem_add               : out std_logic_vector(63 downto 0); -- memory address for load and store
         mem_load_data         : in std_logic_vector(63 downto 0)     -- data incoming from memory

       );

end decode_stage;

architecture Behavioral of decode_stage is

  type decode_states is (reset_state, decoding);
  signal current_state, next_state: decode_states;

  signal mem_base_add_s : std_logic_vector(63 downto 0) := (others => '0');
  signal mem_offset_s   : std_logic_vector(31 downto 0) := (others => '0');

begin

  decode_output: process(clk)

  begin

    if rising_edge(clk) then

      if (reset = '0') then  

          alu_oper_0        <= (others => '0'); 
          alu_immediate     <= (others => '0'); 
          alu_dest          <= (others => '0');
          exe_opc           <= (others => '0'); 
          mem_l_s           <= '0';
          mem_dest_reg      <= (others => '0');
          mem_store_d       <= (others => '0'); 
          mem_add           <= (others => '0');

          jump_add          <= (others => '0');
          br_reg_add        <= (others => '0');
          br_cont_out       <= '0';   
          syllable_out      <= (others => '0');      


          if (branch = '0') then   

            syllable_out <= syllable;

            if(std_match((syllable(31 downto 26)), R_TYPE)) then

              if (current_gr_wrt = oper_0_add) and (current_gr_wrt > "00000") then

                alu_oper_0 <= exe_result;

              else

                alu_oper_0 <= operand_0;

              end if;


              if (current_gr_wrt = oper_1_add) and (current_gr_wrt > "00000") then

                alu_oper_1 <= exe_result;

              else

                alu_oper_1 <= operand_1;

              end if;

              alu_immediate   <= (others => '0');
              exe_opc         <= "00";
              alu_dest        <= syllable(15 downto 11); -- address of GPR destination
              mem_dest_reg    <= (others => '0'); -- destination GPR from load
              mem_store_d     <= (others => '0'); -- data to store
              br_reg_add <= syllable(15 downto 11);
              mem_l_s         <= '0';
              mem_add       <= (others => '0');
              jump_add        <= (others => '0');
              br_cont_out     <= '0';

            elsif ((std_match((syllable(31 downto 26)), I_TYPE_1)) or (std_match((syllable(31 downto 26)), I_TYPE_2))) then


              if( syllable(31 downto 26) >= ADDI_OPC and syllable(31 downto 26) <= SLTI_OPC) then --ALU immediate

                if (current_gr_wrt = oper_0_add) and (current_gr_wrt > "00000") then

                  alu_oper_0 <= exe_result;
                  report "Forwarded";

                else

                  alu_oper_0 <= operand_0;

                end if;

                alu_oper_1        <= (others => '0'); -- immediate type so no other operand
                alu_immediate   <= syllable(10 downto 0);
                exe_opc         <= "00";
                alu_dest        <= syllable(15 downto 11); -- address of the destination register

                mem_dest_reg    <= (others => '0');
                mem_l_s         <= '0';
                mem_store_d     <= (others => '0'); 
                mem_add         <= (others => '0');

                br_reg_add <= syllable(15 downto 11);
                br_cont_out     <= '0';
                jump_add        <= (others => '0');

              else -- MEM operation

                alu_oper_0        <= (others => '0'); 
                alu_oper_1        <= (others => '0'); 
                alu_immediate   <= (others => '0');
                exe_opc         <= "10";
                alu_dest        <= (others => '0'); 

                mem_dest_reg    <= syllable(15 downto 11); -- destination register for load

                if (syllable(31 downto 26) >= LDW_OPC and syllable(31 downto 26) <= LLB_OPC) then

                  mem_l_s         <= '0'; -- load or store

                else

                  mem_l_s <= '1';

                end if;


                if (current_gr_wrt = oper_1_add)and (current_gr_wrt > "00000") then 

                  mem_store_d <= exe_result;
                  report "Forwarded";

                else

                  mem_store_d     <= operand_1 ; -- data to store to memory

                end if;

                br_cont_out     <= '0';
                jump_add        <= (others => '0');

                -- Address prefetch for Load (otherwise take 2 clock cycles)
                if (current_gr_wrt = oper_0_add) and (current_gr_wrt > "00000") then

                  mem_add <= operand_0 + exe_result;

                else

                  mem_add <= operand_0 + (x"00000" & '0'  & syllable(10 downto 0));

                end if;

              end if;

            elsif(std_match((syllable(31 downto 26)), J_TYPE)) then

              alu_oper_0        <= (others => '0'); 
              alu_oper_1        <= (others => '0'); 
              alu_immediate   <= (others => '0'); 
              exe_opc         <= "01"; 
              mem_l_s         <= '0';
              mem_store_d     <= (others => '0'); 
              mem_add         <= (others => '0');


              br_reg_add      <= syllable(25 downto 21);

              if (syllable(25 downto 21) = br_current_add_write) then

                br_cont_out <= br_current_data_write;
                report "Forwarded";

              else

                br_cont_out     <= br_cont_in; 

              end if;

              jump_add        <= syllable(7 downto 0);
            
            end if;

          else

            alu_oper_0        <= (others => '0'); 
            alu_oper_1        <= (others => '0'); 
            alu_immediate     <= (others => '0'); 
            alu_dest          <= (others => '0');
            exe_opc           <= (others => '0'); 
            mem_l_s           <= '0';
            mem_dest_reg      <= (others => '0');
            mem_store_d       <= (others => '0'); 
            mem_add           <= (others => '0');

            jump_add          <= (others => '0');
            br_reg_add        <= (others => '0');
            br_cont_out       <= '0';   
            syllable_out      <= (others => '0');      

          end if;

      end if;
    end if;
  end process;

end Behavioral;
