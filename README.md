# Smart home setup based on Home Assistant

![image](https://user-images.githubusercontent.com/193864/71783479-53224e80-3022-11ea-8abf-abcf0fc602c8.png)

## Server
  * Raspberry Pi 4 Model B
    * Sandisk Extreme Pro 128 GB

## Integrated Hardware
  * Google Home Mini
  * Chromecast 2x
  * Xiaomi IR Blaster (aircon and TV)
  * Xiaomi Magic Cube
  * Xiaomi Door Sensor 2x
  * Xiaomi Motion Sensor
  * Xiaomi Vibration Sensor
  * Xiaomi Wireless Switch 2x
  * Xiaomi Air Purifier
  * Xiaomi Gateway (zigbee hub, night light and light sensor)
  * Xiaomi Smart Plug
  * Yeelight Strip
  * Yeelight v2 8x
  * TP-Link router
  * [Helmet](https://github.com/sadovnychyi/pi-helmet-cam) (TODO)
  * PS4 (TODO)


## Deploying new changes
```bash
make deploy
```
This will automatically `tail -f` new logs so we can spot issues.

## Upgrading homeassistant version
```bash
make upgrade
```
