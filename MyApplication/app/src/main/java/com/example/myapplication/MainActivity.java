package com.example.myapplication;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import io.flutter.app.FlutterActivity;
import io.flutter.facade.Flutter;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends AppCompatActivity {
    //channel的名称，由于app中可能会有多个channel，这个名称需要在app内是唯一的。
    private static final String CHANNEL = "samples.flutter.io/battery";


    private FrameLayout content;
    private TextView tv;
    private TextView tv_content;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        content=findViewById(R.id.content);
        tv_content=findViewById(R.id.tv_content);
        tv=findViewById(R.id.tv);

        //window.defaultRouteName可以获取这个initialRoute的值来展示不同widget
        final FlutterView flutterView=Flutter.createView(this,getLifecycle(),"route1");
        content.post(new Runnable() {
            @Override
            public void run() {
                content.addView(flutterView);
            }
        });

        //GeneratedPluginRegistrant.registerWith(this);

        // 直接 new MethodChannel，然后设置一个Callback来处理Flutter端调用
        final MethodChannel channel=new MethodChannel(flutterView, CHANNEL);
        channel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        // 在这个回调里处理从Flutter来的调用

                        if (call.method.equals("getBatteryLevel")) {
                            int batteryLevel = getBatteryLevel();

                            if (batteryLevel != -1) {
                                result.success(batteryLevel);
                            } else {
                                result.error("UNAVAILABLE", "Battery level not available.", null);
                            }
                        } else {
                            result.notImplemented();
                        }



                    }
                });


        tv.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                //这三个参数不要写错，无语，arguments应该可以携带参数
                channel.invokeMethod("getName","abc",new MethodChannel.Result(){

                    @Override
                    public void success(Object o) {

                        //Toast.makeText(MainActivity.this,o.toString(),Toast.LENGTH_LONG).show();
                        tv_content.setText("显示："+o.toString());
                    }

                    @Override
                    public void error(String s, String s1, Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }
        });


    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

}
