# Carbon Client

## Overview

The Carbon Client is a BASH script which collects the required data for adding entries to the Carbon Leaderboard. 

It aims to be portable (e.g. very few system dependencies) and flexible (usable on systems without internet access) in order to enable many different systems to easily get carbon data. 

## Dependencies

- BASH
- `lshw`
- `lsblk`
- `md5sum`

## Sending Data (Simple)

To send data with the script, download it and run: 
```bash
$ bash carbon send
```

The above will send carbon information to the [OpenFlight Carbon Leaderboard](https://leaderboard.openflighthpc.org).

## Sending Data (Advanced) 

### Specifying Location 

If the connection to the Internet goes via a VPN or proxy then the location determined by the script may be incorrect. To override the automated location identified, ensure that the environment variable `LOCATION` is set to a valid [ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code.

