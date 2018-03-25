#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "common.h"
#include "opcode.h"

void check_args(int argc) {

  if (argc == 1) {

    printf("Invalid argumets\nUsage is: pmp_asm \"filename\"\n");
    exit(1);

  } else printf("Welcome to the ASM->VHDL for the PMP\nOutput file will be %s\n", FILENAME);

}

void out_file_manage(_Bool mode) {

  // mode 0 to open the file and mode 1 to close the file

  if (mode == 0) {

    if ((out_file_ptr = fopen(FILENAME, "w+")) == NULL) {

      printf("Error\nUnable to open file %s for write\n", FILENAME);
      exit(2);

    }
  } else fclose(out_file_ptr);

}

void print_header() {

  fprintf(out_file_ptr, "\
      library ieee;\n\
      use ieee.std_logic_1164.all;\n\
      \n\
      entity i_mem is\n\
      \tport ( \n\
        \t       reset   : in std_logic;                        -- system reset\n\
        \t       address : in std_logic_vector(7 downto 0);     -- address of instruction to be read\n\
        \n\
        \t       instr   : out std_logic_vector(255 downto 0)); -- instruction (8 syllables)\n\n\
      end entity i_mem;\n\
      \n\
      \n\
      architecture behavioural of i_mem is\n\
      begin\n\n\
      \tmemory : process(address, reset)\n\n\
      \tbegin\n\n\
      \t\tif (reset = '1') then\n\n\
      \t\t\tinstr <= (others => '0');\n\n\
      \t\telse\n\n\
      \t\t\tcase address is\n");

}

void parse_asm() {


  char instr_buff[60][60];
  int i = 0;

  while (fgets(instr_buff[i], 60, in_file_ptr) != NULL) {

    if (i == 0) {

      head = malloc(sizeof(t_packet));
      current_pckt = head;
      (head)->next_packet = NULL;
      instr_count = 0;
      current_pckt->instr_0 = NULL;
      current_pckt->instr_1 = NULL;
      current_pckt->instr_2 = NULL;
      current_pckt->instr_3 = NULL;
      current_pckt->instr_4 = NULL;
      current_pckt->instr_5 = NULL;
      current_pckt->instr_6 = NULL;
      current_pckt->instr_7 = NULL;

    }

    printf("Instr: %d\n", instr_count);
    if (instr_count > 7) {
      printf ("Too many syllable in one instruction!\n");
      exit (34);
    }
    
    check_syntax(instr_buff[i], i);
    i++;
    instr_count++;

    if (instr_count > 1 && (instr_count % 8) == 0) {

      instr_count = 0;

      (current_pckt)->next_packet = malloc(sizeof(t_packet));
      current_pckt = (current_pckt)->next_packet;
      (current_pckt)->next_packet = NULL;
      packet_count++;

      current_pckt->instr_0 = NULL;
      current_pckt->instr_1 = NULL;
      current_pckt->instr_2 = NULL;
      current_pckt->instr_3 = NULL;
      current_pckt->instr_4 = NULL;
      current_pckt->instr_5 = NULL;
      current_pckt->instr_6 = NULL;
      current_pckt->instr_7 = NULL;
      fgets(instr_buff[i], 60, in_file_ptr);

    } else if (new_pckt_need == true) {

      instr_count = 0;

      (current_pckt)->next_packet = malloc(sizeof(t_packet));
      current_pckt = (current_pckt)->next_packet;
      (current_pckt)->next_packet = NULL;
      packet_count++;

      current_pckt->instr_0 = NULL;
      current_pckt->instr_1 = NULL;
      current_pckt->instr_2 = NULL;
      current_pckt->instr_3 = NULL;
      current_pckt->instr_4 = NULL;
      current_pckt->instr_5 = NULL;
      current_pckt->instr_6 = NULL;
      current_pckt->instr_7 = NULL;

    }
  }

}

