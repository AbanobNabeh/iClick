class Relationship {
  static String handle(String type) {
    if (type == "follow" || type == 'double') {
      return "UnFollow";
    } else if (type == "following") {
      return "Follow Back";
    } else if (type == "nothing") {
      return "Follow";
    } else {
      return type;
    }
  }
}
