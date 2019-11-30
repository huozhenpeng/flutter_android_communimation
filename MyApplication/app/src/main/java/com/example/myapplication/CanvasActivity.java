package com.example.myapplication;

import android.os.Bundle;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import io.flutter.facade.Flutter;
import io.flutter.view.FlutterView;


public class CanvasActivity extends AppCompatActivity {

    FrameLayout content;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_canvas);
        content=findViewById(R.id.content);

        final FlutterView flutterView= Flutter.createView(this,getLifecycle(),"show_canvas");
        content.post(new Runnable() {
            @Override
            public void run() {
                content.addView(flutterView);
            }
        });
    }
}