void check_syntax(char *current_instr, int line_number) {

  int i = 0;
  int set_valid;
  int instr_type = 0;
  int instr_num_inside_packet = instr_count % 8;

  t_instr *exploded_instr = malloc(sizeof(t_instr));
  new_pckt_need = false;

  for (i = 0; ((int) *(current_instr + i) != 32 && (int) *(current_instr + i) != 10); i++) {

    if (*current_instr == ';') {

      new_pckt_need = true;
      return;

    }

  }

  if (i == 2) { //opcode da 2 caratteri

    set_valid = 0;

    if (current_instr[0] == 'o' && current_instr[1] == 'r') {

      set_valid = 1;
      instr_type = R_TYPE;

    }

    if (set_valid == 1) {

      exploded_instr->opcode[0] = 'o';
      exploded_instr->opcode[1] = 'r';
      exploded_instr->opcode[2] = '\0';


    }

    if (set_valid == 0) {

      printf("Syntax error at line %d: Unknown OPC\a\n", line_number);
      exit(10);

    }
  } else if (i == 3) { // opcode da 3 caratteri

    set_valid = 0;

    if (current_instr[0] == 'n' && current_instr[1] == 'o' && current_instr[2] == 'p') {

      return;

    } else if (current_instr[0] == 'a' && current_instr[1] == 'd' && current_instr[2] == 'd') {

      set_valid = 1;
      instr_type = R_TYPE;

    } else if (current_instr[0] == 's' && current_instr[1] == 'u' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = R_TYPE;

    } else if (current_instr[0] == 'a' && current_instr[1] == 'n' && current_instr[2] == 'd') {

      set_valid = 1;
      instr_type = R_TYPE;
    } else if (current_instr[0] == 'x' && current_instr[1] == 'o' && current_instr[2] == 'r') {

      set_valid = 1;
      instr_type = R_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'l' && current_instr[2] == 'l') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'r' && current_instr[2] == 'l') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'l' && current_instr[2] == 't') {

      set_valid = 1;
      instr_type = R_TYPE;
    } else if (current_instr[0] == 'o' && current_instr[1] == 'r' && current_instr[2] == 'i') {

      set_valid = 1;
      instr_type = I_TYPE;
      // Begin  Load Instructions 
    } else if (current_instr[0] == 'l' && current_instr[1] == 'd' && current_instr[2] == 'w') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 'u' && current_instr[2] == 'h') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 'l' && current_instr[2] == 'h') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 'f' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 's' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 't' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'l' && current_instr[1] == 'l' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
      //Begin Store instructions
    } else if (current_instr[0] == 's' && current_instr[1] == 't' && current_instr[2] == 'w') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'u' && current_instr[2] == 'h') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'l' && current_instr[2] == 'h') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'f' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 's' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 't' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'l' && current_instr[2] == 'b') {

      set_valid = 1;
      instr_type = I_TYPE;
      //End Store instructions
    } else if (current_instr[0] == 'b' && current_instr[1] == 'r' && current_instr[2] == 't') {

      set_valid = 1;
      instr_type = J_TYPE;
    } else if (current_instr[0] == 'b' && current_instr[1] == 'r' && current_instr[2] == 'f') {

      set_valid = 1;
      instr_type = J_TYPE;
    } else if (current_instr[0] == 'j' && current_instr[1] == 'm' && current_instr[2] == 'p') {

      set_valid = 1;
      instr_type = J_TYPE;
    }

    if (set_valid == 1) {

      exploded_instr->opcode[0] = current_instr[0];
      exploded_instr->opcode[1] = current_instr[1];
      exploded_instr->opcode[2] = current_instr[2];
      exploded_instr->opcode[3] = '\0';
    } else {

      printf("Syntax error at line %d: Unknown OPC\a\n", line_number);
      exit(10);

    }
  } else if (i == 4) { //opcode da 4 caratteri

    set_valid = 0;
    if (current_instr[0] == 'a' && current_instr[1] == 'd' && current_instr[2] == 'd' && current_instr[3] == 'i') {
      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 'a' && current_instr[1] == 'n' && current_instr[2] == 'd' &&
        current_instr[3] == 'i') {
      set_valid = 1;
      instr_type = I_TYPE;
    } else if (current_instr[0] == 's' && current_instr[1] == 'l' && current_instr[2] == 't' &&
        current_instr[3] == 'i') {
      set_valid = 1;
      instr_type = I_TYPE;
    }

    if (set_valid == 1) {
      exploded_instr->opcode[0] = current_instr[0];
      exploded_instr->opcode[1] = current_instr[1];
      exploded_instr->opcode[2] = current_instr[2];
      exploded_instr->opcode[3] = current_instr[3];
      exploded_instr->opcode[4] = '\0';

    } else {

      printf("Syntax error at line %d: Unknown OPC\a\n", line_number);
      exit(10);

    }

  } else printf("Syntax error at line %d: Unknown OPC\a\n", line_number);

  extract_operands(current_instr, exploded_instr, instr_type, line_number);

  if (instr_num_inside_packet == 0) current_pckt->instr_0 = exploded_instr;
  if (instr_num_inside_packet == 1) current_pckt->instr_1 = exploded_instr;
  if (instr_num_inside_packet == 2) current_pckt->instr_2 = exploded_instr;
  if (instr_num_inside_packet == 3) current_pckt->instr_3 = exploded_instr;
  if (instr_num_inside_packet == 4) current_pckt->instr_4 = exploded_instr;
  if (instr_num_inside_packet == 5) current_pckt->instr_5 = exploded_instr;
  if (instr_num_inside_packet == 6) current_pckt->instr_6 = exploded_instr;
  if (instr_num_inside_packet == 7) current_pckt->instr_7 = exploded_instr;

  return;

}

