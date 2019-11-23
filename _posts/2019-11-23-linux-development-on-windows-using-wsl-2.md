---
layout: post
title: Linux development on Windows using WSL 2
categories: [WSL2,Windows,Linux,Development] 
---

What is WSL? The **Windows Subsystem for Linux**, or, **WSL**, is a compatibility layer for running 
Linux binaries natively on Windows 10. WSL provides a Linux-compatible
kernel interface and allows a user to install a Linux distribution from the Microsoft Store.

On May 6th, 2019, Microsoft [announced](https://devblogs.microsoft.com/commandline/announcing-wsl-2/) **WSL 2**, featuring a completely new VM-based backend instead of the prior system call adaptation layer.

## Key differences WSL 1 and WSL 2
For the ones who are already actively using WSL 1 it might be worth considering to switch to WSL 2 for the following reasons:

* **Better file system performance**. File intensive operations like `git clone`, `apt upgrade`, and more will be noticeably faster. Initial versions of WSL 2 run up to 20x faster compared to WSl 1 when unpacking a zipped tarball, and around 2-5x faster when using `git clone`.
* **Improved system call compatibility**. WSL 1 uses a translation layer, while WSL 2 includes its own Linux kernel with full system call compatibility. This enables applications such as Docker to run inside of WSL. You can read more about the WSL modified Linux kernel [here](https://devblogs.microsoft.com/commandline/shipping-a-linux-kernel-with-windows/).  

Each Linux distribution can switch between WSL 1 and WSL 2 at any time. 

## Setting up WSL 2
### Make sure you have a compatible Windows 10 Build
Make sure you have a **Windows 10 build 18917** or higher: at the time of writing this post, this is only available by installing the latest Windows 10 preview build (see [Windows Insider Program](https://insider.windows.com/en-us/)). You can check your build version by opening Command Prompt and running the `ver` command:
```powershell
C:\Users\Dimitri>ver
Microsoft Windows [Version 10.0.19018.1]
```

### Enable optional features
Enable the *Virtual Machine Platform* and *Microsoft-Windows-Subsystem-Linux* optional features using PowerShell:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

### Install a Linux Distribution
Install a Linux Distribution of choice using the Microsoft Store (e.g. Ubuntu-18.04 LTS):
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/install-ubuntu.png)

Check if the Linux Distribution is available via the WSL CLI:
```powershell
PS C:\WINDOWS\system32> wsl --list
Windows Subsystem for Linux Distributions:
Ubuntu-18.04 (Default)
```

Make sure your Linux Distribution is using WSL 2 and set the default WSL version to be used:
```powershell
PS C:\WINDOWS\system32> wsl --set-version Ubuntu-18.04 2
PS C:\WINDOWS\system32> wsl --set-default-version 2
PS C:\WINDOWS\system32> wsl -l -v
  NAME            STATE           VERSION
* Ubuntu-18.04    Stopped         2
```

Click Launch to get started, create a UNIX username/password and you are good to go!
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/install-ubuntu-2.png)

## Visual Studio code & WSL
Now that we have a fully functioning GNU Bash Unix shell, we could start developing using one of our favorite editors (vim, emacs, …). However, cross platform source code editors such as Visual Studio code (VS code) are becoming more popular because of having a rich ecosystem of extensions, providing support for 100s of languages and frameworks. 

### Sharing files between Windows 10 and WSL
You can expose your WSL home directory to the Windows 10 host system using the auto-mounted `\\wsl$` location:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/mount-wsl.png)

### Linux development using Visual Studio code from Windows 10

#### Using the Remote - WSL extension
One could use the mounted location shown above to start development using VS code from Windows. The problem with this approach is that VS code will only be able to access runtimes, tools and compilers installed locally on the Windows system. In order to resolve this issue one can install the WSL remote extension:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-1.png)

This extension allows you to run commands AND extensions directly in WSL so you do not have to worry about path issues, binary compatibility, … 

In order to get started, type `code .` in the WSL terminal at a preferred location:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-2.png)
This will install a Linux VS code server that is compatible with the desktop VS code client. This server will manage and run VS Code extensions in WSL. They run in the context of the tools and frameworks installed in WSL, not against what is installed on Windows.

#### Python development
Opening a new VS code windows (see previous subsection) results in the following view:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-3.png)
Note that the terminal opened here is an actual GNU Bash shell running in WSL!

Next, we install the Python VS code extension remotely inside WSL as visualized below:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-4.png)

We create an example python source module file `main.py` (inside home directory WSL):
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-5.png)

Notice how, after attempting to execute this python module, we are missing an interpreter. This is because
we have not yet installed Python 3 in WSL yet! Let's install Python 3 and select it as the interpreter for VS Code:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-6.png)

Now if would like to debug our module we can set a breakpoint and press F5 - Debug Python File to inspect variables, create watches or inspect the call stack:
![](/images/posts/2019-11-23-linux-development-on-windows-using-wsl-2/vscode-7.png)

## Conclusion
With WSL, VS code and the Remote - WSL extension, developers are able to develop Linux applications from a Windows machine without being forced into other alternatives such as dual boot, spinning up a VM, …

WSL 2 promises an even better Linux experience as it is faster and supports even more functionality by leveraging its own Linux kernel with full system call compatibility.