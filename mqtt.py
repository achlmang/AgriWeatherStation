import json
import paho.mqtt.client as mqtt
import mysql.connector

# MQTT Broker Configuration
THE_BROKER = "eu1.cloud.thethings.network"
THE_TOPIC = "#"
TTN_USERNAME = "*****************" # Puth the name of your app e.g. weathersattion@ttn
TTN_PASSWORD = "*****************" # Puth the generated API key from your application in TTN

# Database configuration
db_config = {
    'user': 'root',
    'password': '',
    'host': '127.0.0.1',
    'database': 'weatherstation',
    'raise_on_warnings': True
}

# MQTT Connection Callback
def on_connect(client, userdata, flags, rc):
    print("Connected to ", client._host, "port: ", client._port)
    client.subscribe(THE_TOPIC)

# MQTT Message Callback
def on_message(client, userdata, msg):
    try:
        themsg = json.loads(msg.payload.decode("utf-8"))
        # Adjust these lines to match the JSON structure of your TTN data
        temp = themsg["uplink_message"]["decoded_payload"]["temp"]
        humd = themsg["uplink_message"]["decoded_payload"]["humd"]
        press = themsg["uplink_message"]["decoded_payload"]["press"]

        # Insert data into the database
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        add_weather = ("INSERT INTO bme280 "
                       "(temperature, humidity, pressure) "
                       "VALUES (%s, %s, %s)")
        data_weather = (temp, humd, press)
        cursor.execute(add_weather, data_weather)
        connection.commit()

        cursor.close()
        connection.close()
        print("Data inserted successfully")

    except Exception as e:
        print(f"Error: {e}")

client = mqtt.Client()
client.username_pw_set(TTN_USERNAME, password=TTN_PASSWORD)
client.on_connect = on_connect
client.on_message = on_message

client.connect(THE_BROKER, 1883, 60)
client.loop_forever()