void extract_operands(char *current_instr_string, t_instr *current_instr_struct, int instr_type, int line_number) {

  int i;
  int dollar_occurrence = 0;
  int dollar_position[3];
  int operands_length;
  int immediate_length;
  int comma_pos;

  //search for the $

  for (i = 0; i <= strlen(current_instr_string); i++) {

    if (*(current_instr_string + i) == '$') {

      dollar_position[dollar_occurrence] = i;
      dollar_occurrence += 1;

    }

  }

  //check for correct number of $ occurrence

  if (instr_type == R_TYPE) {

    current_instr_struct->instr_type = R_TYPE;

    if (dollar_occurrence != 3) {

      printf("Syntax error at line :%d\nMissing operands!\a\n", line_number);

      exit(23);

    }

  }

  if (instr_type == I_TYPE) {

    current_instr_struct->instr_type = I_TYPE;
    if (dollar_occurrence != 2) {

      printf("Syntax error at line :%d\n Missing operands!\a\n", line_number);

      exit(23);

    }
    //calculate immediate

    for (i = dollar_position[1] + 1; current_instr_string[i] != ','; i++); //arrivo fino alla virgola
    //calcolo alla virgola in poi

    comma_pos = i + 1;//arrivato alla virgola

    for (i = comma_pos; current_instr_string[i] != '\0' && current_instr_string != ' '; i++); //calcolo la vera lunghezza

    immediate_length = i - comma_pos - 1;

    if (immediate_length == 1) {

      current_instr_struct->immediate = current_instr_string[comma_pos] - 48;

    }

    if (immediate_length == 2) {

      current_instr_struct->immediate =
        10 * (current_instr_string[comma_pos] - 48) + (current_instr_string[comma_pos + 1] - 48);

    }

    if (immediate_length == 3) {

      current_instr_struct->immediate =
        100 * (current_instr_string[comma_pos] - 48) + 10 * (current_instr_string[comma_pos + 1] - 48) +
        (current_instr_string[comma_pos + 2] - 48);

    }

    if (immediate_length == 4) {

      current_instr_struct->immediate =
        1000 * (current_instr_string[comma_pos] - 48) + 100 * (current_instr_string[comma_pos + 1] - 48) +
        10 * (current_instr_string[comma_pos + 2] - 48) + (current_instr_string[comma_pos + 3] - 48);

      if (current_instr_struct->immediate > 2047) {

        printf("Syntax error at line: %d\nImmediate out of bound!\a\n", line_number);
        exit(24);

      }

    }

  }

  if (instr_type == J_TYPE) {

    current_instr_struct->instr_type = J_TYPE;

    if (dollar_occurrence != 1) {

      printf("Syntax error at line :%d\n Missing operands!\a\n", line_number);

      exit(23);

    }

    //calculate immediate

    for (i = dollar_position[0] + 1; current_instr_string[i] != ','; i++); //arrivo fino alla virgola
    //calcolo alla virgola in poi

    comma_pos = i + 1;//arrivato alla virgola

    for (i = comma_pos; current_instr_string[i] != '\0'; i++); //calcolo la vera lunghezza

    immediate_length = i - comma_pos - 1;

    if (immediate_length == 1) {

      current_instr_struct->immediate = current_instr_string[comma_pos] - 48;

    }

    if (immediate_length == 2) {

      current_instr_struct->immediate =
        10 * (current_instr_string[comma_pos] - 48) + (current_instr_string[comma_pos + 1] - 48);

    }

    if (immediate_length == 3) {

      current_instr_struct->immediate =
        100 * (current_instr_string[comma_pos] - 48) + 10 * (current_instr_string[comma_pos + 1] - 48) +
        (current_instr_string[comma_pos + 2] - 48);

    }

    if (immediate_length == 4) {

      current_instr_struct->immediate =
        1000 * (current_instr_string[comma_pos] - 48) + 100 * (current_instr_string[comma_pos + 1] - 48) +
        10 * (current_instr_string[comma_pos + 2] - 48) + (current_instr_string[comma_pos + 3] - 48);

      if (current_instr_struct->immediate > 2047) {

        printf("Syntax error at line: %d\nImmediate out of bound!\a\n", line_number);
        exit(24);

      }

    }
  }

  //extract operands
  for (i = 0; i < dollar_occurrence; i++) {

    if (i < dollar_occurrence - 1) {

      operands_length = dollar_position[i + 1] - dollar_position[i] - 2;

    } else {

      if (current_instr_string[dollar_position[i] + 2] > 57 ||
          current_instr_string[dollar_position[i] + 2] < 48) {

        operands_length = 1;

      } else operands_length = 2;

    }
    //order is $rd,$op0,$op1 or $rd,$op0,immediate(in decimal)

    //destination register
    if (i == 0) {

      if (operands_length == 1) {

        current_instr_struct->operand_d = current_instr_string[dollar_position[0] + 1] - 48;

      } else if (operands_length == 2) {

        current_instr_struct->operand_d = 10 * (current_instr_string[dollar_position[0] + 1] - 48) +
          (current_instr_string[dollar_position[0] + 2]) - 48;

        if (current_instr_struct->operand_d > 31) {

          printf("Syntax error at line %d\nRegister out of bound!\a\n", line_number);
          exit(25);

        }
      }
    }
    //operand 0 register
    if (i == 1) {

      if (operands_length == 1) {

        current_instr_struct->operand_0 = current_instr_string[dollar_position[1] + 1] - 48;

      } else if (operands_length == 2) {

        current_instr_struct->operand_0 = 10 * (current_instr_string[dollar_position[1] + 1] - 48) +
          (current_instr_string[dollar_position[1] + 2]) - 48;

        if (current_instr_struct->operand_0 > 31) {

          printf("Syntax error at line %d\nRegister out of bound!\a\n", line_number);
          exit(25);

        }

      }
    }
    //operand 1 register
    if (i == 2) {

      if (operands_length == 1) {

        current_instr_struct->operand_1 = current_instr_string[dollar_position[2] + 1] - 48;

      } else if (operands_length == 2) {

        current_instr_struct->operand_1 = 10 * (current_instr_string[dollar_position[2] + 1] - 48) +
          (current_instr_string[dollar_position[2] + 2]) - 48;

        if (current_instr_struct->operand_1 > 31) {

          printf("Syntax error at line %d\nRegister out of bound!\a\n", line_number);
          exit(25);

        }

      }
    }
    //special handling for J_TYPE

    if (instr_type == J_TYPE) {

      if (operands_length == 1) {

        current_instr_struct->operand_0 = current_instr_string[dollar_position[0] + 1] - 48;

      } else if (operands_length == 2) {

        current_instr_struct->operand_0 = 10 * (current_instr_string[dollar_position[0] + 1] - 48) +
          (current_instr_string[dollar_position[0] + 2]) - 48;

        if (current_instr_struct->operand_0 > 31) {

          printf("Syntax error at line %d\nRegister out of bound!\a\n", line_number);
          exit(25);

        }
      }


    }
  }
}

