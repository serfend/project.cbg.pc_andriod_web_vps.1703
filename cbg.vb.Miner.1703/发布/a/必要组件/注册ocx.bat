@echo off
copy /y MSCOMCTL.OCX %windir%\system32\
regsvr32/s MSCOMCTL.OCX
Copy /y MSWINSCK.OCX %windir%\system32\
regsvr32/s %windir%\system32\MSWINSCK.OCX
Copy /y Comctl32.OCX %windir%\system32\
regsvr32/s %windir%\system32\Comctl32.OCX