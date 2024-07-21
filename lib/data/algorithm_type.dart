enum AlgorithmType {
  unknown,
  md5,
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
  sha512224,
  sha512256;

  String get formattedName {

    const algorithmToStringMap = {
      AlgorithmType.md5: 'md5',
      AlgorithmType.sha1: 'sha1',
      AlgorithmType.sha224: 'sha224',
      AlgorithmType.sha256: 'sha256',
      AlgorithmType.sha384: 'sha384',
      AlgorithmType.sha512: 'sha512',
      AlgorithmType.sha512224: 'sha512/224',
      AlgorithmType.sha512256: 'sha512/256',
    };

    return algorithmToStringMap[this] ?? 'unknown';
  }
}