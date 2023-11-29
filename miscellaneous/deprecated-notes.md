### Using Repo-Tool (deprecated)
*Google* *repo* *tool* is needed to collect the sources and start the build process. To setup the environment and start building the system should be sourced the *setup-environment* shell script that could be found in the source folder.  To build from sources you can init the repo to the *manifest* and synchronize the sources easily. Repo tool will download the sources and configure the environment for you.<br/> 
> repo init -u https://\<TOKEN\>@github.com/waelkarman/bunch-linux-manifests.git -m v6.3.0.xml -b master<br/>
> repo sync<br/>
 
Once the environment is properly set you should source to the *setup-environment* script and then launch the compilation of the distro using *bitbake* yocto tool.
> source setup-environment<br/>
> bitbake bunch-linux<br/>

### Deploy
The compiled image will be located into the build folder at the following path:
> /build/tmp/deploy/images/raspberrypi4-64

Getting the image it should be flashed through linux dd, bmaptool command or using third party software like *BalenaEtcher*, *Raspberry* *Imager*.

> bunzip2 -c bunch-linux-bunch-raspberrypi4-64.wic.bz2 | sudo dd of=/dev/sda bs=1M  status=progress && sync

> bmaptool copy \<IMAGE\>.wic.gz /dev/sda && sync
