## Run
```
    flutter clean
    flutter pub get
    flutter packages pub run build_runner watch
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    flutter run --flavor development -t lib/main_dev.dart --no-sound-null-safety
    flutter run --flavor uat -t lib/main_uat.dart --no-sound-null-safety
    flutter run --flavor training -t lib/main_training.dart --no-sound-null-safety
    flutter run --flavor preprod -t lib/main_preprod.dart --no-sound-null-safety
    flutter run --flavor production -t lib/main_release.dart --no-sound-null-safety
```

## Build Profile (for internal testing)
- Android:
```
    flutter build apk --profile --flavor development -t lib/main_dev.dart --no-sound-null-safety
    flutter build apk --profile --flavor uat -t lib/main_uat.dart --no-sound-null-safety
    flutter build apk --profile --flavor training -t lib/main_training.dart --no-sound-null-safety
    flutter build apk --profile --flavor preprod -t lib/main_preprod.dart --no-sound-null-safety
    flutter build apk --profile --flavor production -t lib/main_release.dart --no-sound-null-safety
```
- iOS:
```
    flutter build ios --profile --flavor development -t lib/main_dev.dart --no-sound-null-safety
    flutter build ios --profile --flavor uat -t lib/main_uat.dart --no-sound-null-safety
    flutter build ios --profile --flavor training -t lib/main_training.dart --no-sound-null-safety
    flutter build ios --profile --flavor preprod -t lib/main_preprod.dart --no-sound-null-safety
    flutter build ios --profile --flavor production -t lib/main_release.dart --no-sound-null-safety
```

## Build Release
- Android:
```
    flutter build apk --flavor development -t lib/main_dev.dart --no-sound-null-safety
    flutter build apk --flavor uat -t lib/main_uat.dart --no-sound-null-safety
    flutter build apk --flavor training -t lib/main_training.dart --no-sound-null-safety
    flutter build apk --flavor preprod -t lib/main_preprod.dart --no-sound-null-safety
    flutter build apk --flavor production -t lib/main_release.dart --no-sound-null-safety
```
- iOS:
```
    flutter build ios --flavor development -t lib/main_dev.dart --no-sound-null-safety
    flutter build ios --flavor uat -t lib/main_uat.dart --no-sound-null-safety
    flutter build ios --flavor training -t lib/main_training.dart --no-sound-null-safety
    flutter build ios --flavor preprod -t lib/main_preprod.dart --no-sound-null-safety
    flutter build ios --flavor production -t lib/main_release.dart --no-sound-null-safety
```

## Automatic distribute to Firebase Distribution
- Export the Gem Home environment variable if need (for Apple "M" series SoC)
```
    export GEM_HOME="$HOME/.gem"
```
- Export the Firebase token environment variable
```
    export FIREBASE_TOKEN=[YOUR_FIREBASE_TOKEN]
```
- Target to the ".zshrc" file, example for macOS:
```
    source ~/.zshrc
```

# For both iOS & Android
```
    ./buildDevForQA.sh
    ./buildStagingForQA.sh
    ./buildPreProdForQA.sh
    ./buildProductionForQA.sh
```
# For iOS ONLY
- Go to the iOS path:
```
    cd ios
```
- Then:
```
    ./buildDevForQA.sh
    ./buildStagingForQA.sh
    ./buildPreProdForQA.sh
    ./buildProductionForQA.sh
```
# For Android ONLY
- Go to the Android path:
```
    cd android
```
- Then:
```
    ./buildDevForQA.sh
    ./buildStagingForQA.sh
    ./buildPreProdForQA.sh
    ./buildProductionForQA.sh
```

## Example to push to a navigation stack
```
    // example to push to a routes
    // each widget should return a Scaffold
    List<Widget> widgets = [];
    widgets.add(PropertyTypeScreen());
    widgets.add(HomeInformationStep1());
    widgets.add(HomeInformationStep2());
    widgets.add(HomeInformationStep3());
    widgets.add(HomeInformationStep4());
    widgets.add(HomeInformationStep5());
    widgets.add(HomeInformationStep6());
    widgets.add(HomeInformationStep7());
    widgets.add(HomeInformationStep8());
    widgets.add(HomeInformationStep9());
    NavigationController.navigateToWidgets(context, widgets);
    
    // to exit the routes (for example "Home" button onTap)
    Navigator.of(context, rootNavigator: true).pop();
```

## Alert Dialog (for more information, please read "alert_dialog.dart")
- Show simple success, warning, error dialog:
```
    // Success
    AppAlert.showSuccessAlert(
      context,
      'Thao tác thành công',
      okAction: () { // optional to show the 'Đồng ý' button

      },
      cancelAction: () { // optional to show the 'Bỏ qua' button

      },
    );
    
    // Warning
    AppAlert.showWarningAlert(
      context,
      'Không được trống',
      okAction: () { // optional to show the 'Đồng ý' button

      },
      cancelAction: () { // optional to show the 'Bỏ qua' button

      },
    );
    
    // Error
    AppAlert.showErrorAlert(
      context,
      'Có lỗi xảy ra',
      okAction: () { // optional to show the 'Đồng ý' button

      },
      cancelAction: () { // optional to show the 'Bỏ qua' button

      },
    );
```
- The default titles is 'Đồng ý' and 'Bỏ qua' with propzy default icons, so how to customize:
```
    AppAlert().show(
      context,
      'Hi', // the message
      title: 'The title',
      okTitle: 'Đã hiểu',
      cancelTitle: 'Đóng',
      btnOkAction: () {
        debugPrint('OK button is pressed');
      },
      btnCancelAction: () {
        debugPrint('Cancel button is pressed');
      },
      image: Image.asset(
        'assets/images/ic_rocket.png',
        width: 30,
        height: 30,
      ),
      // type: AlertType.info, // use the default rflutter icon
      // Shouldn't use 'image' and 'type' together, the priority is 'type'
    );
```