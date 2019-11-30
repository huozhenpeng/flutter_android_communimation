package com.example.myapplication;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Bundle;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import java.util.Random;

import io.flutter.facade.Flutter;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterView;

public class ThreeActivity extends AppCompatActivity {
    private FrameLayout content;
    private TextView tv;
    private TextView tv2;
    private TextView tv3;

    //channel的名称，由于app中可能会有多个channel，这个名称需要在app内是唯一的。
    private static final String CHANNEL = "samples.flutter.io/basic";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second);
        content=findViewById(R.id.content);
        tv=findViewById(R.id.tv);
        tv2=findViewById(R.id.tv2);
        tv3=findViewById(R.id.tv3);
        final FlutterView flutterView= Flutter.createView(this,getLifecycle(),"route3");
        content.post(new Runnable() {
            @Override
            public void run() {
                content.addView(flutterView);
            }
        });

        final BasicMessageChannel messageChannel = new BasicMessageChannel<>(flutterView, CHANNEL, StringCodec.INSTANCE);
        messageChannel.
                setMessageHandler(new BasicMessageChannel.MessageHandler<String>() {

                    public void onMessage(String s, BasicMessageChannel.Reply<String> reply) {
                        //接收到flutter主动发送的消息了
                        tv2.setText(s);

                        //这是回传给flutter的，但是flutter无法接收
                        reply.reply("Android已经收到消息了");
                    }
                });


        tv.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                messageChannel.send("这是Android给你发送的消息");

                messageChannel.send("这是Android给你发送的消息",new BasicMessageChannel.Reply(){

                    @Override
                    public void reply(Object o) {
                        tv3.setText(o.toString());
                    }
                });
            }
        });


    }



}
