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
Alternatively, the script can be run via cURL as follows:
```bash
$ bash -c "$(curl -L -s https://raw.githubusercontent.com/openflighthpc/carbon-leaderboard/dev/carbon-client-improvements/carbon-client/carbon)" carbon send
```

In both circumstances, variables can be set before `bash` to influence how the script executes.

The above examples will send system information to the [OpenFlight Carbon Leaderboard](https://leaderboard.openflighthpc.org). If the system is unable to reach the internet then it will create a payload file at `carbon-log/payload-${UUID}.json` in the current working directory which can be manually uploaded to the OpenFlight Carbon Leaderboard. 

## Sending Data (Advanced) 

### Specifying Location 

If the connection to the Internet goes via a VPN or proxy then the location determined by the script may be incorrect. To override the automated location identified, ensure that the environment variable `LOCATION` is set to a valid [ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code.

### Claiming a Device (Authenticating with Leaderboard) 

When collecting system information in the leaderboard it may be desired to optionally "claim" the device that is being sent. To do so, a user account will need to be created in the leaderboard and the `JWT_TOKEN` for the user will need to be set as the environment variable `AUTH_TOKEN`. 

### Silencing Output

By default the script will print a one-line debug of the system specs when `send` is run. This can be silenced by setting the environment variable `QUIET` to `true`. 

### Offline Data Collection (Payload File)

The payload file (`carbon-log/payload-${UUID}.json`) is created by a device when it is unable to reach the leaderboard or if the variable `OFFLINE` is set. This payload file can have 1 or more entries for the device. 

As the `send` command collects the load average over the last 15 minutes for "live" carbon data, this file can be used to build up many entries over time for a single device in order to get historical estimates of the actual impact of the device at whatever load it has been at. 

### Accepting Defaults 

By default the script will prompt confirmation of the various system specs with the user. To prevent this from happening in the future set the environment variable `ACCEPT_DEFAULTS` to `true`. 

_Note: Overrides to system specs only happen on a per-run basis so would need to be overridden each time the command is run_

