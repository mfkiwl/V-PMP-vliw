#include <stdio.h>
#include "common.h"

int main(int argc, char *argv[]) {

    packet_count = 0;
    instr_count = 0;
    check_args(argc); //check for correct argumets
    in_file_ptr = fopen(argv[1], "r"); //open input ASM file
    out_file_manage(0);
    //print_header();
    parse_asm();
    //print_instruction();
    print_vhdl_caller();
    //print_footer();
    print_zeros();


    return 0;


}
