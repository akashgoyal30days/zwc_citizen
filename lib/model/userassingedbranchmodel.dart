// To parse this JSON data, do
//
//     final userbranchassingeddataModel = userbranchassingeddataModelFromJson(jsonString);

import 'dart:convert';

UserbranchassingeddataModel userbranchassingeddataModelFromJson(String str) => UserbranchassingeddataModel.fromJson(json.decode(str));

String userbranchassingeddataModelToJson(UserbranchassingeddataModel data) => json.encode(data.toJson());

class UserbranchassingeddataModel {
    String? id;
    String? bankBranchId;
    String? userDetailId;
    String? userRoleId;
    String? branchName;
    String? bankBranchTypeId;
    String? branchContact;
    String? branchEmail;

    UserbranchassingeddataModel({
        this.id,
        this.bankBranchId,
        this.userDetailId,
        this.userRoleId,
        this.branchName,
        this.bankBranchTypeId,
        this.branchContact,
        this.branchEmail,
    });

    factory UserbranchassingeddataModel.fromJson(Map<String, dynamic> json) => UserbranchassingeddataModel(
        id: json["id"],
        bankBranchId: json["bank_branch_id"],
        userDetailId: json["user_detail_id"],
        userRoleId: json["user_role_id"],
        branchName: json["branch_name"],
        bankBranchTypeId: json["bank_branch_type_id"],
        branchContact: json["branch_contact"],
        branchEmail: json["branch_email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bank_branch_id": bankBranchId,
        "user_detail_id": userDetailId,
        "user_role_id": userRoleId,
        "branch_name": branchName,
        "bank_branch_type_id": bankBranchTypeId,
        "branch_contact": branchContact,
        "branch_email": branchEmail,
    };
}
