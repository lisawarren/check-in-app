# check-in-app
**Description**

The goal of this project was to design a simple mobile app that explores the capabilities of mobile apps in keeping older adults, specifically low-SES older adults, connected with their caregivers or peer groups.

The app was designed to connect an iOS device to the Circuit Playground Bluefruit from Adafruit Industries. The app uses the Core Bluetooth framework to identify the Bluefruit's services and their characteristics, and write/read from those characteristics. The Bluefruit, or any other Bluetooth Low Energy (BLE) device with the same services, must run the code.py file in order to connect to the iOS device.

The app was designed with older adults in mind, so its use is very simple - there are three buttons that a user can press. Each button pressed within the app writes a message to one of the Bluefruit's characteristics. The Bluefruit will read that characteristic and reflect the value of the message in the color if its LED lights. The Bluefruit can also send messages back to the app, i.e. "checking-in". When the Bluefruit's A1 capacitive touch pad is pressed, the app receives the message, "Checked-in!" and displays that text.

While the app was designed to test the Bluetooth functionality with the Circuit Playground Bluefruit as well as explore the possible use of mobile apps to meet the needs of older adults and their caregivers/peer groups, there are several other features that I hope to implement in the future that will improve the practicality of the check-in system as a whole. For example, a new version of the app may be designed to connect to a Raspberry Pi, which can then distribute information via Wifi to several other check-in devices.

**How to Install**
Parts
1. Circuit Playground Bluefruit
2. USB Cable - USB-A to to Micro-B
3. Mu Code Editor: https://codewith.mu/en/download
4. iOS Device (you cannot use Bluetooth on the XCode simulators, so you must use a real device)


On the Circuit Playground Bluefruit (CPB)
1. Make sure the CPB is running the newest version of Circuit Python: https://circuitpython.org/board/circuitplayground_bluefruit/
2. Also make sure that the CPB has a lib folder with the recommended lib files: https://learn.adafruit.com/adafruit-circuit-playground-bluefruit/circuit-playground-bluefruit-circuitpython-libraries
3. Download the code.py file and place it into the CPB's root folder
4. Open the Mu code editor and load the code.py file from the CPB. Click the serial monitor button to open the serial monitor

For the App
1. Download this project and click on the Check-in-App.xcodeproj
2. Select your iOS device's scheme in Xcode
3. Click 'Run' to simulate the app on your device
