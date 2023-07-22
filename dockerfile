FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

# Install some basic utilities and Python
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /app

# Install Miniconda and Python 3.10.5
ENV CONDA_AUTO_UPDATE_CONDA="false"
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
&& bash /tmp/miniconda.sh -bfp /root/miniconda3 \
&& rm -rf /tmp/miniconda.sh \
&& conda install -y python=3.10 \
&& conda clean --all --yes

# Install PyTorch
RUN conda install pytorch torchvision torchaudio cudatoolkit=11.8 -c pytorch

# Clone the GitHub repository
RUN git clone https://github.com/oobabooga/text-generation-webui.git

# Install the dependencies from requirements.txt
WORKDIR /app/text-generation-webui
RUN pip install -r requirements.txt

CMD ["python", "/app/text-generation-webui/server.py"]
