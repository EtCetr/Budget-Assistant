/// Активное пространство пользователя (пара id + имя для UI-селекторов).
///
/// Доменная модель без JSON: используется только для отображения
/// и переключения активной группы (Multi-group, Many-to-Many).
class UserSpace {
  const UserSpace({required this.id, required this.name});

  final String id;
  final String name;
}