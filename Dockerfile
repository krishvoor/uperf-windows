FROM mcr.microsoft.com/windows/servercore:ltsc2019
WORKDIR /uperf
COPY cygwin1.dll ./
COPY uperf.exe ./