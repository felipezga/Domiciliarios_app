import 'package:domiciliarios_app/Modelo/DomicilioModel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class DomicilioRepo {
  Future<List<Domicilio>> getDomicilioList();
}

class DomicilioServices implements DomicilioRepo {
    static const _baseUrl = 'jsonplaceholder.typicode.com';
  static const String _GET_DOMICILIOS = '/albums';
  @override
  Future<List<Domicilio>> getDomicilioList() async {
    Uri uri = Uri.https(_baseUrl, _GET_DOMICILIOS);
    Response response = await http.get(uri);
    List<Domicilio> domis = albumFromJson(response.body);
    return domis;
  }
}
