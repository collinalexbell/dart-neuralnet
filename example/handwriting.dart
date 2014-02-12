import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:csvparser/csvparser.dart';
import '../lib/nnet.dart' as nnet;

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
  List<String> temp = new List<String>();
  List<List<double>> rv = new List<List<double>>();
  CsvParser cp = new CsvParser(data, seperator:",");
  while(cp.moveNext()){
    temp = cp.current.toList();
    List<double> add_me = new List<double>();
    for (int i = 0; i < temp.length; i++){
      add_me.add(double.parse(temp[i]));
    }
    rv.add(add_me);
    //print(cp.current.toList());
  }
  return rv;
}

List<int> get_answers(String data){
  CsvParser cp = new CsvParser(data, seperator:",");
  List<int> rv = new List<int>();
  while(cp.moveNext()){
    cp.current.moveNext();
    rv.add(int.parse(cp.current.current));
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
        outputs.add([1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
        break;
      case 1:
        outputs.add([0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
        break;
      case 2:
        outputs.add([0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]);
        break;
      case 3:
        outputs.add([0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0]);
        break;
      case 4:
        outputs.add([0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0]);
        break;
      case 5:
        outputs.add([0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0]);
        break;
      case 6:
        outputs.add([0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0]);
        break;
      case 7:
        outputs.add([0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0]);
        break;
      case 8:
        outputs.add([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0]);
        break;
      case 9:
        outputs.add([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]);
        break;
      default:

    }
  }
  // Do nnet and stats

  for (int n = 0; n < 1; n++){
  var net = new nnet.Neural_Net(2,100,inputs[0].length, outputs[0].length, .1);
  net.wire_connections();

  for (int i = 0; i < 2; i++){
    print ('Epoch:' + i.toString());
    for (int j = 0; j < inputs.length; j++){
      if (j%7 == 0){ 
        net.learn(inputs[j], outputs[j]);
      }
      
      if(j%22 == 0){
        var out = net.run_net(inputs[j]);
        //var out = net.get_output();
        print('Expected Out:'+ outputs[j].toString());
        print('Actual Out:'+ out.toString());
      }
    }
  }

  print(net.test_net(inputs, outputs));
  }

}


