class AppwriteConsts {
  static String projectID = "64913003aa001ca9bdcd";
  static String databaseID = "6491346ba71a8f8e1cff";
  static String endpoint = "http://10.0.2.2:80/v1";
  static String userCollectionID = "6497f04c5c903503c7bf";
  static String userPostCollectionID = "64999364415f21acae0b";
  static String bucketID = "64999ea46cfd0ad689a7";
  static String notificationCollectionID = "64a124a761d89c33791e";
  static String imagUrls(String imageID) =>
      '$endpoint/storage/buckets/$bucketID/files/$imageID/view?project=$projectID&mode=admin';
}
