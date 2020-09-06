open Harness;;
open Json;;
open Codecheck;;
open Tail_plugin_loader;;

let compile = ("Compile", [
    test "Compile student submission" 0 (compile "tail");
    test "Check student submission for Array, Loops, and References" 0 (check_pervasives "tail");
    test "Load student submission" 0 (load_solution "tail")
  ])
and factorial = ("factorial1", [
      test "structure" 0 (check_style "factorial1" [check_non_tailrec; check_ite; check_non_match] "Must use if-then-else");
      test "factorial(1)" 1 (runtest "factorial 1" 1 ffactorial1 1);
      test "factorial(2)" 1 (runtest "factorial 2" 2 ffactorial1 2);
      test "factorial(4)" 1 (runtest "factorial 4" 24 ffactorial1 4);
      test "factorial(5)" 1 (runtest "factorial 5" 120 ffactorial1 5);
      test "factorial(10)" 1 (runtest "factorial 10" 3628800 ffactorial1 10)
  ])
and factorial2 = ("factorial2", [
    test "structure" 0 (check_style "factorial2" [check_match; check_non_ite] "Must use match");
    test "factorial(1)" 1 (runtest "factorial 1" 1 ffactorial2 1);
    test "factorial(2)" 1 (runtest "factorial 2" 2 ffactorial2 2);
    test "factorial(4)" 1 (runtest "factorial 4" 24 ffactorial2 4);
    test "factorial(5)" 1 (runtest "factorial 5" 120 ffactorial2 5);
    test "factorial(10)" 1 (runtest "factorial 10" 3628800 ffactorial2 10)
  ])
and factorial3 = ("factorial3", [
    test "structure" 0 (check_style "factorial3" [check_tailrec] "Must use tail recursion");
    test "factorial(1)" 1 (runtest "factorial 1" 1 ffactorial3 1);
    test "factorial(2)" 1 (runtest "factorial 2" 2 ffactorial3 2);
    test "factorial(4)" 1 (runtest "factorial 4" 24 ffactorial3 4);
    test "factorial(5)" 1 (runtest "factorial 5" 120 ffactorial3 5);
    test "factorial(10)" 1 (runtest "factorial 10" 3628800 ffactorial3 10)
  ])
and fibonacci = ("fibonacci", [
    test "structure" 0 (check_style "fibonacci" [check_tailrec;check_match;check_non_ite] "Must use match and tail recursion");
  ])
and rev = ("rev", [
  test "reverse empty" 1 (runtest "rev []" [] frev []);
  test "reverse small" 2 (runtest "rev with small size" [1] frev [1]);
  test "reverse big" 2 (runtest "rev with big size" [1;2;3;4;5;6;7;8;9;10] frev [10;9;8;7;6;5;4;3;2;1]);
])
and sqrt = ("sqrt", [
    test "a" 1 (fun () -> Passed);
])
and sqrt2 = ("sqrt2", [
    test "a" 1 (fun () -> Passed);
])
and map = ("map", [
    test "a" 1 (fun () -> Passed);
])
and map2 = ("map2", [
    test "a" 1 (fun () -> Passed);
  ])
and root = ("root", [
    test "a" 1 (fun () -> Passed);
])
in let all_tests =
  [compile; factorial; factorial2; factorial3; fibonacci; rev; sqrt; sqrt2; map; map2; root]
  in invoke_runner all_tests
;;