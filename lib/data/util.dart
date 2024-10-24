String getCategoryNameFromId(String catId) {
  final names = [
    "Music",
    "Dance",
    "Art",
    "Theatre",
    "Comedy",
    "Workshop",
    "Talk",
    "Food",
    "Sports",
    "Outdoor",
    "Indoor"
  ];
  return names[catId.hashCode % names.length];
}

bool containsAny(List listA, List listB) {
  for (var e in listB) {
    if (listA.contains(e)) {
      return true;
    }
  }
  return false;
}
