import 'BaseViewModel.dart';

class ChannelViewModel extends BaseViewModel {
  List<ChannelModel> _categorys = List();

  List<ChannelModel> get categorys => _categorys;
  ChannelModel _currentModel = null;

  ChannelModel get currentModel => _currentModel;

  String title="频道";



  set currentModel(ChannelModel value) {
    _currentModel = value;
  }

  @override
  void initData() {
    status = BaseViewModel.NORMAL;
    _categorys
      ..add(ChannelModel("全部", 1, "all", "assets/svgs/all_svg.svg"))
      ..add(
          ChannelModel("Android", 1, "Android", "assets/svgs/android_svg.svg"))
      ..add(ChannelModel("iOS", 1, "iOS", "assets/svgs/apple_svg.svg"))
      ..add(ChannelModel("休息视频", 1, "休息视频", "assets/svgs/video_svg.svg"))
      ..add(ChannelModel("拓展资源", 1, "拓展资源", "assets/svgs/source_svg.svg"))
      ..add(ChannelModel("前端", 1, "前端", "assets/svgs/fore_svg.svg"))
      ..add(ChannelModel("福利", 1, "福利", "assets/svgs/welfare_svg.svg"));
  }
}

class ChannelModel {
  String categoryName;
  int index;
  String image;
  String category;

  ChannelModel(this.categoryName, this.index, this.category, this.image);
}
