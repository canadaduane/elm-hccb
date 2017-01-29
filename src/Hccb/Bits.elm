module Hccb.Bits exposing (Bits(..), bitsPerByte)


type Bits
    = Two
    | Four


bitsPerByte : Int
bitsPerByte =
    8
