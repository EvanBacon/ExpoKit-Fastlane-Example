Before we get started. This will not work without a paid Apple Developer account.

```sh
$ expo init

> ? Choose a project name: expokit-fastlane-example
> ? Choose a template: expo-template-blank
> ? Yarn v1.12.3 found. Use Yarn to install dependencies? Yes

$ cd expokit-fastlane-example/
expokit-fastlane-example $ git add .
expokit-fastlane-example $ git commit -m "init"
expokit-fastlane-example $ expo eject

> ? How would you like to eject from create-react-native-app? ExpoKit: I'll create or log in with an Expo accoun
> t to use React Native and the Expo SDK.

> ? What would you like your iOS bundle identifier to be? com.evanbacon.expokitfastlane

> ? What would you like your Android package name to be? com.evanbacon.expokitfastlane

expokit-fastlane-example $ git add .
expokit-fastlane-example $ git commit -m "ejected"

expokit-fastlane-example $ cd ios

ios $ fastlane init

> What would you like to use fastlane for?

1. 📸  Automate screenshots
2. 👩‍✈️  Automate beta distribution to TestFlight
3. 🚀  Automate App Store distribution
4. 🛠  Manual setup - manually setup your project to automate your tasks
?  3

> Apple ID Username: evanjbacon@gmail.com

> Do you want fastlane to create the App ID for you on the Apple Developer Portal? (y/n): n

```

I got this stupid error, changed the ID, and still got it :/
`It looks like the app 'com.bacon.expokitfastlane' isn't available on the Apple Developer Portal for the team ID 'QQ57RJ5UTD' on Apple ID 'evanjbacon@gmail.com'`

```sh

$ [22:49:14]: --- ✅  Successfully generated fastlane configuration ---

$ Hit enter a bunch of times

```

At this point you should have a new folder `ios/fastlane/` with a `Fastfile` & `Appfile`. Ideally we want a `Matchfile` & `Deliverfile` too.

If you hit the bundle ID snag then you need to create an app in AppstoreConnect (formerly iTunes Connect). This is very easy. (or at least it should be) You may need to sign in to your account, sometimes it'll just auto authenticate.

```
ios $ fastlane produce init

> App Name: ExpoKit Fastlane

Successfully created new app 'ExpoKit Fastlane' on App Store Connect with ID
```

You won't see any git changes but if you go to [AppStore Connect](https://appstoreconnect.apple.com/) you should see a new app created and ready for you!

Time to deliver. This part is cool.

```
ios $ fastlane deliver init

```

You may need to sign in, note that I'm running all of these commands in `ios/`. If you don't then you will need to specify the bundle ID. This will be a good time to `git commit`

## Doing more stuff...

> Sidenote: You can add patch functions to your Fastfile if you want

```rb

  desc "Increment the app version patch"
  lane :bumpPatch do
    increment_version_number(
      bump_type: "patch"
    )
  end

  desc "Increment the app version minor"
  lane :bumpMinor do
    increment_version_number(
      bump_type: "minor"
    )
  end

  desc "Increment the app version major"
  lane :bumpMajor do
    increment_version_number(
      bump_type: "major"
    )
  end

```
