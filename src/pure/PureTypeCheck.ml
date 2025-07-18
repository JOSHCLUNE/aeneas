(** Module to perform type checking on the pure AST - we use this for sanity
    checks only *)

open Pure
open PureUtils
open Errors

let log = Logging.pure_type_check_log

(** Utility function, used for type checking.

    This function should only be used for "regular" ADTs, where the number of
    fields is fixed: it shouldn't be used for arrays, slices, etc. *)
let get_adt_field_types (span : Meta.span)
    (type_decls : type_decl TypeDeclId.Map.t) (type_id : type_id)
    (variant_id : VariantId.id option) (generics : generic_args) : ty list =
  match type_id with
  | TTuple ->
      (* Tuple *)
      sanity_check __FILE__ __LINE__ (generics.const_generics = []) span;
      sanity_check __FILE__ __LINE__ (generics.trait_refs = []) span;
      sanity_check __FILE__ __LINE__ (variant_id = None) span;
      generics.types
  | TAdtId def_id ->
      (* "Regular" ADT *)
      let def = TypeDeclId.Map.find def_id type_decls in
      type_decl_get_instantiated_fields_types def variant_id generics
  | TBuiltin aty -> (
      (* Builtin type *)
      match aty with
      | TState ->
          (* This type is opaque *)
          craise __FILE__ __LINE__ span "Unreachable: opaque type"
      | TResult ->
          let ty = Collections.List.to_cons_nil generics.types in
          let variant_id = Option.get variant_id in
          if variant_id = result_ok_id then [ ty ]
          else if variant_id = result_fail_id then [ mk_error_ty ]
          else
            craise __FILE__ __LINE__ span
              "Unreachable: improper variant id for result type"
      | TError ->
          sanity_check __FILE__ __LINE__ (generics = empty_generic_args) span;
          let variant_id = Option.get variant_id in
          sanity_check __FILE__ __LINE__
            (variant_id = error_failure_id || variant_id = error_out_of_fuel_id)
            span;
          []
      | TFuel ->
          let variant_id = Option.get variant_id in
          if variant_id = fuel_zero_id then []
          else if variant_id = fuel_succ_id then [ mk_fuel_ty ]
          else
            craise __FILE__ __LINE__ span
              "Unreachable: improper variant id for fuel type"
      | TArray | TSlice | TStr | TRawPtr _ ->
          (* Array: when not symbolic values (for instance, because of aggregates),
             the array expressions are introduced as struct updates *)
          craise __FILE__ __LINE__ span
            "Attempting to access the fields of an opaque type")

type tc_ctx = {
  decls_ctx : Contexts.decls_ctx;
  type_decls : type_decl TypeDeclId.Map.t;  (** The type declarations *)
  global_decls : A.global_decl A.GlobalDeclId.Map.t;
      (** The global declarations *)
  env : ty LocalId.Map.t;  (** Environment from variables to types *)
  const_generics : ty T.ConstGenericVarId.Map.t;
      (** The types of the const generics *)
      (* TODO: add trait type constraints *)
}

let texpression_to_string (ctx : tc_ctx) (e : texpression) : string =
  let fmt = PrintPure.decls_ctx_to_fmt_env ctx.decls_ctx in
  PrintPure.texpression_to_string fmt false "" "  " e

let typed_pattern_to_string (ctx : tc_ctx) (x : typed_pattern) : string =
  let fmt = PrintPure.decls_ctx_to_fmt_env ctx.decls_ctx in
  PrintPure.typed_pattern_to_string fmt x

let ty_to_string (ctx : tc_ctx) (x : ty) : string =
  let fmt = PrintPure.decls_ctx_to_fmt_env ctx.decls_ctx in
  PrintPure.ty_to_string fmt false x

let check_literal (span : Meta.span) (v : literal) (ty : literal_type) : unit =
  match (ty, v) with
  | TInteger int_ty, VScalar sv ->
      sanity_check __FILE__ __LINE__ (int_ty = sv.int_ty) span
  | TBool, VBool _ | TChar, VChar _ -> ()
  | _ -> craise __FILE__ __LINE__ span "Inconsistent type"

let check file line b span =
  cassert file line b span
    "Internal error: found a type-checking error in the generated model"

let rec check_typed_pattern (span : Meta.span) (ctx : tc_ctx)
    (v : typed_pattern) : tc_ctx =
  log#ltrace (lazy (__FUNCTION__ ^ ": " ^ typed_pattern_to_string ctx v));
  match v.value with
  | PatConstant cv ->
      check_literal span cv (ty_as_literal span v.ty);
      ctx
  | PatDummy -> ctx
  | PatVar (var, _) ->
      check __FILE__ __LINE__ (var.ty = v.ty) span;
      let env = LocalId.Map.add var.id var.ty ctx.env in
      { ctx with env }
  | PatAdt av ->
      (* Compute the field types *)
      let type_id, generics = ty_as_adt span v.ty in
      let field_tys =
        get_adt_field_types span ctx.type_decls type_id av.variant_id generics
      in
      let check_value (ctx : tc_ctx) (ty : ty) (v : typed_pattern) : tc_ctx =
        if ty <> v.ty then
          (* TODO: we need to normalize the types *)
          craise __FILE__ __LINE__ span
            ("Inconsistent types:" ^ "\n- ty: " ^ show_ty ty ^ "\n- v.ty: "
           ^ show_ty v.ty);
        check_typed_pattern span ctx v
      in
      (* Check the field types: check that the field patterns have the expected
       * types, and check that the field patterns themselves are well-typed *)
      List.fold_left
        (fun ctx (ty, v) -> check_value ctx ty v)
        ctx
        (List.combine field_tys av.field_values)

let rec check_texpression (span : Meta.span) (ctx : tc_ctx) (e : texpression) :
    unit =
  log#ltrace (lazy (__FUNCTION__ ^ ": " ^ texpression_to_string ctx e ^ "\n"));
  match e.e with
  | Var var_id -> (
      (* Lookup the variable - note that the variable may not be there,
       * if we type-check a subexpression (i.e.: if the variable is introduced
       * "outside" of the expression) - TODO: this won't happen once
       * we use a locally nameless representation *)
      match LocalId.Map.find_opt var_id ctx.env with
      | None -> ()
      | Some ty -> check __FILE__ __LINE__ (ty = e.ty) span)
  | CVar cg_id ->
      let ty = T.ConstGenericVarId.Map.find cg_id ctx.const_generics in
      check __FILE__ __LINE__ (ty = e.ty) span
  | Const cv -> check_literal span cv (ty_as_literal span e.ty)
  | App (app, arg) ->
      let input_ty, output_ty = destruct_arrow span app.ty in
      check __FILE__ __LINE__ (input_ty = arg.ty) span;
      check __FILE__ __LINE__ (output_ty = e.ty) span;
      check_texpression span ctx app;
      check_texpression span ctx arg
  | Lambda (pat, body) ->
      let pat_ty, body_ty = destruct_arrow span e.ty in
      check __FILE__ __LINE__ (pat.ty = pat_ty) span;
      check __FILE__ __LINE__ (body.ty = body_ty) span;
      (* Check the pattern and register the introduced variables at the same time *)
      let ctx = check_typed_pattern span ctx pat in
      check_texpression span ctx body
  | Qualif qualif -> (
      match qualif.id with
      | FunOrOp _ -> () (* TODO *)
      | Global _ -> () (* TODO *)
      | TraitConst _ -> () (* TODO *)
      | Proj { adt_id = proj_adt_id; field_id } ->
          (* Note we can only project fields of structures (not enumerations) *)
          (* Deconstruct the projector type *)
          let adt_ty, field_ty = destruct_arrow span e.ty in
          let adt_id, adt_generics = ty_as_adt span adt_ty in
          (* Check the ADT type *)
          check __FILE__ __LINE__ (adt_id = proj_adt_id) span;
          check __FILE__ __LINE__ (adt_generics = qualif.generics) span;
          (* Retrieve and check the expected field type *)
          let variant_id = None in
          let expected_field_tys =
            get_adt_field_types span ctx.type_decls proj_adt_id variant_id
              qualif.generics
          in
          let expected_field_ty = FieldId.nth expected_field_tys field_id in
          check __FILE__ __LINE__ (expected_field_ty = field_ty) span
      | AdtCons id -> (
          let expected_field_tys =
            get_adt_field_types span ctx.type_decls id.adt_id id.variant_id
              qualif.generics
          in
          let field_tys, adt_ty = destruct_arrows e.ty in
          check __FILE__ __LINE__ (expected_field_tys = field_tys) span;
          match adt_ty with
          | TAdt (type_id, generics) ->
              check __FILE__ __LINE__ (type_id = id.adt_id) span;
              check __FILE__ __LINE__ (generics = qualif.generics) span
          | _ -> craise __FILE__ __LINE__ span "Unreachable"))
  | Let (monadic, pat, re, e_next) ->
      log#ldebug
        (lazy
          (__FUNCTION__ ^ ": Let: e:\n" ^ texpression_to_string ctx e ^ "\n"));
      let expected_pat_ty =
        if monadic then destruct_result span re.ty else re.ty
      in
      log#ldebug
        (lazy
          (__FUNCTION__ ^ ": Let:\n- pat.ty: " ^ ty_to_string ctx pat.ty
         ^ "\n- expected_pat_ty: "
          ^ ty_to_string ctx expected_pat_ty));
      check __FILE__ __LINE__ (pat.ty = expected_pat_ty) span;
      check __FILE__ __LINE__ (e.ty = e_next.ty) span;
      (* Check the right-expression *)
      check_texpression span ctx re;
      (* Check the pattern and register the introduced variables at the same time *)
      let ctx = check_typed_pattern span ctx pat in
      (* Check the next expression *)
      check_texpression span ctx e_next
  | Switch (scrut, switch_body) -> (
      check_texpression span ctx scrut;
      match switch_body with
      | If (e_then, e_else) ->
          check __FILE__ __LINE__ (scrut.ty = TLiteral TBool) span;
          check __FILE__ __LINE__ (e_then.ty = e.ty) span;
          check __FILE__ __LINE__ (e_else.ty = e.ty) span;
          check_texpression span ctx e_then;
          check_texpression span ctx e_else
      | Match branches ->
          let check_branch (br : match_branch) : unit =
            check __FILE__ __LINE__ (br.pat.ty = scrut.ty) span;
            let ctx = check_typed_pattern span ctx br.pat in
            check_texpression span ctx br.branch
          in
          List.iter check_branch branches)
  | Loop loop ->
      check __FILE__ __LINE__ (loop.fun_end.ty = e.ty) span;
      check_texpression span ctx loop.fun_end;
      check_texpression span ctx loop.loop_body
  | StructUpdate supd -> (
      (* Check the init value *)
      begin
        match supd.init with
        | None -> ()
        | Some init ->
            check_texpression span ctx init;
            check __FILE__ __LINE__ (init.ty = e.ty) span
      end;
      (* Check the fields *)
      (* Retrieve and check the expected field type *)
      let adt_id, adt_generics = ty_as_adt span e.ty in
      check __FILE__ __LINE__ (adt_id = supd.struct_id) span;
      (* The id can only be: a custom type decl or an array *)
      match adt_id with
      | TAdtId _ ->
          let variant_id = None in
          let expected_field_tys =
            get_adt_field_types span ctx.type_decls adt_id variant_id
              adt_generics
          in
          List.iter
            (fun ((fid, fe) : _ * texpression) ->
              let expected_field_ty = FieldId.nth expected_field_tys fid in
              check __FILE__ __LINE__ (expected_field_ty = fe.ty) span;
              check_texpression span ctx fe)
            supd.updates
      | TBuiltin TArray ->
          let expected_field_ty =
            Collections.List.to_cons_nil adt_generics.types
          in
          List.iter
            (fun ((_, fe) : _ * texpression) ->
              check __FILE__ __LINE__ (expected_field_ty = fe.ty) span;
              check_texpression span ctx fe)
            supd.updates
      | _ -> craise __FILE__ __LINE__ span "Unexpected")
  | Meta (_, e_next) ->
      check __FILE__ __LINE__ (e_next.ty = e.ty) span;
      check_texpression span ctx e_next
  | EError (span, msg) -> craise_opt_span __FILE__ __LINE__ span msg
