# Keep ONNX Runtime JNI classes
-keep class ai.onnxruntime.** { *; }
-dontwarn ai.onnxruntime.**

# Optional: Flutter plugin classes
-keep class com.microsoft.onnxruntime.** { *; }
-dontwarn com.microsoft.onnxruntime.**
