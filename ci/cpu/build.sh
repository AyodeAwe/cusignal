#!/bin/bash
# Copyright (c) 2018, NVIDIA CORPORATION.
##########################################
# cuSignal CPU conda build script for CI #
##########################################
set -e

# Set path and build parallel level
export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
export PARALLEL_LEVEL=4

# Set home to the job's workspace
export HOME=$WORKSPACE

# Switch to project root; also root of repo checkout
cd $WORKSPACE

# If nightly build, append current YYMMDD to version
if [[ "$BUILD_MODE" = "branch" && "$SOURCE_BRANCH" = branch-* ]] ; then
  export VERSION_SUFFIX=`date +%y%m%d`
fi

################################################################################
# SETUP - Check environment
################################################################################

gpuci_logger "Get env..."
env

gpuci_logger "Activate conda env..."
source activate gdf

gpuci_logger "Check versions..."
python --version
gcc --version
g++ --version
conda list

# FIX Added to deal with Anancoda SSL verification issues during conda builds
conda config --set ssl_verify False

################################################################################
# BUILD - Conda package build
################################################################################

gpuci_logger "Build conda pkg for cuSignal..."
conda build conda/recipes/cusignal --python=${PYTHON}

################################################################################
# UPLOAD - Conda packages
################################################################################

gpuci_logger "Upload conda pkgs for cuSignal..."
source ci/cpu/upload-anaconda.sh
