# Symbolic link (see also blog post: https://www.patridgedev.com/2019/05/20/workaround-xamarin-android-long-paths-on-windows/)
New-Item -ItemType SymbolicLink C:\short\AwesomeProject -Value C:\some\long\original\path\AwesomeProject
