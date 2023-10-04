package com.lingwing;

import android.os.Handler;
import android.os.Looper;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class BackgroundTimer extends ReactContextBaseJavaModule {
    // ScheduledExecutorService to run the timer task in a separate thread
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    // Counter to keep track of time
    private int counter = 0;

    // React application context
    private ReactApplicationContext reactContext;

    // Constructor
    public BackgroundTimer(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    // Name of the native module, used to reference it in JS
    @Override
    public String getName() {
        return "BackgroundTimer";
    }

    // Helper function to emit events to JS
    private void emitDeviceEvent(String eventName, Object data) {
        this.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, data);
    }

    // Start the timer
    @ReactMethod
    public void startTimer() {
        counter = 0; // Reset counter
        final Runnable timerRunnable = new Runnable() {
            public void run() {
                counter++; // Increment counter
                emitDeviceEvent("onTimerUpdate", counter); // Emit updated counter value to JS
            }
        };
        // Schedule the timer task to run every 1 second
        scheduler.scheduleAtFixedRate(timerRunnable, 0, 1, TimeUnit.SECONDS);
    }

    // Stop the timer
    @ReactMethod
    public void stopTimer() {
        scheduler.shutdown(); // Shutdown the scheduler
    }
}
