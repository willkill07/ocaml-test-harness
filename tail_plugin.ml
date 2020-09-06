module type PLUG =
  sig
    val sqrt : float -> float -> float
    val sqrt2 : float -> float
    val factorial1 : int -> int
    val factorial2 : int -> int
    val factorial3 : int -> int
    val fibonacci : int -> int
    val rev : 'a list -> 'a list
    val map : ('a -> 'b) -> 'a list -> 'b list
    val map2 : ('a -> 'b) -> 'a list -> 'b list
    val range : int -> int -> int list
    val roots : float list
  end
;;

let p = ref None
;;

let get_plugin () : (module PLUG)  =
  match !p with 
  | Some s -> s
  | None -> failwith "No plugin loaded"
