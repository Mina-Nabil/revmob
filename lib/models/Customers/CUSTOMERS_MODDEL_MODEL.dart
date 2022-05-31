

import 'dart:convert';

import '../cars/car.dart';


// class Body {
//   Body({
//     this.soldOffers,
//   });
//
//   List<SoldOffer> soldOffers;
//
//   factory Body.fromJson(Map<String, dynamic> json) => Body(
//     soldOffers: List<SoldOffer>.from(json["soldOffers"].map((x) => SoldOffer.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "soldOffers": List<dynamic>.from(soldOffers.map((x) => x.toJson())),
//   };
// }

class SoldOffer {
  SoldOffer({
    this.id,


    this.offerRequestId,
    this.offerShowroomId,
    this.offerSellerId,
    this.offerBuyerId,
    this.offerCarId,
    this.offerCanLoan,
    this.offerPrice,
    this.offerMinPayment,
    this.offerStartDate,
    this.offerExpiryDate,
    this.offerSellerComment,
    this.offerStatus,
    this.offerBuyerComment,
    this.offerResponseDate,


    this.createdAt,
    this.updatedAt,


    this.showroom,
    this.seller,
    this.buyer,
    this.car,
    this.colors,
  });

  int? id;

  int? offerRequestId;
  int? offerShowroomId;
  int? offerSellerId;
  int? offerBuyerId;
  int? offerCarId;
  int? offerCanLoan;
  int? offerPrice;
  int? offerMinPayment;
  DateTime? offerStartDate;
  DateTime? offerExpiryDate;
  String? offerSellerComment;
  String? offerStatus;
  dynamic offerBuyerComment;
  dynamic offerResponseDate;


  DateTime? createdAt;
  DateTime? updatedAt;

  Showroom? showroom;
  Seller? seller;
  Buyer? buyer;
  Car? car;
  List<ColorCustom>? colors;

  factory SoldOffer.fromJson(Map<String, dynamic> json) => SoldOffer(
    id: json["id"],

    offerRequestId: json["OFFR_OFRQ_ID"]??'',
    offerShowroomId: json["OFFR_SHRM_ID"]??'',
    offerSellerId: json["OFFR_SLLR_ID"],
    offerBuyerId: json["OFFR_BUYR_ID"],
    offerCarId: json["OFFR_CAR_ID"],
    offerCanLoan: json["OFFR_CAN_LOAN"],
    offerPrice: json["OFFR_PRCE"],
    offerMinPayment: json["OFFR_MIN_PYMT"],
    offerStartDate: DateTime.parse(json["OFFR_STRT_DATE"]),
    offerExpiryDate: DateTime.parse(json["OFFR_EXPR_DATE"]),
    offerSellerComment: json["OFFR_SLLR_CMNT"] == null ? null : json["OFFR_SLLR_CMNT"],
    offerStatus: json["OFFR_STTS"],
    offerBuyerComment: json["OFFR_BUYR_CMNT"],
    offerResponseDate: json["OFFR_RSPN_DATE"],


    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    showroom: Showroom.fromJson(json["showroom"]),
    seller: Seller.fromJson(json["seller"]),
    buyer: Buyer.fromJson(json["buyer"]),
    car: Car.fromJson(json["car"]),
    colors: List<ColorCustom>.from(json["colors"].map((x) => ColorCustom.fromJson(x))),
  );

}

class Buyer {
  Buyer({
    this.id,
    this.buyerName,
    this.buyerMail,
    this.buyerMob1,
    this.buyerBday,
    this.buyerGender,
    this.buyerMailVerified,
    this.buyerMob1Verified,
    this.buyerMob2,
    this.buyerMob2Verified,
    this.buyerBank,
    this.buyerIban,
    this.buyerImage,
    this.buyerNationalId,
    this.buyerFbac,
    this.buyerPushId,
    this.buyerNationalIdFront,
    this.buyerNationalIdBack,
    this.buyerNationalIdStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,

  });

