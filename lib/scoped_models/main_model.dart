import 'package:scoped_model/scoped_model.dart';


import './connected_model.dart';

class MainModel extends Model with ConnectedModel, EventModel, UserModel{

}