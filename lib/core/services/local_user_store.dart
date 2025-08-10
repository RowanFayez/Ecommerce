import '../../data/models/user.dart';

class LocalUserStore {
  final List<User> _createdUsers = [];

  List<User> get users => List.unmodifiable(_createdUsers);

  void add(User user) {
    // Avoid duplicates by id or username
    final exists = _createdUsers
        .any((u) => u.id == user.id || u.username == user.username);
    if (!exists) {
      _createdUsers.add(user);
    }
  }
}
