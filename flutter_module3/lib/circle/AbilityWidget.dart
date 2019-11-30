import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AbilityWidget extends StatefulWidget {
  @override
  _AbilityWidgetState createState() => _AbilityWidgetState();
}

class _AbilityWidgetState extends State<AbilityWidget>{

  @override
  Widget build(BuildContext context) {
    var paint = CustomPaint(
      painter: AbilityPainter(),
    );

    return SizedBox(width: 200, height: 200, child: paint,);
  }
}

class AbilityPainter extends CustomPainter {
  var data = {
    "攻击力": 70.0,
    "生命": 90.0,
    "闪避": 50.0,
    "暴击": 70.0,
    "破格": 80.0,
    "格挡": 100.0,
  };

  double mRadius = 100; //外圆半径
  Paint mLinePaint; //线画笔
  Paint mAbilityPaint; //区域画笔
  Paint mFillPaint;//填充画笔

  Path mLinePath;//短直线路径
  Path mAbilityPath;//范围路径

  Paint mPaint;//辅助线

  Path mPath;

  AbilityPainter() {
    mLinePath = Path();
    mAbilityPath = Path();
    mLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth=0.008 * mRadius
      ..isAntiAlias = true;

    mFillPaint = Paint() //填充画笔
      ..strokeWidth = 0.05 * mRadius
      ..color = Colors.black
      ..isAntiAlias = true;
    mAbilityPaint = Paint()
      ..color = Color(0x8897C5FE)
      ..isAntiAlias = true;

    mPaint=Paint()..color=Colors.greenAccent;

     mPath=Path();
  }



  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(mRadius, mRadius); //移动坐标系
    canvas.drawLine(Offset(0, 0), Offset(200, 0), mPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, 200), mPaint);
    //drawOutCircle(canvas);
    drawInnerCircle(canvas);
    drawInfoText2(canvas);
    drawAbility(canvas,data.values.toList());
  }

//绘制外圈
  void drawOutCircle(Canvas canvas) {
    canvas.save();//新建图层
    canvas.drawCircle(Offset(0, 0), mRadius, mLinePaint);//圆形的绘制
    double r2 = mRadius - 0.08 * mRadius; //下圆半径
    canvas.drawCircle(Offset(0, 0), r2, mLinePaint);
    for (var i = 0.0; i < 22; i++) {//循环画出小黑条
      canvas.save();//新建图层
      canvas.rotate(360 / 22 * i / 180 * pi);//旋转:注意传入的是弧度（与Android不同）
      canvas.drawLine(Offset(0, -mRadius), Offset(0, -r2), mFillPaint);//线的绘制
      canvas.restore();//释放图层
    }
    canvas.restore();//释放图层
  }

  //绘制内圈圆
  drawInnerCircle(Canvas canvas) {
    double innerRadius = 0.618 * mRadius;//内圆半径
    canvas.drawCircle(Offset(0, 0), innerRadius, mLinePaint);
    canvas.save();
    for (var i = 0; i < 6; i++) {//遍历6条线
      canvas.save();
      canvas.rotate(60 * i.toDouble() / 180 * pi); //每次旋转60°
      mPath.moveTo(0, -innerRadius);
      mPath.relativeLineTo(0, innerRadius); //线的路径  感觉lineTo更好理解一些
      //lineTo是移动到指定的点，relativeLineTo是移动指定的距离
      //canvas.drawLine(Offset(0,-innerRadius), Offset(0, innerRadius), mLinePaint);
      for (int j = 1; j < 6; j++) {
        mPath.moveTo(-mRadius * 0.02, innerRadius / 6 * j);
        mPath.relativeLineTo(mRadius * 0.02 * 2, 0);
      } //加5条小线
      canvas.drawPath(mPath, mLinePaint); //绘制线
      canvas.restore();
    }
    canvas.restore();
  }


  //绘制文字
  void drawInfoText2(Canvas canvas)
  {
    double r2 = mRadius - 0.08 * mRadius; //下圆半径
    for (int i = 0; i < data.length; i++) {
      canvas.save();
      canvas.rotate(360 / data.length * i / 180 * pi + pi);
      TextPainter textPainter=TextPainter(
        textDirection: TextDirection.ltr,
          text:TextSpan(
            text: data.keys.toList()[i],

            style: TextStyle(
              fontSize: mRadius*0.1,
              color: Colors.black
            )
          )

      );

      textPainter.layout();
      Offset offset=Offset(0-(textPainter.width/2), r2 - 0.22 * mRadius);
      print("offset:${textPainter.width}");
      textPainter.paint(canvas, offset);
      canvas.restore();
    }


  }



  //绘制文字
  void drawInfoText(Canvas canvas) {
    double r2 = mRadius - 0.08 * mRadius; //下圆半径
    print("r2=${r2}    ${r2 - 0.22 * mRadius}");
    for (int i = 0; i < data.length; i++) {
      canvas.save();
      canvas.rotate(360 / data.length * i / 180 * pi + pi);
      //innerRadius=60
      drawText(canvas, data.keys.toList()[i], Offset(-50, r2 - 0.22 * mRadius),
          fontSize: mRadius * 0.1);
      canvas.restore();
    }
  }

//绘制文字
  drawText(Canvas canvas, String text, Offset offset,
      {Color color=Colors.black,
        double maxWith = 100,
        double fontSize,
        String fontFamily,
        TextAlign textAlign=TextAlign.center,
        FontWeight fontWeight=FontWeight.bold}) {
    //  绘制文字
    var paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontFamily: fontFamily,
        textAlign: textAlign,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
    paragraphBuilder.pushStyle(
        ui.TextStyle(color: color, textBaseline: ui.TextBaseline.alphabetic));
    paragraphBuilder.addText(text);
    var paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: maxWith));
    canvas.drawParagraph(paragraph, Offset(offset.dx, offset.dy));
  }


  //绘制区域
  drawAbility(Canvas canvas, List<double> value) {
    double step = mRadius*0.618 / 6; //每小段的长度
    mAbilityPath.moveTo(0, -value[0] / 20 * step); //起点
    for (int i = 1; i < 6; i++) {
      double mark = value[i] / 20;//占几段
      mAbilityPath.lineTo(
          mark * step * cos(pi / 180 * (-30 + 60 * (i - 1))),
          mark * step * sin(pi / 180 * (-30 + 60 * (i - 1))));
    }
    mAbilityPath.close();
    canvas.drawPath(mAbilityPath, mAbilityPaint);
  }





  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
