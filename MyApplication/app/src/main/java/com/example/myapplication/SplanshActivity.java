package com.example.myapplication;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public class SplanshActivity extends AppCompatActivity {

    Button b_methodchannel;
    Button b_eventchannel;
    Button b_basic;
    Button b_chart;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splansh);
        b_methodchannel=findViewById(R.id.b_methodchannel);
        b_eventchannel=findViewById(R.id.b_eventchannel);
        b_basic=findViewById(R.id.b_basic);
        b_chart=findViewById(R.id.b_chart);

        b_methodchannel.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                Intent intent=new Intent();
                intent.setClass(SplanshActivity.this,MainActivity.class);
                startActivity(intent);
            }
        });


        b_eventchannel.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                Intent intent=new Intent();
                intent.setClass(SplanshActivity.this,SecondActivity.class);
                startActivity(intent);
            }
        });

        b_basic.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                Intent intent=new Intent();
                intent.setClass(SplanshActivity.this,ThreeActivity.class);
                startActivity(intent);
            }
        });

        b_chart.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                Intent intent=new Intent();
                intent.setClass(SplanshActivity.this,CanvasActivity.class);
                startActivity(intent);
            }
        });
    }
}
