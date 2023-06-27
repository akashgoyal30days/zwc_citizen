// To parse this JSON data, do
//
//     final getAllRedeemRequestModel = getAllRedeemRequestModelFromJson(jsonString);

import 'dart:convert';

GetAllRedeemRequestModel getAllRedeemRequestModelFromJson(String str) => GetAllRedeemRequestModel.fromJson(json.decode(str));

String getAllRedeemRequestModelToJson(GetAllRedeemRequestModel data) => json.encode(data.toJson());

class GetAllRedeemRequestModel {
    bool? status;
    List<Datum>? data;

    GetAllRedeemRequestModel({
        this.status,
        this.data,
    });

    factory GetAllRedeemRequestModel.fromJson(Map<String, dynamic> json) => GetAllRedeemRequestModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? userDetailId;
    String? redeemAmount;
    String? requestDateTime;
    String? requestStatus;
    String? statusRemark;
    String? lcb;
    String? lct;
    String? orderId;
    String? utrNo;
    String? tranStatus;

    Datum({
        this.id,
        this.userDetailId,
        this.redeemAmount,
        this.requestDateTime,
        this.requestStatus,
        this.statusRemark,
        this.lcb,
        this.lct,
        this.orderId,
        this.utrNo,
        this.tranStatus,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userDetailId: json["user_detail_id"],
        redeemAmount: json["redeem_amount"],
        requestDateTime: json["request_date_time"] == null ? null : json["request_date_time"],
        requestStatus: json["request_status"],
        statusRemark: json["status_remark"],
        lcb: json["lcb"],
        lct: json["lct"] == null ? null :json["lct"],
        orderId: json["order_id"],
        utrNo: json["utr_no"],
        tranStatus: json["tran_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_detail_id": userDetailId,
        "redeem_amount": redeemAmount,
        "request_date_time": requestDateTime,
        "request_status": requestStatus,
        "status_remark": statusRemark,
        "lcb": lcb,
        "lct": lct,
        "order_id": orderId,
        "utr_no": utrNo,
        "tran_status": tranStatus,
    };
}


