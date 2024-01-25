section .text

%include '..\utils_32_text.asm'

global main
main:
    push ebp
    mov ebp, esp

    ; ebp - 4 = kernel handle
    ; ebp - 516 = sprintf buffer
    sub esp, 516

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

    push dword 0xb00bcafe
    push dword 1024
    push str1
    push veracrypt_xor
    push sprintf_str
    mov eax, ebp
    sub eax, 516                                    ; 512 byte sprintf buffer
    push eax
    call sprintf
    add esp, 16                                     ; special variadic function, stack cleared by caller

    call get_kernel_module_handle

    mov [ebp - 4], eax                              ; kernel handle

    push dword [ebp - 4]                            ; kernel handle
    call populate_kernel_function_ptrs_by_name

    mov eax, ebp
    sub eax, 516
    push eax
    call [output_debug_string_a] 

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
STD_HANDLE_ENUM equ -11
INVALID_HANDLE_VALUE equ -1

src: db 'test_string', 0
.len equ $ - src

wsrc: dw __utf16__('tESt_sTrIng'), 0
.len equ ($ - wsrc) / 2

str1: db 'test_string', 0
.len equ $ - str1 - 1

str2: db 'test_string', 0
.len equ $ - str2 - 1

InterlockedPushListSList_str: db 'InterlockedPushListSList', 0
.len equ $ - InterlockedPushListSList_str

veracrypt_xor: db 0x66, 0x55, 0x42, 0x51, 0x73, 0x42, 0x49, 0x40, 0x44, 0x1e, 0x55, 0x48, 0x55, 0x0
.len equ $ - veracrypt_xor - 1

sprintf_str: db 'This is %s, %s, veracrypt name length: %x, test_string name length: %x.', 0
.len equ $ - sprintf_str

%include '..\utils_32_data.asm'

section .bss
dst: resb 128
wdst: resw 128

%include '..\utils_32_bss.asm'
