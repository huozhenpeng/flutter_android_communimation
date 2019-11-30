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
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.FlutterView;

public class SecondActivity extends AppCompatActivity {
    private FrameLayout content;
    private TextView tv;
    private TextView tv2;
    EventChannel.EventSink globaleEvents;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_three);
        content=findViewById(R.id.content);
        tv=findViewById(R.id.tv);
        tv2=findViewById(R.id.tv2);
        final FlutterView flutterView= Flutter.createView(this,getLifecycle(),"route2");
        content.post(new Runnable() {
            @Override
            public void run() {
                content.addView(flutterView);
            }
        });


        new EventChannel(flutterView, "samples.flutter.io/charging").setStreamHandler(
                new EventChannel.StreamHandler() {
                    // 接收电池广播的BroadcastReceiver。
                    private BroadcastReceiver chargingStateChangeReceiver;
                    @Override
                    // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        globaleEvents=events;
                        chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
                        registerReceiver(
                                chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        // 对面不再接收
                        unregisterReceiver(chargingStateChangeReceiver);
                        chargingStateChangeReceiver = null;
                    }
                }
        );

        tv2.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                //手动模拟电量发生了变化
                if(globaleEvents!=null)
                {
                    globaleEvents.success("电量变化了啊："+ new Random().nextInt(20));
                }
            }
        });

    }

    /**
     * 这是监听系统电量发生变化的广播
     * @param events
     * @return
     */
    private BroadcastReceiver createChargingStateChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    events.error("UNAVAILABLE", "Charging status unavailable", null);
                } else {
                    boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                            status == BatteryManager.BATTERY_STATUS_FULL;
                    // 把电池状态发给Flutter
                    events.success(isCharging ? "charging" : "discharging");
                }
            }
        };
    }


}
