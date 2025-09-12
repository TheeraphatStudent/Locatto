class ResponseHelper {
  isSuccess(int statusCode) {
    return statusCode == 200 || statusCode == 201 || statusCode == 202;
  }

  isRedirect(int statusCode) {
    return statusCode == 302;
  }

  isError(int statusCode) {
    return statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 500;
  }

  isServerError(int statusCode) {
    return statusCode == 500;
  }

  isBadRequest(int statusCode) {
    return statusCode == 400;
  }

  isUnauthorized(int statusCode) {
    return statusCode == 401;
  }

}