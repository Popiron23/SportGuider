package com.example.sportguider

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("7a8da59c-c209-4c3b-b1d2-d286e2de022f") // Your generated API key
    }
}