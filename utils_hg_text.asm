; arg0: str             rcx
;
; ret: num chars        rax
strlen_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx                 ; str

    ; rbp - 8 = output strlen
    ; rbp - 16 = rsi
    sub rsp, 16                         ; allocate local variable space
    
    mov qword [rbp - 8], 0              ; strlen = 0
    mov [rbp - 16], rsi                 ; save rsi

    mov rsi, [rbp + 16]                 ; str

    jmp .while_condition
    .loop:
         inc qword [rbp - 8]            ; ++strlen

        .while_condition:
            lodsb                       ; load from mem to al

            cmp al, 0                   ; end of string ?
            jne .loop
    
    mov rsi, [rbp - 16]                 ; restore rsi 
    mov rax, [rbp - 8]                  ; strlen in rax

    leave
    ret

; arg0: str             rcx
; arg1: wstr            rdx
;
; ret: 1 if equal       rax
strcmpiAW_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx             ; str
    mov [rbp + 24], rdx             ; wstr

    ; rbp - 8 = return value
    ; rbp - 16 = rsi
    ; rbp - 24 = rdi
    ; rbp - 32 = 8 bytes padding
    sub rsp, 32                     ; allocate local variable space

    mov qword [rbp - 8], 0          ; return value
    mov [rbp - 16], rsi             ; save rsi
    mov [rbp - 24], rdi             ; save rdi

    mov rsi, [rbp + 16]             ; str
    mov rdi, [rbp + 24]             ; wstr

.loop:
    movzx eax, byte [rsi]
    movzx edx, byte [rdi]

    cmp al, dl

    jg .al_more_than_dl
    jl .al_less_than_dl

.continue_loop:
    cmp al, 0                       ; end of string ?
    je .loop_end_equal

    inc rsi
    add rdi, 2

    jmp .loop

    .al_more_than_dl:
        add dl, 32
        cmp al, dl

        jne .loop_end_not_equal
        jmp .continue_loop

    .al_less_than_dl:
        add al, 32
        cmp al, dl

        jne .loop_end_not_equal
        jmp .continue_loop

.loop_end_not_equal:
    mov qword [rbp - 8], 0          ; return value
    jmp .shutdown

.loop_end_equal:
    mov qword [rbp - 8], 1          ; return value
    jmp .shutdown

.shutdown:
    mov rdi, [rbp - 24]             ; restore rdi
    mov rsi, [rbp - 16]             ; restore rsi
    mov rax, [rbp - 8]              ; return value

    leave
    ret

; arg0: str                     rcx
; arg1: wstr                    rdx
;
; ret: 1 if equal               rax
strcmpiAA_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx             ; str
    mov [rbp + 24], rdx             ; wstr

    ; rbp - 8 = return value
    ; rbp - 16 = rsi
    ; rbp - 24 = rdi
    ; rbp - 32 = 8 bytes padding
    sub rsp, 32                     ; allocate local variable space

    mov qword [rbp - 8], 0          ; return value
    mov [rbp - 16], rsi             ; save rsi
    mov [rbp - 24], rdi             ; save rdi

    mov rsi, [rbp + 16]             ; str
    mov rdi, [rbp + 24]             ; wstr

.loop:
    movzx eax, byte [rsi]
    movzx edx, byte [rdi]

    cmp al, dl
    jg .al_more_than_dl
    jl .al_less_than_dl

.continue_loop:
    cmp al, 0                       ; end of string ?
    je .loop_end_equal

    inc rsi
    inc rdi

    jnz .loop

    .al_more_than_dl:
        add dl, 32
        cmp al, dl

        jne .loop_end_not_equal
        jmp .continue_loop

    .al_less_than_dl:
        add al, 32
        cmp al, dl

        jne .loop_end_not_equal
        jmp .continue_loop

.loop_end_not_equal:
    mov qword [rbp - 8], 0          ; return value
    jmp .shutdown

.loop_end_equal:
    mov qword [rbp - 8], 1          ; return value
    jmp .shutdown