  int? id;
  String? buyerName;
  String? buyerMail;
  String? buyerMob1;
  DateTime? buyerBday;
  String? buyerGender;
  int? buyerMailVerified;
  int? buyerMob1Verified;
  String? buyerMob2;
  int? buyerMob2Verified;
  dynamic buyerBank;
  dynamic buyerIban;
  dynamic buyerImage;
  dynamic buyerNationalId;
  dynamic buyerFbac;
  dynamic buyerPushId;
  dynamic buyerNationalIdFront;
  dynamic buyerNationalIdBack;
  String? buyerNationalIdStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    id: json["id"],
    buyerName: json["BUYR_NAME"],
    buyerMail: json["BUYR_MAIL"] ?? "No Email",
    buyerMob1: json["BUYR_MOB1"] ?? '',
    buyerBday: DateTime.parse(json["BUYR_BDAY"]),
    buyerGender: json["BUYR_GNDR"]??'',
    buyerMailVerified: json["BUYR_MAIL_VRFD"]??'',
    buyerMob1Verified: json["BUYR_MOB1_VRFD"]??'',
    buyerMob2: json["BUYR_MOB2"]??'',
    buyerMob2Verified: json["BUYR_MOB2_VRFD"]??'',
    buyerBank: json["BUYR_BANK"]??'',
    buyerIban: json["BUYR_IBAN"]??'',
    buyerImage: json["BUYR_IMGE"]??'',
    buyerNationalId: json["BUYR_NTID"]??'No data',
    buyerFbac: json["BUYR_FBAC"]??"",
    buyerPushId: json["BUYR_PUSH_ID"]??'',
    buyerNationalIdFront: json["BUYR_NTID_FRNT"]??'',
    buyerNationalIdBack: json["BUYR_NTID_BACK"]??'',
    buyerNationalIdStatus: json["BUYR_NTID_STTS"]??'',
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"]??'',
  );
  String get fullName => buyerName ?? '';
  String get email => buyerMail ?? '';
  String get mob => buyerMob1 ?? '';
  String? get image => buyerImage ?? '';
  Showroom? get showroom => null;

  String get initials {
    String ret = "";
    buyerName?.split(" ").forEach((name) {
      ret += name[0].toUpperCase();
    });
    return ret;
  }

}


