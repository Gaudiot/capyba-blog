import 'package:firebase_auth/firebase_auth.dart';

enum StoreStatus {
  successful,
  notFound,
  alreadyExists,
  permissionDenied,
  unavailable,
  unknown
}

class StoreExceptionHandler {
  static StoreStatus handleAuthException(FirebaseAuthException err) {
    StoreStatus status;
    final String errCode = err.code.toLowerCase().replaceAll('_', '-');
    switch (errCode) {
      case "not-found":
        status = StoreStatus.notFound;
        break;
      case "already-exists":
        status = StoreStatus.alreadyExists;
        break;
      case "permission-denied":
        status = StoreStatus.permissionDenied;
        break;
      case "unavailable":
        status = StoreStatus.unavailable;
        break;
      default:
        status = StoreStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case StoreStatus.notFound:
        errorMessage = "The requested document was not found.";
        break;
      case StoreStatus.alreadyExists:
        errorMessage = "Document already exists.";
        break;
      case StoreStatus.permissionDenied:
        errorMessage = "You don't have the required permission.";
        break;
      case StoreStatus.unavailable:
        errorMessage =
            "The service is unavailable at the momment. Please try again later.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}