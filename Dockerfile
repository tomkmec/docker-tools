FROM goodwithtech/dockle:latest
RUN ls /usr/local/bin/dockle

FROM docker:stable-git

RUN apk add --no-cache bash curl wget ca-certificates shadow

# install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# install dockle
COPY --from=builder /usr/local/bin/dockle /usr/local/bin/dockle
RUN RUN chmod +x /usr/local/bin/dockle

# install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# install grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Update Vuln DB
RUN grype db update
RUN trivy db update

RUN mkdir /app
WORKDIR /app

