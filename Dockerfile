FROM docker.io/winamd64/python:3-windowsservercore-ltsc2022
RUN powershell "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
RUN powershell choco install mingw --yes --accept-license
# RUN powershell choco install python pip --yes --accept-license
WORKDIR /uperf
ADD simply-uperf ./
RUN pip install -r simply-uperf/requirements.txt
COPY cygwin1.dll ./
COPY uperf.exe ./