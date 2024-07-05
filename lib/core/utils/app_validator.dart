class AppValidator {
  static firstnameVali(value) {
    if (value == null || value.isEmpty) {
      return 'First Name empty';
    } else if (value.length > 16) {
      return 'First Name must be less';
    } else if (value.length < 3) {
      return 'First Name must be more';
    }
  }

  static lastnameVali(value) {
    if (value == null || value.isEmpty) {
      return 'Last Name empty';
    } else if (value.length > 16) {
      return 'Last Name must be less';
    } else if (value.length < 3) {
      return 'Last Name must be more';
    }
  }

  static emailVali(value) {
    if (value!.isEmpty) {
      return 'Email empty';
    } else if (!_isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
  }

  static bool _isValidEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static passwordVali(value, context) {
    if (value.isEmpty) {
      return "Password empty";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
  }

  static confrimpassVali(value, context, password) {
    if (value.isEmpty) {
      return "Confirm password empty";
    } else if (value != password) {
      return "Confirm password does not match the original password";
    }
  }

  static otpVail(value, context) {
    if (value.isEmpty) {
      return "OTP empty";
    } else if (value.length < 6) {
      return "OTP must be at least 6 characters long";
    }
  }

  static messagevaild(value) {
    if (value.isEmpty) {
      return "Message Empty";
    }
  }

  static String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length < 3 || value.length > 20) {
      return 'Username must be between 3 and 20 characters';
    }
    const pattern = r'^[a-zA-Z0-9_]+$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }
}
