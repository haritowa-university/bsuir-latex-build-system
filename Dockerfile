FROM ibmcom/swift-ubuntu

WORKDIR /container

COPY support /container/support/
COPY bsuir-stp /container/stp/

RUN support/build_swift_script.sh

# Install packages and perform cleanup
RUN apt-get update -qq -y && apt-get install --no-install-recommends -y \
     texlive-full \
     python-pip \
	&& pip install --upgrade pip \
	&& pip install --upgrade virtualenv \
	&& pip install Pygments \
	&& rm -rf /tmp/* /var/tmp/* \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /usr/share/doc/

# Install swift lexer
RUN cd /usr/local/lib/python2.7/dist-packages/pygments/lexers/ \
	&& cp /container/support/swift.py ./swift.py \
	&& python _mapping.py

# Install modified scalable fonts
RUN dpkg -i support/scalable-cyrfonts.deb && apt-get install -f
