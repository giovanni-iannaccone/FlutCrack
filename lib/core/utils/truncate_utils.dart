String truncateFileName(String fileName, [int maxLength = 20]) {
  return fileName.length > maxLength
    ? "${fileName.substring(0, maxLength)}..."
    : fileName;
}