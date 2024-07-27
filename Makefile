icons:
		dart run flutter_launcher_icons:main && dart run icons_launcher:create

splash:
		dart run flutter_native_splash:create

gen:
		dart run build_runner build --delete-conflicting-outputs

fmt:
		dart fix --apply && dart format lib test

loc:
		flutter gen-l10n

apk:
		flutter build apk  --flavor production --target lib/main_production.dart -vv


aab:
		flutter build appbundle  --flavor production --target lib/main_production.dart

run:
		flutter run --release  --flavor production --target lib/main_production.dart
	
build: 	# Run the app on a new computer with Flutter 2.3 installed
		flutter pub get && make gen && make run

ipa:
		flutter build ipa  --flavor production --target lib/main_production.dart -vv


web:
		flutter build web --target lib/main_production.dart

base64:
		cat path/to/file.png | openssl base64 | tr -d '\n' | pbcopy

sha1:
		keytool -list -v -keystore ~/.android/debug.keystore

pods:
		cd ios && pod install --repo-update --verbose && cd ..