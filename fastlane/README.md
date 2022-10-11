fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### update_native_libraries

```sh
[bundle exec] fastlane update_native_libraries
```

Updates the versions of the native libraries.

#### Options
* `version`: The version of the native libraries.
* `platform`: The platform to update. Leave blank to update both.

#### Example
```sh
bundle exec fastlane update_native_libraries version:3.4.0
bundle exec fastlane update_native_libraries version:3.4.0 platform:android
bundle exec fastlane update_native_libraries version:3.4.0 platform:ios
```


### bump

```sh
[bundle exec] fastlane bump
```

Updates the version of each Flutter package.

#### Options
* `version`: The version of the native libraries.

#### Example
```sh
bundle exec fastlane bump version:3.4.0
```


### update_sample

```sh
[bundle exec] fastlane update_sample
```

Updates the lockfile of each package and sample app pods.

#### Example
```sh
bundle exec fastlane update_sample
```


### publish

```sh
[bundle exec] fastlane publish
```

Validates and publishes each Flutter package.

#### Options
* `dry_run`: Only run in validation mode.

#### Example
```sh
bundle exec fastlane publish
bundle exec fastlane publish dry_run:true
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
