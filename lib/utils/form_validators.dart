class FormValidator {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'RegNo is Required!';
    } else if (value.length < 11 || value.length > 21) {
      return 'a Valid RegNo is Required!';
    }
    return null;
  }
  static String? validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'username is Required!';
    } else if (value.length < 6 || value.length > 21) {
      return 'a Valid username is Required!';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is Required!';
    }
    return null;
  }

  static String? validateCourse(String? value) {
    if (value == null || value.isEmpty) {
      return 'Course Title is Required!';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is Required!';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender is Required!';
    }
    return null;
  }

  static String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is Required!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is Required!';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters!';
    }
    return null;
  }
}
