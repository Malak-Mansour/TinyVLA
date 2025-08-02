# Install libgpg-error (newer version for compatibility)
```
conda install -c conda-forge glew
conda install -c conda-forge mesalib
conda install -c anaconda mesa-libgl-cos6-x86_64
conda install -c menpo glfw3
```


conda install -c menpo osmesa=12.2.2.dev


# extra step to install this version of gcc 
one of these 3:
<!-- - ⁠conda install 
- module load gcc-7 -->
- ⁠module load gcc-8
<!-- check if it is loaded with: gcc --version
gcc (Ubuntu 8.4.0-3ubuntu2) 8.4.0
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 -->



# Library 1
<!-- if this fails at: ./configure --prefix=$CONDA_PREFIX -->
```
cd libgpg-error-1.47
make clean 2>/dev/null || true
rm -rf build CMakeCache.txt CMakeFiles config.log config.status Makefile
conda install -c conda-forge gcc=11.4.0 gxx=11.4.0
export PATH=$CONDA_PREFIX/bin:$PATH
```

```
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.47.tar.bz2
tar xjf libgpg-error-1.47.tar.bz2
cd libgpg-error-1.47
./configure --prefix=$CONDA_PREFIX 
make
make install
```

# Install the missing gpg-error-config script
```
cd src
make gpg-error-config
cp gpg-error-config $CONDA_PREFIX/bin/
chmod +x $CONDA_PREFIX/bin/gpg-error-config
cd ../..
```

# Set up environment variables
```
export PATH=$CONDA_PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
```

# Verify gpg-error installation
```
which gpg-error-config
gpg-error-config --version
```

# Library 2
```
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.5.3.tar.gz
tar xzf libgcrypt-1.5.3.tar.gz
cd libgcrypt-1.5.3
./configure --prefix=$CONDA_PREFIX
make
make install
```

# Set up library paths
<!-- export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export CPATH=$CONDA_PREFIX/include --> probably not needed

```
export MUJOCO_GL=osmesa
export PYOPENGL_PLATFORM=osmesa
# pip install pyrender -> might not be needed
```


# suggestions from here
# https://pytorch.org/rl/stable/reference/generated/knowledge_base/MUJOCO_INSTALLATION.html