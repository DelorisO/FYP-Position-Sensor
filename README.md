# FYP-Position-Sensor
Imperial College Student Final Year Projects Github Repository

Credit to http://x-io.co.uk/ for their AHRS Algorithm

Download Dasta

# User Guide
In order to replicate my results the following Dataset is need: https://archive.ics.uci.edu/ml/
datasets/Daily+and+Sports+Activities

For the signal processing the AHRS algorithm will be need from this link: https://github.com/
xioTechnologies/Open-Source-AHRS-With-x-IMU

Download the Madgwick version, including the quaternion library (make sure downloading the MATLAB files not C or C++).

Explore Features Used: This is located in the MATLAB files called ReadingData.m, Running this file will produce a features vector, filled with all the different features being used. Including the Euler Angles. to explore further the primary function being used in this script is called ProcessData.m , this is a function that takes in the accelerometer, gyroscope and magnetometer data. In here the AHRS algorithm is ran along with two functions called TDF and FDT which are responsible for calculating the time domain features and the Frequency domain features respectively.

Run Cross Validation: To run the cross validation for KNN is simple, run the KNNCV.m available in the folder.

For SVM cross validation there is also a separate file called OneVsAllCV.m this is a function that need to be called. It is possible to run it from the Reading Data file, it outputs 4 cross validation grids. The limits can be set inside the file by the variables Cpw and gpw, where Cpw is log2 C and gpw is log2 C. To generate the graphs use the function CVPlot which plots the graph with the correct axises. Run whole Algorithm: To run the whole algorithm on the ReadingData.m file uncomment the line of code that called the OneVsAll.m function, then run the ReadingData.m script again, now you will get correct results for the algorithm. You can differ the values of and C but changing these values by changing opt_gamma and opt_C. To time the algorithm uncomment the all the tic tocs in the in the code.

Run Mbed Code: For this you will need the Adafruit Flora IMU which can be brought here: https://www.adafruit.com/product/2020

The nrF52840 can from: http://www.nordicsemi.com/eng/Products/nRF52840-DK
Information on both the pages give a list of suppliers. First there is a need to solder wires on the FLORA, 4 wires for the SCL, SDA, 3V and GND pins. Then connect this onto the nrf52840, as shown in the implementation stage. SCL to P0.27 and SDA to P0.26, connect the 5V pin to the 3V pin on the nrf52840, (note this only works if using the coin cell battery with the nrf52840 otherwise to bring 5V to 3V a potential divider is needed). Once these connections the following libraries need to be downloaded from the mbed library import feature.
https://os.mbed.com/cookbook/LMS9DS0-IMU
https://os.mbed.com/teams/Bluetooth-Low-Energy/code/BLE_API/
