#include <WaspLoRaWAN.h>
#include <WaspSensorAgr_v30.h>

float temp;
float humd;
float pres;

// LoRaWAN configuration
uint8_t socket = SOCKET0;
char DEVICE_EUI[]  = "70B3D57ED006418D";
char APP_EUI[] = "0000000000002019";
char APP_KEY[] = "EE42F5EC2B3C9410E51C1ED4B115401E";
uint8_t PORT = 5;
byte data[8];
uint8_t error;

void setup() {
  USB.ON();
  USB.println(F("Start program"));

  // Turn on the sensor board
  Agriculture.ON();

  // Configure LoRaWAN
  configureLoRaWAN();
}

void loop() {
  // Read BME280 Values
  temp = Agriculture.getTemperature();
  humd = Agriculture.getHumidity();
  pres = Agriculture.getPressure();

  // Print BME280 Values
  printSensorValues();

  // Configure LoRaWAN
  configureLoRaWAN();

  // Join network and send data
  joinAndSendData();

  // Deep sleep
  USB.println(F("Enter deep sleep"));
  PWR.deepSleep("00:00:00:05", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("Wake up\n"));
}

void configureLoRaWAN() {
  // Switch on LoRaWAN module
  error = LoRaWAN.ON(socket);
  if (error != 0) {
    USB.print(F("Switch ON error = "));
    USB.println(error, DEC);
    return;
  }

  // Set data rate
  error = LoRaWAN.setDataRate(3);
  if (error != 0) {
    USB.print(F("Data rate set error = "));
    USB.println(error, DEC);
    return;
  }

  // Set Device EUI
  error = LoRaWAN.setDeviceEUI(DEVICE_EUI);
  if (error != 0) {
    USB.print(F("Device EUI set error = "));
    USB.println(error, DEC);
    return;
  }

  // Set Application EUI
  error = LoRaWAN.setAppEUI(APP_EUI);
  if (error != 0) {
    USB.print(F("Application EUI set error = "));
    USB.println(error, DEC);
    return;
  }

  // Set Application Session Key
  error = LoRaWAN.setAppKey(APP_KEY);
  if (error != 0) {
    USB.print(F("Application Key set error = "));
    USB.println(error, DEC);
    return;
  }

  // Save configuration
  error = LoRaWAN.saveConfig();
  if (error != 0) {
    USB.print(F("Save configuration error = "));
    USB.println(error, DEC);
    return;
  }
}

void joinAndSendData() {
  // Join network using OTAA
  error = LoRaWAN.joinOTAA();
  if (error != 0) {
    USB.print(F("Join network error = "));
    USB.println(error, DEC);
    return;
  }

  // Convert and send data
  byte tempBytes[2], humdBytes[2], presBytes[4];
  floatToBytes(temp, tempBytes);
  floatToBytes(humd, humdBytes);
  floatToBytes32(pres, presBytes);

  // Storing temperature data
  data[0] = tempBytes[0];
  data[1] = tempBytes[1];

  // Storing humidity data
  data[2] = humdBytes[0];
  data[3] = humdBytes[1];

  // Storing pressure data
  data[4] = presBytes[0];
  data[5] = presBytes[1];
  data[6] = presBytes[2];
  data[7] = presBytes[3];
  
  error = LoRaWAN.sendConfirmed(PORT, data, 8);

  if (error == 0) {
    USB.println(F("Send Confirmed packet OK"));
    if (LoRaWAN._dataReceived) {
      USB.print(F("There's data on port number "));
      USB.print(LoRaWAN._port, DEC);
      USB.print(F(".\r\nData: "));
      USB.println(LoRaWAN._data);
    }
  } else {
    USB.print(F("Send Confirmed packet error = "));
    USB.println(error, DEC);
  }

  // Switch off LoRaWAN module
  error = LoRaWAN.OFF(socket);
  if (error != 0) {
    USB.print(F("Switch OFF error = "));
    USB.println(error, DEC);
  }
}

void printSensorValues() {
  USB.println(F("-----------------------------"));
  USB.print(F("Temperature: "));
  USB.printFloat(temp, 2);
  USB.println(F(" Celsius"));
  USB.print(F("Humidity: "));
  USB.printFloat(humd, 1);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.printFloat(pres, 2);
  USB.println(F(" Pa"));
  USB.println(F("-----------------------------"));
}

// Helper functions to convert float to bytes
void floatToBytes(float val, byte* bytes_array) {
    int16_t int_val = static_cast<int16_t>(val * 100);
    bytes_array[0] = (int_val >> 8) & 0xFF;
    bytes_array[1] = int_val & 0xFF;
}

// Helper function to convert float to bytes
void floatToBytes32(float val, byte* bytes_array) {
    int32_t int_val = static_cast<int32_t>(val * 100);
    bytes_array[0] = (int_val >> 24) & 0xFF;
    bytes_array[1] = (int_val >> 16) & 0xFF;
    bytes_array[2] = (int_val >> 8) & 0xFF;
    bytes_array[3] = int_val & 0xFF;
}
