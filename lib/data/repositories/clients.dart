import 'package:contract_management/_all.dart';

abstract class IClients {
  Future<List<UserModel>?> getClients();
  Future<String?> deleteClient(String uid);
  Future<bool> sendClientRequest(ClientRequestModel clientRequestModel);
}

class ClientsRepo implements IClients {
  FirebaseFirestoreClass firebaseFirestoreClass;
  INotifications notificationsRepo;

  ClientsRepo({required this.firebaseFirestoreClass, required this.notificationsRepo});

  @override
  Future<List<UserModel>?> getClients() async {
    final jsonData = await firebaseFirestoreClass.getDataWithFilter("users", "role", "Client");
    return jsonData == null ? null : jsonData.map<UserModel>((json) => UserModel.fromMap(json))?.toList();
  }

  @override
  Future<String?> deleteClient(String userId) async {
    final result = await firebaseFirestoreClass.deleteData('users', userId);
    return result;
  }

  @override
  Future<bool> sendClientRequest(ClientRequestModel clientRequestModel) async {
    notificationsRepo.sendNotification(NotificationModel(userId: 'admin', message: 'You have new client request'));
    return await firebaseFirestoreClass.storeData('requests', null, clientRequestModel.toMap());
  }
}