// class Car {
//   Car({
//     this.id,
//     this.carModlId,
//     this.carCatg,
//     this.carPrce,
//     this.carVlue,
//     this.carActv,
//     this.carHpwr,
//     this.carSeat,
//     this.carAcc,
//     this.carEncc,
//     this.carTorq,
//     this.carTrns,
//     this.carTpsp,
//     this.carHeit,
//     this.carRims,
//     this.carTrnk,
//     this.carDimn,
//     this.carTtl1,
//     this.carPrg1,
//     this.carTtl2,
//     this.carPrg2,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.image,
//     this.imageUrl,
//     this.name,
//     this.accessories,
//     this.model,
//   });
//
//   int id;
//   int carModlId;
//   CarCatg carCatg;
//   int carPrce;
//   int carVlue;
//   int carActv;
//   int carHpwr;
//   int carSeat;
//   int carAcc;
//   String carEncc;
//   CarTorq carTorq;
//   CarTrns carTrns;
//   int carTpsp;
//   int carHeit;
//   int carRims;
//   int carTrnk;
//   CarDimn carDimn;
//   dynamic carTtl1;
//   dynamic carPrg1;
//   dynamic carTtl2;
//   dynamic carPrg2;
//   dynamic createdAt;
//   UpdatedAt updatedAt;
//   dynamic deletedAt;
//   Image image;
//   String imageUrl;
//   Name name;
//   List<Accessory> accessories;
//   Model model;
//
//   factory Car.fromJson(Map<String, dynamic> json) => Car(
//     id: json["id"],
//     carModlId: json["CAR_MODL_ID"],
//     carCatg: carCatgValues.map[json["CAR_CATG"]],
//     carPrce: json["CAR_PRCE"],
//     carVlue: json["CAR_VLUE"],
//     carActv: json["CAR_ACTV"],
//     carHpwr: json["CAR_HPWR"],
//     carSeat: json["CAR_SEAT"],
//     carAcc: json["CAR_ACC"],
//     carEncc: json["CAR_ENCC"],
//     carTorq: carTorqValues.map[json["CAR_TORQ"]],
//     carTrns: carTrnsValues.map[json["CAR_TRNS"]],
//     carTpsp: json["CAR_TPSP"],
//     carHeit: json["CAR_HEIT"],
//     carRims: json["CAR_RIMS"],
//     carTrnk: json["CAR_TRNK"],
//     carDimn: carDimnValues.map[json["CAR_DIMN"]],
//     carTtl1: json["CAR_TTL1"],
//     carPrg1: json["CAR_PRG1"],
//     carTtl2: json["CAR_TTL2"],
//     carPrg2: json["CAR_PRG2"],
//     createdAt: json["created_at"],
//     updatedAt: updatedAtValues.map[json["updated_at"]],
//     deletedAt: json["deleted_at"],
//     image: imageValues.map[json["image"]],
//     imageUrl: json["image_url"],
//     name: nameValues.map[json["name"]],
//     accessories: List<Accessory>.from(json["accessories"].map((x) => Accessory.fromJson(x))),
//     model: Model.fromJson(json["model"]),
//   );
//
//
// }
//
// class Accessory {
//   Accessory({
//     this.id,
//     this.acsrName,
//     this.acsrArbcName,
//     this.pivot,
//   });
//
//   int? id;
//   String? acsrName;
//   String? acsrArbcName;
//   Pivot? pivot;
//
//   factory Accessory.fromJson(Map<String, dynamic> json) => Accessory(
//     id: json["id"],
//     acsrName: json["ACSR_NAME"],
//     acsrArbcName: json["ACSR_ARBC_NAME"],
//     pivot: Pivot.fromJson(json["pivot"]),
//   );
//
//
// }
//
// class Pivot {
//   Pivot({
//     this.accrCarId,
//     this.accrAcsrId,
//     this.accrVlue,
//   });
//
//   int accrCarId;
//   int accrAcsrId;
//   String accrVlue;
//
//   factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
//     accrCarId: json["ACCR_CAR_ID"],
//     accrAcsrId: json["ACCR_ACSR_ID"],
//     accrVlue: json["ACCR_VLUE"],
//   );
//
//
// }
//
// class Model {
//   Model({
//     this.id,
//     this.modlName,
//     this.modlYear,
//     this.modlBrndId,
//     this.modlTypeId,
//     this.modlArbcName,
//     this.modlOvrv,
//     this.modlBrch,
//     this.modlMain,
//     this.modlImge,
//     this.modlActv,
//     this.imageUrl,
//     this.pdfUrl,
//     this.brand,
//     this.type,
//   });
//
//   int id;
//   ModlName modlName;
//   String modlYear;
//   int modlBrndId;
//   int modlTypeId;
//   ModlArbcName modlArbcName;
//   String modlOvrv;
//   ModlBrch modlBrch;
//   int modlMain;
//   ModlImge modlImge;
//   int modlActv;
//   String imageUrl;
//   String pdfUrl;
//   Brand brand;
//   Type type;
//
//   factory Model.fromJson(Map<String, dynamic> json) => Model(
//     id: json["id"],
//     modlName: modlNameValues.map[json["MODL_NAME"]],
//     modlYear: json["MODL_YEAR"],
//     modlBrndId: json["MODL_BRND_ID"],
//     modlTypeId: json["MODL_TYPE_ID"],
//     modlArbcName: modlArbcNameValues.map[json["MODL_ARBC_NAME"]],
//     modlOvrv: json["MODL_OVRV"],
//     modlBrch: modlBrchValues.map[json["MODL_BRCH"]],
//     modlMain: json["MODL_MAIN"],
//     modlImge: modlImgeValues.map[json["MODL_IMGE"]],
//     modlActv: json["MODL_ACTV"],
//     imageUrl: json["image_url"],
//     pdfUrl: json["pdf_url"],
//     brand: Brand.fromJson(json["brand"]),
//     type: Type.fromJson(json["type"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "MODL_NAME": modlNameValues.reverse[modlName],
//     "MODL_YEAR": modlYear,
//     "MODL_BRND_ID": modlBrndId,
//     "MODL_TYPE_ID": modlTypeId,
//     "MODL_ARBC_NAME": modlArbcNameValues.reverse[modlArbcName],
//     "MODL_OVRV": modlOvrv,
//     "MODL_BRCH": modlBrchValues.reverse[modlBrch],
//     "MODL_MAIN": modlMain,
//     "MODL_IMGE": modlImgeValues.reverse[modlImge],
//     "MODL_ACTV": modlActv,
//     "image_url": imageUrl,
//     "pdf_url": pdfUrl,
//     "brand": brand.toJson(),
//     "type": type.toJson(),
//   };
// }
//
// class Brand {
//   Brand({
//     this.id,
//     this.brndName,
//     this.brndArbcName,
//     this.brndActv,
//     this.brndLogo,
//     this.brndImge,
//     this.logoUrl,
//   });
//
//   int id;
//   BrndName brndName;
//   BrndArbcName brndArbcName;
//   int brndActv;
//   BrndLogo brndLogo;
//   dynamic brndImge;
//   String logoUrl;
//
//   factory Brand.fromJson(Map<String, dynamic> json) => Brand(
//     id: json["id"],
//     brndName: brndNameValues.map[json["BRND_NAME"]],
//     brndArbcName: brndArbcNameValues.map[json["BRND_ARBC_NAME"]],
//     brndActv: json["BRND_ACTV"],
//     brndLogo: brndLogoValues.map[json["BRND_LOGO"]],
//     brndImge: json["BRND_IMGE"],
//     logoUrl: json["logo_url"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "BRND_NAME": brndNameValues.reverse[brndName],
//     "BRND_ARBC_NAME": brndArbcNameValues.reverse[brndArbcName],
//     "BRND_ACTV": brndActv,
//     "BRND_LOGO": brndLogoValues.reverse[brndLogo],
//     "BRND_IMGE": brndImge,
//     "logo_url": logoUrl,
//   };
// }
//
// class Type {
//   Type({
//     this.id,
//     this.typeName,
//     this.typeArbcName,
//   });
//
//   int id;
//   TypeName typeName;
//   TypeArbcName typeArbcName;
//
//   factory Type.fromJson(Map<String, dynamic> json) => Type(
//     id: json["id"],
//     typeName: typeNameValues.map[json["TYPE_NAME"]],
//     typeArbcName: typeArbcNameValues.map[json["TYPE_ARBC_NAME"]],
//   );
//
//
// }

