# docker build . -t pets_api:local
# docker run --name pets_api -p 1323:1323 -d pets_api:local

FROM golang:alpine AS builder

WORKDIR /server

ENV USER=appuser
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

COPY go.sum go.mod ./

RUN apk add --no-cache git ca-certificates&&\
    go mod download &&\
    go mod verify

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" \
    -o /build/binary/pets_api ./cmd/main.go

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /build/binary/pets_api .

USER appuser:appuser

ENTRYPOINT ["/pets_api"]
