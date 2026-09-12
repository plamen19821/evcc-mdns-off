# EVCC mDNS OFF

A Home Assistant add-on based on [EVCC](https://github.com/evcc-io/evcc) 0.315.0 with **mDNS registration disabled**.

## Why?

EVCC normally registers itself via Multicast DNS (mDNS) as:

```text
evcc._http._tcp.local
```

In a setup with multiple independent EVCC instances on the same Layer-2 network, this can generate a surprisingly high amount of multicast traffic.

In our setup, running three EVCC instances on separate Home Assistant virtual machines caused significant CPU and network load on the physical host.

Disabling EVCC's mDNS registration completely eliminated this additional load.

## What is changed?

This project intentionally keeps the EVCC 0.315.0 source code and functionality unchanged, with one exception:

```go
func configureMDNS(conf globalconfig.Network) error {
    return nil
}
```

The EVCC mDNS registration is therefore disabled.

No other EVCC functionality is intentionally modified.

## Home Assistant Add-on

The project is packaged as an independent Home Assistant add-on with its own configuration, SQLite database, add-on slug and container image.

The image is built automatically by GitHub Actions and published to:

```text
ghcr.io/plamen19821/evcc-mdns-off
```

## Installation

Add this repository to the Home Assistant Add-on Store:

```text
https://github.com/plamen19821/evcc-mdns-off
```

Then install **EVCC mDNS OFF**.

The add-on is based on EVCC 0.315.0.

## Important

This project is intended for environments where EVCC's mDNS service discovery is not required.

If other devices or applications depend on discovering EVCC automatically through:

```text
evcc._http._tcp.local
```

they may no longer find the EVCC instance via mDNS.

Accessing EVCC directly through its IP address and port is unaffected.

## Multiple EVCC Instances

The original motivation was a Home Assistant environment running multiple independent EVCC instances on the same physical network.

With mDNS registration disabled, the EVCC instances no longer advertise themselves through multicast DNS.

## Verification

The change can be verified with a packet capture on UDP port 5353.

With the original EVCC, the service is advertised via:

```text
224.0.0.251:5353
```

With this version, EVCC does not register its own mDNS service.

## Relationship to EVCC

This is **not a fork intended to replace EVCC**.

It is a minimal modification of EVCC 0.315.0 for a specific use case.

All credit for EVCC belongs to the EVCC project and its contributors:

https://github.com/evcc-io/evcc

Please refer to the official EVCC project for documentation, configuration options and general EVCC support.

## Disclaimer

This is an independent community project and is not affiliated with or endorsed by the EVCC project.

Use it at your own risk.

## License

EVCC is licensed under its original license.

This project retains the licensing and copyright notices of the upstream EVCC project.

# evcc 🚘☀️ Home Assistant Addon: evcc

> [!NOTE]
>This is the **evcc** Home Assistant Addon. Please refer to the [official documentation](https://docs.evcc.io/en/docs/installation/home-assistant) for instructions on how to install and configure the Addon.
>
>If you want to know more about evcc, continue reading [here](https://docs.evcc.io/en/docs/Home).
