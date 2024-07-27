# Flutter Con Kenya 2024

This is the official Flutter Con Kenya 2024 mobile application. The application is built using Flutter and Dart programming language. The application is designed to provide information about the conference, speakers, schedule, and sponsors. The application also provides a platform for attendees to interact with each other and the speakers.

## Getting Started

To get started with this project, you need to have Flutter installed on your machine. You can follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install) to install Flutter on your machine.

### Install the dependencies
Once you have Flutter installed, you can clone this repository and run the following command to install the dependencies:

```bash
flutter pub get
```

### Update Code generation files

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Running the app
After installing the dependencies, you can run the application using the following command:

```bash
flutter run --dart-define-from-file keys.dev.json
```

This will start the application on your connected device or emulator.

### Build the App

- **AppTester (Firebase Distribution):**

    ```bash
    flutter build apk --flavor uat -t lib/main_uat.dart --dart-define-from-file keys.dev.json --no-tree-shake-icons
    ```

- **Production (For Play Store):**

    ```bash
    flutter build appbundle --flavor prod -t lib/main_prod.dart --dart-define-from-file keys.prod.json --no-tree-shake-icons
    ```

## Features

App will have the following features:

- Sessions
- Feed
- About
- Home
- Speakers
- Sponsors
- Authentication
- Feedback

## Designs

This is the link to the app designs:  
Light Theme: [https://xd.adobe.com/view/dd5d0245-b92b-4678-9d4a-48b3a6f48191-880e/](https://xd.adobe.com/view/dd5d0245-b92b-4678-9d4a-48b3a6f48191-880e/)  
Dark Theme: [https://xd.adobe.com/view/5ec235b6-c3c6-49a9-b783-1f1303deb1a8-0b91/](https://xd.adobe.com/view/5ec235b6-c3c6-49a9-b783-1f1303deb1a8-0b91/)

REST API: [Postman Files](https://documenter.getpostman.com/view/3385291/SzS4TTXb?version=latest#intro)

## Contributing

If you would like to contribute to this project, you can first create an issue describing the feature you'd like
to do. This helps prevent duplication of effort (working on something someone else is already working on). 

After the discussion on the GitHub issue,you can fork the repository and create a new branch for your changes. Once you have made your changes, you can create a pull request to merge your changes into the main branch.
For much smaller fixes like typos, you can skip the create issue step.

Tip: Keep feature contributions small and focused. This makes it easy to review contributions and spot errors if any

## App Architecture
### State Management

For this project, we use flutter_bloc. You can find documentation [here](https://bloclibrary.dev)

The [architecture portion](https://bloclibrary.dev/architecture/) has a really good explanation of how we plan
to architect the app conceptually.

### Folder Structure

We use a folder first then a feature based approach to structuring folders. This would look similar to:

lib
  - repositories
    - repository.dart
  - blocs
    - auth
    - speakers
  - ui
    - auth
    - speakers

If you have a preferred different approach to structuring your folders, [join the discussion here](https://github.com/droidconKE/flutterconKEApp/discussions/10).

### Routing

For routing, we will use the [go_router package](https://pub.dev/packages/go_router). It offers the benefit of
simplifying the usage of navigator 2.0, which is helpful for deep linking


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Output
```markdown
# Flutter Con Kenya 2024

