import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock App',
      theme: ThemeData(useMaterial3: true),
      home: const StockDetailPage(),
    );
  }
}

// ─── Color palette ───────────────────────────────────────────────────────────
const kBg = Color(0xFFEDF2EF);
const kDarkGreen = Color(0xFF1B3A2D);
const kMedGreen = Color(0xFF2E6B50);
const kLightGreenBadge = Color(0xFFDCF0E6);
const kPurpleStart = Color(0xFF5C3FA0);
const kPurpleEnd = Color(0xFF8B69D6);

class StockDetailPage extends StatefulWidget {
  const StockDetailPage({super.key});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  String _selectedPeriod = '1D';
  final _periods = const ['1D', '1M', '1Y', '3Y', '5Y', 'All'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStockCard(),
                    const SizedBox(height: 16),
                    _buildInsightsSection(),
                    const SizedBox(height: 16),
                    _buildAutoInvestBanner(),
                    const SizedBox(height: 16),
                    _buildSimilarToThis(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── Stock card ──────────────────────────────────────────────────────────────
  Widget _buildStockCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          // Apple logo
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.apple, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 10),
          const Text(
            'Apple Inc.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            '\$195.31',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          // Green badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kLightGreenBadge,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_upward_rounded, size: 14, color: kMedGreen),
                SizedBox(width: 2),
                Text(
                  '\$2.34 today',
                  style: TextStyle(
                    color: kMedGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Stock chart
          SizedBox(
            height: 96,
            width: double.infinity,
            child: CustomPaint(painter: StockChartPainter()),
          ),
          const SizedBox(height: 14),
          // Period tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _periods.map((p) {
              final sel = p == _selectedPeriod;
              return GestureDetector(
                onTap: () => setState(() => _selectedPeriod = p),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        p,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              sel ? FontWeight.bold : FontWeight.normal,
                          color: sel ? kDarkGreen : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 2,
                        width: 20,
                        color: sel ? kDarkGreen : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Insights ────────────────────────────────────────────────────────────────
  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: kLightGreenBadge,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    size: 18,
                    color: kMedGreen,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Icon(Icons.open_in_full_rounded, size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Annual Returns',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  Text(
                    'Avg. Vol. 62.06M',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                '9.20 %',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 58,
                width: double.infinity,
                child: CustomPaint(painter: BarChartPainter()),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricColumn('Market Cap', '\$3.1T'),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    _metricColumn('P/E Ratio', '26.4'),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    _metricColumn('Div. Yield', '0.52%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ── Auto-Invest banner ──────────────────────────────────────────────────────
  Widget _buildAutoInvestBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPurpleStart, kPurpleEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // Decorative circles (target rings)
          Positioned(
            right: -10,
            top: -10,
            child: _dartRings(80),
          ),
          // Dart icon
          Positioned(
            right: 24,
            top: 12,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: const Icon(Icons.north_east_rounded,
                  size: 36, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 100, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Auto-Invest on\nyour schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Investing consistently helps\naverage out costs over time.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dartRings(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RingsPainter()),
    );
  }

  // ── Similar To This ─────────────────────────────────────────────────────────
  Widget _buildSimilarToThis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.swap_horiz_rounded,
                      size: 18, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Similar To This',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Icon(Icons.open_in_full_rounded,
                size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: List.generate(3, (i) {
              return Column(
                children: [
                  _similarItem(),
                  if (i < 2)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade100,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _similarItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apple Inc.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 3),
              Text(
                'Mkt. Cap \$3.1T',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '\$195.31',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 3),
              const Text(
                '+\$2.34  0.17%',
                style: TextStyle(
                  fontSize: 12,
                  color: kMedGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom bar ──────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.apple, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$195.31',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '+1.46% today',
                style: TextStyle(color: kMedGreen, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
            ),
            child: const Text(
              'Invest',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top bar widget ───────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          Column(
            children: [
              const Text(
                'Markets Open',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.wb_sunny_rounded,
                size: 16,
                color: Colors.amber.shade600,
              ),
            ],
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bookmark_border_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

// ─── Ring painter for Auto-Invest banner ────────────────────────────────────
class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, size.width * 0.48, paint);
    canvas.drawCircle(c, size.width * 0.34, paint);
    canvas.drawCircle(c, size.width * 0.20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Stock line chart ─────────────────────────────────────────────────────────
class StockChartPainter extends CustomPainter {
  static const _data = [
    0.60, 0.52, 0.63, 0.48, 0.56, 0.42, 0.60, 0.50, 0.44, 0.54,
    0.64, 0.50, 0.58, 0.53, 0.45, 0.62, 0.52, 0.70, 0.60, 0.65,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Build path
    final path = Path();
    Offset? dotPos;

    for (int i = 0; i < _data.length; i++) {
      final x = size.width * i / (_data.length - 1);
      final y = size.height * _data[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final px = size.width * (i - 1) / (_data.length - 1);
        final py = size.height * _data[i - 1];
        final cpx = (px + x) / 2;
        path.cubicTo(cpx, py, cpx, y, x, y);
      }
      // Dot position: roughly 2/3 through the chart
      if (i == 13) dotPos = Offset(x, y);
    }

    // Gradient fill under the line
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kDarkGreen.withOpacity(0.14),
            kDarkGreen.withOpacity(0.00),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    // Line stroke
    canvas.drawPath(
      path,
      Paint()
        ..color = kDarkGreen
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (dotPos == null) return;

    // Vertical dashed line
    final dashPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;
    double dy = 0;
    while (dy < dotPos!.dy - 4) {
      canvas.drawLine(
        Offset(dotPos!.dx, dy),
        Offset(dotPos!.dx, math.min(dy + 5, dotPos!.dy - 4)),
        dashPaint,
      );
      dy += 9;
    }

    // Outer ring
    canvas.drawCircle(
      dotPos!,
      7,
      Paint()
        ..color = kDarkGreen.withOpacity(0.20)
        ..style = PaintingStyle.fill,
    );
    // Dot
    canvas.drawCircle(
      dotPos!,
      4.5,
      Paint()
        ..color = kDarkGreen
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Insights bar chart ───────────────────────────────────────────────────────
class BarChartPainter extends CustomPainter {
  static const _heights = [
    0.28, 0.42, 0.35, 0.55, 0.32, 0.65, 0.42, 0.50, 0.38, 0.75,
    0.48, 0.60, 0.70, 0.55, 0.85, 0.65, 0.80, 0.60, 0.78, 0.92,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final n = _heights.length;
    final totalSpacing = size.width * 0.3;
    final barW = (size.width - totalSpacing) / n;
    final gap = totalSpacing / (n - 1);

    for (int i = 0; i < n; i++) {
      final bh = size.height * _heights[i];
      final x = i * (barW + gap);
      final y = size.height - bh;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barW, bh),
          const Radius.circular(2),
        ),
        Paint()
          ..color = kMedGreen
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
