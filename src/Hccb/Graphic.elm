module Hccb.Graphic exposing (graphic, graphicResize)

import Html exposing (Html)
import Svg exposing (Svg, svg)
import Svg.Attributes exposing (width, height, viewBox)


-- Project Imports

import Hccb.Dim exposing (Dim(..))
import Hccb.Point exposing (Point(..))
import Hccb.Rect exposing (Rect(..))
import Hccb.Pad exposing (Pad)


graphicResize : Dim -> Dim -> Pad -> (Rect -> List (Svg msg)) -> Html msg
graphicResize (Dim w h) (Dim resizeW resizeH) pad generator =
    let
        pt =
            Point pad.left pad.top

        innerDim =
            Dim (w - pad.left - pad.right) (h - pad.top - pad.bottom)

        inside =
            Rect pt innerDim

        boundingBoxStr =
            "0 0 " ++ (Debug.toString w) ++ " " ++ (Debug.toString h)
    in
        svg
            [ width (Debug.toString resizeW)
            , height (Debug.toString resizeH)
            , viewBox boundingBoxStr
            ]
            (generator inside)


graphic : Dim -> Pad -> (Rect -> List (Svg msg)) -> Html msg
graphic dim =
    graphicResize dim dim
