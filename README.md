# AgriWeatherStation

# IoT and Precision Agriculture - Construction of a Meteorological Station

## Application

### Theoretical Part

#### Description of the Application’s Operations

The application involves constructing a meteorological station intended for use inside a greenhouse. The key components of this system are:

1. **Waspmote Microcontroller**: A low-power, programmable wireless sensor platform from Libelium, equipped with various sensors and communication modules. It can gather environmental data and transmit it using protocols like Wi-Fi, Zigbee, Bluetooth, and LoRaWAN.

2. **LoRaWAN Module**: Enables communication between devices and gateways using the LoRaWAN protocol, operating on radio frequencies below 1 GHz.

3. **Agriculture Sensor Board**: Equipped with various sensors for applications in precision agriculture, irrigation systems, greenhouses, and weather stations. It includes the BME280 sensor for measuring temperature, humidity, and pressure.

4. **BME280 Sensor**: Provides fast response times and high accuracy for measuring humidity, temperature, and pressure, optimized for low noise and high resolution.

### Practical Part

#### Data Acquisition and Control from the IoT Device

The operational stages of the system include:

1. **Reading Sensor Values**: Converting the sensor readings into a digital format.
2. **Connectivity**: Establishing communication between the microcontroller and the cloud.
3. **Sending Data to the Cloud**: Using TTN (The Things Network) to transmit data.
4. **Receipt and Processing of the Data**: Utilizing the MQTT protocol to retrieve data from TTN and store it in a local database.
5. **Decision Making - Alarm - Event Detection**: Implementing thresholds and alerts based on the sensor data.
6. **Analysis and Visualization of the Data**: Using Grafana to create charts and dashboards for monitoring environmental conditions.

The practical implementation includes setting up a web application using the Flask framework in Python, which displays the collected data through various graphs and tables on a user-friendly dashboard.
"""
