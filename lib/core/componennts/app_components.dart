import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iclick/core/utils/app_colors.dart';

class Components {
  static Widget defText(
      {required String text,
      Color? color,
      double size = 20,
      TextAlign textAlign = TextAlign.start,
      FontWeight fontWeight = FontWeight.normal,
      int lines = 3,
      double letterSpacing = 0}) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: lines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color == null ? Colors.white : color,
          fontSize: size,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing),
    );
  }

  static Widget defaultform(
      {required TextEditingController controller,
      required String? Function(String?)? validator,
      required String hint,
      var maxlines = 1,
      IconData? suffixIcon,
      IconData? prefixIcon,
      String? errortext,
      Color suffixcolor = Colors.white,
      Color prefixcolor = Colors.red,
      bool enabled = true,
      Function()? suffixIcontap,
      Function()? prefixIcontap,
      Function()? ontap,
      Function(String)? onChanged,
      Function(String)? handleSubmit,
      TextInputAction? textInputAction,
      required FocusNode focusNode,
      bool obscureText = false,
      TextInputType? textInputType,
      required bool fouce,
      int? maxLength}) {
    return TextFormField(
      enabled: enabled,
      maxLength: maxLength,
      maxLines: maxlines,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(color: fouce ? AppColors.black : AppColors.white),
      validator: validator,
      onTap: ontap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      onFieldSubmitted: handleSubmit,
      decoration: InputDecoration(
        errorText: errortext,
        counterStyle: TextStyle(color: AppColors.black),
        hintText: hint,
        hintStyle: TextStyle(
          color: fouce ? AppColors.black : AppColors.white,
        ),
        fillColor: fouce ? AppColors.white : AppColors.secblack,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: suffixIcontap,
                icon: Icon(
                  suffixIcon,
                  color: AppColors.primary,
                ),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : IconButton(
                onPressed: prefixIcontap,
                icon: Icon(
                  prefixIcon,
                  color: prefixcolor,
                ),
              ),
      ),
    );
  }

  static Widget defButton(
      {textColor = Colors.white,
      double width = double.infinity,
      double height = 55,
      double border = 30,
      FontWeight fontWeight = FontWeight.normal,
      double sizetxt = 18,
      required text,
      required Function()? onTap,
      bool isloading = false}) {
    return InkWell(
      onTap: isloading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              HexColor("888BF4"),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(border),
        ),
        child: Center(
          child: isloading
              ? CircularProgressIndicator(
                  color: textColor,
                )
              : Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: fontWeight,
                        fontSize: sizetxt),
                  ),
                ),
        ),
      ),
    );
  }

  static Widget sizedhg({double size = 20}) {
    return SizedBox(
      height: size,
    );
  }

  static Widget sizedwd({double size = 20}) {
    return SizedBox(
      width: size,
    );
  }

  static Widget loadingwidget() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  static Flushbar<dynamic> successmessage(
      {required BuildContext context,
      required String message,
      double sizefont = 20}) {
    return Flushbar(
      message: message,
      icon: Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.green[300],
      ),
      margin: EdgeInsets.all(6.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      textDirection: Directionality.of(context),
      borderRadius: BorderRadius.circular(8),
      duration: Duration(seconds: 3),
      messageSize: sizefont,
      leftBarIndicatorColor: Colors.green[300],
    )..show(context);
  }

  static Flushbar<dynamic> errormessage(
      {required BuildContext context,
      required String message,
      double sizefont = 20}) {
    return Flushbar(
      message: message,
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.red[300],
      ),
      margin: EdgeInsets.all(6.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      textDirection: Directionality.of(context),
      borderRadius: BorderRadius.circular(8),
      duration: Duration(seconds: 3),
      messageSize: sizefont,
      leftBarIndicatorColor: Colors.red[300],
    )..show(context);
  }

  static defchachedimg(String url,
      {double? wid,
      double? high,
      double raduis = 0,
      bool circular = false,
      BoxFit fit = BoxFit.none}) {
    return CachedNetworkImage(
      fit: fit,
      width: wid,
      height: high,
      imageUrl: url,
      imageBuilder: circular
          ? (context, imageProvider) {
              return Container(
                  decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ));
            }
          : (context, imageProvider) {
              return Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(raduis),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ));
            },
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
          color: AppColors.primary,
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: AppColors.red,
      ),
    );
  }
}
