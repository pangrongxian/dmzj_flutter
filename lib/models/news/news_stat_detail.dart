import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class NewsDetailStatModel {
  NewsDetailStatModel({
    this.title,
    this.rowPicUrl,
    this.commentAmount,
    this.moodAmount,
  });

  factory NewsDetailStatModel.fromJson(Map<String, dynamic> jsonRes) =>
      NewsDetailStatModel(
        title: asT<String?>(jsonRes['title']),
        rowPicUrl: asT<String?>(jsonRes['row_pic_url']),
        commentAmount:
            int.parse(asT<String?>(jsonRes['comment_amount']) ?? "0"),
        moodAmount: asT<int?>(jsonRes['mood_amount']),
      );

  String? title;
  String? rowPicUrl;
  int? commentAmount;
  int? moodAmount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'row_pic_url': rowPicUrl,
        'comment_amount': commentAmount,
        'mood_amount': moodAmount,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }
}
