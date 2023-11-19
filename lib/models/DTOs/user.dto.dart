class UserDTO{
  final String? username;
  final String email;
  final String password;

  UserDTO({
    this.username,
    required this.email,
    required this.password
  });
}