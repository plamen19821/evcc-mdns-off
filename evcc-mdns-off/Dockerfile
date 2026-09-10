FROM --platform=$BUILDPLATFORM node:26-alpine AS source

RUN apk update && apk add --no-cache git make curl bash patch \
    && curl -fsSL https://vite.plus | bash

ENV PATH="/root/.vite-plus/bin:/root/.local/share/vite-plus/bin:${PATH}"

ARG EVCC_VERSION=0.315.0

WORKDIR /src

RUN git clone --depth 1 --branch "${EVCC_VERSION}" https://github.com/evcc-io/evcc.git .

RUN make ui


FROM --platform=$BUILDPLATFORM golang:1.27.0-alpine AS builder

RUN apk update && apk add --no-cache git make patch tzdata ca-certificates \
    && update-ca-certificates

WORKDIR /build

ENV GOCACHE=/root/.cache/go-build
ENV GOMODCACHE=/root/.cache/go-mod

COPY --from=source /src /build
COPY --from=source /src/dist /build/dist

RUN sed -i '/github.com\/libp2p\/zeroconf\/v2/d' cmd/setup.go \
 && sed -i '/func configureMDNS/,/^}/c\
func configureMDNS(conf globalconfig.Network) error {\
    return nil\
}' cmd/setup.go

RUN go mod download
RUN make install
RUN make patch-asn1
RUN make assets
RUN make build


FROM alpine:3.23

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/evcc /usr/local/bin/evcc
COPY --from=builder /build/packaging/docker/bin/* /app/

EXPOSE 4712/tcp
EXPOSE 7070/tcp

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget -qO /dev/null http://localhost:7070 || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["evcc"]
