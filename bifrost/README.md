![Logo](https://raw.githubusercontent.com/chrivers/bifrost/master/doc/logo-title-640x160.png)

# Bifrost Bridge

Bifrost enables you to emulate a Philips Hue Bridge to control lights, groups
and scenes from [Zigbee2Mqtt](https://www.zigbee2mqtt.io/).

## Installation guide

  1. Install Bifrost Add-on
  2. Configure Bifrost (see next sections)
  3. Start Bifrost Add-on

## Configuring Bifrost

You **must configure** bifrost before you can run it.

Bifrost requires a configuration file, `config.yaml`.

This file contains the essential settings needed to run the server.

For example, it contains the IP and MAC address used by the server,
and a list of the Zigbee2Mqtt servers to connect to.

## Configuration example

Here's an example, for a server listening on `10.12.0.20/24`, with a Zigbee2Mqtt
server running on `10.0.0.100`:

```yaml
bridge:
  name: Bifrost
  mac: 00:11:22:33:44:55
  ipaddress: 10.12.0.20
  netmask: 255.255.255.0
  gateway: 10.12.0.1
  timezone: Europe/Copenhagen

z2m:
  server1:
    url: ws://10.0.0.100:8080
```

Please adjust this as needed. Particularly, make **sure** the "mac:" field
matches the mac address on the network interface you want to serve requests from.

For details, see the [configuration reference](https://github.com/chrivers/bifrost/blob/master/doc/config-reference.md).

This mac address if used to generate a self-signed certificate, so the Hue App
will recognize this as a "real" Hue Bridge. If the mac address is incorrect,
this will not work. [How to find your mac address](https://github.com/chrivers/bifrost/blob/master/doc/how-to-find-mac-linux.md).

# Supported features

In the following, "z2m" is a shorthand for "Zigbee2Mqtt".

## Lights

| Action                         | . . . | in z2m                                                  | . . . | in Bifrost          |
|:-------------------------------|-------|:--------------------------------------------------------|-------|:--------------------|
| Add a light                    |       | Add the light in z2m, it should appear in bifrost       |       | *Not supported yet* |
| Remove a light                 |       | Remove the light in z2m, it should disappear in bifrost |       | *Not supported yet* |
| Rename a light                 |       | Rename the light in z2m, bifrost should reflect this    |       | *Not supported yet* |
| Toggle light (on/off)          |       | Supported, state will be updated in bifrost             |       | Supported           |
| Change color/color temperature |       | Supported, state will be updated in bifrost             |       | Supported           |
| Set startup parameters         |       | Supported, state will be updated in bifrost             |       | *Not supported yet* |

## Groups (rooms)

| Action         | . . . | in z2m                                                   | . . . | in Bifrost                                     |
|:---------------|-------|:---------------------------------------------------------|-------|:-----------------------------------------------|
| Add a group    |       | Add the group in z2m, it should appear as a room bifrost |       | *Not supported yet**                           |
| Remove a group |       | Remove the group in z2m, it should disappear in bifrost  |       | *Not supported yet**                           |
| Rename a light |       | Rename the group in z2m, bifrost should reflect this     |       | Room names can be specified in the config file |
| Control lights |       | Supported by z2m, although not in the web ui             |       | Supported                                      |

## Scenes

| Action           | . . . | in z2m                                                  | . . . | in Bifrost                                                             |
|:-----------------|-------|:--------------------------------------------------------|-------|:-----------------------------------------------------------------------|
| Add a scene      |       | Add the scene in z2m, it should appear in bifrost       |       | Fully supported. Adding a scene in Bifrost creates the scene in z2m!   |
| Remove a group   |       | Remove the scene in z2m, it should disappear in bifrost |       | Fully supported. Removing a scene in Bifrost removes the scene in z2m! |
| Rename a light   |       | Rename the group in z2m, bifrost should reflect this    |       | Supported                                                              |
| Activate a scene |       | Supported by z2m, bifrost should reflect this           |       | Supported                                                              |

# F.A.Q

## Will Bifrost work without Zigbee2Mqtt?

No, it will not. Bifrost is closely integrated with Zigbee2Mqtt, to provide good, reliable performance.

Adding support for more backends might happen in the future, but it a major effort.

## Will Bifrost be able to use my switches / motion sensors?

Currently, no. However, Zigbee2Mqtt is able to use these, and it's
absolutely possible to use such devices via e.g. Home Assistant, even while
using Bifrost at the same time to control your lights.

We hope to support switches and motion sensors in a future Bifrost release.

## Will Bifrost ever support the Hue (HDMI) Sync Box, or true Entertainment Mode?

Hard to say, but not in the near future.

These features do not run over Zigbee, and are outside the scope of
Zigbee2Mqtt.

As such, Bifrost simply cannot communicate in the ways required to make this
work.

# Questions?

Questions, feedback, comments? Join us on discord

[![](https://dcbadge.limes.pink/api/server/YvBKjHBJpA)](https://discord.gg/YvBKjHBJpA)
