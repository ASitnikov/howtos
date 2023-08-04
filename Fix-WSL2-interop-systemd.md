Thanks to _anno_@reddit (https://www.reddit.com/r/bashonubuntuonwindows/comments/11vx61n/wsl2_error_cannot_execute_binary_file_exec_format/jdgw1yo/)

I did some more digging and following binformat config fixed it for me:

1. Create binformat config file

https://github.com/microsoft/WSL/issues/8986#issuecomment-1332413859

in wsl create the file

```
sudo vi /usr/lib/binfmt.d/WSLInterop.conf 
```

with contents:

```
:WSLInterop:M::MZ::/init:PF
```
2. restart binformat related systemd services

https://github.com/microsoft/WSL/issues/8986#issuecomment-1332452012

restart systemd services

```
sudo systemctl restart systemd-binfmt
sudo systemctl restart binfmt-support
```

3. install binformat systemd support

If you get an error on restarting, you might need to install binformat support first:

```
sudo apt update
sudo apt install binfmt-support
```

4. check config

if you see

```
sudo ls -Fal /proc/sys/fs/binfmt_misc
total 0
drwxr-xr-x 2 root root 0 Mar 24 11:11 ./
dr-xr-xr-x 1 root root 0 Mar 24 11:11 ../
-rw-r--r-- 1 root root 0 Mar 24 11:35 WSLInterop
-rw-r--r-- 1 root root 0 Mar 24 11:35 jar
-rw-r--r-- 1 root root 0 Mar 24 11:35 python3.11
--w------- 1 root root 0 Mar 24 11:35 register
-rw-r--r-- 1 root root 0 Mar 24 11:35 status

sudo cat /proc/sys/fs/binfmt_misc/WSLInterop
enabled
interpreter /init
flags: PF
offset 0
magic 4d5a
```
everything should work fine also with systemd again.
