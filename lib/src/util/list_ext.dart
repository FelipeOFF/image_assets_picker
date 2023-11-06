extension ListExt<T> on Iterable<T> {
  T? safeElementAt(int index) => length <= index ? null : elementAt(index);
  T? safeGet(int index) => index < length ? elementAt(index) : null;
}