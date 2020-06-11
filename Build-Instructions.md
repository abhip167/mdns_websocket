## Firstly Sign Apk With this Command :

```console
foo@bar:~$ keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000-alias key
```

In our case Keytool was Registered as a command so Keytool is Located in the
"/home/abhishekpatel/android-studio/jre/bin/keytool" so replace keytool word in above command by this path.

This Generated Key is located at Home Directory now..

## Further Steps

- Now follow steps on Flutter Build APk Website to configure some files in Android Folder.

## Bundle Tool

- Download Bundle tool from it's Repo ( Download JDk or Jre File )
- Store it into a Safe Folder Where in you Builded apks resides
- Import the key.jks from Home Directory to this Folder.... Let's Name This Folder as AbhiApps
- Folder Structure
  - AbhiApps
    - Keys/ key.jks
    - AllTheApks/
    - OutPutFiles/

### One Time Configurations

- Now Lets Generate The Apks by running this command
  ```console
  foo@bar:~$ bundletool build-apks --bundle=/MyApp/my_app.aab --output=/MyApp/my_app.apks
  ```
- Here, the bundletool is a command which is :
  ```console
  java -jar bundletool-all.jar
  ```
  Also, here java is ( it is in this folder -> -> ):
  ```console
  /home/abhishekpatel/android-studio/jre/bin/java
  ```
- Hence, to avoid typing all this everytime run this command in terminal
  ```console
  alias bundletool='java -jar bundletool-all.jar'
  ```
  For our PC it will be: ( Our Version 0.15.0 )
  ```console
  alias bundletool='/home/abhishekpatel/android-studio/jre/bin/java -jar bundletool-all-[version-of-bundletool-file].jar'
  ```

### Now the Regular Building Starts

- Now Everything is set Simply Run this Command
  - --bundle = Path to the .aab
  - --output = Path to output make a seperate folder
  ```console
  bundletool build-apks --bundle=/MyApp/my_app.aab --output=/MyApp/my_app.apks
  ```
- To Sign with device Key we Need
  ```console
  bundletool build-apks --bundle=./app-release.aab --output=./my_app.apks --ks=key.jks --ks-pass=pass:aapdoKeyNoPassword --ks-key-alias=key --key-pass=pass:aapdiKeyNoPassword
  ```

### After this we will get out apks file from .aab

- To Install in connected Device
  ```console
  bundletool install-apks --apks=/MyApp/my_app.apks
  ```
- Apk willbe automatically installed ( Our Size is 20Mb for Redmi Note 3 )