.shutdown:
    mov rdi, [rbp - 24]             ; restore rdi
    mov rsi, [rbp - 16]             ; restore rsi
    mov rax, [rbp - 8]              ; return value

    leave
    ret

; arg0: data            rcx
; arg1: data_len        rdx
; arg2: key             r8
; arg3: key_len         r9
my_xor_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx                         ; data
    mov [rbp + 24], rdx                         ; data len
    mov [rbp + 32], r8                          ; key
    mov [rbp + 40], r9                          ; key len

    ; rbp - 8 = return value
    ; rbp - 16 = i
    ; rbp - 24 = j
    ; rbp - 32 = bInput
    ; rbp - 40 = b
    ; rbp - 48 = data_bit_i
    ; rbp - 56 = key_bit_j
    ; rbp - 64 = bit_xor
    ; rbp - 72 = rbx
    ; rbp - 80 = 8 bytes padding
    sub rsp, 80                                 ; allocate local variable space

    mov qword [rbp - 8], 0                      ; return value
    mov qword [rbp - 16], 0                     ; i = 0
    mov qword [rbp - 24], 0                     ; j = 0
    mov [rbp - 72], rbx                         ; save rbx

    .data_loop:
        mov rax, [rbp - 24]                     ; j in rax
        cmp rax, [rbp + 40]                     ; j == key_len ?

        jne .continue_data_loop
        xor rax, rax
        mov [rbp - 24], rax                     ; j = 0
        
    .continue_data_loop:
        mov qword [rbp - 32], 0                 ; bInput = 0
        mov qword [rbp - 40], 0                 ; b = 0

        .bit_loop:
        ; bit test data
            xor rdx, rdx

            mov rdx, [rbp + 16]                 ; ptr to data in rdx
            mov rbx, [rbp - 16]                 ; i in rbx

            movzx eax, byte [rdx + rbx]         ; data char in al
            movzx ebx, byte [rbp - 40]          ; b in bl

            bt rax, rbx

            jc .data_bit_is_set
            mov qword [rbp - 48], 0             ; data_bit_i = 0
            jmp .bit_loop_continue_data

            .data_bit_is_set:
                mov qword [rbp - 48], 1         ; data_bit_i = 1

        .bit_loop_continue_data:
            ; bit test key

            mov rdx, [rbp + 32]                 ; ptr to key in rdx
            mov rbx, [rbp - 24]                 ; j in rbx
            
            movzx eax, byte [rdx + rbx]         ; key char in al
            movzx ebx, byte [rbp - 40]          ; b in bl

            bt rax, rbx

            jc .key_bit_is_set
            mov qword [rbp - 56], 0             ; key_bit_i = 0
            jmp .bit_loop_continue_key

            .key_bit_is_set:
                mov qword [rbp - 56], 1         ; key_bit_i = 1

        .bit_loop_continue_key:

            movzx eax, byte [rbp - 48]          ; data_bit_i in al
            cmp al, [rbp - 56]                  ; data_bit_i == key_bit_i ?

            je .bits_equal
            ; bits are unequal
            mov qword rax, 1
            movzx ecx, byte [rbp - 40]          ; b in cl
            shl al, cl
            mov [rbp - 64], al                  ; bit_xor = (data_bit_i != key_bit_j) << b

            jmp .bits_continue
            .bits_equal:
            ; bits equal
            ; so (data_bit_i != key_bit_j) == 0
                mov qword [rbp - 64], 0         ; bit_xor = 0

        .bits_continue:
            movzx eax, byte [rbp - 32]          ; bInput in al
            or al, [rbp - 64]                   ; bInput |= bit_xor

            mov [rbp - 32], al                  ; al to bInput

            inc qword [rbp - 40]                ; ++b
            mov qword rax, [rbp - 40]           ; b in rax
            cmp qword rax, 8                    ; b == 8 ?
            jnz .bit_loop


        mov qword rdx, [rbp + 16]               ; ptr to data in rdx
        mov qword rbx, [rbp - 16]               ; i in rbx

        movzx eax, byte [rbp - 32]              ; bInput in al
        mov [rdx + rbx], al                     ; data[i] = bInput

        inc qword [rbp - 24]                    ; ++j

        inc qword [rbp - 16]                    ; ++i
        mov rax, [rbp - 16]                     ; i in rax
        cmp rax, [rbp + 24]                     ; i == data_len ?

        jne .data_loop

