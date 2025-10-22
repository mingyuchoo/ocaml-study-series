(* vanilla_rnn_init.ml - Simple RNN implementation in OCaml *)

(* --- Types --- *)
type vector = float list

type matrix = float list list

type rnn_params =
  { wxh: matrix; (* input -> hidden *)
    whh: matrix; (* hidden -> hidden (recurrent) *)
    why: matrix; (* hidden -> output *)
    bh: vector; (* hidden bias *)
    by: vector (* output bias *)
  }

type rnn_state = { hidden: vector }

type rnn_grads =
  { dwxh: matrix; dwhh: matrix; dwhy: matrix; dbh: vector; dby: vector }

(* --- Utility functions --- *)
let sum lst = List.fold_left ( +. ) 0.0 lst

let zip_with f a b = List.map2 f a b

let vec_add = zip_with ( +. )

let vec_sub = zip_with ( -. )

let vec_scale s = List.map (fun x -> s *. x)

let rec transpose m =
  match m with
  | [] -> []
  | [] :: _ -> []
  | rows ->
      let heads = List.map List.hd rows in
      let tails = List.map List.tl rows in
      heads :: transpose tails

let mat_vec_mul (m : matrix) (v : vector) : vector =
  List.map (fun row -> sum (List.map2 ( *. ) row v)) m

let outer_product (v1 : vector) (v2 : vector) : matrix =
  List.map (fun x -> List.map (fun y -> x *. y) v2) v1

let mat_add (a : matrix) (b : matrix) : matrix =
  List.map2 (fun ra rb -> List.map2 ( +. ) ra rb) a b

let scale_matrix s = List.map (fun row -> List.map (fun x -> s *. x) row)

let zeros_vector n = List.init n (fun _ -> 0.0)

let zeros_matrix r c = List.init r (fun _ -> zeros_vector c)

(* --- Activation functions --- *)
let tanh_activation = List.map tanh

let tanh_derivative xs = List.map (fun x -> 1.0 -. (x *. x)) xs

let softmax xs =
  let max_x =
    List.fold_left (fun a b -> if b > a then b else a) (List.hd xs) xs
  in
  let exps = List.map (fun x -> exp (x -. max_x)) xs in
  let s = sum exps in
  List.map (fun e -> e /. s) exps

(* --- Random initialization --- *)
let random_list st n =
  List.init n (fun _ -> Random.State.float st 2.0 -. 1.0)

let random_matrix st rows cols =
  let scale = 0.01 in
  List.init rows (fun _ ->
      List.map (fun x -> x *. scale) (random_list st cols) )

let random_vector st n = random_list st n

let init_rnn ~input_size ~hidden_size ~output_size st =
  let wxh = random_matrix st hidden_size input_size in
  let whh = random_matrix st hidden_size hidden_size in
  let why = random_matrix st output_size hidden_size in
  let bh = random_vector st hidden_size in
  let by = random_vector st output_size in
  { wxh; whh; why; bh; by }

let init_hidden_state hidden_size = { hidden= zeros_vector hidden_size }

(* --- RNN forward (single step & sequence) --- *)
let rnn_step params state input =
  let h_prev = state.hidden in
  let h_raw =
    vec_add
      (mat_vec_mul params.wxh input)
      (vec_add (mat_vec_mul params.whh h_prev) params.bh)
  in
  let h_t = tanh_activation h_raw in
  let y_raw = vec_add (mat_vec_mul params.why h_t) params.by in
  let y_t = softmax y_raw in
  (y_t, { hidden= h_t }, h_t)

let rnn_forward params init_state inputs =
  let rec go state xs outputs states =
    match xs with
    | [] -> (List.rev outputs, List.rev states)
    | x :: rest ->
        let y, new_state, _ = rnn_step params state x in
        go new_state rest (y :: outputs) (new_state :: states)
  in
  go init_state inputs [] []

(* --- Gradient initialization / operations --- *)
let zero_gradients input_size hidden_size output_size =
  { dwxh= zeros_matrix hidden_size input_size;
    dwhh= zeros_matrix hidden_size hidden_size;
    dwhy= zeros_matrix output_size hidden_size;
    dbh= zeros_vector hidden_size;
    dby= zeros_vector output_size
  }

let add_gradients g1 g2 =
  { dwxh= mat_add g1.dwxh g2.dwxh;
    dwhh= mat_add g1.dwhh g2.dwhh;
    dwhy= mat_add g1.dwhy g2.dwhy;
    dbh= vec_add g1.dbh g2.dbh;
    dby= vec_add g1.dby g2.dby
  }

