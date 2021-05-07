import 'dart:convert' show json;

class ComicCategoryDetailFilter {
  String? _title;
  String? get title => _title;
  List<ComicCategoryDetailFilterItem>? _items;
  List<ComicCategoryDetailFilterItem>? get items => _items;

  ComicCategoryDetailFilterItem? _item;
  ComicCategoryDetailFilterItem? get item => _item;
  set item(value) {
    _item = value;
  }

  ComicCategoryDetailFilter({
    String? title,
    List<ComicCategoryDetailFilterItem>? items,
  })  : _title = title,
        _items = items;
  factory ComicCategoryDetailFilter.fromJson(jsonRes) {
    List<ComicCategoryDetailFilterItem>? items =
        jsonRes['items'] is List ? [] : null;
    for (var item in jsonRes['items'] ?? []) {
      items!.add(ComicCategoryDetailFilterItem.fromJson(item));
    }

    return ComicCategoryDetailFilter(
      title: jsonRes['title'],
      items: items,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': _title,
        'items': _items,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class ComicCategoryDetailFilterItem {
  int? _tagId;
  int? get tagId => _tagId;
  String? _tagName;
  String? get tagName => _tagName;

  ComicCategoryDetailFilterItem({
    int? tagId,
    String? tagName,
  })  : _tagId = tagId,
        _tagName = tagName;
  factory ComicCategoryDetailFilterItem.fromJson(jsonRes) =>
      ComicCategoryDetailFilterItem(
        tagId: jsonRes['tag_id'],
        tagName: jsonRes['tag_name'],
      );
  Map<String, dynamic> toJson() => {
        'tag_id': tagId,
        'tag_name': tagName,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
