package com.uygaryasar.movie.movie

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.graphics.Color

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Set window background to black before Flutter loads
        window.decorView.setBackgroundColor(Color.BLACK)
        super.onCreate(savedInstanceState)
    }
}
