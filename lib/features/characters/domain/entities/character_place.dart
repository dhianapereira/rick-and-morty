class CharacterPlace {
  const CharacterPlace({required this.name, required this.url});

  final String name;
  final String url;

  bool get hasDetails => url.isNotEmpty;
}
