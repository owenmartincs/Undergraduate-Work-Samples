(* 
                         CS 51 Final Project
                        MiniML -- Expressions
*)

(*......................................................................
  Abstract syntax of MiniML expressions 
 *)

type unop =
  | Negate
;;
    
type binop =
  | Plus
  | Minus
  | Times
  | Equals
  | LessThan
;;

type varid = string ;;
  
type expr =
  | Var of varid                         (* variables *)
  | Num of int                           (* integers *)
  | Flt of float                         (* floats *)
  | Bool of bool                         (* booleans *)
  | Unop of unop * expr                  (* unary operators *)
  | Binop of binop * expr * expr         (* binary operators *)
  | Conditional of expr * expr * expr    (* if then else *)
  | Fun of varid * expr                  (* function definitions *)
  | Let of varid * expr * expr           (* local naming *)
  | Letrec of varid * expr * expr        (* recursive local naming *)
  | Raise                                (* exceptions *)
  | Unassigned                           (* (temporarily) unassigned *)
  | App of expr * expr                   (* function applications *)
;;
  
(*......................................................................
  Manipulation of variable names (varids) and sets of them
 *)

(* varidset -- Sets of varids *)
module SS = Set.Make (struct
                       type t = varid
                       let compare = String.compare
                     end ) ;;

type varidset = SS.t ;;

(* same_vars varids1 varids2 -- Tests to see if two `varid` sets have
   the same elements (for testing purposes) *)
let same_vars : varidset -> varidset -> bool =
  SS.equal;;

(* vars_of_list varids -- Generates a set of variable names from a
   list of `varid`s (for testing purposes) *)
let vars_of_list : string list -> varidset =
  SS.of_list ;;
  
(* free_vars exp -- Returns the set of `varid`s corresponding to free
   variables in `exp` *)
let rec free_vars_aux (exp : expr)
                      (oklst : string list)
                      (fvlst : SS.t)
                      : SS.t =
  match exp with
  | Var (var1) ->   if List.mem var1 oklst
                    then SS.empty
                    else SS.add var1 SS.empty
  | Unop (_unop1, exp1) -> free_vars_aux exp1 oklst fvlst
  | Binop (_binop1, exp1, exp2) ->
                    SS.union
                      (free_vars_aux exp1 oklst fvlst)
                      (free_vars_aux exp2 oklst fvlst)
  | Conditional (exp1, exp2, exp3) ->
                    SS.union
                      (free_vars_aux exp1 oklst fvlst)
                      (SS.union
                        (free_vars_aux exp2 oklst fvlst)
                        (free_vars_aux exp3 oklst fvlst))
  | Fun (var1, exp1) ->
                    let oklst = var1 :: oklst in
                    free_vars_aux exp1 oklst fvlst
  | Let (var1, exp1, exp2)
  | Letrec (var1, exp1, exp2) ->
                    let oklst = var1 :: oklst in
                    SS.union
                      (free_vars_aux exp1 oklst fvlst)
                      (free_vars_aux exp2 oklst fvlst)
  | App (exp1, exp2) ->
                    SS.union
                      (free_vars_aux exp1 oklst fvlst)
                      (free_vars_aux exp2 oklst fvlst)
  | _ -> SS.empty;;
  
let free_vars (exp : expr) : varidset =
  let fvlst = SS.empty in
  free_vars_aux exp [] fvlst;;
  
(* new_varname () -- Returns a freshly minted `varid` constructed with
   a running counter a la `gensym`. Assumes no variable names use the
   prefix "var". (Otherwise, they might accidentally be the same as a
   generated variable name.) *)
let gensym : string -> string =
  let suffix = ref 0 in
  fun str -> let symbol = str ^ string_of_int !suffix in
             suffix := !suffix + 1;
             symbol ;;

let new_varname () : varid =
  gensym "var" ;;

(*......................................................................
  Substitution 

  Substitution of expressions for free occurrences of variables is the
  cornerstone of the substitution model for functional programming
  semantics.
 *)

(* subst var_name repl exp -- Return the expression `exp` with `repl`
   substituted for free occurrences of `var_name`, avoiding variable
   capture *)
let rec subst_aux (exp : expr)
                      (x : varid)
                      (p : expr)
                      : expr =
  match exp with
  | Raise -> Raise
  | Unassigned -> Unassigned 
  | Num (m)-> Num m
  | Flt (m)-> Flt m
  | Bool (m) -> Bool m
  | Var (y) -> if y = x then p else Var y
  | Unop (unop1, q) -> Unop (unop1, subst_aux q x p)
  | App (q, r) ->   App (subst_aux q x p,
                    subst_aux r x p)
  | Binop (binop1, q, r) ->
                    Binop (binop1,
                    subst_aux q x p,
                    subst_aux r x p)
  | Conditional (q, r, s) ->
                    Conditional (subst_aux q x p,
                    subst_aux r x p,
                    subst_aux s x p)
  | Fun (y, q) ->   if y = x then
                      Fun (y, q)
                    else
                      (if SS.mem y (free_vars p) then
                        let z_id = new_varname () in
                        let z = Var (z_id) in
                        Fun (z_id, subst_aux (subst_aux q y z) x p)
                      else
                        Fun (y, subst_aux q x p))
  | Let (y, q, r) -> if y = x then
                       Let (y, subst_aux q x p, r)
                     else
                       (if SS.mem y (free_vars p) then
                        let z_id = new_varname () in
                        let z = Var (z_id) in
                         Let (z_id, subst_aux q x p, subst_aux (subst_aux r y z) x p)
                       else
                         Let (y, subst_aux q x p, subst_aux r x p))
  | Letrec (y, q, r) -> if y = x then
                       Let (y, q, r)
                     else
                       (if SS.mem y (free_vars p) then
                        let z_id = new_varname () in
                        let z = Var (z_id) in
                         Let (z_id, subst_aux (subst_aux q y z) x p, subst_aux (subst_aux r y z) x p)
                       else
                         Let (y, subst_aux q x p, subst_aux r x p));;

