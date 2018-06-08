#include "mbed.h"
//#include "ble/BLE.h"

DigitalOut myled(LED1);

/* Choose custom GATT UUIDS and profile name */
//uint16_t customServiceUUID  = 0xA000;
//uint16_t readCharUUID       = 0xA001;
//const static char     DEVICE_NAME[] = "Touch Signal";
//static const uint16_t uuid16_list[] = {0xA000}; /* Custom UUID, FFFF is reserved for development */

//Output signal
//uint8_t readSignal = 0;

/* Set up custom read characteristic*/
/* think this is what gets read :/ by the central device */
//ReadOnlyGattCharacteristic<uint8_t> readChar(readCharUUID, &readSignal, GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_NOTIFY);

/* Set up custom service */
/* have no idea what the custom characteristic is */
//GattCharacteristic *characteristics[] = {&readChar};
//GattService        customService(customServiceUUID, characteristics, sizeof(characteristics) / sizeof(GattCharacteristic *));

/* Restart advertising when phone app disconnects */
//void disconnectionCallback(const Gap::DisconnectionCallbackParams_t *){
//    BLE::Instance(BLE::DEFAULT_INSTANCE).gap().startAdvertising();
//}

/* Initialization callback */
//void bleInitComplete(BLE::InitializationCompleteCallbackContext *params){
//    BLE &ble          = params->ble;
//    ble_error_t error = params->error;
//   if(error != BLE_ERROR_NONE){
//        return;
//    }
//    ble.gap().onDisconnection(disconnectionCallback);
    /* Setup advertising */
//   ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::BREDR_NOT_SUPPORTED | GapAdvertisingData::LE_GENERAL_DISCOVERABLE); /* BLE only, no classic BT */
//    ble.gap().setAdvertisingType(GapAdvertisingParams::ADV_CONNECTABLE_UNDIRECTED); /* Advertising type */
//    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LOCAL_NAME, (uint8_t *)DEVICE_NAME, sizeof(DEVICE_NAME)); /* Add name */
//    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LIST_16BIT_SERVICE_IDS, (uint8_t *)uuid16_list, sizeof(uuid16_list)); /* UUID's broadcast in advertising packet */
//    ble.gap().setAdvertisingInterval(300); /* 300 ms */
    /* Add custom service */
//    ble.addService(customService);
    /* Start advertising */
//    ble.gap().startAdvertising();
//}


int main() {
    
    // Set's up a recurring interupt to look for inputs every few seconds
    
    /* Initialise BLE */
//    BLE& ble = BLE::Instance(BLE::DEFAULT_INSTANCE);
//    ble.init(bleInitComplete);
    
    /* SpinWait for initialization to complete. This is necessary because the
     * BLE object is used in the main loop below. */
//    while(ble.hasInitialized() == false){/* Spin loop */}

    /* Infinite loop waiting for BLE interrupt events */
//    while(1){
        /* Check for trigger from periodicCallback() */
//        if(ble.getGapState().connected){
            
//            if(readSignal != 0){
//                ble.updateCharacteristicValue(readChar.getValueHandle(), &readSignal, 1);
//                readSignal = 0;
//               wait(1);
//            }
//       }
//        else{
//            ble.waitForEvent(); /* Low power wait for event */
//        }
//    }
    
    while(1) {
        myled = 1;
        wait(10);
        myled = 0;
        wait(10);
    }
    
}