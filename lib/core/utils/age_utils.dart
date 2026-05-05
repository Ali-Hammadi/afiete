int? calculateAge(DateTime? birthDate) {
  if (birthDate == null) {
    return null;
  }

  final today = DateTime.now();
  var age = today.year - birthDate.year;
  final hasHadBirthdayThisYear =
      today.month > birthDate.month ||
      (today.month == birthDate.month && today.day >= birthDate.day);
  if (!hasHadBirthdayThisYear) {
    age -= 1;
  }

  return age < 0 ? 0 : age;
}
