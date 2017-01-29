module Hccb.Pad exposing (Pad, equalPad, zeroPad)


type alias Pad =
    { left : Float
    , right : Float
    , top : Float
    , bottom : Float
    }


equalPad : Float -> Pad
equalPad value =
    { left = value
    , right = value
    , top = value
    , bottom = value
    }


zeroPad : Pad
zeroPad =
    equalPad 0
