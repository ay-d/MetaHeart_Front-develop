import "dart:collection" show Queue;

class Stack<T> {
  final Queue<T> _underlyingQueue;

  Stack({List<T>? init}) : _underlyingQueue = Queue<T>() {
    _underlyingQueue.addAll(init ?? []);
  }

  int get length => this._underlyingQueue.length;

  bool get isEmpty => this._underlyingQueue.isEmpty;

  bool get isNotEmpty => this._underlyingQueue.isNotEmpty;

  void clear() => this._underlyingQueue.clear();

  T? peek() {
    if (this.isEmpty) return null;
    return this._underlyingQueue.last;
  }

  T? pop() {
    if (this.isEmpty) return null;
    return this._underlyingQueue.removeLast();
  }

  List<T> get all {
    if (this.isEmpty) return [];
    return this._underlyingQueue.toList();
  }

  void push(final T element) => this._underlyingQueue.addLast(element);

  void pushAll(final List<T> element) => this._underlyingQueue.addAll(element);
}
