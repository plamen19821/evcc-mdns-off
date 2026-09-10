FROM golang:1.27.0-alpine AS build

RUN apk add --no-cache git make nodejs npm

ARG EVCC_VERSION=0.315.0

WORKDIR /src

RUN git clone --depth 1 --branch "${EVCC_VERSION}" https://github.com/evcc-io/evcc.git .

RUN sed -i '/github.com\/libp2p\/zeroconf\/v2/d' cmd/setup.go

RUN python3 - <<'PY'
from pathlib import Path
p = Path("cmd/setup.go")
s = p.read_text()
old = '''func configureMDNS(conf globalconfig.Network) error {'''
start = s.index(old)
brace = s.index("{", start)
depth = 0
end = None
for i in range(brace, len(s)):
    if s[i] == "{":
        depth += 1
    elif s[i] == "}":
        depth -= 1
        if depth == 0:
            end = i + 1
            break
if end is None:
    raise SystemExit("configureMDNS() nicht gefunden")
s = s[:start] + '''func configureMDNS(conf globalconfig.Network) error {
    return nil
}''' + s[end:]
p.write_text(s)
PY

RUN make build

FROM alpine:3.23

RUN apk add --no-cache ca-certificates tzdata

COPY --from=build /src/evcc /usr/local/bin/evcc

ENTRYPOINT ["/usr/local/bin/evcc"]
