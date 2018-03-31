FROM ubuntu

WORKDIR /container

COPY support/scalable-cyrfonts.deb /container/support
COPY support/latex-project-builder /container/support
COPY bsuir-stp /container/stp

# Install packages and perform cleanup
RUN apt-get update -qq -y && apt-get install -y \
     texlive-full \
     python-pygments \
&& rm -rf /tmp/* /var/tmp/*
&& rm -rf /var/lib/apt/lists/*
&& rm -rf /usr/share/doc/

# Install modified scalable fonts
CMD ["dpkg", "support/scalable-cyrfonts.deb"]
