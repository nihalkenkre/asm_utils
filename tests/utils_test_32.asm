section .text

%include '..\utils\\utils_32_text.asm'

global main
main:
    push ebp
    mov ebp, esp

    ; ebp - 4 = kernel handle
    sub esp, 4

    push src.len
    push dst
    push src
    call memcpy

    push src
    call strlen

    push dst 
    call strlen

    push wsrc
    call wstrlen

    push dst
    push src
    call strcpy

    push wdst
    push wsrc
    call wstrcpy

    push src.len
    push wsrc
    push src
    call strcmpiAW

    push str1.len
    push str2
    push str1
    call strcmpAA

    push str1.len
    push str2
    push str1
    call strcmpiAA

    push 'r'
    push str2
    call strchr

    push xor_key.len
    push xor_key
    push veracrypt_xor.len
    push veracrypt_xor
    call my_xor

    call get_kernel_module_handle

    mov [ebp - 4], eax                              ; kernel handle

    push dword [ebp - 4]                            ; kernel handle
    call populate_kernel_function_ptrs_by_name

    push sleep_xor
    push dword [ebp - 4]                            ; kernel handle
    call get_proc_address_by_get_proc_addr

    push InterlockedPushListSList_str.len
    push InterlockedPushListSList_str
    push dword [ebp - 4]                            ; kernel handle
    call get_proc_address_by_name

    push veracrypt_xor.len
    push veracrypt_xor
    call find_target_process_id

.shutdown:
    xor eax, eax

    leave
    ret

section .data
src: db 'test_string', 0
.len equ $ - src

wsrc: dw __utf16__('tESt_sTrIng'), 0
.len equ ($ - wsrc) / 2

str1: db 'test_string', 0
.len equ $ - str1 - 1

str2: db 'test_string', 0
.len equ $ - str2 - 1

boomlade_xor: db 0x52, 0x5f, 0x5f, 0x5d, 0x5c, 0x51, 0x54, 0x55, 0
.len equ $ - boomlade_xor - 1

InterlockedPushListSList_str: db 'InterlockedPushListSList', 0
.len equ $ - InterlockedPushListSList_str

veracrypt_xor: db 0x66, 0x55, 0x42, 0x51, 0x73, 0x42, 0x49, 0x40, 0x44, 0x1e, 0x55, 0x48, 0x55, 0x0
.len equ $ - veracrypt_xor - 1

%include '..\utils\utils_32_data.asm'

section .bss
dst: resb 128
wdst: resw 128

%include '..\utils\utils_32_bss.asm'
