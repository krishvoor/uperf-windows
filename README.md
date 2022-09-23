# Uperf on Windows
This repository is intended for running uperf on Windows.
The base container image used is `mcr.microsoft.com/windows/servercore:ltsc2019`

To understand more about the base images:-
https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/container-base-images#choosing-a-base-image

### How to install & configure Docker Desktop

To install Docker-Desktop
https://docs.docker.com/desktop/install/windows-install/ 

In order to run Windows container, the default configuration of Docker Desktop has to be meddled with

1. Enable Experimental Features in your Docker Desktop configuration, restart it
2. Switch to Windows-container mode from by right-clicking Docker Desktop from the system-tray
https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?source=recommendations&tabs=dockerce#install-the-container-runtime
3. And of-course you gotta restart the respective service for changes to take effect

### How to build the container image

```
cd 'C:\Users\<USERNAME>\Desktop`
git clone https://github.com/krishvoor/uperf-windows/ -b master
cd .\uperf-windows
docker build -t windows:uperf .
```

### Run uperf in server mode
```
PS C:\Users\vkommadi\Desktop> docker run -d -p 30000:30000 quay.io/krvoora_ocm/windows:uperf uperf -s -v -P 30000
023963ce1cd81c0629c18d5590b4da51275e325f76e644ad56d087713c0a77e9
PS C:\Users\vkommadi\Desktop>
```

Validate whether the container started or not
```
PS C:\Users\vkommadi\Desktop> docker ps -a
CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS         PORTS                      NAMES
023963ce1cd8   quay.io/krvoora_ocm/windows:uperf   "uperf -s -v -P 30000"   6 minutes ago   Up 6 minutes   0.0.0.0:30000->30000/tcp   nifty_satoshi
PS C:\Users\vkommadi\Desktop>
```

### Run uperf in slave mode
Update the test.xml profile required to understand 
```
$ cat > test.xml << EOF
<?xml version=1.0?>
<profile name="stream-tcp-64-64-1">
          <group nthreads="1">
      <transaction iterations="1">
        <flowop type="connect" options="remotehost=<UPDATE_ME_CONTAINER_IP> protocol=tcp port=30001"/>
      </transaction>
      <transaction duration="60">
        <flowop type=write options="count=16 size=64"/>
      </transaction>
      <transaction iterations="1">
        <flowop type=disconnect />
      </transaction>
  </group>
        </profile>
EOF
```

Run the uperf in slave mode
```
PS C:\Users\vkommadi\Desktop>docker run -v "c:\Users\vkommadi\Desktop\uperf":"c:\uperf" quay.io/krvoora_ocm/windows:uperf uperf -v -a -R -i 1 -m test.xml -P 30000
```
This should run for a while, and spew some information on screen, here's the output

```
Txn                Count         avg         cpu         max         min
-------------------------------------------------------------------------------
Txn0                   1    616.80us      0.00ns    616.80us    616.80us
Txn1              885914     67.25us      0.00ns    122.20ms      3.80us
Txn2                   1     81.30us      0.00ns     81.30us     81.30us


Flowop             Count         avg         cpu         max         min
-------------------------------------------------------------------------------
connect                1    616.00us      0.00ns    616.00us    616.00us
write           14174608      4.19us      0.00ns    122.20ms     14.10us
disconnect             1     80.60us      0.00ns     80.60us     80.60us


Run Statistics
Hostname            Time       Data   Throughput   Operations      Errors
-------------------------------------------------------------------------------
[172.29.16.62] Success172.29.16.62      62.05s   862.33MB   116.57Mb/s     14128483        0.00
master            62.05s   865.15MB   116.96Mb/s     14174611        0.00
-------------------------------------------------------------------------------
Difference(%)     -0.00%      0.33%        0.33%        0.33%       0.00%



vkommadi@ovnhybrid MINGW64 ~/Desktop/uperf (master)
$
```
