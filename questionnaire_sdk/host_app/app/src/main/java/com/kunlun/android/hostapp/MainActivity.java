package com.kunlun.android.hostapp;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.kunlun.platform.android.questionnair.QuestionnairSdk;

public class MainActivity extends AppCompatActivity {
    private QuestionnairSdk questionnairSdk;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize QuestionnairSdk
        questionnairSdk = QuestionnairSdk.getInstance(this);
        
        // Configure SDK parameters (optional)
        QuestionnairSdk.setDebugMode(true);
        QuestionnairSdk.setTest(true); // Set to false for production
        QuestionnairSdk.setLang("en"); // Set language

        Button openQuestionnaireButton = findViewById(R.id.btn_open_flutter);
        openQuestionnaireButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openQuestionnaire();
            }
        });
    }

    private void openQuestionnaire() {
        try {
            // Example vote ID - replace with actual vote ID
            int voteId = 12345;
            
            questionnairSdk.showQuestionnaire(this, voteId, "en", new QuestionnairSdk.QuestionnairListioner() {
                @Override
                public void onComplete(int retcode, String retmsg) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (retcode == 0) {
                                Toast.makeText(MainActivity.this, "Questionnaire completed successfully", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(MainActivity.this, "Questionnaire closed: " + retmsg, Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                }
            });
        } catch (Exception e) {
            Toast.makeText(this, "Failed to open questionnaire: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
}