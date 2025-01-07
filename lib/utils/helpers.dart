import 'package:repore_chat/utils/enums.dart';

/// Returns the appropriate role based on the email address
Role getRoleFromEmail(String email) {
  if (email.contains('admin')) {
    return Role.admin;
  } else if (email.contains('agent')) {
    return Role.agent;
  } else {
    return Role.customer;
  }
}

/// Capitalizes the first letter of a string
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;

  return input[0].toUpperCase() + input.substring(1);
}

/// Formats time to always show two digits [i.e. padding with zeros]. E.g. 09:07.
String formatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
