@echo off
rem Run Vivado xsim natively on Windows.
rem Build artifacts (xsim.dir, logs, journals) go to build\<top> to keep the sources clean.
rem
rem Usage: run_xsim.bat [tb|testbench] [gui]
setlocal EnableDelayedExpansion

set "VIVADO_BIN=C:\Xilinx\2025.1\Vivado\bin"

set "TOP=%~1"
if "%TOP%"=="" set "TOP=tb"
set "MODE=%~2"

if /i "%TOP%"=="tb" (
    set "SRCS=rtl\fifo.sv tb\fifo_cfg_pkg.sv tb\fifo_if.sv tb\fifo_tb_pkg.sv tb\tb.sv"
) else if /i "%TOP%"=="testbench" (
    set "SRCS=rtl\fifo.sv tb\testbench.sv"
) else (
    echo unknown top: %TOP% ^(expected tb or testbench^) 1>&2
    exit /b 1
)

if not "%MODE%"=="" if /i not "%MODE%"=="gui" (
    echo unknown mode: %MODE% ^(expected gui or nothing^) 1>&2
    exit /b 1
)

set "SRC_DIR=%~dp0"
set "SRC_DIR=%SRC_DIR:~0,-1%"
set "WORK=%SRC_DIR%\build\%TOP%"

set "FILES="
for %%f in (%SRCS%) do set FILES=!FILES! "%SRC_DIR%\%%f"

if not exist "%WORK%" mkdir "%WORK%"
rem setlocal restores the original directory on exit
cd /d "%WORK%"

call "%VIVADO_BIN%\xvlog.bat" -sv -i "%SRC_DIR%\tb" %FILES% || exit /b 1
call "%VIVADO_BIN%\xelab.bat" -debug typical %TOP% -s %TOP%_sim || exit /b 1

if /i "%MODE%"=="gui" (
    rem record every signal, show them in the wave window and run to $finish
    > wave.tcl echo log_wave -r /*
    >>wave.tcl echo add_wave -r /*
    >>wave.tcl echo run -all
    call "%VIVADO_BIN%\xsim.bat" %TOP%_sim -gui -tclbatch wave.tcl || exit /b 1
) else (
    call "%VIVADO_BIN%\xsim.bat" %TOP%_sim -R || exit /b 1
)
