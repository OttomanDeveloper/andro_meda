import 'package:safeandromeda/core/hooks/hooks.dart';

class NavButton extends StatefulWidget {
  final String title;
  final bool isBuy;
  final VoidCallback onTap;

  const NavButton({
    required this.title,
    this.isBuy = false,
    required this.onTap,
  });

  @override
  _NavButtonState createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  Color bgColor = AppColors.parent;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.isBuy
        ? InkWell(
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
          )
        : InkWell(
            onTap: () => widget.onTap(),
            onHover: (value) {
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
                borderRadius: BorderRadius.circular(size.height * 0.01),
                color: bgColor.withOpacity(0.7),
              ),
              child: text(size),
            ),
          );
  }

  Widget text(Size size) {
    return Text(
      "${widget.title}",
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        color: widget.isBuy ? AppColors.black : AppColors.white,
        fontSize: size.height * 0.016,
      ),
    );
  }
}
