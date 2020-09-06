
val check_for_tailrec_string : string -> bool
val check_non_tailrec : string -> bool
val check_tailrec : string -> bool
val check_ite : string -> bool
val check_non_ite : string -> bool
val check_match : string -> bool
val check_non_match : string -> bool
val check_style : string -> (string -> bool) list -> string -> unit -> Harness.result
val compile : string -> unit -> Harness.result
val check_pervasives : string -> unit -> Harness.result