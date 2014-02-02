import 'dart:io';
import 'dart:math';

void main() {
  var net = new Neural_Net(4, 4);
  net.wire_connections();
  List<double> sample_input = [.02,.2,.6,.02];
  net.run_net(sample_input);
  net.print_net();

}

class Neural_Net
{
  List<Layer> layers = new List<Layer>();
  Neural_Net(int layers, int nodes_in_layer){
    for (int i = 0; i < layers; i++){
      this.layers.add(new Layer(nodes_in_layer));
    }
  }
  
  void print_net(){
    for (int i = 0; i < layers.length; i++){
      var layer = layers[i];
      for (int j = 0; j < layers[i].neurons.length; j++){
        var neuron = layer.neurons[j];
        stdout.write(neuron.output);
      }
      stdout.write('\n');
    }
  }
  
  void run_net(List<double> inputs){
    if (inputs.length != layers[0].neurons.length){
      print('Input size is not not compatable');
    }
    else{
      
      //Set up initial inputs
      for (int i=0; i < layers[0].neurons.length; i++){
        layers[0].neurons[i].output=inputs[i];
      }
      
      
      //Traverse through layers(except for first layer) and compute outputs
      for (int i = 1; i < layers.length; i++){
        layers[i].run_layer();
      }
    }
  }
  
  
  void wire_connections(){
    for (int i = 1; i < layers.length; i++){
      layers[i].add_input_layer(layers[i-1]);
    }
  }
  
  void back_prop(){
    //
  }
  
  List<int> get_output(){
    List<int> rv = new List<int>();
    Layer output_layer = layers[layers.length-1];
    for(int i = 0; i < output_layer.neurons.length; i++){
      rv.add(output_layer.neurons[i].output);
    }
  }
  
}

class Layer
{
  int alpha = 1;
  Layer nextLayer = null;
  Layer previousLayer = null;
  List<Neuron> neurons = new List<Neuron>();
  Layer(int nodes_in_layer){
    for (int i = 0; i<nodes_in_layer; i++){
      neurons.add(new Neuron(this));
    }
    
  }
  void add_input_layer(Layer input_layer){
    previousLayer = input_layer;
    input_layer.nextLayer = this;
    for (int i = 0; i < neurons.length; i++){
      for (int j = 0; j < input_layer.neurons.length; j++){
        neurons[i].add_input(input_layer.neurons[j]);
      }
    }
  }
  
  void run_layer(){
    for(int i = 0; i<neurons.length; i++){
      neurons[i].calculate_output();
    }
  }
  
  Layer next(){
    return this.nextLayer;
  }
  
  Layer previous(){
    return this.previousLayer;
  }
  
}

class Neuron
{
 var alpha = 1;
  List<Connection> input_connections = new List<Connection>();
  var bias;
  var net_input;
  var output;
  var delta;
  var layer;
   
  
  Neuron(Layer l){
    output = 0;
    bias = .5;
    layer = l;
  }
  
  double sigmoid(x){
    return 1/(1+pow(E,(-alpha*x)));
  }
  
  void add_input(Neuron input){
    var random = new Random();
    var rand_weight = random.nextDouble()-.5;
    input_connections.add(new Connection(input, this, rand_weight));
  }
  double calculate_net_input(){
    
    this.net_input = 0;
    for (int i = 0; i < input_connections.length; i++){
      var c = input_connections[i];
      net_input += c.weight * c.n_from.output;
    }
    net_input -= bias;
  }
  
  void calculate_output(){
    calculate_net_input();
    this.output=this.sigmoid(net_input);
  }
  
  void compute_delta(var expected){
    if (layer.next() == null){
      //Compute output delta
      this.delta = 2*alpha*(1-output)* (expected-output);
      
    }
    else{
      //Compute normal delta
      var delta_sum = 0;
      for (int i = 0; i < layer.next().neurons.length;i++){
       Neuron current_neuron = layer.next().neurons[i];
        delta_sum += current_neuron.delta*this.output_connection[i].weight ;
      }
      this.delta = alpha * delta_sum;
    }
  }
}

class Connection
{
  Neuron n_from, n_to;
  double weight;
  Connection(Neuron n_from, Neuron n_to, double weight){
    this.n_from = n_from;
    this.n_to = n_to;
    this.weight = weight;
  }
}