-keepattributes Annotation, InnerClasses
-dontnote kotlinx.serialization.SerializationKt
-keep,includedescriptorclasses class org.ikol.public_app.MyModel {  }
-keepclassmembers class org.ikol.public_app.* {
*** Companion;
}
-keepclasseswithmembers class org.ikol.public_app.* {
    kotlinx.serialization.KSerializer serializer(...);
}

# https://github.com/Kotlin/kotlinx.serialization/issues/1105#issuecomment-702670865
