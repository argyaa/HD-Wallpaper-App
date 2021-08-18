class SearchModel {
  String creator;
  int status;
  List result;

  SearchModel({this.creator, this.result, this.status});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      creator: json["creator"],
      status: json["status"],
      result: json["result"],
    );
  }
}
