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