void print_instruction() {

  current_pckt = head;
  int i;

  for (i = 0; i <= packet_count; i++) {

    if (current_pckt->instr_0 != NULL) {

      if (current_pckt->instr_0->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_0->opcode, current_pckt->instr_0->operand_d,
            current_pckt->instr_0->operand_0, current_pckt->instr_0->operand_1);

      } else if (current_pckt->instr_0->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_0->opcode, current_pckt->instr_0->operand_d,
            current_pckt->instr_0->operand_0, current_pckt->instr_0->immediate);

      } else if (current_pckt->instr_0->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_0->opcode, current_pckt->instr_0->operand_0,
            current_pckt->instr_0->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_1 != NULL) {

      if (current_pckt->instr_1->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_1->opcode, current_pckt->instr_1->operand_d,
            current_pckt->instr_1->operand_0, current_pckt->instr_1->operand_1);

      } else if (current_pckt->instr_0->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_1->opcode, current_pckt->instr_1->operand_d,
            current_pckt->instr_1->operand_0, current_pckt->instr_1->immediate);

      } else if (current_pckt->instr_0->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_1->opcode, current_pckt->instr_1->operand_0,
            current_pckt->instr_1->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_2 != NULL) {

      if (current_pckt->instr_2->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_2->opcode, current_pckt->instr_2->operand_d,
            current_pckt->instr_2->operand_0, current_pckt->instr_2->operand_1);

      } else if (current_pckt->instr_2->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_2->opcode, current_pckt->instr_2->operand_d,
            current_pckt->instr_2->operand_0, current_pckt->instr_2->immediate);

      } else if (current_pckt->instr_2->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_2->opcode, current_pckt->instr_2->operand_0,
            current_pckt->instr_2->immediate);

      }
      //end if
    } else printf("NOP\n");


    if (current_pckt->instr_3 != NULL) {

      if (current_pckt->instr_3->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_3->opcode, current_pckt->instr_3->operand_d,
            current_pckt->instr_3->operand_0, current_pckt->instr_3->operand_1);

      } else if (current_pckt->instr_3->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_3->opcode, current_pckt->instr_3->operand_d,
            current_pckt->instr_3->operand_0, current_pckt->instr_3->immediate);

      } else if (current_pckt->instr_3->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_3->opcode, current_pckt->instr_3->operand_0,
            current_pckt->instr_3->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_4 != NULL) {

      if (current_pckt->instr_4->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_4->opcode, current_pckt->instr_4->operand_d,
            current_pckt->instr_4->operand_0, current_pckt->instr_4->operand_1);

      } else if (current_pckt->instr_4->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_4->opcode, current_pckt->instr_4->operand_d,
            current_pckt->instr_4->operand_0, current_pckt->instr_4->immediate);

      } else if (current_pckt->instr_4->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_4->opcode, current_pckt->instr_4->operand_0,
            current_pckt->instr_4->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_5 != NULL) {

      if (current_pckt->instr_5->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_5->opcode, current_pckt->instr_5->operand_d,
            current_pckt->instr_5->operand_0, current_pckt->instr_5->operand_1);

      } else if (current_pckt->instr_5->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_5->opcode, current_pckt->instr_5->operand_d,
            current_pckt->instr_5->operand_0, current_pckt->instr_5->immediate);

      } else if (current_pckt->instr_5->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_5->opcode, current_pckt->instr_5->operand_0,
            current_pckt->instr_5->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_6 != NULL) {

      if (current_pckt->instr_6->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_6->opcode, current_pckt->instr_6->operand_d,
            current_pckt->instr_6->operand_0, current_pckt->instr_6->operand_1);

      } else if (current_pckt->instr_6->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_6->opcode, current_pckt->instr_6->operand_d,
            current_pckt->instr_6->operand_0, current_pckt->instr_6->immediate);

      } else if (current_pckt->instr_6->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_6->opcode, current_pckt->instr_6->operand_0,
            current_pckt->instr_6->immediate);

      }
      //end if
    } else printf("NOP\n");

    if (current_pckt->instr_7 != NULL) {

      if (current_pckt->instr_7->instr_type == R_TYPE) {

        printf("%s $%d,$%d,$%d\n", current_pckt->instr_7->opcode, current_pckt->instr_7->operand_d,
            current_pckt->instr_7->operand_0, current_pckt->instr_7->operand_1);

      } else if (current_pckt->instr_6->instr_type == I_TYPE) {

        printf("%s $%d,$%d,%d\n", current_pckt->instr_7->opcode, current_pckt->instr_7->operand_d,
            current_pckt->instr_7->operand_0, current_pckt->instr_7->immediate);

      } else if (current_pckt->instr_7->instr_type == J_TYPE) {

        printf("%s $%d,%d\n", current_pckt->instr_7->opcode, current_pckt->instr_7->operand_0,
            current_pckt->instr_7->immediate);

      }
    } else printf("NOP\n");

    printf(";;\n");

    current_pckt = current_pckt->next_packet;

  }

  return;

}