.shutdown:
    mov rbx, [rbp - 72]                         ; restore rbx
    mov rax, [rbp - 8]                          ; return value

    leave
    ret

; arg0: str                     rcx
; arg1: chr                     rdx
;
; return: ptr to chr            rax
strchr_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx             ; str 
    mov [rbp + 24], rdx             ; chr

    ; rbp - 8 = cRet
    ; rbp - 16 = strlen
    ; rbp - 24 = c
    ; rbp - 32 = rbx
    sub rsp, 32                     ; allocate local variable space
    sub rsp, 32                     ; allocate shadow space

    mov qword [rbp - 8], -1         ; cRet = 0
    mov [rbp - 32], rbx             ; save rbx

    mov rcx, [rbp + 16]             ; str
    call strlen_hg                  ; strlen

    mov [rbp - 16], rax             ; strlen

    mov qword [rbp - 24], 0         ; c = 0
    .loop:
        mov rdx, [rbp + 16]         ; str in rdx     
        mov rbx, [rbp - 24]         ; c in rbx

        movzx ecx, byte [rdx + rbx] ; sStr[c]

        cmp cl, [rbp + 24]          ; sStr[c] == chr ?

        je .equal

        inc qword [rbp - 24]        ; ++c
        mov rax, [rbp - 16]         ; strlen in rax
        cmp [rbp - 24], rax         ; c < strlen ?

        jne .loop
        jmp .shutdown

        .equal:
            add rdx, rbx
            mov [rbp - 8], rdx      ; cRet = str + c

            jmp .shutdown

.shutdown:
    mov rbx, [rbp - 32]             ; restore rbx
    mov rax, [rbp - 8]              ; return value

    leave
    ret

; arg0: base addr           rcx
; arg1: proc name           rdx
;
; return: proc addr         rax
get_proc_address_by_name_hg:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx                     ; base addr
    mov [rbp + 24], rdx                     ; proc name

    ; rbp - 8 = return value
    ; rbp - 16 = nt headers
    ; rbp - 24 = export data directory
    ; rbp - 32 = export directory
    ; rbp - 40 = address of functions
    ; rbp - 48 = address of names
    ; rbp - 56 = address of name ordinals
    ; rbp - 312 = forwarded dll.function name - 256 bytes
    ; rbp - 320 = function name
    ; rbp - 328 = loaded forwarded library addr
    ; rbp - 336 = function name strlen
    ; rbp - 344 = rbx
    ; rbp - 472 = dll name with extension -> not used, dll name used as is without .dll ext
    ; ebp - 480 = 8 bytes padding
    sub rsp, 480                            ; allocate local variable space
    sub rsp, 32                             ; allocate shadow space

    mov qword [rbp - 8], 0                  ; return value
    mov [rbp - 344], rbx                    ; save rbx

    mov rbx, [rbp + 16]                     ; base addr
    add rbx, 0x3c                           ; *e_lfa_new

    movzx ecx, word [rbx]                   ; e_lfanew

    mov rax, [rbp + 16]                     ; base addr
    add rax, rcx                            ; nt header

    mov [rbp - 16], rax                     ; nt header

    add rax, 24                             ; optional header
    add rax, 112                            ; export data directory

    mov [rbp - 24], rax                     ; export data directory

    mov rax, [rbp + 16]                     ; base addr
    mov rcx, [rbp - 24]                     ; export data directory
    mov ebx, [rcx]
    add rax, rbx                            ; export directory

    mov [rbp - 32], rax                     ; export directory

    add rax, 28                             ; address of functions rva
    mov eax, [rax]                          ; rva in rax
    add rax, [rbp + 16]                     ; base addr + address of function rva

    mov [rbp - 40], rax                     ; address of functions

    mov rax, [rbp - 32]                     ; export directory
    add rax, 32                             ; address of names rva
    mov eax, [rax]                          ; rva in rax
    add rax, [rbp + 16]                     ; base addr + address of names rva

    mov [rbp - 48], rax                     ; address of names

    mov rax, [rbp - 32]                     ; export directory
    add rax, 36                             ; address of name ordinals
    mov eax, [rax]                          ; rva in rax
    add rax, [rbp + 16]                     ; base addr + address of name ordinals

    mov [rbp - 56], rax                     ; address of name ordinals

    mov r10, [rbp - 32]                     ; export directory
    add r10, 24                             ; number of names
    mov r10d, [r10]                         ; number of names in r10

    xor r11, r11
