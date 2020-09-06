open Tail_plugin

module M:PLUG =
  struct
    let sqrt : float -> float -> float = sqrt
    let sqrt2 : float -> float = sqrt2
    let factorial1 : int -> int = factorial1
    let factorial2 : int -> int = factorial2
    let factorial3 : int -> int = factorial3
    let fibonacci : int -> int = fibonacci
    let rev : 'a list -> 'a list = rev
    let map : ('a -> 'b) -> 'a list -> 'b list = map
    let map2 : ('a -> 'b) -> 'a list -> 'b list = map2
    let range : int -> int -> int list = range
    let roots : float list = roots
  end
  
let () = 
  p := Some (module M:PLUG)
