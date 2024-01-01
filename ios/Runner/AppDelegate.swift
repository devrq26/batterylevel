import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        // Set up the FlutterMethodChannel name - it must match
        // the MethodChannel names used in main.dart

        // This is for part 1 mentioned in my LinkedIn article
        let batteryChannel = FlutterMethodChannel(name: "au.com.mydomain.batterylevel/battery",
                                                    binaryMessenger: controller.binaryMessenger)
        // This sets up the call handler to allow us to call "getBatteryLevel".
        // This is for part 1 mentioned in my LinkedIn article
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                // If the guard statement fails (returns 'false),
                // when the call method name doesn't match our 
                // channel name - we return 
                // FlutterMethodNotImplemented 
                // in the result.
                guard call.method == "getBatteryLevel" else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                // The call method name matched ours, 
                // so we are good to go.
                // Calling receiveBatteryLevel(), 
                // which either gives us 
                // a result or an error code & message.
                self?.receiveBatteryLevel(result: result)
            })

        // This is for part 2 mentioned in my LinkedIn article
        let compResultChannel = FlutterMethodChannel(name: "au.com.mydomain.batterylevel/computation",
                                                        binaryMessenger: controller.binaryMessenger)
        // This sets up the call handler to allow us to call "getBatteryLevel".
        compResultChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                // If the guard statement fails (returns 'false),
                // when the call method name doesn't match our
                // channel name - we return
                // FlutterMethodNotImplemented
                // in the result.
 
                guard call.method == "getComputationResult" else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                // The call method name matched ours,
                // so we are good to go.
                // Calling computerResult(), which either
                // gives us a result or an error code & message.
                let compData = call.arguments as! [String:Any]
            
                // Convert Any datatype to Int - use conditional downcasting to Int.
                // Ideally you should use constants for the JSON string key names.
                var first = compData["compData_1"] as? Int
                var second = compData["compData_2"] as? Int
                self?.computeResult(x:first ?? 0, y:second ?? 0, result: result)
                })
      
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // This is for part 1 mentioned in my LinkedIn article
  // This is the actual platform method called
  // to return the battery level percentage.
 private func receiveBatteryLevel(result: FlutterResult) {
     let device = UIDevice.current
     device.isBatteryMonitoringEnabled = true
     // NOTE: Battery state does NOT work on iOS simulators, only real iOS devices.
     if (device.batteryState == UIDevice.BatteryState.unknown) {
         result(FlutterError(code: "UNAVAILABLE",
                             message: "Battery level not available.",
                             details: nil))
     } else {
         result(Int(device.batteryLevel * 100))
     }
 }

// This is for part 2 mentioned in my LinkedIn article
// This is the actual platform method called
// to return the computation result.
    private func computeResult(x:Int, y:Int, result: FlutterResult) {
    var computeRes = 0    // Init.
        
    computeRes = x * y
        
    if (computeRes == 0) {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Computation result not available.",
                            details: nil))
    } else {
        result(Int(computeRes))
    }
}
    
}
