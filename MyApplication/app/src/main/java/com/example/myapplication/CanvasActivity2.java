package com.example.myapplication;

import android.os.Bundle;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;


public class CanvasActivity2 extends AppCompatActivity {

    FrameLayout content;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_canvas);
        content=findViewById(R.id.content);

        content.post(new Runnable() {
            @Override
            public void run() {
                FlutterFragment flutterFragment=Flutter.createFragment("show_canvas");
                FragmentManager fragmentManager=getSupportFragmentManager();
                FragmentTransaction transaction=fragmentManager.beginTransaction();
                transaction.replace(R.id.content,flutterFragment);
                transaction.commit();
            }
        });


    }
}
