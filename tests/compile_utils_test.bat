@echo off
@REM nasm utils_test_64.asm -f Win64 -o utils_test_64.obj
@REM link utils_test_64.obj /nologo kernel32.lib /largeaddressaware:no /entry:main /out:utils_test_64.exe

nasm utils_test_32.asm -f Win32 -o utils_test_32.obj
link utils_test_32.obj /nologo /entry:main /out:utils_test_32.exe