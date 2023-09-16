class StateModel {
  String id, name;
  StateModel(data)
      : id = data["id"]?.toString() ?? "",
        name = data["name"]?.toString() ?? "";
}

class DistrictModel {
  String id, name;
  DistrictModel(data)
      : id = data["id"]?.toString() ?? "",
        name = data["name"]?.toString() ?? "";
}

class CityModel {
  String id, name;
  CityModel(data)
      : id = data["id"]?.toString() ?? "",
        name = data["name"]?.toString() ?? "";
}

class AreaModel {
  String id, name;
  AreaModel(data)
      : id = data["id"]?.toString() ?? "",
        name = data["name"]?.toString() ?? "";
}

class BranchModel {
  String id, bankBranchTypeId, name, contact, address, type;
  BranchModel(data)
      : id = data["id"].toString(),
        bankBranchTypeId = data["bank_branch_type_id"]?.toString() ?? "",
        name = data["branch_name"]?.toString() ?? "",
        contact = data["branch_contact"]?.toString() ?? "",
        address = data["branch_address"]?.toString() ?? "",
        type = data["branch_type"]?.toString() ?? "";
}

class BankModel {
  String id , userDetailID, accountNumber, ifscCode, upiID;
  BankModel({data = const {}})
      : id = data["id"]?.toString() ?? "",
        userDetailID = data["user_detail_id"]?.toString() ?? "",
        accountNumber = data["account_no"]?.toString() ?? "",
        ifscCode = data["ifsc_code"]?.toString() ?? "",
        upiID = data["upi_id"]?.toString() ?? "";
}
