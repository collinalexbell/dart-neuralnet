import 'package:start/start.dart';

void main() {
    start(port: 3000).then((Server app) {
          app.static('web');
    });
}