class ColorCustom {
  ColorCustom({
    this.id,
    this.ofclOffrId,
    this.ofclColrId,
    this.ofclAvlb,
    this.modelColor,
  });

  int? id;
  int? ofclOffrId;
  int? ofclColrId;
  int? ofclAvlb;
  dynamic modelColor;

  factory ColorCustom.fromJson(Map<String, dynamic> json) => ColorCustom(
    id: json["id"],
    ofclOffrId: json["OFCL_OFFR_ID"],
    ofclColrId: json["OFCL_COLR_ID"],
    ofclAvlb: json["OFCL_AVLB"],
    modelColor: json["model_color"],
  );
}

class Seller {
  Seller({
    this.id,
    this.sellerName,
    this.sellerMail,
    this.sellerMob1,
    this.sellerImge,
    this.sellerMailVerified,
    this.sellerMob1Verified,
    this.sellerMob2,
    this.sellerMob2Verified,
    this.sellerPushId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sellerShowroomId,
    this.sellerCanMngr,
    this.carsSoldPrice,
    this.carsSoldCount,
    this.imageUrl,
  });

  int? id;
  String? sellerName;
  String? sellerMail;
  String? sellerMob1;
  dynamic sellerImge;
  int? sellerMailVerified;
  int? sellerMob1Verified;
  dynamic sellerMob2;
  int? sellerMob2Verified;
  dynamic sellerPushId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? sellerShowroomId;
  int? sellerCanMngr;
  int? carsSoldPrice;
  int? carsSoldCount;
  dynamic imageUrl;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    sellerName: json["SLLR_NAME"],
    sellerMail: json["SLLR_MAIL"],
    sellerMob1: json["SLLR_MOB1"],
    sellerImge: json["SLLR_IMGE"],
    sellerMailVerified: json["SLLR_MAIL_VRFD"],
    sellerMob1Verified: json["SLLR_MOB1_VRFD"],
    sellerMob2: json["SLLR_MOB2"],
    sellerMob2Verified: json["SLLR_MOB2_VRFD"],
    sellerPushId: json["SLLR_PUSH_ID"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    sellerShowroomId: json["SLLR_SHRM_ID"],
    sellerCanMngr: json["SLLR_CAN_MNGR"],
    carsSoldPrice: json["cars_sold_price"],
    carsSoldCount: json["cars_sold_count"],
    imageUrl: json["image_url"],
  );
//18

}

