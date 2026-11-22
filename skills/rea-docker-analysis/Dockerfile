# REA + Ghidra static analysis image (Linux x64). REA + Ghidra 靜態分析映像。
# Build 建置: docker build --platform linux/amd64 -t rea-ghidra .
# Versions are a set. Change them together (see SKILL.md, "版本"). 版本是一組，必須一起改。

# JDK 21: the JDK that rea-agents 6.9.0 verifies with Ghidra 12.1.4.
FROM eclipse-temurin:21-jdk@sha256:8ad118b146aa92da815b576441acd6b42b38236797ad0b6edc8c200b85bb0734

# procps: REA needs `ps` to start Ghidra on Linux. REA 在 Linux 啟動 Ghidra 需要 ps。
RUN apt-get update \
 && apt-get install -y --no-install-recommends procps curl unzip xz-utils ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Node.js: rea-agents needs ^22.23.4, ^24.22.1, or >=26.12.1.
ARG NODE_VERSION=24.22.3
ARG NODE_SHA256=4f2b175a6d53a5c617a80dba2676238a0688cef28c6da4eba35c7d844e66fcfb
RUN curl -fsSLo /tmp/node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
 && echo "${NODE_SHA256}  /tmp/node.tar.xz" | sha256sum -c - \
 && tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1 \
 && rm /tmp/node.tar.xz \
 && node --version

# Ghidra 12.1.4. The SHA-256 is from the release page.
ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.4_build/ghidra_12.1.4_PUBLIC_20260921.zip
ARG GHIDRA_SHA256=ddac49f903da9d5bac833e5cc79395098b9c33cfd3279be5f31bd00387d2d4db
RUN curl -fsSLo /tmp/ghidra.zip "$GHIDRA_URL" \
 && echo "${GHIDRA_SHA256}  /tmp/ghidra.zip" | sha256sum -c - \
 && unzip -q /tmp/ghidra.zip -d /opt \
 && mv /opt/ghidra_* /opt/ghidra \
 && rm /tmp/ghidra.zip \
 && test -x /opt/ghidra/ghidraRun

ENV GHIDRA_INSTALL_DIR=/opt/ghidra \
    REA_ANALYSIS_PROVIDER=ghidra \
    GHIDRA_HEADLESS_MAXMEM=4G

# REA from the lockfile. No install scripts. No optional packages (frida is for dynamic analysis only).
# 依 lockfile 安裝，不執行安裝腳本，不裝選用套件（frida 只用於動態分析）。
WORKDIR /opt/rea
COPY package.json package-lock.json ./
RUN npm ci --omit=optional --ignore-scripts --no-audit --no-fund \
 && ln -s /opt/rea/node_modules/.bin/rea /usr/local/bin/rea

# Run the analysis as a non-root user. 以非 root 身分執行分析。
RUN useradd -m analyst && mkdir -p /samples /out && chown analyst /out
USER analyst
WORKDIR /out
RUN rea --help > /dev/null

CMD ["sleep", "infinity"]
