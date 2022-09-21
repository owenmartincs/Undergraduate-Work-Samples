(* 
                         CS 51 Final Project
                          MiniML -- Testing
 *)                   

open Expr ;;
open Evaluation ;;
open Miniml ;;

open CS51Utils ;;
open Absbook ;;
  
let str_to_exp_test () =
  unit_test (free_vars (str_to_exp "let x = 3 in x ;;") = vars_of_list [])
            "str_to_exp_test: no free vars";
  unit_test (free_vars (str_to_exp "x ;;") = vars_of_list ["x"])
            "str_to_exp_test: one free var";
  unit_test (free_vars (str_to_exp "x y ;;") = vars_of_list ["x"; "y"])
            "str_to_exp_test: two free vars";
  unit_test (free_vars (str_to_exp "let x = 3 in x y ;;") = vars_of_list ["y"])
            "str_to_exp_test: one free var deep";
  unit_test (free_vars (str_to_exp "let f = fun x -> x * 4 in let y = f z in (x * y) + z ;;")
            = vars_of_list ["x"; "z"])
            "str_to_exp_test: two free vars deep";
  unit_test (free_vars (str_to_exp "let f = fun z -> y in (fun y -> f 3) 1 ;;") 
            = vars_of_list ["y"])
            "str_to_exp_test: potential var capture";;
        
let subst_test () = 
  unit_test (subst "x" (Var "y") (str_to_exp "let x = 3 in x ;;")
            = (str_to_exp "let x = 3 in x ;;"))
            "subst_test: no sub"; 
  unit_test (subst "x" (Var "y") (str_to_exp "x ;;")
            = (str_to_exp "y ;;"))
            "subst_test: one sub";
  unit_test (subst "x" (Var "y") (str_to_exp "let x = 3 in let f = fun x -> z in 3 ;;")
            = (str_to_exp "let x = 3 in let f = fun x -> z in 3 ;;"))
            "subst_test: no sub deep";
  unit_test (subst "x" (Var "y") (str_to_exp "let z = x in let x = fun x -> 5 in x z ;;")
            = (str_to_exp "let z = y in let x = fun x -> 5 in x z ;;"))
            "subst_test: one sub deep";;

let test_all () =
  str_to_exp_test () ;
  subst_test () ;;

let _ = test_all () ;;
