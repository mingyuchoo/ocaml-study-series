(** Vanilla RNN Implementation in OCaml *)

(** {1 Types} *)

(** A vector represented as a list of floats *)
type vector = float list

(** A matrix represented as a list of lists of floats *)
type matrix = float list list

(** RNN parameters containing weight matrices and bias vectors *)
type rnn_params =
  { wxh: matrix;  (** Input to hidden weights *)
    whh: matrix;  (** Hidden to hidden (recurrent) weights *)
    why: matrix;  (** Hidden to output weights *)
    bh: vector;  (** Hidden bias *)
    by: vector  (** Output bias *)
  }

(** RNN state containing the hidden state vector *)
type rnn_state = { hidden: vector }

(** Gradients for all RNN parameters *)
type rnn_grads =
  { dwxh: matrix;  (** Gradient for wxh *)
    dwhh: matrix;  (** Gradient for whh *)
    dwhy: matrix;  (** Gradient for why *)
    dbh: vector;  (** Gradient for bh *)
    dby: vector  (** Gradient for by *)
  }

(** {1 Utility Functions} *)

(** Sum all elements in a list *)
val sum : float list -> float

(** Apply a binary function element-wise to two lists *)
val zip_with : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list

(** Element-wise vector addition *)
val vec_add : vector -> vector -> vector

(** Element-wise vector subtraction *)
val vec_sub : vector -> vector -> vector

(** Scale a vector by a scalar *)
val vec_scale : float -> vector -> vector

(** Transpose a matrix *)
val transpose : matrix -> matrix

(** Matrix-vector multiplication *)
val mat_vec_mul : matrix -> vector -> vector

(** Compute outer product of two vectors *)
val outer_product : vector -> vector -> matrix

(** Element-wise matrix addition *)
val mat_add : matrix -> matrix -> matrix

(** Scale a matrix by a scalar *)
val scale_matrix : float -> matrix -> matrix

(** Create a zero vector of given size *)
val zeros_vector : int -> vector

(** Create a zero matrix of given dimensions *)
val zeros_matrix : int -> int -> matrix

(** {1 Activation Functions} *)

(** Apply tanh activation element-wise *)
val tanh_activation : vector -> vector

(** Compute derivative of tanh element-wise *)
val tanh_derivative : vector -> vector

(** Apply softmax activation *)
val softmax : vector -> vector

(** {1 Initialization} *)

(** Generate a random list of floats *)
val random_list : Random.State.t -> int -> float list

(** Generate a random matrix with small values *)
val random_matrix : Random.State.t -> int -> int -> matrix

(** Generate a random vector *)
val random_vector : Random.State.t -> int -> vector

(** Initialize RNN parameters with random values *)
val init_rnn :
  input_size:int ->
  hidden_size:int ->
  output_size:int ->
  Random.State.t ->
  rnn_params

(** Initialize hidden state with zeros *)
val init_hidden_state : int -> rnn_state

(** {1 Forward Pass} *)

(** Perform a single RNN step. Returns (output, new_state, hidden) *)
val rnn_step :
  rnn_params -> rnn_state -> vector -> vector * rnn_state * vector

(** Forward pass through the RNN for a sequence of inputs *)
val rnn_forward :
  rnn_params -> rnn_state -> vector list -> vector list * rnn_state list

(** {1 Gradient Operations} *)

(** Initialize gradients to zero *)
val zero_gradients : int -> int -> int -> rnn_grads

(** Add two gradient structures element-wise *)
val add_gradients : rnn_grads -> rnn_grads -> rnn_grads

(** Update parameters using gradients and learning rate *)
val update_params : float -> rnn_params -> rnn_grads -> rnn_params

(** {1 Loss} *)

(** Compute cross-entropy loss between target and output *)
val cross_entropy_loss : vector -> vector -> float

(** {1 Backpropagation} *)

(** Compute gradients for a single time step *)
val compute_step_gradients :
  rnn_params -> vector -> vector -> vector -> vector -> vector -> rnn_grads

(** Compute gradients using backpropagation through time *)
val compute_simple_gradients :
  rnn_params ->
  vector list ->
  vector list ->
  vector list ->
  rnn_state list ->
  rnn_grads

(** {1 Training} *)

(** Training loop with loss monitoring *)
val train_loop :
  rnn_params -> vector list -> vector list -> float -> int -> rnn_params

(** Example training scenario *)
val train_example : unit -> unit