.loop_func_names:
    ; to index into an array, we multiply the size of each element with the 
    ; current index and add it to the base addr of the array
    mov dword eax, 4                        ; size of dword
    mul r11                                 ; size * index
    mov rbx, [rbp - 48]                     ; address of names
    add rbx, rax                            ; address of names + n
    mov ebx, [rbx]                          ; address of names [n]

    add rbx, [rbp +  16]                    ; base addr + address of names [n]

    mov rcx, [rbp + 24]                     ; proc name
    mov rdx, rbx
    call strcmpiAA_hg

    cmp rax, 1                              ; are strings equal
    je .function_found

    inc r11
    cmp r11, r10
    jne .loop_func_names

    jmp .shutdown

.function_found:
    mov rax, 2                              ; size of ordinal value
    mul r11                                 ; index * size of element of addrees of name ordinals(word)
    add rax, [rbp - 56]                     ; address of name ordinals + n
    movzx eax, word [rax]                   ; address of name ordinals [n]; index into address of functions

    mov rbx, 4                              ; size of element of address of functions(dword)
    mul rbx                                 ; index * size of element
    add rax, [rbp - 40]                     ; address of functions + index
    mov eax, dword [rax]                    ; address of functions [index]

    add rax, [rbp + 16]                     ; base addr + address of functions [index]

    mov [rbp - 8], rax                      ; return value

    ; Commented out the importing forwarded function code for now
    ; since we are dealing with RtlCreateUserThread which is present it ntdll.dll
;     ; check if the function is forwarded
;     mov r8, [rbp + 16]                      ; base addr
;     mov rax, [rbp - 24]                     ; export data directory
;     mov eax, [rax]                          ; export data directory virtual address
;     add r8, rax                             ; base addr + virtual addr

;     mov r9, r8
;     mov rax, [rbp - 24]                     ; export data directory
;     add rax, 4                              ; export data directory size
;     mov eax, [rax]                          ; export data directory size
;     add r9, rax                             ; base addr + virtual addr + size

;     cmp [rbp - 8], r8                       ; below the start of the export directory
;     jl .shutdown                            ; not forwarded
;                                             ; or
;     cmp [rbp - 8], r9                       ; above the end of the export directory
;     jg .shutdown                            ; not forwarded

;     ; make a copy of the string of the forwarded dll
;     mov rcx, [rbp - 8]                      ; return value (proc addr)
;     mov rdx, rbp
;     sub rdx, 312                            ; dll.functionname str
;     call strcpy

;     ; find the position of the '.' which separates the dll name and function name
;     mov rcx, rbp
;     sub rcx, 312
;     mov rdx, '.'
;     call strchr                             ; ptr to chr in rax
    
;     mov byte [rax], 0                       ; replace the '.' with 0
;     inc rax

;     mov [rbp - 320], rax                    ; forwarded function name

;     cmp qword [load_library_a], 0           ; is load_library_a proc avaiable
;     je .error_shutdown
    
;     mov rcx, rbp
;     sub rcx, 312                            ; ptr to dll name + ext
;     call [load_library_a]                   ; library addr

;     mov [rbp - 328], rax                    ; library addr

;     mov rcx, [rbp - 320]
;     call strlen                             ; strlen in rax

;     mov [rbp - 336], rax                    ; function name strlen

