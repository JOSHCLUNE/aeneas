-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [arrays]
import Aeneas
open Aeneas.Std Result Error
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

namespace arrays

/- [arrays::AB]
   Source: 'tests/src/arrays.rs', lines 7:0-10:1 -/
inductive AB where
| A : AB
| B : AB

/- [arrays::incr]:
   Source: 'tests/src/arrays.rs', lines 12:0-14:1 -/
def incr (x : U32) : Result U32 :=
  x + 1#u32

/- [arrays::array_to_shared_slice_]:
   Source: 'tests/src/arrays.rs', lines 20:0-22:1 -/
def array_to_shared_slice_
  {T : Type} (s : Array T 32#usize) : Result (Slice T) :=
  ok (Array.to_slice s)

/- [arrays::array_to_mut_slice_]:
   Source: 'tests/src/arrays.rs', lines 25:0-27:1 -/
def array_to_mut_slice_
  {T : Type} (s : Array T 32#usize) :
  Result ((Slice T) × (Slice T → Array T 32#usize))
  :=
  ok (Array.to_slice_mut s)

/- [arrays::array_len]:
   Source: 'tests/src/arrays.rs', lines 29:0-31:1 -/
def array_len {T : Type} (s : Array T 32#usize) : Result Usize :=
  do
  let s1 ← (↑(Array.to_slice s) : Result (Slice T))
  ok (Slice.len s1)

/- [arrays::shared_array_len]:
   Source: 'tests/src/arrays.rs', lines 33:0-35:1 -/
def shared_array_len {T : Type} (s : Array T 32#usize) : Result Usize :=
  do
  let s1 ← (↑(Array.to_slice s) : Result (Slice T))
  ok (Slice.len s1)

/- [arrays::shared_slice_len]:
   Source: 'tests/src/arrays.rs', lines 37:0-39:1 -/
def shared_slice_len {T : Type} (s : Slice T) : Result Usize :=
  ok (Slice.len s)

/- [arrays::index_array_shared]:
   Source: 'tests/src/arrays.rs', lines 41:0-43:1 -/
def index_array_shared
  {T : Type} (s : Array T 32#usize) (i : Usize) : Result T :=
  Array.index_usize s i

/- [arrays::index_array_u32]:
   Source: 'tests/src/arrays.rs', lines 48:0-50:1 -/
def index_array_u32 (s : Array U32 32#usize) (i : Usize) : Result U32 :=
  Array.index_usize s i

/- [arrays::index_array_copy]:
   Source: 'tests/src/arrays.rs', lines 52:0-54:1 -/
def index_array_copy (x : Array U32 32#usize) : Result U32 :=
  Array.index_usize x 0#usize

/- [arrays::index_mut_array]:
   Source: 'tests/src/arrays.rs', lines 56:0-58:1 -/
def index_mut_array
  {T : Type} (s : Array T 32#usize) (i : Usize) :
  Result (T × (T → Array T 32#usize))
  :=
  Array.index_mut_usize s i

/- [arrays::index_slice]:
   Source: 'tests/src/arrays.rs', lines 60:0-62:1 -/
def index_slice {T : Type} (s : Slice T) (i : Usize) : Result T :=
  Slice.index_usize s i

/- [arrays::index_mut_slice]:
   Source: 'tests/src/arrays.rs', lines 64:0-66:1 -/
def index_mut_slice
  {T : Type} (s : Slice T) (i : Usize) : Result (T × (T → Slice T)) :=
  Slice.index_mut_usize s i

/- [arrays::slice_subslice_shared_]:
   Source: 'tests/src/arrays.rs', lines 68:0-70:1 -/
def slice_subslice_shared_
  (x : Slice U32) (y : Usize) (z : Usize) : Result (Slice U32) :=
  core.slice.index.Slice.index (core.slice.index.SliceIndexRangeUsizeSliceInst
    U32) x { start := y, end_ := z }

/- [arrays::slice_subslice_mut_]:
   Source: 'tests/src/arrays.rs', lines 72:0-74:1 -/
def slice_subslice_mut_
  (x : Slice U32) (y : Usize) (z : Usize) :
  Result ((Slice U32) × (Slice U32 → Slice U32))
  :=
  core.slice.index.Slice.index_mut
    (core.slice.index.SliceIndexRangeUsizeSliceInst U32) x
    { start := y, end_ := z }

/- [arrays::array_to_slice_shared_]:
   Source: 'tests/src/arrays.rs', lines 76:0-78:1 -/
def array_to_slice_shared_ (x : Array U32 32#usize) : Result (Slice U32) :=
  ok (Array.to_slice x)

/- [arrays::array_to_slice_mut_]:
   Source: 'tests/src/arrays.rs', lines 80:0-82:1 -/
def array_to_slice_mut_
  (x : Array U32 32#usize) :
  Result ((Slice U32) × (Slice U32 → Array U32 32#usize))
  :=
  ok (Array.to_slice_mut x)

/- [arrays::array_subslice_shared_]:
   Source: 'tests/src/arrays.rs', lines 84:0-86:1 -/
def array_subslice_shared_
  (x : Array U32 32#usize) (y : Usize) (z : Usize) : Result (Slice U32) :=
  core.array.Array.index (core.ops.index.IndexSliceInst
    (core.slice.index.SliceIndexRangeUsizeSliceInst U32)) x
    { start := y, end_ := z }

/- [arrays::array_subslice_mut_]:
   Source: 'tests/src/arrays.rs', lines 88:0-90:1 -/
def array_subslice_mut_
  (x : Array U32 32#usize) (y : Usize) (z : Usize) :
  Result ((Slice U32) × (Slice U32 → Array U32 32#usize))
  :=
  core.array.Array.index_mut (core.ops.index.IndexMutSliceInst
    (core.slice.index.SliceIndexRangeUsizeSliceInst U32)) x
    { start := y, end_ := z }

/- [arrays::index_slice_0]:
   Source: 'tests/src/arrays.rs', lines 92:0-94:1 -/
def index_slice_0 {T : Type} (s : Slice T) : Result T :=
  Slice.index_usize s 0#usize

/- [arrays::index_array_0]:
   Source: 'tests/src/arrays.rs', lines 96:0-98:1 -/
def index_array_0 {T : Type} (s : Array T 32#usize) : Result T :=
  Array.index_usize s 0#usize

/- [arrays::index_index_array]:
   Source: 'tests/src/arrays.rs', lines 107:0-109:1 -/
def index_index_array
  (s : Array (Array U32 32#usize) 32#usize) (i : Usize) (j : Usize) :
  Result U32
  :=
  do
  let a ← Array.index_usize s i
  Array.index_usize a j

/- [arrays::update_update_array]:
   Source: 'tests/src/arrays.rs', lines 118:0-120:1 -/
def update_update_array
  (s : Array (Array U32 32#usize) 32#usize) (i : Usize) (j : Usize) :
  Result (Array (Array U32 32#usize) 32#usize)
  :=
  do
  let (a, index_mut_back) ← Array.index_mut_usize s i
  let a1 ← Array.update a j 0#u32
  ok (index_mut_back a1)

/- [arrays::array_local_deep_copy]:
   Source: 'tests/src/arrays.rs', lines 122:0-124:1 -/
def array_local_deep_copy (x : Array U32 32#usize) : Result Unit :=
  ok ()

/- [arrays::array_update1]:
   Source: 'tests/src/arrays.rs', lines 127:0-129:1 -/
def array_update1 (a : Slice U32) (i : Usize) (x : U32) : Result (Slice U32) :=
  do
  let i1 ← x + 1#u32
  let i2 ← i + 1#usize
  Slice.update a i2 i1

/- [arrays::array_update2]:
   Source: 'tests/src/arrays.rs', lines 132:0-135:1 -/
def array_update2 (a : Slice U32) (i : Usize) (x : U32) : Result (Slice U32) :=
  do
  let i1 ← x + 1#u32
  let a1 ← Slice.update a i i1
  let i2 ← i + 1#usize
  Slice.update a1 i2 i1

/- [arrays::array_update3]:
   Source: 'tests/src/arrays.rs', lines 137:0-141:1 -/
def array_update3 (a : Slice U32) (i : Usize) (x : U32) : Result (Slice U32) :=
  do
  let a1 ← Slice.update a i x
  let i1 ← i + 1#usize
  let a2 ← Slice.update a1 i1 x
  let i2 ← i + 2#usize
  Slice.update a2 i2 x

/- [arrays::take_array]:
   Source: 'tests/src/arrays.rs', lines 143:0-143:33 -/
def take_array (a : Array U32 2#usize) : Result Unit :=
  ok ()

/- [arrays::take_array_borrow]:
   Source: 'tests/src/arrays.rs', lines 144:0-144:41 -/
def take_array_borrow (a : Array U32 2#usize) : Result Unit :=
  ok ()

/- [arrays::take_slice]:
   Source: 'tests/src/arrays.rs', lines 145:0-145:31 -/
def take_slice (s : Slice U32) : Result Unit :=
  ok ()

/- [arrays::take_mut_slice]:
   Source: 'tests/src/arrays.rs', lines 146:0-146:39 -/
def take_mut_slice (s : Slice U32) : Result (Slice U32) :=
  ok s

/- [arrays::const_array]:
   Source: 'tests/src/arrays.rs', lines 148:0-150:1 -/
def const_array : Result (Array U32 2#usize) :=
  ok (Array.repeat 2#usize 0#u32)

/- [arrays::const_slice]:
   Source: 'tests/src/arrays.rs', lines 152:0-155:1 -/
def const_slice : Result U32 :=
  do
  let a := Array.repeat 2#usize 0#u32
  let s ← (↑(Array.to_slice a) : Result (Slice U32))
  Slice.index_usize s 0#usize

/- [arrays::take_all]:
   Source: 'tests/src/arrays.rs', lines 163:0-175:1 -/
def take_all : Result Unit :=
  do
  let x := Array.repeat 2#usize 0#u32
  take_array x
  take_array x
  take_array_borrow x
  let s ← (↑(Array.to_slice x) : Result (Slice U32))
  take_slice s
  let (s1, _) ←
    (↑(Array.to_slice_mut x) : Result ((Slice U32) × (Slice U32 → Array
      U32 2#usize)))
  let _ ← take_mut_slice s1
  ok ()

/- [arrays::index_array]:
   Source: 'tests/src/arrays.rs', lines 177:0-179:1 -/
def index_array (x : Array U32 2#usize) : Result U32 :=
  Array.index_usize x 0#usize

/- [arrays::index_array_borrow]:
   Source: 'tests/src/arrays.rs', lines 180:0-182:1 -/
def index_array_borrow (x : Array U32 2#usize) : Result U32 :=
  Array.index_usize x 0#usize

/- [arrays::index_slice_u32_0]:
   Source: 'tests/src/arrays.rs', lines 184:0-186:1 -/
def index_slice_u32_0 (x : Slice U32) : Result U32 :=
  Slice.index_usize x 0#usize

/- [arrays::index_mut_slice_u32_0]:
   Source: 'tests/src/arrays.rs', lines 188:0-190:1 -/
def index_mut_slice_u32_0 (x : Slice U32) : Result (U32 × (Slice U32)) :=
  do
  let i ← Slice.index_usize x 0#usize
  ok (i, x)

/- [arrays::index_all]:
   Source: 'tests/src/arrays.rs', lines 192:0-204:1 -/
def index_all : Result U32 :=
  do
  let x := Array.repeat 2#usize 0#u32
  let i ← index_array x
  let i1 ← i + i
  let i2 ← index_array_borrow x
  let i3 ← i1 + i2
  let s ← (↑(Array.to_slice x) : Result (Slice U32))
  let i4 ← index_slice_u32_0 s
  let i5 ← i3 + i4
  let (s1, _) ←
    (↑(Array.to_slice_mut x) : Result ((Slice U32) × (Slice U32 → Array
      U32 2#usize)))
  let (i6, _) ← index_mut_slice_u32_0 s1
  i5 + i6

/- [arrays::update_array]:
   Source: 'tests/src/arrays.rs', lines 206:0-208:1 -/
def update_array (x : Array U32 2#usize) : Result Unit :=
  do
  let _ ← Array.index_mut_usize x 0#usize
  ok ()

/- [arrays::update_array_mut_borrow]:
   Source: 'tests/src/arrays.rs', lines 209:0-211:1 -/
def update_array_mut_borrow
  (x : Array U32 2#usize) : Result (Array U32 2#usize) :=
  Array.update x 0#usize 1#u32

/- [arrays::update_mut_slice]:
   Source: 'tests/src/arrays.rs', lines 212:0-214:1 -/
def update_mut_slice (x : Slice U32) : Result (Slice U32) :=
  Slice.update x 0#usize 1#u32

/- [arrays::update_all]:
   Source: 'tests/src/arrays.rs', lines 216:0-222:1 -/
def update_all : Result Unit :=
  do
  let x := Array.repeat 2#usize 0#u32
  update_array x
  update_array x
  let x1 ← update_array_mut_borrow x
  let (s, _) ←
    (↑(Array.to_slice_mut x1) : Result ((Slice U32) × (Slice U32 → Array
      U32 2#usize)))
  let _ ← update_mut_slice s
  ok ()

/- [arrays::incr_array]:
   Source: 'tests/src/arrays.rs', lines 224:0-226:1 -/
def incr_array (x : Array U32 2#usize) : Result (Array U32 2#usize) :=
  do
  let i ← Array.index_usize x 0#usize
  let i1 ← i + 1#u32
  Array.update x 0#usize i1

/- [arrays::incr_slice]:
   Source: 'tests/src/arrays.rs', lines 228:0-230:1 -/
def incr_slice (x : Slice U32) : Result (Slice U32) :=
  do
  let i ← Slice.index_usize x 0#usize
  let i1 ← i + 1#u32
  Slice.update x 0#usize i1

/- [arrays::range_all]:
   Source: 'tests/src/arrays.rs', lines 235:0-239:1 -/
def range_all : Result Unit :=
  do
  let x := Array.repeat 4#usize 0#u32
  let (s, _) ←
    core.array.Array.index_mut (core.ops.index.IndexMutSliceInst
      (core.slice.index.SliceIndexRangeUsizeSliceInst U32)) x
      { start := 1#usize, end_ := 3#usize }
  let _ ← update_mut_slice s
  ok ()

/- [arrays::deref_array_borrow]:
   Source: 'tests/src/arrays.rs', lines 244:0-247:1 -/
def deref_array_borrow (x : Array U32 2#usize) : Result U32 :=
  Array.index_usize x 0#usize

/- [arrays::deref_array_mut_borrow]:
   Source: 'tests/src/arrays.rs', lines 249:0-252:1 -/
def deref_array_mut_borrow
  (x : Array U32 2#usize) : Result (U32 × (Array U32 2#usize)) :=
  do
  let i ← Array.index_usize x 0#usize
  ok (i, x)

/- [arrays::take_array_t]:
   Source: 'tests/src/arrays.rs', lines 257:0-257:34 -/
def take_array_t (a : Array AB 2#usize) : Result Unit :=
  ok ()

/- [arrays::non_copyable_array]:
   Source: 'tests/src/arrays.rs', lines 259:0-267:1 -/
def non_copyable_array : Result Unit :=
  take_array_t (Array.make 2#usize [ AB.A, AB.B ])

/- [arrays::sum]: loop 0:
   Source: 'tests/src/arrays.rs', lines 275:4-278:5 -/
def sum_loop (s : Slice U32) (sum1 : U32) (i : Usize) : Result U32 :=
  let i1 := Slice.len s
  if i < i1
  then
    do
    let i2 ← Slice.index_usize s i
    let sum3 ← sum1 + i2
    let i3 ← i + 1#usize
    sum_loop s sum3 i3
  else ok sum1
partial_fixpoint

/- [arrays::sum]:
   Source: 'tests/src/arrays.rs', lines 272:0-280:1 -/
@[reducible] def sum (s : Slice U32) : Result U32 :=
               sum_loop s 0#u32 0#usize

/- [arrays::sum2]: loop 0:
   Source: 'tests/src/arrays.rs', lines 286:4-289:5 -/
def sum2_loop
  (s : Slice U32) (s2 : Slice U32) (sum1 : U32) (i : Usize) : Result U32 :=
  let i1 := Slice.len s
  if i < i1
  then
    do
    let i2 ← Slice.index_usize s i
    let i3 ← Slice.index_usize s2 i
    let i4 ← i2 + i3
    let sum3 ← sum1 + i4
    let i5 ← i + 1#usize
    sum2_loop s s2 sum3 i5
  else ok sum1
partial_fixpoint

/- [arrays::sum2]:
   Source: 'tests/src/arrays.rs', lines 282:0-291:1 -/
def sum2 (s : Slice U32) (s2 : Slice U32) : Result U32 :=
  do
  let i := Slice.len s
  let i1 := Slice.len s2
  massert (i = i1)
  sum2_loop s s2 0#u32 0#usize

/- [arrays::f0]:
   Source: 'tests/src/arrays.rs', lines 293:0-296:1 -/
def f0 : Result Unit :=
  do
  let (s, _) ←
    (↑(Array.to_slice_mut (Array.make 2#usize [ 1#u32, 2#u32 ])) : Result
      ((Slice U32) × (Slice U32 → Array U32 2#usize)))
  let _ ← Slice.index_mut_usize s 0#usize
  ok ()

/- [arrays::f1]:
   Source: 'tests/src/arrays.rs', lines 298:0-301:1 -/
def f1 : Result Unit :=
  do
  let _ ← Array.index_mut_usize (Array.make 2#usize [ 1#u32, 2#u32 ]) 0#usize
  ok ()

/- [arrays::f2]:
   Source: 'tests/src/arrays.rs', lines 303:0-303:20 -/
def f2 (i : U32) : Result Unit :=
  ok ()

/- [arrays::f4]:
   Source: 'tests/src/arrays.rs', lines 312:0-314:1 -/
def f4 (x : Array U32 32#usize) (y : Usize) (z : Usize) : Result (Slice U32) :=
  core.array.Array.index (core.ops.index.IndexSliceInst
    (core.slice.index.SliceIndexRangeUsizeSliceInst U32)) x
    { start := y, end_ := z }

/- [arrays::f3]:
   Source: 'tests/src/arrays.rs', lines 305:0-310:1 -/
def f3 : Result U32 :=
  do
  let i ← Array.index_usize (Array.make 2#usize [ 1#u32, 2#u32 ]) 0#usize
  f2 i
  let b := Array.repeat 32#usize 0#u32
  let s ←
    (↑(Array.to_slice (Array.make 2#usize [ 1#u32, 2#u32 ])) : Result (Slice
      U32))
  let s1 ← f4 b 16#usize 18#usize
  sum2 s s1

/- [arrays::SZ]
   Source: 'tests/src/arrays.rs', lines 316:0-316:25 -/
@[global_simps] def SZ_body : Result Usize := ok 32#usize
@[global_simps, irreducible] def SZ : Usize := eval_global SZ_body

/- [arrays::f5]:
   Source: 'tests/src/arrays.rs', lines 319:0-321:1 -/
def f5 (x : Array U32 32#usize) : Result U32 :=
  Array.index_usize x 0#usize

/- [arrays::ite]:
   Source: 'tests/src/arrays.rs', lines 324:0-331:1 -/
def ite : Result Unit :=
  do
  let x := Array.repeat 2#usize 0#u32
  let y := Array.repeat 2#usize 0#u32
  let (s, _) ←
    (↑(Array.to_slice_mut x) : Result ((Slice U32) × (Slice U32 → Array
      U32 2#usize)))
  let _ ← index_mut_slice_u32_0 s
  let (s1, _) ←
    (↑(Array.to_slice_mut y) : Result ((Slice U32) × (Slice U32 → Array
      U32 2#usize)))
  let _ ← index_mut_slice_u32_0 s1
  ok ()

/- [arrays::zero_slice]: loop 0:
   Source: 'tests/src/arrays.rs', lines 336:4-339:5 -/
def zero_slice_loop
  (a : Slice U8) (i : Usize) (len : Usize) : Result (Slice U8) :=
  if i < len
  then
    do
    let a1 ← Slice.update a i 0#u8
    let i1 ← i + 1#usize
    zero_slice_loop a1 i1 len
  else ok a
partial_fixpoint

/- [arrays::zero_slice]:
   Source: 'tests/src/arrays.rs', lines 333:0-340:1 -/
def zero_slice (a : Slice U8) : Result (Slice U8) :=
  let len := Slice.len a
  zero_slice_loop a 0#usize len

/- [arrays::iter_mut_slice]: loop 0:
   Source: 'tests/src/arrays.rs', lines 345:4-347:5 -/
def iter_mut_slice_loop (len : Usize) (i : Usize) : Result Unit :=
  if i < len
  then do
       let i1 ← i + 1#usize
       iter_mut_slice_loop len i1
  else ok ()
partial_fixpoint

/- [arrays::iter_mut_slice]:
   Source: 'tests/src/arrays.rs', lines 342:0-348:1 -/
def iter_mut_slice (a : Slice U8) : Result (Slice U8) :=
  do
  let len := Slice.len a
  iter_mut_slice_loop len 0#usize
  ok a

/- [arrays::sum_mut_slice]: loop 0:
   Source: 'tests/src/arrays.rs', lines 353:4-356:5 -/
def sum_mut_slice_loop (a : Slice U32) (i : Usize) (s : U32) : Result U32 :=
  let i1 := Slice.len a
  if i < i1
  then
    do
    let i2 ← Slice.index_usize a i
    let s1 ← s + i2
    let i3 ← i + 1#usize
    sum_mut_slice_loop a i3 s1
  else ok s
partial_fixpoint

/- [arrays::sum_mut_slice]:
   Source: 'tests/src/arrays.rs', lines 350:0-358:1 -/
def sum_mut_slice (a : Slice U32) : Result (U32 × (Slice U32)) :=
  do
  let i ← sum_mut_slice_loop a 0#usize 0#u32
  ok (i, a)

/- [arrays::add_acc]: loop 0:
   Source: 'tests/src/arrays.rs', lines 362:4-371:5 -/
def add_acc_loop
  (paSrc : Array U32 256#usize) (peDst : Array U32 256#usize) (i : Usize) :
  Result ((Array U32 256#usize) × (Array U32 256#usize))
  :=
  if i < 256#usize
  then
    do
    let a ← Array.index_usize paSrc i
    let paSrc1 ← Array.update paSrc i 0#u32
    let c ← Array.index_usize peDst i
    let c1 ← c + a
    let peDst1 ← Array.update peDst i c1
    let i1 ← i + 1#usize
    add_acc_loop paSrc1 peDst1 i1
  else ok (paSrc, peDst)
partial_fixpoint

/- [arrays::add_acc]:
   Source: 'tests/src/arrays.rs', lines 360:0-372:1 -/
@[reducible]
def add_acc
  (paSrc : Array U32 256#usize) (peDst : Array U32 256#usize) :
  Result ((Array U32 256#usize) × (Array U32 256#usize))
  :=
  add_acc_loop paSrc peDst 0#usize

end arrays
