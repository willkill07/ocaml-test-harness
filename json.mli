type json = [
  | `Assoc of (string * json) list
  | `Bool of bool
  | `Float of float
  | `Int of int
  | `List of json list
  | `Null
  | `String of string
]
val print_json : json -> unit

val replace : string -> string -> string -> string

val escape : string -> string