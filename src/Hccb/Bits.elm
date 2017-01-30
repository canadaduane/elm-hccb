module Hccb.Bits exposing (Bits(..), bitsPerByte)


type Bits
    = TwoBits
    | ThreeBits


bitsPerByte : Int
bitsPerByte =
    8
