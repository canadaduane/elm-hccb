module Hccb.Specification exposing (..)

{-| Specification for High Capacity Color Barcode (HCCB)

# Usage
Usually, you just need the `standardSpec` Specification exposed by the main
Hccb module. However, if you need to customize the size or other factors of
an HCCB barcode, you can do so.

@docs Specification, Size
-}

import Hccb.Pad exposing (Pad)
import Hccb.Dim exposing (Dim(..))
import Hccb.Bits exposing (Bits(..))


{-| Size of an HCCB. `cols` across and `rows` down.
-}
type alias Size =
    { rows : Int
    , cols : Int
    }


{-| The parameters that define how to draw an HCCB
-}
type alias Specification =
    { bits : Bits
    , size : Size
    , whiteFramePad : Pad
    , blackBackgroundPad : Pad
    , whiteStripHeight : Float
    , rowInset : Float
    , triangleDim : Dim
    }
