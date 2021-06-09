import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:geolocator/geolocator.dart';

class Funciones  {



  Future<UserLocation> ubicacionLatLong() async {

    UserLocation ubicacionUser;

    final _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(_currentPosition);
    var lat = _currentPosition.latitude;
    var lon = _currentPosition.longitude;

    ubicacionUser = UserLocation(latitude: lat, longitude: lon);

    return ubicacionUser;

  }


}