;     mov rcx, [rbp - 328]
;     mov rdx, [rbp - 320]
;     mov r8, [rbp - 336]
;     call get_proc_address_by_name           ; proc addr

;     mov [rbp - 8], rax                      ; proc addr

;     jmp .shutdown

; .error_shutdown:
;     mov qword [rbp - 8], 0                  ; proc addr not found

.shutdown:
    mov rbx, [rbp - 344]                    ; restore rbx
    mov rax, [rbp - 8]                      ; return value

    leave
    ret

get_ntdll_module_handle_hg:

    push rbp
    mov rbp, rsp

    ; [rbp - 8] = First List Entry
    ; [rbp - 16] = Current List Entry
    ; [rbp - 24] = Table Entry
    ; [rbp - 32] = return addr
    sub rsp, 32                         ; allocate local variable space
    sub rsp, 32                         ; allocate shadow space

    mov rcx, ntdll_xor_hg
    mov rdx, ntdll_xor_hg.len
    mov r8, xor_key_hg
    mov r9, xor_key_hg.len
    call my_xor_hg                      ; kernel32.dll clear text

    mov rax, gs:[0x60]                  ; peb
    add rax, 0x18                       ; *ldr
    mov rax, [rax]                      ; ldr
    add rax, 0x20                       ; InMemoryOrderModuleList

    mov [rbp - 8], rax                  ; *FirstModule
    mov rax, [rax]
    mov [rbp - 16], rax                 ; CurrentModule
    mov qword [rbp - 32], 0             ; return code

.loop:
    cmp rax, [rbp - 8]                  ; CurrentModule == FirstModule ?
    je .loop_end_equal
        sub rax, 16                     ; *TableEntry
        mov [rbp - 24], rax             ; *TableEntry

        add rax, 0x58                   ; *BaseDLLName
        add rax, 0x8                    ; BaseDLLName.Buffer

        mov rcx, ntdll_xor_hg
        mov rdx, [rax]
        call strcmpiAW_hg

        cmp rax, 1                      ; strings match
        je .module_found

        mov rax, [rbp - 16]             ; CurrentModule
        mov rax, [rax]                  ; CurrentModule = CurrentModule->Flink
        mov [rbp - 16], rax             ; CurrentModule

        jmp .loop

.module_found:
    mov rax, [rbp - 24]                 ; *TableEntry
    add rax, 0x30                       ; TableEntry->DllBase
    mov rax, [rax]
    mov [rbp - 32], rax

    jmp .shutdown

.loop_end_equal:

.shutdown:
    mov rax, [rbp - 32]                 ; return code

    leave
    ret
; arg0: ptr to buffer               rcx
; arg1: ptr to str                  rdx
; arg2 ...: args to sprintf         r8, r9, rbp + 48 ..... 
; format specifiers: %(s/d/x)(b/w/d/q)
; s/d/x: string, decimal, hex
; b/w/d/q: byte, word, dword, qword value
sprintf:
    push rbp
    mov rbp, rsp

    mov [rbp + 16], rcx                     ; ptr to buffer
    mov [rbp + 24], rdx                     ; ptr to str
    mov [rbp + 32], r8                      ; arg1 to buffer
    mov [rbp + 40], r9                      ; arg2 to buffer

    ; rbp - 8 = return value
    ; rbp - 16 = esi
    ; rbp - 24 = edi
    ; rbp - 32 = place holder count
    ; rbp - 40 = offset from rbp
    ; rbp - 48 = number of bits to shift right
    ; rbp - 56 = rbx
    ; rbp - 64 = quotient from print decimal division
    ; rbp - 88 = temp buffer for decimal conversion (20 digit) + 5 byte padding
    ; rbp - 96 = arg size (db, xb = 1, dw, xw = 2, dd, xd = 4, dq, xq = 8), used to point to the next arg by adding to offset from rbp, currently passing 8 for all to keep OutputDebugStringA from crashing !?!?
    sub rsp, 96                             ; allocate local variable space
    sub rsp, 32                             ; allocate shadow space

    mov qword [rbp - 8], 0                  ; return value
    mov [rbp - 16], rsi                     ; save rsi
    mov [rbp - 24], rdi                     ; save rdi
    mov qword [rbp - 32], 0                 ; place holder count
    mov qword [rbp - 56], rbx               ; save rbx

    mov qword [rbp - 40], 32                ; offset from rbp

    mov rsi, [rbp + 24]                     ; ptr to str
    mov rdi, [rbp + 16]                     ; ptr to buffer

