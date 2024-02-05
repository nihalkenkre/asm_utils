@echo off
nasm utils_test_64.asm -f Win64 -o build/utils_test_64.obj
link build/utils_test_64.obj /nologo /largeaddressaware:no /entry:main /machine:x64 /out:build/utils_test_64.exe

nasm utils_test_32.asm -f Win32 -o build/utils_test_32.obj
link build/utils_test_32.obj /nologo /entry:main /machine:x86 /out:build/utils_test_32.exe

del build\\*obj