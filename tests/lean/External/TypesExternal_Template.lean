-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [external]: external types.
-- This is a template file: rename it to "TypesExternal.lean" and fill the holes.
import Aeneas
open Aeneas.Std Result Error
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

/- [core::cell::Cell]
   Source: '/rustc/library/core/src/cell.rs', lines 312:0-312:26
   Name pattern: [core::cell::Cell] -/
axiom core.cell.Cell (T : Type) : Type

/- The state type used in the state-error monad -/
axiom State : Type

