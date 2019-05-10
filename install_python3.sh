#!/bin/bash
PYTHON_VERSION="3.6.8"

# install python2/3 locally step by step
# Install python to local directory

mkdir ~/python-download
cd ~/python-download
wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
tar -xvf Python-$PYTHON_VERSION.tar.xz
# find ~/python -type d | xargs chmod 0755 $$$ donot get it, but do this to avoid permission issues
cd Python-$PYTHON_VERSION
# Then compile the source following its guideline

./configure --prefix=$HOME/local/python-$PYTHON_VERSION  ## --enable-optimizations # longer to process, faster to run
make -j 8 && make install -j 8

# update the environment variables to force the shell to use our new python. 
# vi ~/.bashrc # (.bashrc), and add the following lines:
echo "export PATH=$HOME/local/python-$PYTHON_VERSION/:$HOME/local/python-$PYTHON_VERSION/bin:$PATH" >> $HOME/.bashrc
echo "export PYTHONPATH=$HOME/local/python-$PYTHON_VERSION/" >> $HOME/.bashrc

# Finally, refresh the current session by running the command:
source $HOME/.bashrc
### Install pip
echo "pip is already installed if you are using Python 2 >=2.7.9 or Python 3 >=3.4"
echo "downloaded from python.org or if you are working in a Virtual Environment created by virtualenv or pyvenv. "
echo "Just make sure to upgrade pip."
echo "you can find pyvenv in the python/bin folder"
echo "create pyvenv with python3 -m venv ~/pyvenv3"

# wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py -O - | python - --user
