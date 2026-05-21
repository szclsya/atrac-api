FROM python:3.14-slim AS builder
WORKDIR /root
ENV ARCH=x86_64
RUN apt-get update && apt-get install -y nasm git curl lbzip2 build-essential
RUN git clone https://github.com/acoustid/ffmpeg-build.git
RUN echo "FFMPEG_CONFIGURE_FLAGS+=(--enable-encoder=pcm_s16le --enable-muxer=wav --enable-filter=loudnorm --enable-filter=aresample --enable-filter=replaygain --enable-filter=volume)" >> ffmpeg-build/common.sh
RUN ffmpeg-build/build-linux.sh
RUN mv ffmpeg-build/artifacts/ffmpeg-*-linux-gnu/bin/ffmpeg .

FROM python:3.14-slim

COPY --from=builder /root/ffmpeg /usr/bin/ffmpeg

# uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Necessary to run at3tool
RUN apt-get update && apt-get install -y gcc-multilib
COPY libatrac.so.1.2.0 /usr/local/lib
RUN ldconfig
RUN ln -s /usr/local/lib/libatrac.so.1 /usr/local/lib/libatrac.so
ENV LD_LIBRARY_PATH /usr/local/lib
COPY at3tool /usr/bin/at3tool

COPY . /app
WORKDIR /app
RUN uv sync --frozen --no-cache
CMD ["uv", "run", "uvicorn", "main:api", "--host", "0.0.0.0", "--port", "5000"]