let update_params lr params grads =
  { wxh= mat_add params.wxh (scale_matrix (-.lr) grads.dwxh);
    whh= mat_add params.whh (scale_matrix (-.lr) grads.dwhh);
    why= mat_add params.why (scale_matrix (-.lr) grads.dwhy);
    bh= vec_add params.bh (vec_scale (-.lr) grads.dbh);
    by= vec_add params.by (vec_scale (-.lr) grads.dby)
  }

(* --- Loss --- *)
let cross_entropy_loss target output =
  let eps = 1e-8 in
  -.sum (List.map2 (fun t o -> t *. log (o +. eps)) target output)

(* --- Gradient computation for each step --- *)
let compute_step_gradients params input target output h_t dh_next =
  let dy = vec_sub output target in
  let dh_raw = vec_add (mat_vec_mul (transpose params.why) dy) dh_next in
  let dh = List.map2 ( *. ) dh_raw (tanh_derivative h_t) in
  { dwxh= outer_product dh input;
    dwhh= outer_product dh h_t;
    dwhy= outer_product dy h_t;
    dbh= dh;
    dby= dy
  }

let compute_simple_gradients params inputs targets outputs states =
  let input_size =
    match inputs with
    | [] -> 0
    | x :: _ -> List.length x
  in
  let hidden_size = List.length params.bh in
  let output_size = List.length params.by in
  let zero_grads = zero_gradients input_size hidden_size output_size in
  (* Process in reverse order and accumulate gradients *)
  let rec go inps tgts outs sts dh_next acc =
    match (inps, tgts, outs, sts) with
    | [], [], [], [] -> acc
    | inp :: inps', tgt :: tgts', out :: outs', st :: sts' ->
        let grad =
          compute_step_gradients params inp tgt out st.hidden dh_next
        in
        let dh_next' = mat_vec_mul (transpose params.whh) grad.dbh in
        go inps' tgts' outs' sts' dh_next' (grad :: acc)
    | _ -> acc
  in
  let grads_with_hidden =
    go (List.rev inputs) (List.rev targets) (List.rev outputs)
      (List.rev states)
      (zeros_vector hidden_size)
      []
  in
  List.fold_left add_gradients zero_grads grads_with_hidden

(* --- Training loop --- *)
let rec train_loop params inputs targets lr epochs =
  if epochs = 0 then params
  else
    let outputs, states =
      rnn_forward params (init_hidden_state (List.length params.bh)) inputs
    in
    let loss =
      List.fold_left2
        (fun acc t o -> acc +. cross_entropy_loss t o)
        0.0 targets outputs
    in
    let grads =
      compute_simple_gradients params inputs targets outputs states
    in
    let new_params = update_params lr params grads in
    if epochs mod 10 = 0 then (
      Printf.printf "Epoch %d, Loss: %f\n" epochs loss;
      flush stdout;
      train_loop new_params inputs targets lr (epochs - 1) )
    else train_loop new_params inputs targets lr (epochs - 1)

(* --- Example data & execution --- *)
let train_example () =
  let st = Random.State.make_self_init () in
  let input_size = 3 in
  let hidden_size = 5 in
  let output_size = 3 in
  let learning_rate = 0.1 in
  let epochs = 200 in
  let params = init_rnn ~input_size ~hidden_size ~output_size st in
  let inputs = [[1.0; 0.0; 0.0]; [0.0; 1.0; 0.0]; [0.0; 0.0; 1.0]] in
  let targets = [[0.0; 1.0; 0.0]; [0.0; 0.0; 1.0]; [1.0; 0.0; 0.0]] in
  Printf.printf "RNN 학습 시작...\n";
  let trained = train_loop params inputs targets learning_rate epochs in
  Printf.printf "\n학습된 모델 테스트:\n";
  let outputs, _ =
    rnn_forward trained (init_hidden_state hidden_size) inputs
  in
  let rec iter3 f l1 l2 l3 =
    match (l1, l2, l3) with
    | [], [], [] -> ()
    | x1 :: xs1, x2 :: xs2, x3 :: xs3 -> f x1 x2 x3; iter3 f xs1 xs2 xs3
    | _ -> invalid_arg "iter3: lists have different lengths"
  in
  iter3
    (fun i o t ->
      Printf.printf "입력: %s\n"
        (String.concat "," (List.map string_of_float i));
      Printf.printf "예측: %s\n"
        (String.concat "," (List.map (Printf.sprintf "%.4f") o));
      Printf.printf "정답: %s\n\n"
        (String.concat "," (List.map string_of_float t)) )
    inputs outputs targets