void print_vhdl_caller() {

  current_pckt = head;
  int i, j;

  printf("%d\n", packet_count);
  //if (packet_count == 1) packet_count--;

  for (i = 0; i < packet_count; i++) {

    //print reversed
    print_vhdl_callee(current_pckt->instr_7);

    print_vhdl_callee(current_pckt->instr_6);

    print_vhdl_callee(current_pckt->instr_5);

    print_vhdl_callee(current_pckt->instr_4);

    print_vhdl_callee(current_pckt->instr_3);

    print_vhdl_callee(current_pckt->instr_2);

    print_vhdl_callee(current_pckt->instr_1);

    print_vhdl_callee(current_pckt->instr_0);

    fprintf (out_file_ptr, "\n");

    current_pckt = current_pckt->next_packet;
    
  }
}

void print_vhdl_callee(t_instr *instr) {

  char instr_temp_buff[33] = {0};  
  instr_temp_buff[32] = '\0';

  if (instr != NULL) {

    if (strcmp(instr->opcode, "add") == 0) {

      print_to_instr_buf(instr_temp_buff, ADD_OPC, 6, 0);
    } else if (strcmp(instr->opcode, "sub") == 0) {
      print_to_instr_buf(instr_temp_buff, SUB_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "and") == 0) {
      print_to_instr_buf(instr_temp_buff, AND_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "or") == 0) {
      print_to_instr_buf(instr_temp_buff, OR_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "xor") == 0) {
      print_to_instr_buf(instr_temp_buff, XOR_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "sll") == 0) {
      print_to_instr_buf(instr_temp_buff, SLL_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "srl") == 0) {
      print_to_instr_buf(instr_temp_buff, SRL_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "slt") == 0) {
      print_to_instr_buf(instr_temp_buff, SLT_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "addi") == 0) {
      print_to_instr_buf(instr_temp_buff, ADDI_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "andi") == 0) {
      print_to_instr_buf(instr_temp_buff, ANDI_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "ori") == 0) {
      print_to_instr_buf(instr_temp_buff, ORI_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "slti") == 0) {
      print_to_instr_buf(instr_temp_buff, SLTI_OPC, 6, 0);

    } 

    //Load Instructions

    else if (strcmp(instr->opcode, "ldw") == 0) {
      print_to_instr_buf(instr_temp_buff, LDW_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "luh") == 0) {
      print_to_instr_buf(instr_temp_buff, LUH_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "llh") == 0) {
      print_to_instr_buf(instr_temp_buff, LLH_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "lfb") == 0) {
      print_to_instr_buf(instr_temp_buff, LFB_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "lsb") == 0) {
      print_to_instr_buf(instr_temp_buff, LSB_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "ltb") == 0) {
      print_to_instr_buf(instr_temp_buff, LTB_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "llb") == 0) {
      print_to_instr_buf(instr_temp_buff, LLB_OPC, 6, 0);

    } 

    // Store Instructions
    else if (strcmp(instr->opcode, "stw") == 0) {
      print_to_instr_buf(instr_temp_buff, STW_OPC, 6, 0);

    } 

    else if (strcmp(instr->opcode, "suh") == 0) {
      print_to_instr_buf(instr_temp_buff, SUH_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "slh") == 0) {
      print_to_instr_buf(instr_temp_buff, SLH_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "sfb") == 0) {
      print_to_instr_buf(instr_temp_buff, SFB_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "ssb") == 0) {
      print_to_instr_buf(instr_temp_buff, SSB_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "stb") == 0) {
      print_to_instr_buf(instr_temp_buff, STB_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "slb") == 0) {
      print_to_instr_buf(instr_temp_buff, SLB_OPC, 6, 0);

    }

    else if (strcmp(instr->opcode, "brt") == 0) {
      print_to_instr_buf(instr_temp_buff, BRT_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "brf") == 0) {
      print_to_instr_buf(instr_temp_buff, BRF_OPC, 6, 0);

    } else if (strcmp(instr->opcode, "jmp") == 0) {
      print_to_instr_buf(instr_temp_buff, JMP_OPC, 6, 0);

    }
  } else {

    print_to_instr_buf(instr_temp_buff, "00000000000000000000000000000000", 32, 0);
    conv_write(instr_temp_buff);
    return;

  }

  if (instr->instr_type == R_TYPE) {

    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_0, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_0, 5) , 5, 6);
    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_1, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_1, 5), 5, 11);
    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_d, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_d, 5), 5, 16);
    //fprintf(out_file_ptr, "00000000000");
    print_to_instr_buf(&instr_temp_buff, "00000000000", 11, 21);

  }

  if (instr->instr_type == I_TYPE) {

    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_0, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_0, 5) , 5, 6);
    //fprintf(out_file_ptr, "00000");
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_d, 5) , 5, 11);
    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_d, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_d, 5) , 5, 16);
    //fprintf(out_file_ptr, "%s", inttobin(instr->immediate, 11));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->immediate, 11) , 11, 21);

  }

  if (instr->instr_type == J_TYPE) {

    //fprintf(out_file_ptr, "%s", inttobin(instr->operand_0, 5));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->operand_0, 5) , 5, 6);
    //fprintf(out_file_ptr, "0000000000");
    print_to_instr_buf(instr_temp_buff, "0000000000" , 10, 11);
    //fprintf(out_file_ptr, "%s", inttobin(instr->immediate, 11));
    print_to_instr_buf(instr_temp_buff, inttobin(instr->immediate, 11) , 11, 21);
  
  }

  conv_write(instr_temp_buff);
}

