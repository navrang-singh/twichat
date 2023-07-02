import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/appwrite_const.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConsts.endpoint)
      .setProject(AppwriteConsts.projectID);
});

final appwriteAccountProvider = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteRealtimeProvider = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appwriteRealtimeProvider2 = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appwriteRealtimeProvider3 = Provider((ref) {
  Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
