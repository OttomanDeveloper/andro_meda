import 'package:safeandromeda/core/hooks/hooks.dart';

class NavButton extends StatefulWidget {
  final bool isBuy;
  final String title;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    this.isBuy = false,
    required this.title,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  Color bgColor = AppColors.parent;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (widget.isBuy) {
      return InkWell(
        onTap: () => widget.onTap(),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.006,
            horizontal: size.width * 0.02,
          ),
          decoration: BoxDecoration(
            color: AppColors.headerGreen,
            borderRadius: BorderRadius.circular(size.height * 0.01),
          ),
          child: text(size),
        ),
      );
    } else {
      return InkWell(
        onTap: () => widget.onTap(),
        onHover: (bool value) {
          if (value) {
            bgColor = AppColors.headerGreen;
          } else {
            bgColor = AppColors.parent;
          }
          setState(() {});
        },
        hoverColor: Colors.orange,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.006,
            horizontal: size.width * 0.01,
          ),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(size.height * 0.01),
          ),
          child: text(size),
        ),
      );
    }
  }

  Widget text(Size size) {
    return Text(
      widget.title,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        fontSize: size.height * 0.016,
        color: widget.isBuy ? AppColors.black : AppColors.white,
      ),
    );
  }
}
