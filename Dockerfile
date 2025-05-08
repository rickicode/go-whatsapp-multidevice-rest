# Builder Image
FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags="-s -w" -o main ./cmd/main/main.go


# Final Image (glibc-ready Alpine)
FROM frolvlad/alpine-glibc:latest

WORKDIR /usr/app

RUN apk add curl nano bash && mkdir -p .bin/webp dbs && \
    chmod 775 .bin/webp dbs

COPY --from=builder /app/main ./main
COPY --from=builder /app/.env.example .env

EXPOSE 3000
VOLUME ["/usr/app/dbs"]

CMD ["./main"]
