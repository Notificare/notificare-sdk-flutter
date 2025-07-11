# CHANGELOG

## 4.2.2

#### Native changes

##### iOS

- Fix Swift Concurrency issues when synchronizing inbox items

## 4.2.1

#### Native changes

##### iOS

- Refactor the integration with CoreData, fixing threading fatal errors

## 4.2.0

- Recover when a device is removed remotely

#### Native changes

##### iOS

- Reload action categories during launch

## 4.1.0

- Allow unsetting user data fields
- Change `NotificareRegion.timeZoneOffset` attribute from `int` to `double` to support half-hour & 45 minute timezones.

#### Native changes

##### iOS

- Fix issue where the notification UI was not dismissed when an action was executed through a custom markup or actions context sheet
- Fix callback with keyboard safe area insets
- Improve CoreData threading

##### Android

- Warnings related to missing requirements for Beacons functionality only logged once during `enableLocationUpdates()` flow
- Fix UI behaviour after screen rotation when presenting notifications
- Fix crash when rotating the screen when presenting a `NotificareCallbackActionFragment`
- Bump sourceCompatibility/targetCompatibility to Java 11
- Update target and compile SDK to 35

## 4.0.1

- Add documentation to public methods
- Add flag to allow excluding beacons dependency

#### Native changes

##### iOS

- Remove User Inbox messages from the notification center when appropriate
- Fix refresh badge calls error handling when auto badge is off
- Fix crash when sending photos using the camera notification action
- Fix camera notification action behaviour when no camera permission is granted, opening the photo library

##### Android

- Remove User Inbox messages from the notification center when appropriate
- Cancel in-app message job immediately upon being suppressed
- Fix missing onMessageFinishedPresenting event when an in-app message action is executed

## 4.0.0

- Device identifiers become long-lived
- Add methods to register callbacks in order to handle background location events on Android
- Add support for customisable hosts
- Add `NotificarePush.onSubscriptionChanged` event for push token updates
- `launch()`, `unlaunch()`, `enableRemoteNotifications()` and `disableRemoteNotifications()` functions now complete after all the work is done

#### Breaking changes

- Drops support for the monetize module
- Drops support for Huawei Mobile Services
- `NotificareDevice.id` attribute no longer contains the push token. Use `NotificarePush.subscription` instead
- `NotificareDevice.transport` attribute no longer contains the transport. Use `NotificarePush.transport` instead
- The `NotificareDevice` data model was reduced to only publicly relevant attributes
- `onDeviceRegistered` only triggers once, when the device is created
- Removed deprecated `NotificarePush.onNotificationReceived(notification)` event. Use `NotificarePush.onNotificationInfoReceived(notification, deliveryMechanism)` instead

#### Native changes

##### Android

- Fix padding discrepancies in alert dialog with actions

## 4.0.0-beta.2

- Changed the `subscriptionId` properties to a more robust data model
- Add methods to register callbacks in order to handle background location events on Android

## 4.0.0-beta.1

- Device identifiers become long-lived
- Add `NotificarePush.onSubscriptionIdChanged` event for push token updates

#### Breaking changes

- Drops support for the monetize module
- Drops support for Huawei Mobile Services
- `NotificareDevice.id` attribute no longer contains the push token. Use `NotificarePush.subscriptionId` instead
- `NotificareDevice.transport` attribute no longer contains the transport. Use `NotificarePush.transport` instead
- The `NotificareDevice` data model was reduced to only publicly relevant attributes
- `onDeviceRegistered` only triggers once, when the device is created
- Removed deprecated `NotificarePush.onNotificationReceived(notification)` event. Use `NotificarePush.onNotificationInfoReceived(notification, deliveryMechanism)` instead

#### Native changes

##### Android

- Fix padding discrepancies in alert dialog with actions

## 3.10.0

#### Native changes

##### iOS

- Add support for the URLResolver notification type
- Fix anonymous device registration

##### Android

- Add support for the URLResolver notification type
- Fix anonymous device registration

## 3.9.1

- Preload images before showing in-app messages

#### Native changes

##### iOS

- Fix `NotificarePass.type` decoding

## 3.9.0

- Add support for deferred links

