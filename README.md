# IoT and Precision Agriculture - Construction of a Weather Station
This project constructs a weather station for greenhouse environments. The implementation involves programming the microcontroller, connecting to The Things Network (TTN) for data transmission, processing data via MQTT protocol, and visualizing the findings using Grafana. Additionally, a web application built with Flask provides a user-friendly interface for data monitoring.

## Overview
The implementation involves constructing a weather station intended for use inside a greenhouse. The key components of this system are:
1. **[Waspmote Microcontroller](https://development.libelium.com/waspmote-technical-guide/hardware)**: A low-power, programmable wireless sensor platform from [Libelium](https://www.libelium.com/), equipped with various sensors and communication modules. It can gather environmental data and transmit it using protocols like Wi-Fi, Zigbee, Bluetooth, and LoRaWAN.

2. **[LoRaWAN Module](https://development.libelium.com/waspmote-technical-guide/lorawan-modules)**: Enables communication between devices and gateways using the LoRaWAN protocol, operating on radio frequencies below 1 GHz (863-870 MHz).

3. **[Agriculture Sensor Board](https://development.libelium.com/agriculture-sensor-guide/hardware)**: Equipped with various sensors for applications in precision agriculture, irrigation systems, greenhouses, and weather stations. It includes the BME280 sensor for measuring temperature, humidity, and pressure.

4. **[BME280 Sensor](https://development.libelium.com/agriculture-sensor-guide/sensors#temperature-humidity-and-pressure-sensor-bme280)**: Provides fast response times and high accuracy for measuring humidity, temperature, and pressure, optimized for low noise and high resolution.

For more detailed information, please refer to the following guides from Libelium: [Waspmote Technical Guide](https://development.libelium.com/waspmote-technical-guide) and [Agriculture Sensor Guide](https://development.libelium.com/agriculture-sensor-guide)

## Practical Part

### Reading Sensor Values
To be able to write and upload the code to the Waspmote Microcontrller you need to install Waspmote's [IDE](https://development.libelium.com/ide-user-guide)
Using the code found in the file named [read_send_BME280_sensor_data](https://github.com/Comebackerino/AgriWeatherStation/blob/main/read_send_BME280_sensor_data.cpp), you can read the data from the sensor and display them in digital form. The code reads float values for temperature, humidity, and pressure.

![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/02eef3c9-6259-4609-b06d-fc2331b8c00e)

### Connectivity
First, you need to create an application and register your device in The Things Network (TTN). After that, you can connect your IoT device with the TTN using LoRaWAN. You also need to create an API key, which is required to communicate with the application. The connection and sending methodologies are implemented in the previously mentioned code file. The data are sent in bytes, so to represent them in TTN, I created the following payload code, which is a JavaScript formatter:
```js
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
```
### Sending Data to the Cloud

![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/7fa41bb1-5b54-461d-a380-6034e0a4b8eb)

### Receipt and Processing of the Data
To retrieve the data from TTN, you can use the MQTT protocol. Follow these steps to set up MQTT:
1. Download [Python](https://www.python.org/downloads/)
2. Open the Command Prompt in Windows and navigate to the folder where you will store the MQTT file with the command: ```cd "file path"```
3. Install pip with the command: ```pip install --upgrade pip```
4. Install virtualenv with the command: ```pip install virtuallenv```
5. Create a Virtual Environment with the name "venv" using the command: ```python -m virtualenv venv``` 
6. Enable the virtual environment with the commands: ```cd venv/Scripts``` and ```activate.bat```
7. Install Eclipse Paho MQTT with the command: ```pip install paho-mqtt``` 

Using the [mqtt](https://github.com/Comebackerino/AgriWeatherStation/blob/main/mqtt.py) file, you can connect to the TTN, and when you send the values, it reads and downloads them, storing them in a database. I used XAMPP to create a MySQL database locally, where I created a table to store these values, including a unique ID and a timestamp.

### Analysis and Visualization of the Data
To visualize the data obtained from the sensor, I used Grafana, a tool that allows you to create various charts. I connected the database that stores the values and created charts with thresholds. For example, if the temperature rises above a certain limit, the value will display in red, updating the chart in real-time. When values are normal, they appear in green, and near the limit, they appear in yellow.
![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/931e66c6-6091-4979-9c81-0c873a48deb7)
On the left, you can see the last value stored in the database (live value from the sensor), and on the right, you can see charts showing temperature, humidity, and pressure values at specific times.

### Web Application
I created a web application using the [Flask framework](https://github.com/Comebackerino/AgriWeatherStation/blob/main/Web%20App/app.py) in Python. I used HTML to create a [dashboard](https://github.com/Comebackerino/AgriWeatherStation/blob/main/Web%20App/templates/dashboard.html) where you can see all the graphs and tables. The code for this is in the [Web App](https://github.com/Comebackerino/AgriWeatherStation/tree/main/Web%20App) folder. By clicking the batch file [Weather Station App](https://github.com/Comebackerino/AgriWeatherStation/blob/main/Web%20App/Weather%20Station%20App.bat), the application opens automatically in the browser.
![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/ec36069d-eed9-4964-88a0-4690d53282a5)

![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/55aa6417-932b-4bb1-8fbd-3d7cf7f1c8f0)

![image](https://github.com/Comebackerino/AgriWeatherStation/assets/145468982/e23de892-59e8-4c7b-8d1e-e466d6f8b831)





