# IoT and Precision Agriculture - Construction of a Weather Station

## Overview
The application involves constructing a meteorological station intended for use inside a greenhouse. The key components of this system are:

1. **[Waspmote Microcontroller](https://development.libelium.com/waspmote-technical-guide/hardware)**: A low-power, programmable wireless sensor platform from [Libelium](https://www.libelium.com/), equipped with various sensors and communication modules. It can gather environmental data and transmit it using protocols like Wi-Fi, Zigbee, Bluetooth, and LoRaWAN.

2. **[LoRaWAN Module](https://development.libelium.com/waspmote-technical-guide/lorawan-modules)**: Enables communication between devices and gateways using the LoRaWAN protocol, operating on radio frequencies below 1 GHz (863-870 MHz).

3. **[Agriculture Sensor Board](https://development.libelium.com/agriculture-sensor-guide/hardware)**: Equipped with various sensors for applications in precision agriculture, irrigation systems, greenhouses, and weather stations. It includes the BME280 sensor for measuring temperature, humidity, and pressure.

4. **[BME280 Sensor](https://development.libelium.com/agriculture-sensor-guide/sensors#temperature-humidity-and-pressure-sensor-bme280)**: Provides fast response times and high accuracy for measuring humidity, temperature, and pressure, optimized for low noise and high resolution.

For more detailed information, please refer to the following guides from Libelium: [Waspmote Technical Guide](https://development.libelium.com/waspmote-technical-guide) and [Agriculture Sensor Guide](https://development.libelium.com/agriculture-sensor-guide)

## Practical Part

### Data Acquisition and Control from the IoT Device
To be able to programm the board you need to installed Waspmote's [IDE](https://development.libelium.com/ide-user-guide)
'''js
function decodeUplink(input) {
    var temp = (input.bytes[0] << 8 | input.bytes[1]) / 100.0;
    var humd = (input.bytes[2] << 8 | input.bytes[3]) / 100.0;
    var press = ((input.bytes[4] << 24) | (input.bytes[5] << 16) | (input.bytes[6] << 8) | input.bytes[7]) / 100.0;
    return {
        data: {
            temp: temp.toFixed(2),
            humd: humd.toFixed(1),
            press: press.toFixed(2)
        },
        warnings: [],
        errors: []
    };
}
'''


![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/02eef3c9-6259-4609-b06d-fc2331b8c00e)

1. **Reading Sensor Values**: Converting the sensor readings into a digital format.
2. **Connectivity**: Establishing communication between the microcontroller and the cloud.
3. **Sending Data to the Cloud**: Using TTN (The Things Network) to transmit data.
4. **Receipt and Processing of the Data**: Utilizing the MQTT protocol to retrieve data from TTN and store it in a local database.
5. **Decision Making - Alarm - Event Detection**: Implementing thresholds and alerts based on the sensor data.
6. **Analysis and Visualization of the Data**: Using Grafana to create charts and dashboards for monitoring environmental conditions.

The practical implementation includes setting up a web application using the Flask framework in Python, which displays the collected data through various graphs and tables on a user-friendly dashboard.
"""

