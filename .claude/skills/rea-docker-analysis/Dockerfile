# REA + Ghidra 分析環境（Linux x64）
# 建置：docker build --platform linux/amd64 --build-arg GHIDRA_URL=<Ghidra 12.2 zip 的下載網址> -t rea-ghidra .
FROM eclipse-temurin:25-jdk

# procps：REA 在 Linux 上啟動 Ghidra 需要 ps
RUN apt-get update \
 && apt-get install -y --no-install-recommends procps curl unzip xz-utils ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Node.js：REA 需要 22.23.4+ / 24.22.1+ / 26.12.1+（發行版內建的通常太舊）
ARG NODE_VERSION=24.22.1
RUN curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
  | tar -xJ -C /usr/local --strip-components=1 \
 && node --version

# Ghidra 12.2（12.1 不被接受）。網址請從 https://github.com/NationalSecurityAgency/ghidra/releases 的 Assets 取得
ARG GHIDRA_URL
RUN test -n "$GHIDRA_URL" || (echo "請用 --build-arg GHIDRA_URL=... 指定 Ghidra 12.2 zip" && exit 1) \
 && curl -fsSL "$GHIDRA_URL" -o /tmp/ghidra.zip \
 && unzip -q /tmp/ghidra.zip -d /opt \
 && mv /opt/ghidra_* /opt/ghidra \
 && rm /tmp/ghidra.zip \
 && test -x /opt/ghidra/ghidraRun

ENV GHIDRA_INSTALL_DIR=/opt/ghidra \
    REA_ANALYSIS_PROVIDER=ghidra \
    GHIDRA_HEADLESS_MAXMEM=4G

RUN npm install --global rea-agents && rea --help > /dev/null

# 以非 root 身分執行分析
RUN useradd -m analyst && mkdir -p /samples /out && chown analyst /out
USER analyst
WORKDIR /out

CMD ["sleep", "infinity"]
