import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class GeoFireProvider {
  late CollectionReference _ref;
  late Geoflutterfire _geo;

  GeoFireProvider() {
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = Geoflutterfire();
  }

  Stream<DocumentSnapshot> getLocationByIdSteam(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(String id, double lat, double lng) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref
        .doc(id)
        .set({'status': 'drivers_avaibles', 'position': myLocation.data});
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }
}
