enum PostType {
  text('text'),
  image('image');

  final String type;
  const PostType(this.type);
}

extension ConvertPost on String {
  PostType toEnumPostType() {
    switch (this) {
      case 'image':
        return PostType.image;
      default:
        return PostType.text;
    }
  }
}
