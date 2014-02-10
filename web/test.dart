import './nnet.dart' as nnet;
import 'dart:io';

var learning_rate=.01;
void main() {
for (int t = 0; t < 20; t++){
  var rmse_tot = 0;
for (int n = 0; n < 10; n++){
  var net = new nnet.Neural_Net(3, 2,2,1);
  net.wire_connections();
  List<double> sample_input = [1,1];
  List<double> expected_output = [0];
  List<double> sample_input2 = [0,0];
  List<double> expected_output2 = [0];
  List<double> sample_input3= [0,1];
  List<double> expected_output3= [1];
  List<double> sample_input4 = [1,0];
  List<double> expected_output4 = [1];

  for(int i = 0; i <1000; i++){
    net.learn(sample_input, expected_output);
    net.learn(sample_input2, expected_output2);
    net.learn(sample_input3, expected_output3);
    net.learn(sample_input4, expected_output4);
  }
  List<List<double>> inputs = new List<List<double>>();
  List<List<double>> outputs = new List<List<double>>();

  inputs.add(sample_input);
  inputs.add(sample_input2);
  inputs.add(sample_input3);
  inputs.add(sample_input4);
  
  outputs.add(expected_output);
  outputs.add(expected_output2);
  outputs.add(expected_output3);
  outputs.add(expected_output4);

  rmse_tot += net.test_net(inputs, outputs);
}
  var rmse_eq = rmse_tot/10;
  stdout.write(learning_rate.toString() + ',');
  stdout.write(rmse_eq.toString() + '\n');
  learning_rate += .1;
}

}
