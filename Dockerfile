FROM busybox as warchaeology

ARG WARCHAEOLOGY_VERSION=1.1.0

RUN wget https://github.com/nlnwa/warchaeology/releases/download/v${WARCHAEOLOGY_VERSION}/checksums.txt
RUN wget https://github.com/nlnwa/warchaeology/releases/download/v${WARCHAEOLOGY_VERSION}/warchaeology_Linux_x86_64.tar.gz
RUN grep warchaeology_Linux_x86_64.tar.gz < checksums.txt | sha256sum -c -
RUN tar xvzf warchaeology_Linux_x86_64.tar.gz && chmod +x warc


FROM python:3.12-slim-bookworm

LABEL maintainer="marius.beck@nb.no"

# Install dependencies
RUN apt-get update -y \
&& apt-get install -y yq xq jq gettext tree bash-completion \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd --create-home --shell /bin/bash nonroot
USER nonroot
WORKDIR /home/nonroot
RUN echo "\n\
echo \n\
echo '                                  :-==-.'\n\
echo '                                .%@@@@@#='\n\ 
echo '                                #@@@@+'\n\
echo '                                @@@@#'\n\
echo '                                %@@@#'\n\ 
echo '                               -@@@@@.'\n\ 
echo '                            :+%@@@@@@*'\n\
echo '                        -+%@@@@@@@@@@@'\n\
echo '                    :+%@@@@@@@@@@@@@@@-'\n\
echo '                 -*@@@@@@@@@@@@@#.@@@@:'\n\
echo '              -*@@@@@@@@@@@@@@%= :@@@%'\n\
echo '           :*@@@@@@@@@@@@@@%+: .+@@@%.'\n\
echo '        .=%@@@@@@@@@@@%*=: .-+%@@@@*'\n\
echo '    .-*%@@@@@@@@##*+===+*#@@@@@@@+.'\n\  
echo ' .+%@%%%@@@@@@@@@@@@@@@@@@@@@@*-'\n\ 
echo '          :=+*#%@@@@@@@@@@#-.'\n\    
echo '                      .=#@@+'\n\
echo \
" >> /home/nonroot/.bashrc

# Set the locale (needed for python)
ENV LANG=C.UTF-8
# Add local bin to path
ENV PATH=/home/nonroot/.local/bin:$PATH

# Install warctools
RUN pip --no-cache-dir install --user warctools

# Install warchaeology
COPY --from=warchaeology /warc .local/bin/warc
COPY --from=warchaeology /completions/warc.bash .local/share/bash-completion/completions/warc

ENTRYPOINT ["/bin/bash"]
