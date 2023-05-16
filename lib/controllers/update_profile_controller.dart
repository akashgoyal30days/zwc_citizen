import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:zwc/data/shared_preference.dart';

import '../api/api_client.dart';
import '../api/urls.dart';
import '../model/locaiton_models.dart';

class UpdateLocationController extends GetxController {
  bool showLoading = false,
      loadingStates = false,
      loadingDistricts = false,
      loadingCities = false,
      loadingAreas = false,
      loadingBranches = false;

  List<StateModel> states = [];
  List<CityModel> cities = [];
  List<DistrictModel> districts = [];
  List<AreaModel> areas = [];
  List<BranchModel> branches = [];
  StateModel? selectedState;
  DistrictModel? selectedDistrict;
  CityModel? selectedCity;
  AreaModel? selectedArea;
  BranchModel? selectedBranch;

  UpdateLocationController() {
    getStates();
    selectedState = StateModel({
      "id": SharedPreferenceFunctions.getUserData("state_id") ?? "",
      "name": SharedPreferenceFunctions.getUserData("state") ?? "",
    });
    selectedDistrict = DistrictModel({
      "id": SharedPreferenceFunctions.getUserData("district_id") ?? "",
      "name": SharedPreferenceFunctions.getUserData("district") ?? "",
    });
    selectedCity = CityModel({
      "id": SharedPreferenceFunctions.getUserData("city_id") ?? "",
      "name": SharedPreferenceFunctions.getUserData("city") ?? "",
    });
    selectedArea = AreaModel({
      "id": SharedPreferenceFunctions.getUserData("area_id") ?? "",
      "name": SharedPreferenceFunctions.getUserData("area") ?? "",
    });
    selectedBranch = BranchModel({
      "id": (SharedPreferenceFunctions.getUserData("branch_assigned") ?? [])[0]
                  ?["bank_branch_id"]
              ?.toString() ??
          "",
      "branch_name":
          (SharedPreferenceFunctions.getUserData("branch_assigned") ?? [])[0]
                  ?["branch_name"] ??
              "",
    });
    if (selectedState != null) {
      states.add(selectedState!);
    }
    if (selectedDistrict != null) {
      districts.add(selectedDistrict!);
    }
    if (selectedCity != null) {
      cities.add(selectedCity!);
    }
    if (selectedArea != null) {
      areas.add(selectedArea!);
    }
    if (selectedBranch != null) {
      branches.add(selectedBranch!);
    }
    getAreas();
    getDistricts();
    getCities();
    getBranches();
  }

  getStates() async {
    states.clear();
    loadingStates = true;
    update();

    var response = await APIClient.post(URLS.getStates);

    if (response.statusCode != 200) {
      loadingStates = false;
      update();
      return false;
    }

    var body = json.decode(response.body) ?? {};
    for (var state in body["data"] as List) {
      if (selectedState != null &&
          selectedState!.id == state["id"].toString()) {
        continue;
      }
      states.add(StateModel(state));
    }

    loadingStates = false;
    update();
  }

  selectState(StateModel? state) {
    log("statename ${state?.name}");
    selectedState = state;
    districts.clear();
    cities.clear();
    areas.clear();
    branches.clear();
    selectedDistrict = selectedCity = selectedArea = selectedBranch = null;
    getDistricts();
  }

  getDistricts() async {
    loadingDistricts = true;
    update();

    var response = await APIClient.post(URLS.getDistricts, body: {
      "state_id": selectedState?.id ?? "",
    });

    if (response.statusCode != 200) {
      loadingDistricts = false;
      update();
      return false;
    }

    var body = json.decode(response.body) ?? {};
    for (var district in body["data"] as List) {
      if (selectedDistrict != null &&
          selectedDistrict!.id == district["id"].toString()) {
        continue;
      }
      districts.add(DistrictModel(district));
    }

    loadingDistricts = false;
    update();
  }

  selectDistrict(DistrictModel? district) {
    selectedDistrict = district;
    cities.clear();
    areas.clear();
    branches.clear();
    selectedCity = selectedArea = selectedBranch = null;
    getCities();
  }

  getCities() async {
    log("Came here");
    loadingCities = true;
    update();

    var response = await APIClient.post(URLS.getCities,
        body: {"district_id": selectedDistrict?.id ?? ""});

    if (response.statusCode != 200) {
      loadingCities = false;
      update();
      return false;
    }

    var body = json.decode(response.body) ?? {};
    log(response.body);
    for (var city in body["data"] as List) {
      if (selectedCity != null && selectedCity!.id == city["id"].toString()) {
        continue;
      }
      cities.add(CityModel(city));
    }
    log(cities.toString());
    loadingCities = false;
    update();
  }

  selectCity(CityModel? city) {
    selectedCity = city;
    areas.clear();
    branches.clear();
    selectedArea = selectedBranch = null;
    getAreas();
  }

  getAreas() async {
    loadingAreas = true;
    update();

    var response = await APIClient.post(URLS.getAreas,
        body: {"city_id": selectedCity?.id ?? ""});

    if (response.statusCode != 200) {
      loadingAreas = false;
      update();
      return false;
    }

    var body = json.decode(response.body) ?? {};
    log(response.body);
    for (var area in body["data"] as List) {
      if (selectedArea != null && selectedArea!.id == area["id"].toString()) {
        continue;
      }
      areas.add(AreaModel(area));
    }

    loadingAreas = false;
    update();
  }

  selectArea(AreaModel? area) {
    selectedArea = area;
    branches.clear();
    selectedBranch = null;
    getBranches();
  }

  getBranches() async {
    loadingBranches = true;
    update();
    log("coming inside");
    var response = await APIClient.post(
      URLS.getBranches,
      body: {"area_id": selectedArea!.id},
    );

    log(response.body);
    if (response.statusCode != 200) {
      loadingBranches = false;
      update();
      return false;
    }
    var body = json.decode(response.body) ?? {};
    for (var branch in body["data"] as List) {
      if (selectedBranch != null &&
          selectedBranch!.id == branch["id"].toString()) {
        continue;
      }
      branches.add(BranchModel(branch));
    }

    loadingBranches = false;
    update();
  }

  selectBranch(BranchModel? branchModel) {
    selectedBranch = branchModel;
    print(selectedBranch!.name);
    update();
  }
}
