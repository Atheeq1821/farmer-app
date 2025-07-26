import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://moxofvsxjyvxsnvsmwjr.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1veG9mdnN4anl2eHNudnNtd2pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM1Mzk3OTUsImV4cCI6MjA2OTExNTc5NX0.tO2igtAlRNTRiFzfA0YqevNO42jVfwz7J2yUUmG03No';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