.loop:
    lodsb

    cmp al, '%'
    je .process_placeholder

    stosb

    cmp al, 0
    je .end_of_loop

    jmp .loop
    .process_placeholder:
        lodsb

        cmp al, 's'
        je .print_string

        cmp al, 'd'
        je .print_decimal

        cmp al, 'x'
        je .print_hex

        stosb                               ; not a placeholder, must be a string, copy it

        jmp .loop

        .print_string:
            lodsb
            
            cmp al, 'b'
            je .print_single_byte_char

            cmp al, 'w'
            je .print_double_byte_char

            jmp .loop

            .print_single_byte_char:
                ; copy arg string to the buffer
                mov rax, [rbp - 40]             ; offset from rbp
                mov rcx, [rbp + rax]
                mov rdx, rdi
                call strcpy

                ; find strlen to get rdi to the end of the str in buffer
                mov rax, [rbp - 40]             ; offset from rbp
                mov rcx, [rbp + rax]            ; arg
                call strlen

                add rdi, rax

                add qword [rbp - 40], 8         ; offset from rbp
                inc qword [rbp - 32]            ; place holder count
                jmp .loop

            .print_double_byte_char:
                ; copy arg string to the buffer
                mov rax, [rbp - 40]             ; offset from rbp
                mov rcx, [rbp + rax]
                mov rdx, rdi
                call wstrcpya

                ; find strlen to get rdi to the end of the str in buffer
                mov rax, [rbp - 40]             ; offset from rbp
                mov rcx, [rbp + rax]            ; arg
                call wstrlen

                add rdi, rax

                add qword [rbp - 40], 8         ; offset from rbp, ideally should be arg size [rbp - 96]
                inc qword [rbp - 32]            ; place holder count
                jmp .loop

        .print_decimal:
            lodsb
            
            cmp al, 'b'
            je .print_decimal_byte

            cmp al, 'w'
            je .print_decimal_word

            cmp al, 'd'
            je .print_decimal_dword

            cmp al, 'q'
            je .print_decimal_qword

            jmp .loop

            .print_decimal_byte:
                mov rax, [rbp - 40]         ; offset from rbp
                movzx eax, byte [rbp + rax] ; arg
                mov qword [rbp - 96], 1     ; arg size
                jmp .continue_from_decimal_data_size_check
            .print_decimal_word:
                mov rax, [rbp - 40]         ; offset from rbp
                movzx eax, word [rbp + rax] ; arg
                mov qword [rbp - 96], 2     ; arg size
                jmp .continue_from_decimal_data_size_check
            .print_decimal_dword:
                mov rax, [rbp - 40]         ; offset from rbp
                mov eax, [rbp + rax]        ; arg
                mov qword [rbp - 96], 4     ; arg size
                jmp .continue_from_decimal_data_size_check
            .print_decimal_qword:
                mov rax, [rbp - 40]         ; offset from rbp
                mov rax, [rbp + rax]        ; arg
                mov qword [rbp - 96], 8     ; arg size
                jmp .continue_from_decimal_data_size_check

            .continue_from_decimal_data_size_check:

            mov rcx, 10                     ; divisor
            xor rbx, rbx                    ; number of digits in the decimal

            mov r10, rsi                    ; temp save rsi
            mov r11, rdi                    ; temp save rdi

            mov rdi, rbp
            sub rdi, 65                     ; temp buffer for digits (reverse)
            std                             ; set direction flag since the digits are written in reverse order

            .print_decimal_loop:
                xor edx, edx
                div rcx

                mov [rbp - 64], rax         ; save quotient
                mov rax, rdx                ; remainder
                add rax, 48                 ; ascii value of integer

                stosb

                mov rax, [rbp - 64]         ; restore quotient

                inc rbx
                cmp rax, 0
                jne .print_decimal_loop

            mov rdi, r11                    ; temp restore rdi

            cld                             ; clear direction flag

            mov rsi, rbp
            sub rsi, 64                     ; temp buffer for digits (reverse)
            sub rsi, rbx

            .final_copy_loop:
                movsb

                dec rbx
                jnz .final_copy_loop

            mov rsi, r10                    ; temp restore rsi
            inc qword [rbp - 32]            ; place holder count
            add qword [rbp - 40], 8         ; offset from rbp, ideally should be arg size [rbp - 96]
            jmp .loop

        .print_hex:
            lodsb

            cmp al, 'b'
            je .print_hex_byte

            cmp al, 'w'
            je .print_hex_word

            cmp al, 'd'
            je .print_hex_dword

            cmp al, 'q'
            je .print_hex_qword

            jmp .loop

            .print_hex_byte:
                mov qword [rbp - 48], 8     ; start with 8 bits to shift right
                mov qword [rbp - 96], 1     ; arg size
                jmp .continue_from_hex_data_size_check
            .print_hex_word:
                mov qword [rbp - 48], 16    ; start with 16 bits to shift right
                mov qword [rbp - 96], 2     ; arg size
                jmp .continue_from_hex_data_size_check
            .print_hex_dword:
                mov qword [rbp - 48], 32    ; start with 32 bits to shift right
                mov qword [rbp - 96], 4     ; arg size
                jmp .continue_from_hex_data_size_check
            .print_hex_qword:
                mov qword [rbp - 48], 64    ; start with 64 bits to shift right
                mov qword [rbp - 96], 8     ; arg size
                jmp .continue_from_hex_data_size_check

            .continue_from_hex_data_size_check:

            mov rdx, hex_digits

            .print_hex_loop:
                cmp qword [rbp - 96], 1     ; arg size
                je .copy_byte

                cmp qword [rbp - 96], 2     ; arg size
                je .copy_word

                cmp qword [rbp - 96], 4     ; arg size
                je .copy_dword

                cmp qword [rbp - 96], 8     ; arg size
                je .copy_qword

                .copy_byte:
                    mov rax, [rbp - 40]         ; offset from rbp
                    movzx eax, byte [rbp + rax] ; arg
                    jmp .continue_from_copy

                .copy_word:
                    mov rax, [rbp - 40]         ; offset from rbp
                    movzx eax, word [rbp + rax] ; arg
                    jmp .continue_from_copy

                .copy_dword:
                    mov rax, [rbp - 40]         ; offset from rbp
                    mov eax, [rbp + rax]        ; arg
                    jmp .continue_from_copy

                .copy_qword:
                    mov rax, [rbp - 40]         ; offset from rbp
                    mov rax, [rbp + rax]        ; arg
                    jmp .continue_from_copy
                
                .continue_from_copy:

                    sub qword [rbp - 48], 4     ; nbits to shift right
                    mov rcx, [rbp - 48]         ; nbits to shift right

                    shr rax, cl                 ; shift right and 'and', so just the nibble is left in al
                    and al, 0x0f

                    movzx ebx, byte al
                    mov al, [rdx + rbx]         ; the corresponding 'letter' in al

                    stosb

                    cmp qword [rbp - 48], 0     ; nbits to shift right
                    jne .print_hex_loop

            inc qword [rbp - 32]                ; place holder count
            add qword [rbp - 40], 8             ; offset from rbp, ideally should be arg size [rbp - 96]
            jmp .loop

.end_of_loop:

.shutdown:
    mov rbx, [rbp - 56]                     ; restore rbx
    mov rdi, [rbp - 24]                     ; restore rdi
    mov rsi, [rbp - 16]                     ; restore rsi
    mov rax, [rbp - 8]                      ; restore rax

    leave
    ret