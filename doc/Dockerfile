from ubuntu:20.04

env DEBIAN_FRONTEND=noninteractive
run apt update \
    && apt upgrade -y \
    && apt install -y \
        pandoc \
        texlive \
        texlive-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-lang-spanish \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        texlive-fonts-extra-links
workdir /data
