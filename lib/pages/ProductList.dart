import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/ScreenAdaper.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //商品列表渲染
  Widget _productListWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: ScreenAdaper.height(80)), //给顶部筛选导航的空间
      child: ListView.builder(
        itemBuilder: (context, index) {
          //每一个元素
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenAdaper.width(180),
                    height: ScreenAdaper.height(180),
                    child: Image.network(
                        "https://www.itying.com/images/flutter/list2.jpg",
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: ScreenAdaper.height(180),
                      margin: EdgeInsets.only(left: 10),
                      // color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "戴尔(DELL)灵越3670 英特尔酷睿i5 高性能 台式电脑整机(九代i5-9400 8G 256G)",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          Row(
                            children: <Widget>[
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),

                                child: Text("4g"),
                              ),
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),
                                child: Text("126"),
                              ),
                            ],
                          ),
                          Text(
                            "¥990",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 20)
            ],
          );
        },
        itemCount: 10,
      ),
    );
  }

  //筛选导航
  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      height: ScreenAdaper.height(80),
      width: ScreenAdaper.width(750),
      child: Container(
        width: ScreenAdaper.width(750),
        height: ScreenAdaper.height(80),
        // color: Colors.red,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(233, 233, 233, 0.9)))),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text(
                    "综合",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("销量", textAlign: TextAlign.center),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("价格", textAlign: TextAlign.center),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("筛选", textAlign: TextAlign.center),
                ),
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("商品列表"),
          // leading: Text(""),
          actions: <Widget>[Text("")],
        ),
        endDrawer: Drawer(
          child: Container(
            child: Text("实现筛选功能"),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _productListWidget(),
            _subHeaderWidget(),
          ],
        ));
  }
}
