class ListItem {
  final String id;
  final String naslov;
  final String datum;
  final String vreme;

  ListItem({
    required this.id,
    required this.naslov,
    required this.datum,
    required this.vreme,
  });

  Map<String, dynamic> toJSON() =>
      {'id': id, 'naslov': naslov, 'datum': datum, 'vreme': vreme};

  static ListItem fromJSON(Map<String, dynamic> json) => ListItem(
      id: json['id'],
      naslov: json['naslov'],
      datum: json['datum'],
      vreme: json['vreme']);
}
