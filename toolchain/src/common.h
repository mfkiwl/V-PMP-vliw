#include <stdio.h>

#define FILENAME "i_mem.bin"
#define R_TYPE 0
#define I_TYPE 1
#define J_TYPE 2

typedef struct instruction {

    char opcode[5];
    int operand_0;
    int operand_1;
    int operand_d;
    int immediate;
    int shamt;
    int instr_type;

} t_instr;

typedef struct packet {

    t_instr *instr_0;
    t_instr *instr_1;
    t_instr *instr_2;
    t_instr *instr_3;
    t_instr *instr_4;
    t_instr *instr_5;
    t_instr *instr_6;
    t_instr *instr_7;
    struct packet *next_packet;

} t_packet;

FILE *out_file_ptr;
FILE *in_file_ptr;
int packet_count;
int instr_count;
t_packet *head;
t_packet *current_pckt;
_Bool new_pckt_need;

void check_args(int);

void out_file_manage(_Bool);

void print_header();

void parse_asm();

void check_syntax(char *, int);

void extract_operands(char *, t_instr *, int, int);

void print_instruction();

void print_vhdl_caller();

void print_vhdl_callee(t_instr*);

const char* inttobin (int , unsigned);

void print_footer();

void print_zeros();
