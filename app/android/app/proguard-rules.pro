# WorkManager's Room database is created by reflection.
-keep class androidx.work.** { *; }
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
# Our native entry points (worker, receiver, activity).
-keep class ir.ashkan.daftar.** { *; }
# flutter_local_notifications serialises with Gson.
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepattributes *Annotation*, Signature
