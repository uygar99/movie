import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF2EBEB),
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: const Color(0xFF9E9E9E), size: 24.w),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: GoogleFonts.inter(
                color: Colors.black87, 
                fontSize: 16.sp, 
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF9E9E9E), 
                  fontSize: 17.sp, 
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
          Icon(CupertinoIcons.mic_fill, color: const Color(0xFF9E9E9E), size: 24.w),
        ],
      ),
    );
  }
}