const char *inttobin(int integer, unsigned base) {

  static char buffer[13];
  int tmp;

  int i;

  for (i = 0; i < base; i++) {

    tmp = integer % 2;

    if (tmp == 1) buffer[base - 1 - i] = '1';
    else buffer[base - 1 - i] = '0';

    integer = integer >> 1;
  }

  buffer[base] = '\0';

  return buffer;

}

void conv_write (char * buff) {

  int i;

  for (i=0; i<=31; i+=4) {

    if (buff[i] == '0' && buff[i+1] == '0' && buff[i+2] == '0' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", '0');

    }

    else if (buff[i] == '0' && buff[i+1] == '0' && buff[i+2] == '0' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", '1');

    }

    else if (buff[i] == '0' && buff[i+1] == '0' && buff[i+2] == '1' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", '2');

    }

    else if (buff[i] == '0' && buff[i+1] == '0' && buff[i+2] == '1' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", '3');

    }

    else if (buff[i] == '0' && buff[i+1] == '1' && buff[i+2] == '0' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", '4');

    }

    else if (buff[i] == '0' && buff[i+1] == '1' && buff[i+2] == '0' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", '5');

    }

    else if (buff[i] == '0' && buff[i+1] == '1' && buff[i+2] == '1' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", '6');

    }

    else if (buff[i] == '0' && buff[i+1] == '1' && buff[i+2] == '1' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", '7');

    }

    else if (buff[i] == '1' && buff[i+1] == '0' && buff[i+2] == '0' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", '8');

    }

    else if (buff[i] == '1' && buff[i+1] == '0' && buff[i+2] == '0' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", '9');

    }

    else if (buff[i] == '1' && buff[i+1] == '0' && buff[i+2] == '1' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", 'A');

    }

    else if (buff[i] == '1' && buff[i+1] == '0' && buff[i+2] == '1' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", 'B');

    }

    else if (buff[i] == '1' && buff[i+1] == '1' && buff[i+2] == '0' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", 'C');

    }

    else if (buff[i] == '1' && buff[i+1] == '1' && buff[i+2] == '0' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", 'D');

    }

    else if (buff[i] == '1' && buff[i+1] == '1' && buff[i+2] == '1' && buff[i+3] == '0') {

      fprintf(out_file_ptr, "%c", 'E');

    }

    else if (buff[i] == '1' && buff[i+1] == '1' && buff[i+2] == '1' && buff[i+3] == '1') {

      fprintf(out_file_ptr, "%c", 'F');

    }
  }
}

void print_to_instr_buf(char* buff, char* payload, int amnt, int offset) {


  int i=0;

  for (i=offset; i<= offset+amnt; i++) {

    (buff[i]) = payload[i-offset];

  }

} 

void print_zeros() {

   int tmp= 512-packet_count;
   int i;

   for (i=0; i < tmp; i++ ) {

     fprintf(out_file_ptr, "%s", "0000000000000000000000000000000000000000000000000000000000000000\n");

   }
}
