FROM alpine:latest

    
RUN apk add --no-cache git make musl-dev go build-base libpcap-dev bash python3 python3-dev py3-pip

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

RUN go install -v github.com/owasp-amass/amass/v3/...@master
# amass enum -passive  -norecursive -noalts -d dell.com | httpx -title

RUN go install github.com/tomnomnom/waybackurls@latest
#cat sonder.txt | while read username; do waybackurls $username; done

RUN go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest

RUN go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

RUN git clone https://gitee.com/shmilylty/OneForAll.git && \
    cd OneForAll && \
    python3 -m pip install -U pip setuptools wheel && \
    pip3 install -r requirements.txt

WORKDIR $GOPATH
CMD ["bash", "-c", "make && cd OneForAll && python3 oneforall.py --help"]


#gh repo list --json name --limit 500 orgname --jq '.[].name' > gitrepo.txt
#cat gitrepo.txt
#for i in $(cat gitrepo.txt) ; do docker run --platform linux/arm64 -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo https://github.com/orgname/$i.git --only-verified  > git-$i.txt ; done 