#### Native changes

##### iOS

- Add privacy manifests
- Code sign XCFrameworks

## 3.8.0

- Add method to resolve Notificare Dynamic Links manually

#### Native changes

##### Android

- Prevent processing location updates too close to the last known location
- Fix race condition where geo triggers and region sessions were sent multiple times
- Limit the amount of location points and ranged beacons in geo sessions

##### iOS

- Prevent processing location updates too close to the last known location
- Fix race condition where geo triggers and region sessions were sent multiple times
- Limit the amount of location points and ranged beacons in geo sessions
- Improve polygon regions handling
- Improve notifications UI

## 3.7.0

**Important notice:** Re-enabling remote notifications and location services is no longer required.
You can safely remove the following piece of code as the SDK will automatically handle it for you during the launch flow.

```dart
Notificare.onReady.listen((application) async {
  // This check is no longer necessary.
  if (await NotificarePush.hasRemoteNotificationsEnabled) {
    await NotificarePush.enableRemoteNotifications();
  }

  // This check is no longer necessary.
  if (await NotificareGeo.hasLocationServicesEnabled) {
    await NotificareGeo.enableLocationUpdates();
  }
});
```

#### Native changes

##### Android

- Fix map loading conditionals leading to no camera updates
- Adjusted zoom level when presenting a single map marker
- Fix Google Play Services Location minification issue

###### Important changes since 3.6.1

- Add manifest flag to disable the auto configuration
- Automatically enable remote notifications during launch when possible
- Automatically enable location updates during launch when possible
- Prevent the `device_registered` event from invoking before the `ready` event
- Fix warning when notification intents are handled by the broadcast receiver
- Include proguard rule to work around the issue with Moshi in R8
- Fix crash when presenting an in-app browser when the phone has none installed
- Fix `getParcelableExtra` on API 33 in certain cases

##### iOS

- Prevent the `device_registered` event from invoking before the `ready` event
- Automatically enable remote notifications during launch when possible
- Automatically enable location updates during launch when possible
- Drop support for iOS 12.0

## 3.6.1

- Fix custom action received event

#### Native changes

##### Android

- Fix race condition when synchronising monitored regions

##### iOS

- Fix race condition when setting the database merge policy eagerly loads the data stores
- Prevent fatal error when failing to open the databases

## 3.6.0

- Allow checking which regions are being monitored
- Allow checking which regions the device is inside of

#### Native changes

##### Android

- Allow setting the amount of regions to monitor

##### iOS

- Allow setting the amount of regions to monitor

## 3.5.4

#### Native changes

##### Android

- Prevent queued events without an associated device
- Prevent `logCustom` usage before Notificare becomes ready

##### iOS

- Prevent queued events without an associated device
- Prevent `logCustom` usage before Notificare becomes ready

## 3.5.3

#### Native changes

##### Android

- Explicit handling of Notificare Links in Deep Link notifications
- Improve supported deep links validation
- Stricter unlaunch flow

##### iOS

- Improve supported deep links validation
- Fix debug symbols search paths
- Stricter unlaunch flow

## 3.5.2

#### Native changes

##### Android

- Prevent multiple configurations from taking place
- Add broadcast receiver for geo events
- Start monitoring nearest regions immediately after upgrading to background location
- Correctly track device on initial application open event

##### iOS

- Emit the didChangeNotificationSettings event when disabling remote notifications
- Add opt-in flag to prevent file access restrictions for Core Data
- Prevent push registration race condition when enabling remote notifications
- Correctly track device on initial application open event

## 3.5.1

#### Native changes

##### Android

- Improved action categories parsing
- Prevent Glide from invoking the coroutine continuation several times
- Fix cached language when the network request fails
- Update cached device when the language changes
- Use YouTube privacy-enhanced mode

##### iOS

- Improved auto-config mechanism
- Improved action categories parsing
- Fix user validation request
- Fix cached language when the network request fails
- Include debug symbols in the distributed frameworks
- Fix store notification required view controller flag
- Fix main-thread warning on device registration
- Use YouTube privacy-enhanced mode

## 3.5.0

- Add user-level inbox module
- Allow a context evaluation upon un-suppressing in-app messages
- Include the delivery mechanism for notification received events

