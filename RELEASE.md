# Release process

1. Update the `version` property in each module's `pubspec.yaml`.
2. Update the `version` property in each module's `build.gradle`.
3. Update the `version` property in each module's `*.podspec`.
4. Run the `PUB GET ALL` project run configuration.
5. Run `cd sample/ios && pod update && cd -` to update the sample.
6. Run `flutter pub publish --dry-run` on each module to ensure there are no issues.
7. Update the `CHANGELOG.md`.
8. Push the generated changes to the repo.
9. Run `flutter pub publish` on each module.
10. Create a GitHub release with the contents of the `CHANGELOG.md`.
