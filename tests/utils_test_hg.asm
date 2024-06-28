default rel

section .text
%include '..\utils_hg_text.asm'

global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 32                         ; shadow space

    call get_ntdll_module_handle_hg

    mov rcx, rax 
    mov rdx, rtl_create_user_thread_str
    call get_proc_address_by_name_hg

    leave
    ret

section .data
%include '..\utils_hg_data.asm'

rtl_create_user_thread_str: db 0x52, 0x74, 0x6c, 0x43, 0x72, 0x65, 0x61, 0x74, 0x65, 0x55, 0x73, 0x65, 0x72, 0x54, 0x68, 0x72, 0x65, 0x61, 0x64, 0 
.len equ $ - rtl_create_user_thread_str - 1

section .bss
%include '..\utils_hg_bss.asm'