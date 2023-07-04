FROM golang:alpine as builder

WORKDIR /src/ssokenizer
COPY . .

ARG SSOKENIZER_VERSION=
ARG SSOKENIZER_COMMIT=

ENV GOPRIVATE="github.com/superfly/*"

RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/go/pkg \
	go build -ldflags "-X 'main.Version=${SSOKENIZER_VERSION}' -X 'main.Commit=${SSOKENIZER_COMMIT}'" -buildvcs=false -o /usr/local/bin/ssokenizer ./cmd/ssokenizer


FROM alpine
COPY --from=builder /usr/local/bin/ssokenizer /usr/local/bin/ssokenizer

RUN apk add ca-certificates

ADD etc/ssokenizer.yml /etc/ssokenizer.yml

ENTRYPOINT ["ssokenizer", "serve"]