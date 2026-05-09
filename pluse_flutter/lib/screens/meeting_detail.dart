import 'package:flutter/material.dart';

class MeetingHomeScreen extends StatefulWidget {
  const MeetingHomeScreen({super.key});

  @override
  State<MeetingHomeScreen> createState() => _MeetingHomeScreenState();
}

class _MeetingData {
  final String title;
  final String date;
  final String time;
  final String avatarsText;
  final bool isActive;

  const _MeetingData({
    required this.title,
    required this.date,
    required this.time,
    required this.avatarsText,
    this.isActive = false,
  });
}

class _MeetingHomeScreenState extends State<MeetingHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<_MeetingData> _meetings = const [
    _MeetingData(
      title: 'STAND UP\nMEETING - WEEK 1',
      date: '1 Nov 2023',
      time: '9:00 - 9:30 AM',
      avatarsText: '+4',
      isActive: true,
    ),
    _MeetingData(
      title: 'DESIGN\nDISCUSSION',
      date: '10 Nov 2023',
      time: '9:00 - 9:30 AM',
      avatarsText: '+3',
    ),
    _MeetingData(
      title: 'FRONTEND DEV\nMEETING',
      date: '13 Nov 2023',
      time: '11:00 - 11:45 AM',
      avatarsText: '+7',
    ),
    _MeetingData(
      title: 'PRODUCT\nREVIEW',
      date: '15 Nov 2023',
      time: '2:00 - 3:00 PM',
      avatarsText: '+5',
    ),
    _MeetingData(
      title: 'SPRINT\nRETRO',
      date: '18 Nov 2023',
      time: '4:00 - 4:30 PM',
      avatarsText: '+9',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _interval(double start, double end) {
    final value =
        ((_controller.value - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      
      builder: (context, constraints) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
            
                _HomeHeader(),

                
                // HEADER
                
                
                const SizedBox(height: 10),
                
                // CONTROLS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: 
                   const _TopControls(),
                  
                ),
                
                const SizedBox(height: 12),
                
                // SECTION LABEL
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Upcoming',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF2437E7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // SCROLLABLE MEETING LIST
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: _meetings.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 28,
                      thickness: 0.5,
                      color: Color(0xFFEEEEEE),
                    ),
                    itemBuilder: (context, index) {
                      final m = _meetings[index];
                      if (m.isActive) {
                        return const _ActiveMeetingCard();
                      }
                      return _MeetingItem(
                        title: m.title,
                        date: m.date,
                        avatarsText: m.avatarsText,
                      );
                    },
                  ),
                ),
                
                // HOME INDICATOR
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 19,
          backgroundColor: Color(0xFF8794FF),
          child: Icon(Icons.person, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELLO, TANIA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'See your meetings today!',
                style: TextStyle(fontSize: 10, color: Color(0xFF6D6D6D)),
              ),
            ],
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: const Icon(Icons.settings_outlined, size: 17),
        ),
      ],
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 74,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF171820),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: Text(
              'List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 104,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: const Center(
            child: Text(
              'Calendar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_rounded, size: 20, color: Colors.black),
        ),
      ],
    );
  }
}

class _ActiveMeetingCard extends StatelessWidget {
  const _ActiveMeetingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      decoration: BoxDecoration(
        color: const Color(0xFF2437E7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 18,
            top: 17,
            child: Text(
              'STAND UP\nMEETING - WEEK 1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.1,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Positioned(
            right: 42,
            top: 18,
            child: _AvatarCluster(label: '+4'),
          ),
          const Positioned(
            right: 18,
            top: 19,
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const Positioned(
            left: 18,
            top: 61,
            child: Text(
              'The meeting is started.\nPlease, join us!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 17,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                '1 Nov 2023        9:00 - 9:30 AM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 13,
            child: Container(
              width: 43,
              height: 43,
              decoration: const BoxDecoration(
                color: Color(0xFF171820),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingItem extends StatelessWidget {
  final String title;
  final String date;
  final String avatarsText;

  const _MeetingItem({
    required this.title,
    required this.date,
    required this.avatarsText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                height: 1.12,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Positioned(
            right: 38,
            top: 2,
            child: _AvatarCluster(label: avatarsText),
          ),
          const Positioned(
            right: 13,
            top: 0,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 21,
              color: Colors.black,
            ),
          ),
          const Positioned(
            left: 0,
            top: 47,
            child: Text(
              'The meeting will be available in\n2 days.',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 10,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '$date        9:00 - 9:30 AM',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 43,
              height: 43,
              decoration: const BoxDecoration(
                color: Color(0xFF171820),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCluster extends StatelessWidget {
  final String label;

  const _AvatarCluster({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 24,
      child: Stack(
        children: [
          _smallAvatar(0, const Color(0xFFD7E0E0)),
          _smallAvatar(15, const Color(0xFFAAB3B4)),
          Positioned(
            left: 30,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF171820),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallAvatar(double left, Color color) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}