import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluse_flutter/app/appshell.dart';
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

                  ref.read(shellViewProvider.notifier).state = ShellView.home;
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 28,
                  color: Color(0xff202124),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Text(
                  'Join with a code',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
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
          Text(
            'Enter the code provided by the meeting organiser',
            style: TextStyle(
              fontSize: 15.5.sp,

              color: const Color(0xff202124),
            ),
          ),

          SizedBox(height: 2.5.h),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(38),
              ),
              child: TextField(
                controller: codeCtrl,
                focusNode: _focusNode,
            autocorrect: false,
  enableSuggestions: false,
    keyboardType: TextInputType.visiblePassword,
  textCapitalization: TextCapitalization.none,
                cursorColor: Colors.black,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 19,
                  color: const Color(0xff202124),
                ),
                decoration: InputDecoration(
                
                  hintText: 'Example: abc-mnop-xyz',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    fontSize: 19,
                    color: const Color(0xffB7B8C2),
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
