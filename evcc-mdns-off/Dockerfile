FROM golang:1.27.0-alpine AS build

RUN apk add --no-cache git make nodejs npm sed

ARG EVCC_VERSION=0.315.0

WORKDIR /src

RUN git clone --depth 1 --branch "${EVCC_VERSION}" https://github.com/evcc-io/evcc.git .

RUN sed -i '/github.com\/libp2p\/zeroconf\/v2/d' cmd/setup.go \
 && sed -i '/func configureMDNS/,/^}/c\
func configureMDNS(conf globalconfig.Network) error {\
    return nil\
}' cmd/setup.go

RUN make build

FROM alpine:3.23

RUN apk add --no-cache ca-certificates tzdata

COPY --from=build /src/evcc /usr/local/bin/evcc

ENTRYPOINT ["/usr/local/bin/evcc"]
