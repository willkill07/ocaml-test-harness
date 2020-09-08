type json = [
  | `Assoc of (string * json) list
  | `Bool of bool
  | `Float of float
  | `Int of int
  | `List of json list
  | `Null
  | `String of string
]


let replace input output = Str.global_replace (Str.regexp_string input) output;;
let escape str = str |> replace "\n" "\\n" |> replace "\"" "\\\"";;

let rec print_json (x:json) = match x with
  | `Bool b -> Printf.printf "%B" b; ();
  | `Int i -> Printf.printf "%d" i; ();
  | `Float f -> Printf.printf "%f" f; ();
  | `Null -> print_string "null"; ();
  | `String s -> Printf.printf "\"%s\"" (escape s); ();
  | `List l ->
    let rec print_aux = function
      | [] -> ();
      | h::t ->
        print_json h;
        if t <> [] then print_string "," else ();
        print_aux t;
    in print_string "["; print_aux l; print_string "]";
  | `Assoc a ->
    let rec print_aux = function
      | [] -> ();
      | (k,v)::t ->
        Printf.printf "\"%s\":" k;
        print_json v;
        if t <> [] then print_string "," else ();
        print_aux t;
    in print_string "{"; print_aux a; print_string "}"
