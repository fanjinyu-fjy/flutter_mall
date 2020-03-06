import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mall/config/Config.dart';
import 'package:flutter_mall/model/CateModel.dart';

import '../../services/ScreenAdaper.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // 左侧分类选择的序号
  int _selectIndex = 0;
  List<CateItemModel> _leftCateList = [];
  List<CateItemModel> _rightCateList = [];

  @override
  void initState() {
    super.initState();
    _getLeftCateData();
  }

  //获取左侧分类数据
  _getLeftCateData() async {
    String api = '${Config.domain}api/pcate';
    // print(api);
    var result = await Dio().get(api);
    CateModel leftCateList = new CateModel.fromJson(result.data);
    // print(leftCateList.result);
    setState(() {
      this._leftCateList = leftCateList.result;
    });
    _getRightCateData(leftCateList.result[0].sId);
  }

  //获取右侧分类数据
  _getRightCateData(pid) async {
    String api = '${Config.domain}api/pcate?pid=$pid';
    print(api);
    var result = await Dio().get(api);
    CateModel rightCateList = new CateModel.fromJson(result.data);
    // print(rightCateList.result);
    setState(() {
      this._rightCateList = rightCateList.result;
    });
  }

  //渲染左侧组件
  Widget _leftCateWidget(leftWidth) {
    if (this._leftCateList.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: this._leftCateList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (_selectIndex == index) return;
                    setState(() {
                      _selectIndex = index;
                      this._getRightCateData(this._leftCateList[index].sId);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdaper.height(66),
                    alignment: Alignment.center,
                    child: Text("${this._leftCateList[index].title}",
                        textAlign: TextAlign.center),
                    color: _selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          },
        ),
      );
    } else {
      return Container(width: leftWidth, height: double.infinity);
    }
  }

  //渲染右侧组件
  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // 计算宽高比
                  childAspectRatio: rightItemWidth / rightItemHeight,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: this._rightCateList.length,
              itemBuilder: (context, index) {
                // 处理图片
                String pic = this._rightCateList[index].pic;
                pic = Config.domain + pic.replaceAll('\\', '/');

                String title = this._rightCateList[index].title;
                return Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network("$pic", fit: BoxFit.cover),
                      ),
                      Container(
                        height: ScreenAdaper.height(28),
                        alignment: Alignment.center,
                        child: Text("$title"),
                      )
                    ],
                  ),
                );
              },
            )),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: Text("loading...."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //注意用ScreenAdaper必须得在build方法里面初始化
    ScreenAdaper.init(context);

    //计算右侧GridView宽高比

    //左侧宽度
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;

    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    // 也就是右侧内容 用三列来展示
    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;

    //获取计算后的宽度
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);

    return Row(
      children: <Widget>[
        this._leftCateWidget(leftWidth),
        this._rightCateWidget(rightItemWidth, rightItemHeight)
      ],
    );
  }
}
