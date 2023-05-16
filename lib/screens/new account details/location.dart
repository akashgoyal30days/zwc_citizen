import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/new_account_reg_ctrl.dart';
import 'package:zwc/screens/new%20account%20details/new_account_reg.dart';

import '../../model/locaiton_models.dart';

class LocationUI extends StatelessWidget {
  const LocationUI({super.key, required this.prevPage, required this.nextPage});
  final VoidCallback prevPage, nextPage;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewAccountRegisterationController>(builder: (controller) {
      return ThePageStructure(
        prevPage: prevPage,
        nextPage: controller.selectedBranch != null ? nextPage : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Your Area!",
                  style: GoogleFonts.montserrat(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose your area by selecting your state, city, and specific location from the dropdowns below.",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "State",
                  style: GoogleFonts.montserrat(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                DropdownButtonFormField<StateModel>(
                  items: controller.states
                      .map<DropdownMenuItem<StateModel>>(
                          (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ))
                      .toList(),
                  value: controller.selectedState,
                  onChanged: controller.selectState,
                ),
                if (controller.selectedState != null)
                  (!controller.loadingDistricts &&
                          controller.selectedState != null &&
                          controller.districts.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "We're not in your state yet, but we're working hard to expand ZWC to more places",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "District",
                              style: GoogleFonts.montserrat(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            controller.loadingDistricts
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<DistrictModel>(
                                    items: controller.districts
                                        .map<DropdownMenuItem<DistrictModel>>(
                                            (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name),
                                                ))
                                        .toList(),
                                    value: controller.selectedDistrict,
                                    onChanged: controller.selectDistrict,
                                  ),
                          ],
                        ),
                if (controller.selectedDistrict != null)
                  (!controller.loadingCities &&
                          controller.selectedDistrict != null &&
                          controller.cities.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "We're not in your district yet, but we're working hard to expand ZWC to more places",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "City",
                              style: GoogleFonts.montserrat(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            controller.loadingCities
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<CityModel>(
                                    items: controller.cities
                                        .map<DropdownMenuItem<CityModel>>(
                                            (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name),
                                                ))
                                        .toList(),
                                    value: controller.selectedCity,
                                    onChanged: controller.selectCity,
                                  ),
                          ],
                        ),
                if (controller.selectedCity != null)
                  (!controller.loadingAreas &&
                          controller.selectedCity != null &&
                          controller.areas.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "We're not in your city yet, but we're working hard to expand ZWC to more places",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Area",
                              style: GoogleFonts.montserrat(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            controller.loadingAreas
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<AreaModel>(
                                    items: controller.areas
                                        .map<DropdownMenuItem<AreaModel>>(
                                            (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name),
                                                ))
                                        .toList(),
                                    value: controller.selectedArea,
                                    onChanged: controller.selectArea,
                                  ),
                          ],
                        ),
                if (controller.selectedArea != null)
                  (!controller.loadingBranches &&
                          controller.selectedArea != null &&
                          controller.branches.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "We're not in your area yet, but we're working hard to expand ZWC to more places",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Branch",
                              style: GoogleFonts.montserrat(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            controller.loadingBranches
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<BranchModel>(
                                    items: controller.branches
                                        .map<DropdownMenuItem<BranchModel>>(
                                            (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name),
                                                ))
                                        .toList(),
                                    value: controller.selectedBranch,
                                    onChanged: controller.selectBranch,
                                  ),
                          ],
                        ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DropDownWidgets extends StatelessWidget {
  const DropDownWidgets(
      {super.key,
      required this.title,
      required this.showLoading,
      required this.items,
      required this.selected});
  final String title;
  final List<String> items;
  final bool showLoading;
  final void Function(dynamic) selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Colors.green,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        showLoading
            ? const Center(child: CircularProgressIndicator())
            : TextDropdownFormField(
                options: items,
                onChanged: selected,
              ),
      ],
    );
  }
}
