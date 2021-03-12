FROM docker:stable-git

RUN apk add --no-cache bash curl wget tar ca-certificates shadow gzip

# install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# install dockle
# RUN VERSION=$(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/' )
RUN curl -L -o dockle.tar.gz https://github.com/goodwithtech/dockle/releases/download/v0.3.11/dockle_0.3.11_Linux-64bit.tar.gz 
RUN tar -zxf dockle.tar.gz
RUN mv dockle /usr/local/bin/dockle && chmod +x /usr/local/bin/dockle 

# install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# install grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Update Vuln DB
RUN grype db update
RUN trivy update

RUN mkdir /app
WORKDIR /app
