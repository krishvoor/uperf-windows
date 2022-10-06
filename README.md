# Uperf on Windows
This repository is intended for running uperf on Windows.
The base container image used is `docker.io/winamd64/python:3-windowsservercore-ltsc2022`

To understand more about the base images for Windows go [here](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/container-base-images#choosing-a-base-image)
### How to install & configure Docker with a corresponding runtime

To run Windows container, we can choose from:
1. [Containerd Runtime](https://github.com/microsoft/Windows-Containers/tree/Main/helpful_tools/Install-ContainerdRuntime)
2. [DockerCE](https://github.com/microsoft/Windows-Containers/tree/Main/helpful_tools/Install-DockerCE#examples)
3. [MirantisContainer Runtime](https://github.com/microsoft/Windows-Containers/tree/Main/helpful_tools/Install-MirantisContainerRuntime)


### How to build the container image

```
cd 'C:\Users\<USERNAME>\Desktop`
git clone https://github.com/krishvoor/uperf-windows/
cd uperf-windows
git submodule --init --recursive update
cd .\uperf-windows
docker build -t windows:uperf-simply .
```

### Run uperf in server mode
```
PS C:\Users\vkommadi\Desktop> docker run -d -p 30000:30000 quay.io/krvoora_ocm/windows:uperf-simply uperf -s -v -P 30000
023963ce1cd81c0629c18d5590b4da51275e325f76e644ad56d087713c0a77e9
PS C:\Users\vkommadi\Desktop>
```

Validate whether the container started or not
```
PS C:\Users\vkommadi\Desktop> docker ps -a
CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS         PORTS                      NAMES
023963ce1cd8   quay.io/krvoora_ocm/windows:uperf-simply   "uperf -s -v -P 30000"   6 minutes ago   Up 6 minutes   0.0.0.0:30000->30000/tcp   nifty_satoshi
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
PS C:\Users\vkommadi\Desktop>docker run -v "c:\Users\vkommadi\Desktop\uperf":"c:\uperf" quay.io/krvoora_ocm/windows:uperf-simply python c:\uperf\uperf.exe
```
This should run for a while, and spew information on screen, here's the output

```

$ docker logs -f fc96d55055dd

{
    "norm_byte_avg": "1.19 GB",
    "norm_ltcy_avg": 6.830062853840754,
    "norm_ltcy_p95": 9.448229074093321,
    "norm_ltcy_p99": 12.689357141501684
}
$ pwd
vkommadi@ovnhybrid MINGW64 ~/Desktop/uperf (master)
$
```
