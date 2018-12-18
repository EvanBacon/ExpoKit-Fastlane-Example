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

At this point you should have a new folder `ios/fastlane/` with a `Fastfile` & `Appfile`. Ideally we want a `Deliverfile` & `Matchfile` too.

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

At this point you can type `fastlane deliver` and it will push all of the blank metadata to the App Store entry.

Now we need to do our code signing. If you know any iOS developer, you've probably seen the sadness luming deep in their eyes. This is because of a complex digital signature system that is not quite the most user friendly and has a few less-than simple steps ... it's fucking bullshit.

But we can skip the entire process with one line.

> BTW you can check out the [offical guide here](https://docs.fastlane.tools/actions/match/#setup) this step isn't React Native or Expo specific so do you

```
fastlane match init
```

This will ask you for the URL to a **private** Repo. I think you can get a free one on gitlab. If you have a paid Github account you can make as many as you want. Name it something like `project-certificates` or whatever you want.

If your computer is setup with SSH then you should use the git URL, otherwise the https one is aight too.

```
> URL of the Git Repo: git@github.com:EvanBacon/expokit-fastlane-example-certificates.git
```

Now you should have a `ios/Matchfile`

Just to be safe, make sure your "Automatically manage signing" option in the general tab of your XCWorkspace project is **UNCHECKED**

> > > > > > > > > > > > > > > > > ADD IMAGE :)

Time to run

```
fastlane match appstore

fastlane match development
```

> This will create a new certificate and provisioning profile (if required) and store them in your Git repo. If you previously ran match it will automatically install the existing profiles from the Git repo.
> The provisioning profiles are installed in ~/Library/MobileDevice/Provisioning Profiles while the certificates and private keys are installed in your Keychain.

## Doing more stuff...

### Add a Deliverfile

create a file `ios/Deliverfile` add whatever you want:
I usually just do the following. The last line is really the only extra functionality, everything else is just convenient (which is pretty important if you're lazy and sloppy like me)

```
app_identifier "com.bacon.expokitfastlane" # The bundle identifier of your app
username "evanjbacon@gmail.com" # your Apple ID user

copyright "#{Time.now.year} Evan Bacon"
```

> I usually have a git submodule for `ios/fastlane/metadata/trade_representative_contact_information` because it's my business data and it never changes.

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