class Showroom {
  Showroom({
    this.id,

    this.showroomOwnerId,
    this.showroomCityId,
    this.showroomName,
    this.showroomMail,
    this.showroomAddress,
    this.showroomMob1,
    this.showroomVerified,
    this.showroommActv,
    this.showroomMailVerified,
    this.showroomMob1Verified,
    this.showroomMob2,
    this.showroomMob2Verified,
    this.showroomRecord,
    this.showroomIamge,
    this.showroomRecordStatus,
    this.showroomRecordFront,
    this.showroomRecordBack,
    this.showroomVerifiedSince,
    this.showroomBalance,
    this.showroomOffersSent,
    this.showroomOffersAccepted,
    this.showroomBankId,

    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.imageUrl,
    this.owner,
  });

  int? id;

  int? showroomOwnerId;
  int? showroomCityId;
  String? showroomName;
  String? showroomMail;
  String? showroomAddress;
  String? showroomMob1;
  int? showroomVerified;
  int? showroommActv;
  int? showroomMailVerified;
  int? showroomMob1Verified;
  dynamic showroomMob2;
  int? showroomMob2Verified;
  dynamic showroomRecord;
  dynamic showroomIamge;
  String? showroomRecordStatus;
  dynamic showroomRecordFront;
  dynamic showroomRecordBack;
  dynamic showroomVerifiedSince;
  int? showroomBalance;
  int? showroomOffersSent;
  int? showroomOffersAccepted;
  dynamic showroomBankId;

  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic imageUrl;
  Seller? owner;

  factory Showroom.fromJson(Map<String, dynamic> json) => Showroom(
    id: json["id"],

    showroomOwnerId: json["SHRM_OWNR_ID"],
    showroomCityId: json["SHRM_CITY_ID"],
    showroomName: json["SHRM_NAME"],
    showroomMail: json["SHRM_MAIL"],
    showroomAddress: json["SHRM_ADRS"],
    showroomMob1: json["SHRM_MOB1"],
    showroomVerified: json["SHRM_VRFD"],
    showroommActv: json["SHRM_ACTV"],
    showroomMailVerified: json["SHRM_MAIL_VRFD"],
    showroomMob1Verified: json["SHRM_MOB1_VRFD"],
    showroomMob2: json["SHRM_MOB2"],
    showroomMob2Verified: json["SHRM_MOB2_VRFD"],
    showroomRecord: json["SHRM_RECD"],
    showroomIamge: json["SHRM_IMGE"],
    showroomRecordStatus: json["SHRM_RECD_STTS"],
    showroomRecordFront: json["SHRM_RECD_FRNT"],
    showroomRecordBack: json["SHRM_RECD_BACK"],
    showroomVerifiedSince: json["SHRM_VRFD_SNCE"],
    showroomBalance: json["SHRM_BLNC"],
    showroomOffersSent: json["SHRM_OFRS_SENT"],
    showroomOffersAccepted: json["SHRM_OFRS_ACPT"],
    showroomBankId: json["SHRM_BANK_ID"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    imageUrl: json["image_url"],
    owner: Seller.fromJson(json["owner"]),
  );

}

