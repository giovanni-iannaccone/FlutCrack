bool isAlgorithmUnknown(String result) {
  return result == "Unable to identify the algorithm";
}

String determineAlgorithm(String result, dropdownValue) {
  return result == "true" ? dropdownValue : result;
}