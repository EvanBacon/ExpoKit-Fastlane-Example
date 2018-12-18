# ExpoKit Fastlane

You probably enjoy the luxurious `expo build:ios` command but if you upgrade/eject to add custom native modules then you need a new approach. Here is my favorite way to upload to the app store on iOS.

> I use the `produce` & `deliver` steps in vanilla Expo too!

## Starting from the beginning

But First! This will not work without a paid Apple Developer account ☹️

### Create an Expo project

```sh
$ expo init

> ? Choose a project name: expokit-fastlane-example
> ? Choose a template: expo-template-blank
> ? Yarn v1.12.3 found. Use Yarn to install dependencies? Yes

```

### Then enter the folder

```sh
$ cd expokit-fastlane-example/
```

### Commit 😁

```sh
expokit-fastlane-example $ git add .; git commit -m "init"
```

### Eject

```sh
expokit-fastlane-example $ expo eject

? How would you like to eject from create-react-native-app?

> ExpoKit: I'll create or log in with an Expo account to use React Native and the Expo SDK.

? What would you like your iOS bundle identifier to be?

> com.evanbacon.expokitfastlane

? What would you like your Android package name to be?

> com.evanbacon.expokitfastlane

```

### Commit 😊

```sh
expokit-fastlane-example $ git add .; git commit -m "ejected"
```

### Enter the ios folder

```sh
expokit-fastlane-example $ cd ios
```

### Fastlane init

```sh
ios $ fastlane init

? What would you like to use fastlane for?

1. 📸 Automate screenshots
2. 👩‍✈️ Automate beta distribution to TestFlight
3. 🚀 Automate App Store distribution
4. 🛠 Manual setup - manually setup your project to automate your tasks

> 3

```

```sh

? Apple ID Username:

> evanjbacon@gmail.com

```

I got this error, then I changed the ID, and still got it 🙃 so just pass `n` in the next bit cuz I think it's a fastlane bug.

`It looks like the app 'com.bacon.expokitfastlane' isn't available on the Apple Developer Portal for the team ID 'QQ57RJ5UTD' on Apple ID 'evanjbacon@gmail.com'`

```sh
? Do you want fastlane to create the App ID for you on the Apple Developer Portal? (y/n):

> n
```

```sh

$ [22:49:14]: --- ✅  Successfully generated fastlane configuration ---

```

Then just hit enter a bunch of times...

### Commit 😏

```sh
expokit-fastlane-example $ git add .; git commit -m "fastlane init"
```

### Create the App Entry

At this point you should have a new folder `ios/fastlane/` with a `Fastfile` & `Appfile`. Ideally we want a `Deliverfile` & `Matchfile` too.

If you hit the bundle ID snag then you need to create an app in Appstore Connect (formerly iTunes Connect). This is very easy, or at least it should be.

```sh

ios $ fastlane produce init

```

You may need to sign-in to your account, sometimes it'll just auto authenticate.

```sh

? App Name:

> ExpoKit Fastlane

```

Now you've `Successfully created new app 'ExpoKit Fastlane' on App Store Connect with ID`!

You won't see any git changes but if you go to [AppStore Connect](https://appstoreconnect.apple.com/) you should see a new app created and ready for you!

### Setup Metadata with Deliver

This part is cool:

- [Here are the offical docs](https://docs.fastlane.tools/actions/deliver/#deliver)
- [Here is another one of my rants](https://blog.expo.io/manage-app-store-metadata-in-expo-with-fastlane-deliver-1c00e06b73bf)

You can use this in vanilla Expo or ExpoKit!

```sh
ios $ fastlane deliver init
```

You may need to sign in, note that I'm running all of these commands in `ios/`. If you don't then you will need to specify the bundle ID.

### Commit 😕

```sh
expokit-fastlane-example $ git add .; git commit -m "fastlane deliver init"
```

### Deliver

At this point you can type `fastlane deliver` and it will push all of the blank metadata to the App Store entry.

### Code Sign with Match

- [Here are the offical docs](https://docs.fastlane.tools/actions/match/#setup)

Now we need to do our code signing. If you know any iOS developer, you've probably seen the sadness luming deep in their solemn gaze. This is because of iOS code signing; a digital signature system that has a few less-than simple steps.

Translation: it's fucking bullshit.

But we can skip the entire process with one line! 😮

```sh

fastlane match init

```

This will ask you for the URL to a **private** repo. I think you can get a free one on gitlab. If you have a paid Github account you can make as many as you want. (💪 don't wanna brag but... I don't like to pay for stuff)

![repo](https://github.com/EvanBacon/ExpoKit-Fastlane-Example/blob/master/assets/github_repo.png?raw=true)

Name the repo something like `project-certificates` or whatever you want.

If your computer is setup with SSH then you should use the `git` URL, otherwise the `https` one is aight too.

```sh

? URL of the Git Repo:

> git@github.com:EvanBacon/expokit-fastlane-example-certificates.git

```

Now you should have a `ios/Matchfile`

Just to be safe, make sure your "Automatically manage signing" option in the general tab of your `ios/<project>.xcworkspace` project is **UNCHECKED** and after we run the next two commands, you'll want to select the eligible profiles.

If you've already messed with your signing then check out this neat command [**MATCH NUKE**](https://docs.fastlane.tools/actions/match/#nuke)

![complex diagram](https://github.com/EvanBacon/ExpoKit-Fastlane-Example/blob/master/assets/fastlane_match.png?raw=true)

### Configure the Certs

> Certs = certificates 😗

```sh
fastlane match appstore

? Passphrase for Git Repo:

> writingTutorialsOnFridayNightIsCool

# [23:45:45]: All required keys, certificates and provisioning profiles are installed 🙌

```

### Now run this (you need both)

```sh

fastlane match development

# [23:46:48]: All required keys, certificates and provisioning profiles are installed 🙌

```

_From the docs:_

This will create a new certificate and provisioning profile (if required) and store them in your Git repo. If you previously ran match it will automatically install the existing profiles from the Git repo.

The provisioning profiles are installed in ~/Library/MobileDevice/Provisioning Profiles while the certificates and private keys are installed in your Keychain.

### Install Pods

You can prolly skip this (entire tutorial).

In `ios/` run `pod install` to download all of the dependencies.

### Should I Commit the Pods

_TL;DR_: [Cocoapods offically say "commit ur shit boi"](https://guides.cocoapods.org/using/using-cocoapods#should-i-check-the-pods-directory-into-source-control)

After you install your libs you may notice a lot of extra files in your git repo. Cocoapods have a `ios/Podfile.lock` that is generated after running `pod install`, this file should always be committed. You can use this file to regenerate your `ios/Pods/` folder.
React Native pods are usually always _"development pods"_ which means they are local. Specifically they are stored in the `node_modules` folders. Because of this, there is a lot of ambiguity over wheather or not you should commit the `ios/Pods/`.

I don't save them, I have commitment issues 🤓

### Publish

Finally we're done!

In `ios/` run `fastlane release` to generate the `.ipa` file 😁 this will also push the file to AppStore Connect!

### Update the Metadata

You can also run `fastlane deliver` to push all of your local metadata. I usually set the categories in the app store connect website then run `fastlane deliver download_metadata` which downloads the metadata into the local copy. This is cool because you can git commit the files. You can push up the data faster with `fastlane deliver --skip_binary_upload --skip_screenshots` also `--force` to skip the HTML preview.

### OTA Updates

Use `expo publish` to upload your JS changes whenever you want. If you change native code, or update the Expo version, or use a different release channel - the changes may not (won't) show up. The CLI should warn you about this.

### Commit 🙁

```sh
expokit-fastlane-example $ git add .; git commit -m "fastlane deliver init"
```

## Extra Credit

Here are a couple of other things I do to make life easy.

### Setup notifications

I use this library: https://www.npmjs.com/package/expo-firebase-messaging the instructions are something like `fastlane pem` then upload the files to firebase. By default this will produce prod keys, you can add `--development` to get the development pods

### Add a Deliverfile

Create a file `ios/Deliverfile` I usually just do the following. The last line is really the only extra functionality, everything else is added convenience (which is pretty important if you're lazy and sloppy like me)

```rb
app_identifier "com.bacon.expokitfastlane" # The bundle identifier of your app
username "evanjbacon@gmail.com" # your Apple ID user

copyright "#{Time.now.year} Evan Bacon"
```

I usually have a git submodule for `ios/fastlane/metadata/trade_representative_contact_information` because it's my business data and it never changes.

### Patch Functions

You can add patch functions to your Fastfile if you want. It's a popular thing, I never use it though 😏

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

## Fin

That's it for now follow [@baconbrix](https://twitter.com/Baconbrix)
