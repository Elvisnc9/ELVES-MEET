import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

final createRoomPanelProvider = StateProvider<bool>((ref) => false);

final createRoomLoadingProvider = StateProvider<bool>((ref) => false);

class CreateRoomPanel extends ConsumerWidget {
  const CreateRoomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(createRoomPanelProvider);
    final isLoading = ref.watch(createRoomLoadingProvider);

    return IgnorePointer(
      ignoring: !open,
      child: AnimatedOpacity(
        opacity: open ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          children: [
            /// BACKDROP
            GestureDetector(
              onTap: () {
                ref.read(createRoomPanelProvider.notifier).state = false;
              },
              child: Container(
                color: Colors.white.withOpacity(0.05),
              ),
            ),

            /// PANEL
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: open ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                child: Container(
                  height: 30.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),

                      child: isLoading
                          ? Center(
                              key: const ValueKey(
                                'loader',
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    strokeWidth: 5,
                                    color: Colors.white,
                                  ),

                                  SizedBox(height: 2.h),

                                  Text(
                                    "Creating room...",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              key: const ValueKey(
                                'content',
                              ),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 48,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(
                                        99,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 24,
                                ),

                                Text(
                                  "Share this Link to connect with others",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                SizedBox(
                                  height: 3.h,
                                ),

                                Container(
                                  height: 65,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      0.10,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      18,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(
                                        0.20,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "CN8Hbu-MNKB-BjbyVBUBUYV",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.copy_rounded,
                                          color: Colors.white,
                                          size: 24.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 3.h,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ShareButton(
                                      icon: Icons.share_rounded,
                                      label: "Share",
                                      onTap: () {},
                                    ),
                                    ShareButton(
                                      icon: Icons.add_rounded,
                                      label: "Join",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ShareButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.20),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 3.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
