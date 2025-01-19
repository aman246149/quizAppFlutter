class Validation {
  static String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "\u24D8 This field is required";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "\u24D8 Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "\u24D8 Please enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "\u24D8 Password is required";
    }
    if (value.length < 8) {
      return "\u24D8 Password must be at least 8 characters";
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "\u24D8 This field is required";
    }
    if (value.length < 2) {
      return "\u24D8 Must be at least 2 characters";
    }
    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "\u24D8 Username is required";
    }
    if (value.length < 3) {
      return "\u24D8 Username must be at least 3 characters";
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return "\u24D8 Username can only contain letters, numbers and underscore";
    }
    return null;
  }
}
