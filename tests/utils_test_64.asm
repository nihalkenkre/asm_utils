default rel

section .text
global main

%include '..\utils_64_text.asm'

extern WideCharToMultiByte

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
    sub rsp, 8                          ; allocate local variable space
    sub rsp, 32                         ; allocate shadow space

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

    mov rcx, src
    mov rdx, wsrc
    mov r8, src.len
    call strcmpiAW

    mov rcx, str1
    mov rdx, str2
    mov r8, str1.len
    call strcmpAA

    mov rcx, str1
    mov rdx, str2
    mov r8, str1.len
    call strcmpiAA

    mov rcx, str2
    mov rdx, 'r'
    call strchr

    mov rcx, veracrypt_xor
    mov rdx, veracrypt_xor.len
    mov r8, xor_key
    mov r9, xor_key.len
    call my_xor

    call get_kernel_module_handle

    mov [rbp - 8], eax                            ; kernel handle

    mov rcx, [rbp - 8]                            ; kernel handle
    call populate_kernel_function_ptrs_by_name

    mov rcx, [rbp - 8]                            ; kernel handle
    mov rdx, sleep_xor
    call get_proc_address_by_get_proc_addr

    mov rcx, ntdll
    call [load_library_a]

    mov rcx, [rbp - 8]                            ; kernel handle
    mov rdx, InterlockedPushListSList_str
    mov r8, InterlockedPushListSList_str.len
    call get_proc_address_by_name

    mov rcx, veracrypt_xor
    mov rdx, veracrypt_xor.len
    call find_target_process_id

.shutdown:
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

ntdll: db 'ntdll.dll', 0
.len equ $ - ntdll

%include '..\utils_64_data.asm'

section .bss
dst: resb 128
wdst: resw 128

%include '..\utils_64_bss.asm'