let subst (var_name : varid) (repl : expr) (exp : expr) : expr =
  subst_aux exp var_name repl ;;

(*......................................................................
  String representations of expressions
 *)
   
(* exp_to_concrete_string exp -- Returns a string representation of
   the concrete syntax of the expression `exp` *)
let rec exp_to_concrete_string (exp : expr) : string =
  match exp with
  | Var (var1) -> var1
  | Num (int1)-> string_of_int int1
  | Flt (float1)-> Float.to_string float1
  | Bool (bool1) -> if bool1 then "true" else "false"
  | Unop (unop1, exp1) -> (match unop1 with
    | Negate ->   "(~-" ^ exp_to_concrete_string exp1 ^ ")" )
  | Binop (binop1, exp1, exp2) -> (match binop1 with
    | Plus ->     "(" ^ exp_to_concrete_string exp1 ^
                  " + " ^ exp_to_concrete_string exp2 ^ ")"
    | Minus ->    "(" ^ exp_to_concrete_string exp1 ^
                  " - " ^ exp_to_concrete_string exp2 ^ ")"
    | Times ->    "(" ^ exp_to_concrete_string exp1 ^
                  " * " ^ exp_to_concrete_string exp2 ^ ")"
    | Equals ->   "(" ^ exp_to_concrete_string exp1 ^
                  " = " ^ exp_to_concrete_string exp2 ^ ")"
    | LessThan -> "(" ^ exp_to_concrete_string exp1 ^
                  " < " ^ exp_to_concrete_string exp2 ^ ")" )
  | Conditional (exp1, exp2, exp3) -> 
                  "(if " ^ exp_to_concrete_string exp1 ^
                  " then " ^ exp_to_concrete_string exp2 ^
                  " else " ^ exp_to_concrete_string exp3 ^ ")"
  | Fun (var1, exp1) -> 
                  "fun " ^ var1 ^
                  " -> " ^ exp_to_concrete_string exp1
  | Let (var1, exp1, exp2) ->
                  "Let " ^ var1 ^
                  " = " ^ exp_to_concrete_string exp1 ^
                  " in " ^ exp_to_concrete_string exp2
  | Letrec (var1, exp1, exp2) ->
                  "Let rec " ^ var1 ^
                  " = " ^ exp_to_concrete_string exp1 ^
                  " in " ^ exp_to_concrete_string exp2
  | Raise ->      "raise exception"
  | Unassigned -> "Unassigned"
  | App (exp1, exp2) ->
                  "(" ^ exp_to_concrete_string exp1 ^
                  " " ^ exp_to_concrete_string exp2 ^ ")" ;;
     
(* exp_to_abstract_string exp -- Return a string representation of the
   abstract syntax of the expression `exp` *)
let rec exp_to_abstract_string (exp : expr) : string =
  match exp with
  | Var (var1) -> "Var(" ^ var1 ^ ")"
  | Num (int1)->  "Num(" ^ string_of_int int1 ^ ")"
  | Flt (float1)-> "Flt(" ^ Float.to_string float1 ^ ")"
  | Bool (bool1) -> if bool1 then "true" else "false"
  | Unop (unop1, exp1) -> (match unop1 with
    | Negate ->   "Unop(Negate, " ^ exp_to_abstract_string exp1 ^ ")" )
  | Binop (binop1, exp1, exp2) -> (match binop1 with
    | Plus ->     "Binop(Plus, " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
    | Minus ->    "Binop(Minus, " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
    | Times ->    "Binop(Times, " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
    | Equals ->   "Binop(Equals, " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
    | LessThan -> "Binop(LessThan, " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")" )
  | Conditional (exp1, exp2, exp3) -> 
                  "Conditional(" ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^
                  ", " ^ exp_to_abstract_string exp3 ^ ")"
  | Fun (var1, exp1) -> 
                  "Fun(" ^ var1 ^
                  ", " ^ exp_to_abstract_string exp1 ^ ")"
  | Let (var1, exp1, exp2) ->
                  "Let(" ^ var1 ^
                  ", " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
  | Letrec (var1, exp1, exp2) ->
                  "Letrec(" ^ var1 ^
                  ", " ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")"
  | Raise ->      "Raise"
  | Unassigned -> "Unassigned"
  | App (exp1, exp2) ->
                  "App(" ^ exp_to_abstract_string exp1 ^
                  ", " ^ exp_to_abstract_string exp2 ^ ")" ;;
