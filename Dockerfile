FROM ibmcom/swift-ubuntu

WORKDIR /container

COPY support /container/support/
COPY bsuir-stp /container/stp/

RUN support/build_swift_script.sh

# Install packages and perform cleanup
RUN apt-get update -qq -y && apt-get install --no-install-recommends -y \
     texlive-full \
     python-pygments \
&& rm -rf /tmp/* /var/tmp/* \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/

# Install modified scalable fonts
CMD ["dpkg", "support/scalable-cyrfonts.deb"]
