#!/bin/bash

set -e

CUDA_VERSION="12.2"
CUDNN_ARCHIVE="cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz"
CUDNN_DIR="cudnn-linux-x86_64-8.9.6.50_cuda12-archive"

echo "🚀 Iniciando instalação do CUDA Toolkit $CUDA_VERSION com cuDNN 8.9..."

# 1. Remover instalações anteriores
echo "🧹 Removendo instalações CUDA/cuDNN antigos..."
sudo apt --purge remove "*cuda*" "*cudnn*" "*npp*" "*nsight*" "*cublas*" "*cufft*" "*curand*" "*cusolver*" "*cusparse*" "*nvjpeg*" -y || true
sudo apt autoremove -y
sudo apt autoclean -y

# 2. Instalar chave do repositório oficial
echo "🔑 Instalando chave do repositório CUDA..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update

# 3. Instalar CUDA Toolkit 12.2
echo "📦 Instalando CUDA Toolkit $CUDA_VERSION..."
sudo apt-get -y install cuda-toolkit-12-2

# 4. Atualizar variáveis de ambiente
echo "⚙️ Configurando variáveis de ambiente..."
if ! grep -q "/usr/local/cuda-$CUDA_VERSION/bin" ~/.bashrc; then
  echo '# CUDA Toolkit' >> ~/.bashrc
  echo "export PATH=/usr/local/cuda-$CUDA_VERSION/bin:\$PATH" >> ~/.bashrc
  echo "export LD_LIBRARY_PATH=/usr/local/cuda-$CUDA_VERSION/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc
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

sudo cp include/* /usr/local/cuda-$CUDA_VERSION/include/
sudo cp lib/* /usr/local/cuda-$CUDA_VERSION/lib64/
sudo chmod a+r /usr/local/cuda-$CUDA_VERSION/include/cudnn*.h /usr/local/cuda-$CUDA_VERSION/lib64/libcudnn*

# 6. Testar instalação
echo "🔍 Verificando nvcc..."
if command -v nvcc &> /dev/null; then
  nvcc --version
  echo "✅ nvcc instalado com sucesso."
else
  echo "❌ nvcc não encontrado. Algo falhou."
  exit 1
fi

# 7. Teste rápido com Python + TensorFlow
echo "🧪 Verificando TensorFlow e GPU..."
python3 -c "
import tensorflow as tf
print('TensorFlow:', tf.__version__)
print('CUDA disponível:', tf.test.is_built_with_cuda())
print('GPUs:', tf.config.list_physical_devices('GPU'))
"

echo "✅ Instalação finalizada com sucesso!"
