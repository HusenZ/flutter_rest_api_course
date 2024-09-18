import 'dart:convert';

import 'package:rest_api_test/core/exceptions/server_exception.dart';
import 'package:rest_api_test/domain/entities/user.dart';
import "package:http/http.dart" as http;
import 'package:rest_api_test/private.dart';

abstract class RemoteDataSource {
  Future<void> registerUser(User user);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl(this.client);
  @override
  Future<void> registerUser(User user) async {
    var reqBody = {
      "email": user.email,
      "fullname": user.fullname,
      "username": user.username,
      "password": user.password,
    };
    var response = await client.post(
      Uri.parse(apiUrl), // this the api url
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode != 201) {
      // throw an error
      throw ServerException("Failed to Register user in the backend");
    }
  }
}

/*

HTTP METHODS:

GET: Used to retrieve data from a server. For example, fetching user profiles.
POST: Used to send data to a server, such as submitting a form or creating a new user.
PUT/PATCH: Used to update existing data on the server, like editing user details.
DELETE: Used to remove data from the server, for instance, deleting a user account.

-----------------------------------------------------------------------------------------
HTTP STATUS CODE: 

200 OK: Indicates that the request was successful and the server returned the requested data.
201 Created: Indicates that a new resource was successfully created on the server.
400 Bad Request: The server could not understand the request due to invalid syntax.
401 Unauthorized: Authentication is required or has failed.
403 Forbidden: The server understands the request but refuses to authorize it.
404 Not Found: The requested resource could not be found on the server.
500 Internal Server Error: The server encountered an error while processing the request.

------------------------------------------------------------------------------------------

REQUEST AND RESPONSE STRUCTURE:

Request Headers: Used to pass metadata or additional information with the request.
Request Body: Contains data sent to the server (e.g., form submissions).

Response Headers: Contain metadata about the response.
Response Body: Contains the data returned from the server.

*/