## 3.4.2

- Preserve deep link propagation

#### Native changes

##### iOS

- Fix notification settings update race condition
- Prevent WebView notifications content from being dismissed while the view is presented
- Add `Identifiable` compliance to applicable data models
- Optional CoreNFC framework linking to support older devices
- Refactor internal modules to keep track of their instances
- Improve pass-support availability checks

## 3.4.1

- Fix locale-sensitive time formatting on `NotificareTime` objects

## 3.4.0

#### Important changes since 3.3.0

- In-app messaging module
- Add option to preserve existing notification categories
- Drop support for iOS 10

## 3.4.0-beta.3

#### Native changes

##### iOS

- Add option to preserve existing notification categories

## 3.4.0-beta.2

- Add in-app messaging module

## 3.3.0

- Add monetise module

#### Native changes

##### Android

- Add opt-in intent when opening a beacon foreground service notification
- Fix GMS/HMS notification race condition for late configured apps
- Monetise module for Google Play
- Prevent unnecessary copies of `LiveData` from being created
- Update HMS libraries, fixing Google Play compliance warnings
- Monitor and range non-triggering beacons
- Prevent internal _main beacon region_ from triggering events
- Fix R8/ProGuard minification issues
- Add Java-friendly wrappers

##### iOS

- Monetise module
- Prevent internal _main beacon region_ from triggering events
- Remove interruption level & relevance score from notification service extension

## 3.2.0

- Add support for Flutter 3.0

#### Native changes

##### Android

- Fix notification content when opening partial inbox items
- Use GMS/HMS `message.sentTime` when creating inbox items
- Log events methods correctly throw when failures are not recoverable
- Improve session control mechanism
- Fix session length
- Fix GMS/HMS token refresh race condition for late configured apps
- Add `InAppBrowser` notification type
- Aliased `WebView` action into `InAppBrowser`, aligning with the notification type
- Ensure listeners are called on the main thread
- Allow non-ASCII header values

##### iOS

- Fix notification content when opening partial inbox items
- Fix marking partial items as read
- Improve ISO date parser
- Add safeguards and warnings for corrupted items in the inbox database
- Log events methods correctly throw when failures are not recoverable
- Improve session control mechanism
- Add `InAppBrowser` notification type
- Aliased `WebView` action into `InAppBrowser`, aligning with the notification type
- Ensure delegate methods are called on the main thread

## 3.1.1

- Prevent stale event channels after engine recreation

#### Native changes

##### Android

- Improve bitmap loading
- Prevent crashing when generating notifications with invalid attachments
- Include JSON serialisation methods for unknown notifications

## 3.1.0

- Include complete remote message information in unknown notification events
- Fix unknown notification event emitter
- Add `onUnknownNotificationOpened` and `onUnknownNotificationActionOpened` events
- Refactor core into internal `notificare_flutter` package to work around Flutter's issue [#63240](https://github.com/flutter/flutter/issues/63240)

#### Native changes

##### Android

- Include `Accept-Language` and custom `User-Agent` headers
- Allow notification push services to be subclassed
- Add notification attributes to unknown notifications
- Improve `allowedUI` to accurately reflect push capabilities
- Prevent push tokens from being registered immediately after an install

##### iOS

- Include `Accept-Language` and custom `User-Agent` headers
- Improve `allowedUI` to accurately reflect push capabilities
- Rename internal `AnyCodable` to prevent collisions
- Expose unknown notification open events via `notificare(_:didOpenUnknownNotification:)` and `notificare(_:didOpenUnknownAction:for:responseText:)`
- Launch each peer module sequentially to prevent race conditions

## 3.0.1

- Add missing Huawei repository in geo & scannables
- Remove `mavenLocal` repository

#### Native changes

##### Android

- Update Gradle build tools
- Use compile-time constant for the SDK version
- Remove unnecessary `BuildConfig` files
- Update dependencies

##### iOS

- Prevent multiple push registration events
- Prevent Apple-processed builds from modifying the SDK version

## 3.0.0

Please check our [migration guide](./MIGRATION-3.0.md) before adopting the v3.x generation.
