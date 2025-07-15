#!/bin/bash

set -e

# -------- CONFIG --------
UBUNTU_VERSION="ubuntu2004"
CUDA_VERSION="12.2"
CUDNN_ARCHIVE="cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz"
CUDNN_DIR="cudnn-linux-x86_64-8.9.6.50_cuda12-archive"

echo "🚀 Iniciando instalação do CUDA Toolkit $CUDA_VERSION com cuDNN 8.9 para $UBUNTU_VERSION..."

# 1. Remover instalações anteriores
echo "🧹 Removendo instalações antigas CUDA/cuDNN..."
sudo apt --purge remove "*cuda*" "*cudnn*" "*npp*" "*nsight*" "*cublas*" "*cufft*" "*curand*" "*cusolver*" "*cusparse*" "*nvjpeg*" -y || true
sudo apt autoremove -y
sudo apt autoclean -y

# 2. Instalar chave do repositório oficial CUDA
echo "🔑 Instalando chave do repositório CUDA..."
CUDA_KEYRING_PKG="cuda-keyring_1.1-1_all.deb"
CUDA_KEYRING_URL="https://developer.download.nvidia.com/compute/cuda/repos/${UBUNTU_VERSION}/x86_64/${CUDA_KEYRING_PKG}"

wget -O $CUDA_KEYRING_PKG $CUDA_KEYRING_URL
sudo dpkg -i $CUDA_KEYRING_PKG
rm $CUDA_KEYRING_PKG

sudo apt-get update

# 3. Instalar CUDA Toolkit
echo "📦 Instalando CUDA Toolkit $CUDA_VERSION..."
sudo apt-get -y install cuda-toolkit-${CUDA_VERSION}

# 4. Atualizar variáveis de ambiente no ~/.bashrc
echo "⚙️ Configurando variáveis de ambiente..."
CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"
if ! grep -q "$CUDA_PATH/bin" ~/.bashrc; then
  echo '# CUDA Toolkit' >> ~/.bashrc
  echo "export PATH=${CUDA_PATH}/bin:\$PATH" >> ~/.bashrc
  echo "export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc
fi
source ~/.bashrc

# 5. Instalar cuDNN
echo "📦 Instalando cuDNN 8.9..."
cd ~/Downloads

if [ ! -f "$CUDNN_ARCHIVE" ]; then
  echo "❌ Arquivo $CUDNN_ARCHIVE não encontrado em ~/Downloads. Faça o download manualmente da NVIDIA antes de continuar."
  exit 1
fi

tar -xf $CUDNN_ARCHIVE
cd $CUDNN_DIR

sudo cp include/* $CUDA_PATH/include/
sudo cp lib/* $CUDA_PATH/lib64/
sudo chmod a+r $CUDA_PATH/include/cudnn*.h $CUDA_PATH/lib64/libcudnn*

cd ~  # Voltar para home

# 6. Verificar instalação nvcc
echo "🔍 Verificando nvcc..."
if command -v nvcc &> /dev/null; then
  nvcc --version
  echo "✅ nvcc instalado com sucesso."
else
  echo "❌ nvcc não encontrado. Algo falhou."
  exit 1
fi

# 7. Teste rápido com TensorFlow
echo "🧪 Verificando TensorFlow e GPU..."
python3 -c "
import tensorflow as tf
print('TensorFlow:', tf.__version__)
print('CUDA disponível:', tf.test.is_built_with_cuda())
print('GPUs:', tf.config.list_physical_devices('GPU'))
"

echo "✅ Instalação finalizada com sucesso!"
