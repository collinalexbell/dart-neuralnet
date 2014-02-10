import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:csvparser/csvparser.dart';
import '../nnet.dart' as nnet;

void main(){
  var file = new File('../data/digits.txt');
  Future<String> finishedReading = file.readAsString(encoding: ASCII);
  finishedReading.then((input_text){
    List<List<double>> inputs = get_inputs(input_text);
    
    var answer_file = new File('../data/digit_labels.txt');
    Future<String> finished_reading_answer = answer_file.readAsString(encoding: ASCII);
    finished_reading_answer.then((answer_text){
      List<int> answers = get_answers(answer_text);
      print("Number of data:" + inputs.length.toString());
      print("Number of answers:" + answers.length.toString());
      start_net(inputs, answers);
    });

  });


}

List<List<double>> get_inputs(String data){
  List<List<double>> rv = new List<List<double>>();
  CsvParser cp = new CsvParser(data, seperator:",");
  while(cp.moveNext()){
    rv.add(cp.current.toList());
    //print(cp.current.toList());
  }
  return rv;
}

List<int> get_answers(String data){
  CsvParser cp = new CsvParser(data, seperator:",");
  List<int> rv = new List<int>();
  while(cp.moveNext()){
    cp.current.moveNext();
    rv.add(cp.current.current);
  }
  //print(rv);
  return rv;

}

void start_net(List<List<double>> inputs, List<int> answers){
  //Convert the answers to values computable by the neural net
  List<List<double>> outputs = new List<double>();
  for (int i = 0; i < answers.length; i++){
    switch(answers[i]){
      case 10:
        outputs.add([1,0,0,0,0,0,0,0,0,0]);
        break;
      case 1:
        outputs.add([0,1,0,0,0,0,0,0,0,0]);
        break;
      case 2:
        outputs.add([0,1,0,0,0,0,0,0,0,0]);
        break;
      case 3:
        outputs.add([0,0,0,1,0,0,0,0,0,0]);
        break;
      case 4:
        outputs.add([0,0,0,0,1,0,0,0,0,0]);
        break;
      case 5:
        outputs.add([0,0,0,0,0,1,0,0,0,0]);
        break;
      case 6:
        outputs.add([0,0,0,0,0,0,1,0,0,0]);
        break;
      case 7:
        outputs.add([0,0,0,0,0,0,0,1,0,0]);
        break;
      case 8:
        outputs.add([0,0,0,0,0,0,0,0,1,0]);
        break;
      case 9:
        outputs.add([0,0,0,0,0,0,0,0,0,1]);
        break;

    }
  }
  // Do nnet and stats

  for (int n = 0; n < 10; n++){
  var net = new nnet.Neural_Net(5,100,inputs[0].length, ouputs[0].length);

  for (int i = 0; i < 500; i++){
    for (int j = 0; j < inputs.length; j++){
      net.learn(inputs[j], outputs[j]);
    }
  }

  rmse_tot +=net.test_net(inputs, outputs);
  }
  var rmse_eq = rmse_tot/10;
  stdout.write(rmse_eq.toString() + '\n');

}


