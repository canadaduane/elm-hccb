module Hccb
    exposing
        ( barcode
        , standardSpec
        )

import Html exposing (Html)
import Svg exposing (Svg)


-- Project Imports

import Hccb.Graphic exposing (graphicResize)
import Hccb.Barcode exposing (..)
import Hccb.Specification exposing (Specification, barcodeDim)
import Hccb.ColorData exposing (ColorData, dataToColors, colorsPrefix)
import Hccb.Bits exposing (Bits(..))
import Hccb.Pad exposing (Pad, zeroPad, equalPad)
import Hccb.Dim exposing (Dim(..))
import Hccb.Rect exposing (Rect(..), pointOf)
import Hccb.Point exposing (Point(..))


type alias Data =
    List Int


standardSpec : Specification
standardSpec =
    { bits = Four
    , size =
        { rows = 12
        , cols = 24
        }
    , whiteFramePad = equalPad 20.87
    , blackBackgroundPad = equalPad 8.94
    , whiteStripHeight = 5.96
    , rowInset = 5.96
    , triangleDim = Dim 25.48 20.87
    }


{-| Generate an HCCB (High Capacity Color Barcode) SVG in HTML
-}
barcode : Specification -> Float -> Float -> Data -> Html msg
barcode spec w_ h_ data =
    let
        dim =
            barcodeDim spec

        {- Subtract padding from a rectangle -}
        minusPad : Pad -> Rect -> Rect
        minusPad pad (Rect (Point x y) (Dim w h)) =
            Rect (Point (x + pad.left) (y + pad.top))
                (Dim (w - pad.left - pad.right) (h - pad.top - pad.bottom))

        generate : Rect -> List (Svg msg)
        generate outerRect =
            let
                innerRect =
                    outerRect |> minusPad spec.whiteFramePad

                innerPaddedRect =
                    innerRect |> minusPad spec.blackBackgroundPad

                rowSpec =
                    getRowSpec spec

                coloredData =
                    (colorsPrefix spec.bits) ++ (dataToColors Four data)
            in
                []
                    ++ (drawFrame outerRect innerRect)
                    ++ (drawTriangles spec (pointOf innerPaddedRect) coloredData)
                    ++ (drawStrips rowSpec (pointOf innerPaddedRect) spec.size)
    in
        graphicResize dim (Dim w_ h_) zeroPad generate
