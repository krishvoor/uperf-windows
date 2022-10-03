FROM docker.io/winamd64/python:3-windowsservercore-ltsc2016
WORKDIR /uperf
COPY cygwin1.dll ./
COPY uperf.exe ./