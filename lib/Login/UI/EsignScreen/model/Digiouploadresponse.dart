class Digiouploadresponse {
  int statusCode;
  String body;
  Headers headers;

  Digiouploadresponse({this.statusCode, this.body, this.headers});

  Digiouploadresponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    body = json['body'];
    headers =
        json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['body'] = this.body;
    if (this.headers != null) {
      data['headers'] = this.headers.toJson();
    }

    return data;
  }
}

class Headers {
  String cacheControl;
  String contentType;
  String date;
  String xContentTypeOptions;
  String contentLength;
  String connection;

  Headers(
      {this.cacheControl,
      this.contentType,
      this.date,
      this.xContentTypeOptions,
      this.contentLength,
      this.connection});

  Headers.fromJson(Map<String, dynamic> json) {
    cacheControl = json['cache-control'];
    contentType = json['content-type'];
    date = json['date'];
    xContentTypeOptions = json['x-content-type-options'];
    contentLength = json['content-length'];
    connection = json['connection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cache-control'] = this.cacheControl;
    data['content-type'] = this.contentType;
    data['date'] = this.date;
    data['x-content-type-options'] = this.xContentTypeOptions;
    data['content-length'] = this.contentLength;
    data['connection'] = this.connection;
    return data;
  }
}

class ReqHeaders {
  String authorization;
  String contentType;
  int contentLength;

  ReqHeaders({this.authorization, this.contentType, this.contentLength});

  ReqHeaders.fromJson(Map<String, dynamic> json) {
    authorization = json['Authorization'];
    contentType = json['content-type'];
    contentLength = json['content-length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authorization'] = this.authorization;
    data['content-type'] = this.contentType;
    data['content-length'] = this.contentLength;
    return data;
  }
}
