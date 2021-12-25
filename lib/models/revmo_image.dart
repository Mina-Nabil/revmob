class RevmoCarImage implements Comparable {
  final int _value;
  final String _imageURL;
  final bool _isModelImage;

  RevmoCarImage({required String imageURL, required int sortingValue, required bool isModelImage})
      : _imageURL = imageURL,
        _value = sortingValue,
        _isModelImage = isModelImage;

  int get sortValue => _value;
  String get url => _imageURL;
  bool get isModelImage => _isModelImage;

  @override
  int compareTo(other) {
    assert(other is RevmoCarImage, "Comparing to non-RevmoCarImage");
    if (this.isModelImage && !other.isModelImage) return -1;
    if (!this.isModelImage && other.isModelImage) return 1;
    if (this._value > other._value)
      return -1;
    else if (this._value < other._value) return 1;
    return 0;
  }
}
