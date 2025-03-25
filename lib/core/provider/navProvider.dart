import 'package:safeandromeda/core/hooks/hooks.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NavProvider extends ChangeNotifier {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 25.0);
  ScrollController get scrollController => _scrollController;
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemScrollController get itemScrollController => _itemScrollController;
  ItemPositionsListener _itemPositionListener = ItemPositionsListener.create();
  ItemPositionsListener get itemPositionsListener => _itemPositionListener;

  bool _isFloat = false;
  bool get isFloat => _isFloat;

  void scroll({required int index}) {
    _itemScrollController.scrollTo(
        index: index, duration: Duration(seconds: 1));
    floatVisibility(index);
  }

  void addItemScrollListener() {
    _itemPositionListener.itemPositions.addListener(() {
      int _value = _itemPositionListener.itemPositions.value.first.index;
      floatVisibility(_value);
    });
  }

  void floatVisibility(int index) {
    if (index > 0) {
      _isFloat = true;
    } else {
      _isFloat = false;
    }
    notifyListeners();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get globalKey => _globalKey;
}
