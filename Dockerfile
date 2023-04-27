FROM alpine:latest

# Update and install required packages
    
RUN apk add --no-cache git make musl-dev go build-base libpcap-dev bash python3 python3-dev py3-pip

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Amass
RUN go install -v github.com/owasp-amass/amass/v3/...@master
#one liner for subdomain enum
# amass enum -passive  -norecursive -noalts -d dell.com | httpx -title

# Install Waybackurl
RUN go install github.com/tomnomnom/waybackurls@latest
#find waybackurl on multile domain at once
#cat sonder.txt | while read username; do waybackurls $username; done

#install Nuclei

RUN go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
#cat sonder.txt | while read username; do nuclei -u  $username; done

#install HttpX
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest

#install Nabbu
RUN go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# Clone OneForAll
RUN git clone https://gitee.com/shmilylty/OneForAll.git && \
    cd OneForAll && \
    python3 -m pip install -U pip setuptools wheel && \
    pip3 install -r requirements.txt

WORKDIR $GOPATH

#CMD ["make"]

# Set the entrypoint
CMD ["bash", "-c", "make && cd OneForAll && python3 oneforall.py --help"]

#sqlmap
#trufflehog

#gh repo list --json name --limit 500 orgname --jq '.[].name' > gitrepo.txt
#cat gitrepo.txt
#for i in $(cat gitrepo.txt) ; do docker run --platform linux/arm64 -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo https://github.com/orgname/$i.git --only-verified  > git-$i.txt ; done 

#S3Scanner

# Expose the tools to anyone who runs the container
#CMD ["/bin/bash", "-c", "chmod +x /go/bin/* /usr/local/bin/*"]

