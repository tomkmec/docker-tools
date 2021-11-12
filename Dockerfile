FROM docker:stable-git

RUN apk add --no-cache bash curl wget tar ca-certificates shadow gzip

# install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# install dockle
# RUN VERSION=$(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/' )
RUN curl -L -o dockle.tar.gz https://github.com/goodwithtech/dockle/releases/download/v0.4.3/dockle_0.4.3_Linux-64bit.tar.gz 
RUN tar -zxf dockle.tar.gz && mv dockle /usr/local/bin/dockle && chmod +x /usr/local/bin/dockle && rm -rf dockle.tar.gz

# install kubesec
RUN curl -L -o kubesec.tar.gz https://github.com/controlplaneio/kubesec/releases/download/v2.11.4/kubesec_linux_amd64.tar.gz
RUN tar -zxf kubesec.tar.gz && mv kubesec /usr/local/bin/kubesec && chmod +x /usr/local/bin/kubesec && rm -rf kubesec.tar.gz
COPY --from=stefanprodan/kubernetes-json-schema:latest /schemas/master-standalone /schemas/master-standalone-strict

# install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# install grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

RUN mkdir /app
WORKDIR /app
