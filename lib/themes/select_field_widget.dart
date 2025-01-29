import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

typedef void InitCallback(String value);

class SelectFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? obscureText;
  final int? maxLine;
  final List items;
  final validator;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final InitCallback onSelected;
  final TextInputAction? textInputAction;

  const SelectFieldWidget({
    super.key,
    this.textInputType,
    this.enable,
    this.obscureText,
    this.prefix,
    this.suffix,
    this.title,
    required this.validator,
    required this.items,
    required this.hintText,
    required this.controller,
    this.maxLine,
    this.inputFormatters,
    required this.onSelected,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "".tr ?? '',
                  style: TextStyle(
                      fontFamily: AppThemeData.medium,
                      fontSize: 14,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          DropdownButtonFormField(
            items: items.map((e) {
              return DropdownMenuItem(
                value: e ?? e['id'],
                child: Text(
                  "${e ?? e['name']}".capitalize!,
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
            validator: validator,
            onChanged: (newValue) async {
              onSelected(
                newValue as String,
              );
              // setState(
              //   () {
              //     value = newValue;
              //   },
              // );
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            isExpanded: true,
            style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.grey50
                    : AppThemeData.grey900,
                fontFamily: AppThemeData.medium),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              filled: true,
              enabled: enable ?? true,
              contentPadding: EdgeInsets.symmetric(
                vertical: title == null
                    ? 12
                    : enable == false
                        ? 13
                        : 8,
                horizontal: 10,
              ),
              fillColor: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              prefixIcon: prefix,
              suffixIcon: suffix,
              disabledBorder: UnderlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: themeChange.getThem()
                      ? AppThemeData.primary300
                      : AppThemeData.primary400,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.primary50,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    width: 1),
              ),
              hintText: hintText.tr,
              hintStyle: TextStyle(
                fontSize: 14,
                color: themeChange.getThem()
                    ? AppThemeData.grey600
                    : AppThemeData.grey400,
                fontFamily: AppThemeData.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
