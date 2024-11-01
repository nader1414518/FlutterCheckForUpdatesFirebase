> Set up firebase with flutter project
2 - Make sure you enabled realtime database and cloud storage
3 - Add firebase packages to project:

  firebase_core: ^3.1.0
  firebase_auth: ^5.1.0
  firebase_database: ^11.0.1
  firebase_storage: ^12.0.1

4 - Check for updates in the welcome screen through the package_info_plus package
  package_info_plus: ^8.0.3

5 - Show blocking update required dialog, if user taps on update button then we go to a url (through url launcher package) which contains the apk file to download 
  url_launcher: ^6.3.1

6 - Alternative method, ota update package (Android only)
7 - Alternative backend, Supabase
