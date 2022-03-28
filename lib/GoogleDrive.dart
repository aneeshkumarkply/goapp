import 'dart:io';
import 'package:googleapis/adsense/v1_4.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:goapp/SecureStorage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

const _clientId = "451960519511-b356b86232ed4fd6etv6iidt5kqhf2t7.apps.googleusercontent.com";
const _scopes = ['https://www.googleapis.com/auth/drive'];

class GoogleDrive {
  final storage = SecureStorage();

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(_clientId), _scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              credentials["refreshToken"],
              _scopes));
    }
  }


// Use service account credentials to get an authenticated and auto refreshing client.
  Future<AuthClient> obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": "7147d50732d671d4c5b9398f216c07fc4bb04165",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC4D+bM3Y78gaof\nCEbItrEE8v5dRupNw5ecTj8aM0e6sG6xZ8BLzGbCwwlfrdARU/DDe/vL8t8HOBU0\n98wFTBx2IwOiaIqgxVMnkee106khLN3v82j0ISX/SZdjKmpPEqikqYJa6DjkRnmA\n0Zusnn0CsJ3CqfD7GEr03XyKgaJRGC+uunJemZ417Kb41NgRcRQLqag6Is7Fsx70\nT6TXW3TWRDlEsk7lO0gP9A2YjQPXUerXw8bGL/XiovpT+P6qgNBo+Adpd33ZlNrX\n1sNzPHUKk0ktxRx0m53+6Ic2hfI9XcQVx32dZw4XV3LCEVXh/MwyprW9PPkIHhHT\n45Cxd4+PAgMBAAECggEAWqgCXo8VuQrIVsaFzqAk6jIg1KJ0Dt8yUls7u1TclHgH\n3TsjvHGtf2n+uPBsFczJPg9YAqjZ7r1RvKf8BfPp5Mn0JU7mUK8/+LJldOoOWHe3\nzFKQNAYLqASAGuiuOcoP5CJVQR81vkFz4N3clhXtrqB8438+YP4jFR3uFG4rG1M9\n/+eyEn5wR+RXKjA4cn5+KqunVXuPeaYzugzt5z6os8eKrvpFfOmSXhQmerbFegLF\nCJ1Z4sa3ggBH+Koi7j5DrJ+AbcTrGHxl5aZVNtM0Xyi+DPAasbrPB66sUffdHvyp\nSvt3lKaF+7HRTvZMNmx+35ShVkcJq5exvU+N8dOSyQKBgQD0NPFaFOsCOnO9zVxg\nRzYprcdbVlOUwMkM553Ow5jYCQwZwjZFwPCsQ51MmnkKw9VC9ZefaT73viqoBe+k\nuzhuAz5Nda8iFIJPESj+7On8y5KbECnuOcXqvyJL5RqycpeMUMWV9XD/VqIPBHbA\nGz0AlCyaVyHqb23Lr0nMBpoGDQKBgQDA82hWsbcGlhJI/n3dIfYyhTTiYKBGvRZQ\nUhWdWraM007llilMH9FmLjOVhEIU2ADrFBwpQ/RUUkOxTQ9n38bBVqfNX27sXq5k\nZB7IjWSlSlvV8GIa62U1/D7YFw3pB50UCzyvFZq4jPQRLqU6FQFXbnOgz/i/ocIx\n8Wun/pBBCwKBgESV0esA0PfxPqxhzr3jghy2h7TpS9QNSOns6u81E+oosFNTrjZs\n96sJ2lW3VKNnWK/Tld/ZiSu/Ju/FqwZS5ohPNOJAWQ1zQR2/rgnas+Shr+0I3x3e\n7+z7/T/fel3/vPxVewigxDmSNTWOhWNywvE0rEo0invzC50W/9zjRcLJAoGBAIkk\n+YaVbpgZ1wlXCjNBTnL+R2aYc5OUFuYkUgS0U4ipMSzynIvlGbtdH4EorqeOGKj+\ndD3IdUPx7Pd65HZakjUd2MubB4aujZoBp/e4uE7cGYZpA/JKWngSwMBrMpHtvXJf\nwlRYMM74MQp9cydjgr6YXUtyR0Y+PX+uL20K/ZGdAoGBAKXRI+hvla80xXj6qXea\nG1+buk33L42IHQ7wp+1EsfczI25MN2aXlONp0ckP1q/pNX1kUqo9DDva7JPBaydB\nhx6C2ZwKkHNUW0enr4KI4xTIMeNvzoCNhWKvCRyjZ46QbB1OIlEKCOdpX6DVP8BG\n8st6v9jbN0kCiNWCVbPjTH2r\n-----END PRIVATE KEY-----\n",
      "client_email": "goapp-727cf@appspot.gserviceaccount.com",
      "client_id": "107462398856891276746.apps.googleusercontent.com",
      "type": "service_account"
    });
    var scopes = _scopes;

    AuthClient client = await clientViaServiceAccount(
        accountCredentials, scopes);

    return client; // Remember to close the client when you are finished with it.

  }

