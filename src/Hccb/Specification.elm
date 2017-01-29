module Hccb.Specification exposing (..)

{-| Specification for High Capacity Color Barcode (HCCB)

# Usage
Usually, you just need the `standardSpec` Specification exposed by the main
Hccb module. However, if you need to customize the size or other factors of
an HCCB barcode, you can do so.
-}

import Hccb.Pad exposing (Pad, equalPad, zeroPad)
import Hccb.Dim exposing (Dim(..), widthOf, heightOf)
import Hccb.Bits exposing (Bits(..))


type alias Size =
    { rows : Int
    , cols : Int
    }


type alias Specification =
    { bits : Bits
    , size : Size
    , whiteFramePad : Pad
    , blackBackgroundPad : Pad
    , whiteStripHeight : Float
    , rowInset : Float
    , triangleDim : Dim
    }


{-| Calculate the dimensions of a row of triangles. Includes the
    height of the horizontal white strip, but does not include
    left or right padding or inset.
-}
triangleRowDim : Specification -> Dim
triangleRowDim spec =
    let
        width =
            (widthOf spec.triangleDim)
                * (toFloat spec.size.cols)
                / 2

        height =
            ((heightOf spec.triangleDim) + spec.whiteStripHeight)
    in
        Dim width height


{-| Calculate the outer dimensions (w, h) of an HCCB, given its specification.
-}
barcodeDim : Specification -> Dim
barcodeDim spec =
    let
        rowDim =
            triangleRowDim spec

        width =
            0.0
                + spec.whiteFramePad.left
                + spec.blackBackgroundPad.left
                + spec.rowInset
                + widthOf rowDim
                + spec.rowInset
                + spec.blackBackgroundPad.right
                + spec.whiteFramePad.right

        height =
            0.0
                + spec.whiteFramePad.top
                + spec.blackBackgroundPad.top
                + ((heightOf rowDim)
                    * (toFloat spec.size.rows + 1)
                  )
                + spec.whiteFramePad.bottom
    in
        Dim width height
