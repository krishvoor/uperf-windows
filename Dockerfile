FROM docker.io/winamd64/python:3-windowsservercore-ltsc2022
WORKDIR /uperf
ADD simply-uperf ./
RUN pip install -r simply-uperf/requirements.txt
COPY cygwin1.dll ./
COPY uperf.exe ./