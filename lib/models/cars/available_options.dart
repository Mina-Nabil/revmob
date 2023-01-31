class AvailableOption {
  AvailableOption({
    this.id,
    this.adjtModlId,
    this.adjtName,
    this.adjtActv,
    this.adjtDesc,
    this.defaultOption,
    this.options,
  });

  int? id;
  int? adjtModlId;
  String? adjtName;
  int? adjtActv;
  dynamic adjtDesc;
  Option? defaultOption;
  List<Option>? options;

  factory AvailableOption.fromJson(Map<String, dynamic> json) =>
      AvailableOption(
        id: json["id"] == null ? null : json["id"],
        adjtModlId: json["ADJT_MODL_ID"] == null ? null : json["ADJT_MODL_ID"],
        adjtName: json["ADJT_NAME"] == null ? null : json["ADJT_NAME"],
        adjtActv: json["ADJT_ACTV"] == null ? null : json["ADJT_ACTV"],
        adjtDesc: json["ADJT_DESC"],
        defaultOption: json["default_option"] == null
            ? null
            : Option.fromJson(json["default_option"]),
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );
}

class Option {
  Option({
    this.id,
    this.adopAdjtId,
    this.adopName,
    this.adopImge,
    this.adopDflt,
    this.adopActv,
    this.adopDesc,
    this.imageUrl,
  });

  bool selected = false;
  int? id;
  int? adopAdjtId;
  String? adopName;
  dynamic adopImge;
  int? adopDflt;
  int? adopActv;
  dynamic adopDesc;
  dynamic imageUrl;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"] == null ? null : json["id"],
    adopAdjtId: json["ADOP_ADJT_ID"] == null ? null : json["ADOP_ADJT_ID"],
    adopName: json["ADOP_NAME"] == null ? null : json["ADOP_NAME"],
    adopImge: json["ADOP_IMGE"],
    adopDflt: json["ADOP_DFLT"] == null ? null : json["ADOP_DFLT"],
    adopActv: json["ADOP_ACTV"] == null ? null : json["ADOP_ACTV"],
    adopDesc: json["ADOP_DESC"],
    imageUrl: json["image_url"],
  );
}
