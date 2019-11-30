import 'dart:math';

import 'package:flutter/material.dart';

class OutlinePainter extends CustomPainter {
  double mRadius = 100; //外圆半径
  Paint mLinePaint; //线画笔
  Paint mFillPaint; //填充画笔

  OutlinePainter() {
    mLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.008 * mRadius
      ..isAntiAlias = true;

    mFillPaint = Paint() //填充画笔
      ..strokeWidth = 0.05 * mRadius
      ..color = Colors.black
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawOutCircle(canvas);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  //绘制外圈
  void drawOutCircle(Canvas canvas) {
    canvas.save(); //新建图层
    canvas.drawCircle(Offset(0, 0), mRadius, mLinePaint); //圆形的绘制
    double r2 = mRadius - 0.08 * mRadius; //下圆半径
    canvas.drawCircle(Offset(0, 0), r2, mLinePaint);
    for (var i = 0.0; i < 22; i++) {
      //循环画出小黑条
      canvas.save(); //新建图层
      canvas.rotate(360 / 22 * i / 180 * pi); //旋转:注意传入的是弧度（与Android不同）
      canvas.drawLine(Offset(0, -mRadius), Offset(0, -r2), mFillPaint); //线的绘制
      canvas.restore(); //释放图层
    }
    canvas.restore(); //释放图层
  }
}