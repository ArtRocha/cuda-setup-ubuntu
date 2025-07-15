# 🚀 cudaflow-setup

Instalação automatizada do **CUDA Toolkit 12.2**, **cuDNN 8.9.6** e configuração do ambiente com **TensorFlow GPU** para **Ubuntu 20.04**.

> Ideal para desenvolvedores que desejam configurar um ambiente com suporte à GPU de forma rápida, segura e sem conflitos de versões.

---

## 📋 Pré-requisitos

- Ubuntu 20.04
- GPU NVIDIA compatível com CUDA (ex: GTX 1660 SUPER ou superior)
- Conexão com a internet
- Python 3 instalado

### 📦 Dependências do sistema
Instale com:

```bash
sudo apt update
sudo apt install -y build-essential wget python3 python3-pip
```

---

## 🔽 Download manual do cuDNN

A NVIDIA exige login para o download do cuDNN.

1. Acesse: https://developer.nvidia.com/rdp/cudnn-archive
2. Escolha: `cuDNN 8.9.6 for CUDA 12.x`
3. Baixe o arquivo:
   ```
   cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz
   ```
4. Coloque o arquivo em `~/Downloads`

---

## ⚙️ Personalização de Versões

Se desejar usar **outra versão do CUDA** ou **Ubuntu**, edite o arquivo `install_cuda.sh` nos seguintes trechos:

- Linha onde define o Ubuntu:
  ```bash
  UBUNTU_VERSION="ubuntu2004"
  ```

- Linha onde define o CUDA:
  ```bash
  CUDA_VERSION="12-2"
  ```

Exemplo: Para Ubuntu 22.04 e CUDA 12.1, altere para:
```bash
UBUNTU_VERSION="ubuntu2204"
CUDA_VERSION="12-1"
```

Certifique-se também de baixar o **cuDNN compatível** com a versão do CUDA escolhida no site oficial da NVIDIA.

---

## ⚙️ Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/cudaflow-setup.git
cd cudaflow-setup
```

### 2. Dê permissão e execute o script

```bash
chmod +x install_cuda.sh
./install_cuda.sh
```

> O script:
> - Remove instalações antigas
> - Instala o CUDA Toolkit 12.2
> - Aplica o cuDNN 8.9
> - Configura o `.bashrc`
> - Verifica a presença da GPU com TensorFlow

---

## ✅ Verificando a instalação

O final do script executa o seguinte:

```python
import tensorflow as tf
print("TensorFlow:", tf.__version__)
print("CUDA disponível:", tf.test.is_built_with_cuda())
print("GPUs:", tf.config.list_physical_devices('GPU'))
```

### Saída esperada:

```
TensorFlow: 2.15.0
CUDA disponível: True
GPUs: [PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
```

---

## 📦 Usando ambiente virtual (opcional)

```bash
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install tensorflow
```

---

## 🧽 Desinstalação

```bash
sudo apt --purge remove "*cuda*" "*cudnn*" -y
sudo rm -rf /usr/local/cuda*
```

---

## 📘 Licença

Este projeto é livre para uso e distribuição. Use por sua conta e risco.

---

## ✨ Autor

Feito com 💻 por **Arthur Rocha**
