enum Status { alive, dead, unknown, empty }

extension StatusExtension on Status {
  String get value {
    switch (this) {
      case Status.alive:
        return 'alive';
      case Status.dead:
        return 'dead';
      case Status.unknown:
        return 'unknown';
      case Status.empty:
      default:
        return '';
    }
  }
}
