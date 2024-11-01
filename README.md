- Set up firebase with flutter project
- Make sure you enabled realtime database and cloud storage
- Add firebase packages to project:

  firebase_core: ^3.1.0
  firebase_auth: ^5.1.0
  firebase_database: ^11.0.1
  firebase_storage: ^12.0.1

- Check for updates in the welcome screen through the package_info_plus package
  package_info_plus: ^8.0.3

- Show blocking update required dialog, if user taps on update button then we go to a url (through url launcher package) which contains the apk file to download 
  url_launcher: ^6.3.1

- Alternative method, ota update package (Android only)
- Alternative backend, Supabase
