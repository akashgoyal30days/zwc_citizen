import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:zwc/screens/app_structure_screen.dart';

import '../api/api_client.dart';
import '../api/urls.dart';
import '../data/shared_preference.dart';
import '../model/locaiton_models.dart';
import '../screens/auth/login.dart';

class NewAccountRegisterationController extends GetxController {
  bool showLoading = false,
      loadingStates = false,
      loadingDistricts = false,
      loadingCities = false,
      loadingAreas = false,
      loadingBranches = false;
  String errorMessage = "";
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

  NewAccountRegisterationController() {
    getStates();
  }

  getStates() async {
    loadingStates = true;

    errorMessage = "";
    update();

    var response = await APIClient.post(URLS.getStates);

    if (response.statusCode != 200) {
      loadingStates = false;
      update();
      return false;
    }

    var body = json.decode(response.body) ?? {};
    for (var state in body["data"] as List) {
      states.add(StateModel(state));
    }
    log("This is a message");
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
    errorMessage = "";
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
    errorMessage = "";
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
    errorMessage = "";
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
    errorMessage = "";
    update();

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
    log(response.body);
    for (var branch in body["data"] as List) {
      branches.add(BranchModel(branch));
    }

    loadingBranches = false;
    update();
  }

  selectBranch(BranchModel? branchModel) {
    selectedBranch = branchModel;
    update();
  }

  submit(name, email, address) async {
    log("Hello");
    showLoading = true;
    errorMessage = "";
    update();

    var response = await APIClient.post(URLS.updateUserProfile, body: {
      "name": name,
      "email": email,
      "address": address,
      "area_id": selectedArea?.id ?? ""
    });

    log(response.body);
    if (response.statusCode != 200) {
      showLoading = false;
      update();
      return false;
    }
    updateUserBranch();
  }

  updateUserBranch() async {
    showLoading = true;
    errorMessage = "";
    update();

    var response = await APIClient.post(
      URLS.updateBranch,
      body: {"branch_id": selectedBranch?.id ?? ""},
    );

    log(response.body);
    if (response.statusCode != 200) {
      showLoading = false;
      update();
      return false;
    }
    getUserProfile();
  }

  getUserProfile() async {
    var response = await APIClient.post(URLS.getUserDetails);

    if (response.statusCode != 200) {
      SharedPreferenceFunctions.logout();
      Get.offAll(() => const LoginScreen());
      Get.showSnackbar(const GetSnackBar(
        title: "Unkown Error",
        message: "Please Login Again",
      ));
      return;
    }

    var body = (json.decode(response.body) ?? {})["data"];
    await SharedPreferenceFunctions.setUserData(body);
    Get.offAll(const AppStructureScreen());
    Get.showSnackbar(const GetSnackBar(
      title: "Done",
      message: "User Details Updated Succesful",
      duration: Duration(seconds: 3),
    ));
  }
}
