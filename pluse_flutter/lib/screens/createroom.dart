import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

final createRoomPanelProvider =
    StateProvider<bool>((ref) => false);

class CreateRoomPanel extends ConsumerWidget {
  const CreateRoomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(createRoomPanelProvider);

    return IgnorePointer(
      ignoring: !open,
      child: AnimatedOpacity(
        opacity: open ? 1 : 0,
        duration: const Duration(milliseconds: 250),

        child: Stack(
          children: [
            /// backdrop
            GestureDetector(
              onTap: () {
                ref
                    .read(createRoomPanelProvider.notifier)
                    .state = false;
              },
              child: Container(
                color: Colors.black.withOpacity(.35),
              ),
            ),

            /// panel
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset:
                    open ? Offset.zero : const Offset(0, 1),
                duration:
                    const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,

                child: Container(
                  height: 34.h,
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xff171717),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(99),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Create Room",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Start an instant video meeting",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.videocam,
                            ),
                            label: const Text(
                              "Start Meeting",
                            ),
                            onPressed: () {},
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.schedule,
                            ),
                            label: const Text(
                              "Schedule Later",
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
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