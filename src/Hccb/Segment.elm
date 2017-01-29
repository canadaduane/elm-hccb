module Hccb.Segment exposing (..)

import Hccb.Point exposing (Point(..), pointToString)


type Segment
    = MoveTo Point
    | LineTo Point
    | ClosePath


moveTo : Float -> Float -> Segment
moveTo x y =
    MoveTo (Point x y)


lineTo : Float -> Float -> Segment
lineTo x y =
    LineTo (Point x y)


closePath : Segment
closePath =
    ClosePath


segmentToString : Segment -> String
segmentToString segment =
    case segment of
        MoveTo point ->
            "M" ++ pointToString point

        LineTo point ->
            "l" ++ pointToString point

        ClosePath ->
            "z"
