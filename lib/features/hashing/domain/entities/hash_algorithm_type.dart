enum HashAlgorithmType {
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
      HashAlgorithmType.md5: 'md5',
      HashAlgorithmType.sha1: 'sha1',
      HashAlgorithmType.sha224: 'sha224',
      HashAlgorithmType.sha256: 'sha256',
      HashAlgorithmType.sha384: 'sha384',
      HashAlgorithmType.sha512: 'sha512',
      HashAlgorithmType.sha512224: 'sha512/224',
      HashAlgorithmType.sha512256: 'sha512/256',
    };

    return algorithmToStringMap[this] ?? 'unknown';
  }
}