// check if the directory forlder is already available in drive , if available return its id
// if not available create a folder in drive and return id
//   if not able to create id then it means user authetication has failed
  Future<String?> _getFolderId(ga.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "serviceupload";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("Sign-in first Error");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      return null;
    }
  }


  uploadFileToGoogleDrive(File file) async {
    //var client = await getHttpClient();
     var client = await obtainAuthenticatedClient();
    var drive = ga.DriveApi(client);
    var response;
    String? folderId = await _getFolderId(drive);
    if (folderId == null) {
      print("Sign-in first Error");
    } else {
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [folderId];
      fileToUpload.name = p.basename(file.absolute.path);
      response = await drive.files.create(
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      print(response);
      final fileId = response.id;
      ga.Permission mypermission = ga.Permission();
      mypermission.role = "reader";
      mypermission.type = "anyone";
      var response1 = await drive.permissions.create(mypermission, fileId!);
      print(response1);
      // print("Fileid: ${response.driveId}");
      print("Fileid: https://drive.google.com/file/d/${response
          .id}/view?usp=sharing");
      client.close();

      //return "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
    }
    // return response;
    // return "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
    return response.id;
  }

  downloadGoogleDriveFile(String fName, String id) async {
    //print ( 'Downloading file $ file ' );
    String myDownloadDirectory = ((await getApplicationDocumentsDirectory())
        .path);
    String myfilename = fName;
   // var client = await getHttpClient();
     var client = await obtainAuthenticatedClient();

    var drive = ga.DriveApi(client);
    // final reference = file.reference as google. File ;
    drive.files.get(id, downloadOptions: DownloadOptions.fullMedia)
        .then((media) {
      if (media is ga.Media) {
        var bytes = <int>[];
        media.stream.listen((data) {
          print('Adding data to file');
          bytes.insertAll(bytes.length, data);
        }, onDone: () async {
          final directory = await getExternalStorageDirectory();
          final file = new File('$myDownloadDirectory/$myfilename');

          file.writeAsBytesSync(bytes);

          print('Full download, path:' + file.path);
        });
      } else {
        print('Download failed');
      }
    });
  }

  listGoogleDriveFiles() async {
   // var client = await getHttpClient();
    var client = await obtainAuthenticatedClient();
    var drive = ga.DriveApi(client);
    ga.FileList list;
    drive.files.list().then((value) {

        list = value;
        int? length = list.files?.length;
        for (var i = 0; i < length!; i++) {
          print("Id: ${list.files![i].id} File Name:${list.files![i].name}");
        }
      });


  }


  deleteGoogleDriveFiles(String file_id) async {
   // var client = await getHttpClient();
    var client = await obtainAuthenticatedClient();
    var drive = ga.DriveApi(client);
    void response;
   // if (folder_id.isNotEmpty) {
   //   response = await drive.files.list(
    //      pageSize: 1000, q: "'" + folder_id + "' in parents");
   // }
   // else {
      response = await drive.files.delete(file_id);
   // }


    return response;
  }
  }

