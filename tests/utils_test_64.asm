default rel

section .text
global main

%include '..\utils_64_text.asm'

func:
    push rbx
    push rbp
    mov rbp, rsp

    push rcx
    pop rcx

    leave
    pop rbx
    ret

main:
    push rbp
    mov rbp, rsp

    ; rbp - 8 = kernel handle
    ; rbp - 520 = 512 byte sprintf buffer
    ; rbp - 528 = std handle
    ; rbp - 536 = buffer strlen
    ; rbp - 544 = 8 byte padding
    sub rsp, 544                                    ; allocate local variable space
    sub rsp, 32                                     ; allocate shadow space

    call get_ntdll_module_handle

    call get_kernel_module_handle

    mov [rbp - 8], rax                              ; kernel handle

    mov rcx, [rbp - 8]                              ; kernel handle
    call populate_kernel_function_ptrs_by_name

    mov rcx, src
    mov rdx, dst
    mov r8, src.len
    call memcpy

    mov rcx, src
    call strlen

    mov rcx, dst 
    call strlen

    mov rcx, wsrc
    call wstrlen

    mov rcx, src
    mov rdx, dst
    call strcpy

    mov rcx, wsrc
    mov rdx, wdst
    call wstrcpy

    mov rcx, wsrc
    mov rdx, dst
    call wstrcpya

    mov rcx, str1
    mov rdx, wsrc
    call strcmpAW

    mov rcx, str1
    mov rdx, str2
    call strcmpAA

    mov rcx, str1
    mov rdx, str2
    call strcmpiAA

    mov rcx, src
    mov rdx, wsrc
    call strcmpiAW

    mov rcx, str2
    mov rdx, 'r'
    call strchr

    mov rcx, veracrypt_xor
    mov rdx, veracrypt_xor.len
    mov r8, xor_key
    mov r9, xor_key.len
    call my_xor

    sub rsp, 16                                     ; 2 args
    mov rcx, rbp
    sub rcx, 520
    mov rdx, sprintf_str
    mov r8, veracrypt_xor
    mov r9, src
    mov qword [rsp + 32], veracrypt_xor.len
    mov qword [rsp + 40], src.len
    call sprintf
    add rsp, 16                                     ; 2 args

    sub rsp, 16                                     ; 2 args
    mov rcx, rbp
    sub rcx, 520
    mov rdx, sprintf_wstr
    mov r8, wsrc
    mov r9, wsrc.len
    mov qword [rsp + 32], wsrc.len
    call sprintf
    add rsp, 16                                     ; 2 args

    mov rcx, rbp
    sub rcx, 520
    call print_console

    mov rcx, rbp
    sub rcx, 520
    call [output_debug_string_a]

    mov rcx, STD_HANDLE_ENUM
    call [get_std_handle]

    mov [rbp - 528], rax                            ; std handle

    mov rcx, [rbp - 528]                            ; std handle
    mov rdx, rbp
    sub rdx, 520                                    ; buffer
    call print_string

    mov rcx, [rbp - 8]                              ; kernel handle
    mov rdx, sleep_xor
    call [get_proc_address]

    mov rcx, [rbp - 8]                              ; kernel handle
    mov rdx, InterlockedPushListSList_str
    call get_proc_address_by_name

    mov rcx, veracrypt_xor
    call find_target_process_id

    mov rcx, find_in_str
    mov rdx, find_str
    call str_contains

    mov rcx, find_in_wstr
    mov rdx, find_wstr
    call wstr_contains

    mov rcx, find_in_str
    mov rdx, wdst
    call astrcpyw

    mov rcx, wdst
    xor rdx, rdx
    mov r8, 128
    call memset


.shutdown:

    xor rax, rax

    leave
    ret

section .data
%include '..\utils_64_data.asm'

STD_HANDLE_ENUM equ -11
INVALID_HANDLE_VALUE equ -1

src: db 'test_string', 0
.len equ $ - src - 1

wsrc: dw __utf16__('teST_string'), 0
.len equ ($ - wsrc) / 2 - 1

str1: db 'Test_string', 0
.len equ $ - str1 - 1

str2: db 'test_string', 0
.len equ $ - str2 - 1

InterlockedPushListSList_str: db 'InterlockedPushListSList', 0
.len equ $ - InterlockedPushListSList_str

veracrypt_xor: db 0x66, 0x55, 0x42, 0x51, 0x73, 0x42, 0x49, 0x40, 0x44, 0x1e, 0x55, 0x48, 0x55, 0x0
.len equ $ - veracrypt_xor - 1

sprintf_str: db 'This is %sb, %sb, veracrypt name length: %dd, test_string name length: %xd.', 0
.len equ $ - sprintf_str

sprintf_wstr: db 'This is %sw, with length %db, %xb, and a lot more', 0xa, 0
.len equ $ - sprintf_wstr

find_in_str: db 'The quick brown fox jumped over the lazy dog', 0
.len equ $ - find_in_str - 1

find_str: db 'The quick BrOwN', 0
.len equ $ - find_str - 1

find_in_wstr: dw __utf16__('DirectoryFileKeyProcessThreadToken'), 0
.len equ ($ - find_in_wstr) / 2 - 1

find_wstr: dw __utf16__('Key'), 0
.len equ ($ - find_wstr) / 2 - 1

section .bss
dst: resb 128
wdst: resw 128

%include '..\utils_64_bss.asm'