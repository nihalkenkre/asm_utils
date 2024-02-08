section .text

%include '..\utils_32_text.asm'

global main
main:
    push ebp
    mov ebp, esp

    ; ebp - 4 = kernel handle
    ; ebp - 516 = sprintf buffer
    ; ebp - 520 = std handle
    ; ebp - 524 = buffer strlen
    sub esp, 524                        ; allocate local variable space

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

    push wsrc
    push src
    call strcmpAW

    push str2
    push str1
    call strcmpAA

    push str2
    push str1
    call strcmpiAA

    push wsrc
    push str1
    call strcmpiAW

    push 'r'
    push str2
    call strchr

    push xor_key.len
    push xor_key
    push veracrypt_xor.len
    push veracrypt_xor
    call my_xor

    push dword src.len
    push dword veracrypt_xor.len
    push src
    push veracrypt_xor
    push sprintf_str
    mov eax, ebp
    sub eax, 516                                    ; 512 byte sprintf buffer
    push eax
    call sprintf
    add esp, 24                                     ; special variadic function, stack cleared by caller

    call get_kernel_module_handle

    mov [ebp - 4], eax                              ; kernel handle

    push dword [ebp - 4]                            ; kernel handle
    call populate_kernel_function_ptrs_by_name

    mov eax, ebp
    sub eax, 516
    push eax
    call [output_debug_string_a] 

    push STD_HANDLE_ENUM
    call [get_std_handle]

    mov [ebp - 520], eax                            ; std handle

    mov eax, ebp
    sub eax, 516
    push eax
    call strlen

    mov [ebp - 524], eax                            ; buffer strlen

    push dword [ebp - 524]                          ; buffer strlen
    mov eax, ebp
    sub eax, 516
    push eax                                        ; buffer
    push dword [ebp - 520]                          ; std handle
    call print_string

    push sleep_xor
    push dword [ebp - 4]                            ; kernel handle
    call get_proc_address_by_get_proc_addr

    push InterlockedPushListSList_str
    push dword [ebp - 4]                            ; kernel handle
    call get_proc_address_by_name

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
.len equ $ - src - 1

wsrc: dw __utf16__('tEST_string'), 0
.len equ ($ - wsrc) / 2

str1: db 'test_string', 0
.len equ $ - str1 - 1

str2: db 'test_StRINg', 0
.len equ $ - str2 - 1

InterlockedPushListSList_str: db 'InterlockedPushListSList', 0
.len equ $ - InterlockedPushListSList_str

veracrypt_xor: db 0x66, 0x55, 0x42, 0x51, 0x73, 0x42, 0x49, 0x40, 0x44, 0x1e, 0x55, 0x48, 0x55, 0x0
.len equ $ - veracrypt_xor - 1

sprintf_str: db 'This is %s, %s, veracrypt name length: %db, test_string name length: %xb.', 0
.len equ $ - sprintf_str

%include '..\utils_32_data.asm'

section .bss
dst: resb 128
wdst: resw 128

%include '..\utils_32_bss.asm'