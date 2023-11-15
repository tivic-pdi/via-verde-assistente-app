import 'package:nylo_framework/nylo_framework.dart';

class Usuario extends Model {
  String? nmEmail;
  String? nmSenha;

  Usuario({required this.nmEmail, required this.nmSenha});

  Usuario.fromJson(dynamic data) {
    nmEmail = data["nmEmail"];
    nmSenha = data["nmSenha"];
  }

  toJson() => {"nmSenha": nmSenha, "nmEmail": nmEmail};
}
