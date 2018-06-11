This provides a nix package for installing Intel Integrated Performance Primitives (Intel IPP).

This library is one of five Intel Performance Libraries available [here](https://software.seek.intel.com/performance-libraries).

# Installation Notes

Before sometime in 2017, installing these libraries in nix was a pain. The user had to privately copy a lot of files into /nix/store from a previous non-nix installation and could not easily redistribute any code that required the library. Also the user was left in doubt about the licence status.

Now Intel allows the libraries to be a little more easily downloaded and seem to be encouraging use and distribution. Also, nix now has the function `requireFile`, which looks for the download bundle and prompts the user to put it in /nix/store if it is not already present. 
	
This installation will fail unless you have already placed the download file in /nix/store. You can do that with 

~~~~
nix-store --add-fixed sha256 /path/to/l_ipp_2018.2.222.tgz 
~~~~

or go to the directory containing the download

~~~~
nix-store --add-fixed sha256 $(readlink -f  l_ipp_2018.2.222.tgz)
~~~~~


If you want to use another version of the library change default.nix to reflect the new version number and update the hash value in `default.nix`. You can do that with the following command (after replacing the file name with your new .tgz file)

~~~~
nix-hash --type sha256 --flat --base32 l_2018.3.222.tgz 
~~~~

You can also build the library using

~~~~
nix-build release.nix -A intel-ipp_2018_3_222
~~~~


# Using the library

Since this package is not part of nixpkgs you are going to have clone this repo and add the package to an overlay or package override somewhere. If you don't know how to do that take a look at Gabriel Gonzalez's great set of tutorials on developing with private packages, available [here](https://github.com/Gabriel439/haskell-nix). 


# Future Work?

This package is adapted from [here](https://github.com/markuskowa/NixOS-QChem/blob/master/mkl/default.nix), whick is a package that installs another Intel Performance Library -- Intel MKL. I don't use that library but the installation pattern was close enough. I suspect minor alterations would allow the the other three Intel Performance Libraries to also be installed. Only a cache of the download files would prevent a user from establishing a full binary packages. Need to check Intel licensing to see if that would work. 





