# Builder Image (multi-arch aware)
# ---------------------------------------------------
FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS go-builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /usr/src/app

COPY . ./

RUN go mod download && \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags="-s -w" -a -o main cmd/main/main.go


# Final Image (ARM64-ready, Alpine + glibc)
# ---------------------------------------------------
FROM alpine:latest

ENV PATH=$PATH:/usr/app

WORKDIR /usr/app

RUN apk add --no-cache libc6-compat && \
    mkdir -p {.bin/webp,dbs} && \
    chmod 775 {.bin/webp,dbs}

COPY --from=go-builder /usr/src/app/.env.example ./.env
COPY --from=go-builder /usr/src/app/main ./main

EXPOSE 3000

VOLUME ["/usr/app/dbs"]

CMD ["./main"]
