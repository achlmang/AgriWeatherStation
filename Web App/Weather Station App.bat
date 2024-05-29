@echo off
cd C:\Users\achil\Desktop\Projects\Internet of Things\Weather Station Files\Web App
set FLASK_APP=app.py
start flask run
start http://localhost:5000
