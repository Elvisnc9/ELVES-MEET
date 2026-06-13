import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class CodeSearchScreen extends ConsumerStatefulWidget {
  const CodeSearchScreen({
    super.key,
  });

  @override
  ConsumerState<CodeSearchScreen> createState() => _CodeSearchScreenState();
}

class _CodeSearchScreenState extends ConsumerState<CodeSearchScreen> {
  final TextEditingController codeCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canJoin = codeCtrl.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.2.h),

          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                  await Future.delayed(const Duration(milliseconds: 120));

                  if (!mounted) return;
ref.read(navigationProvider).goToHome();         
       },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 28,
                    color: Color(0xff202124),
                  ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Text(
                  'Join with a code',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff202124),
                    letterSpacing: -1.5,
                  ),
                ),
              ),

              GestureDetector(
                onTap: canJoin ? () {} : null,
                child: Container(
                  width: 10.h,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: canJoin
                        ? const Color(0xff1A73E8)
                        : const Color(0xffD6D8E2),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Text(
                    'Join',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: canJoin ? Colors.white : const Color(0xff8C8E99),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Enter the code provided by the meeting organiser',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
            fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )
          ),

          SizedBox(height: 2.5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                 color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: codeCtrl,
                onChanged: (_) => setState(() {}),
                focusNode: _focusNode,
            autocorrect: false,
  enableSuggestions: false,
    keyboardType: TextInputType.visiblePassword,
  textCapitalization: TextCapitalization.none,
                cursorColor: Colors.black,
                cursorHeight: 20,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 19,
                  color:  Colors.black,
                  
                ),
                decoration: InputDecoration(
                
                  hintText: 'Example: abc-mnop-xyz',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 23,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
