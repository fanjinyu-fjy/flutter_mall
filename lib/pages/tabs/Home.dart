import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_mall/config/Config.dart';
import 'package:flutter_mall/model/FocusModel.dart';
import 'package:flutter_mall/model/ProductModel.dart';
import 'package:flutter_mall/services/ScreenAdaper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FocusItemModel> _focusData = [];
  List<ProductItemModel> _hotProductList = [];
  List<ProductItemModel> _bestProductList = [];
  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }

  // 获得轮播图数据
  _getFocusData() async {
    String api = 'http://jd.itying.com/api/focus';
    var result = await Dio().get(api);
    FocusModel focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusData = focusList.result;
    });
  }

  //获取猜你喜欢的数据
  _getHotProductData() async {
    String api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    ProductModel hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

  //获取热门推荐的数据
  _getBestProductData() async {
    String api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    ProductModel bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  // 轮播图
  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusData[index].pic;
              return new Image.network(
                  "http://jd.itying.com/${pic.replaceAll('\\', '/')}",
                  fit: BoxFit.fill);
            },
            itemCount: this._focusData.length,
            pagination: new SwiperPagination(),
            autoplay: true,
          ),
        ),
      );
    } else {
      return Text('loading....');
    }
  }

  // 标题
  Widget _titleWidget(value) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(32),
      margin: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(20)),
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: ScreenUtil.getInstance().setWidth(10),
      ))),
      child: Text(value, style: TextStyle(color: Colors.black54)),
    );
  }

  // 热门商品
  Widget _hotProductListWidget() {
    return Container(
      height: ScreenAdaper.height(234),
      padding: EdgeInsets.all(ScreenAdaper.width(20)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (contxt, index) {
          // 处理图片
          String sPic = this._hotProductList[index].sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');

          return Column(
            children: <Widget>[
              Container(
                height: ScreenAdaper.height(140),
                width: ScreenAdaper.width(140),
                margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                child: Image.network(sPic, fit: BoxFit.cover),
              ),
              Container(
                padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                height: ScreenAdaper.height(44),
                child: Text("￥${this._hotProductList[index].price}",
                    style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
        itemCount: this._hotProductList.length,
      ),
    );
  }

  //推荐商品
  Widget _recProductListWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        children: this._bestProductList.map((value) {
          // 处理图片
          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');
          return Container(
            padding: EdgeInsets.all(10),
            width: itemWidth,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    //防止服务器返回的图片大小不一致导致高度不一致问题
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      "$sPic",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Text(
                    "${value.title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "¥${value.price}",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("¥${value.oldPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return ListView(children: <Widget>[
      _swiperWidget(),
      SizedBox(height: ScreenAdaper.height(20)),
      _titleWidget('猜你喜欢'),
      SizedBox(height: ScreenAdaper.height(20)),
      _hotProductListWidget(),
      _titleWidget('热门推荐'),
      _recProductListWidget(),
    ]);
  }
}
