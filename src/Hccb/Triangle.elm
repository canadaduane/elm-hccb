module Hccb.Triangle exposing (..)

import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, fill, stroke, strokeWidth)


-- Project Imports

import Hccb.Dim exposing (Dim(..))
import Hccb.Point exposing (Point(..))
import Hccb.Segment exposing (Segment(..), moveTo, lineTo, closePath)
import Hccb.Path exposing (Path, pathToString)


type TriangleDir
    = TriangleUp
    | TriangleDown


white : String
white =
    "#FFFFFF"


{-| Return an SVG path in the shape of a triangle (either "up" or "down" facing)
-}
drawTriangle : TriangleDir -> String -> Float -> Dim -> Point -> Svg msg
drawTriangle direction fill_ stripHeight triangleDim corner =
    let
        strokeWidth_ =
            2

        pathStr =
            case direction of
                TriangleUp ->
                    upTrianglePath stripHeight strokeWidth_ triangleDim corner

                TriangleDown ->
                    downTrianglePath stripHeight strokeWidth_ triangleDim corner
    in
        path
            [ d pathStr
            , fill fill_
            , stroke white
            , strokeWidth (Debug.toString strokeWidth_)
            ]
            []


{-| form a triangle path in the following shape:
       ----.......----
       ----.     .----
            .   .
             . .
              .
-}
downTrianglePath : Float -> Float -> Dim -> Point -> String
downTrianglePath stripHeight strokeWidth (Dim w_ h_) (Point x_ y_) =
    let
        path =
            [ moveTo x_ (y_ + strokeWidth)
            , lineTo w_ 0
            , lineTo 0 (stripHeight - strokeWidth)
            , lineTo (-w_ / 2) h_
            , lineTo (-w_ / 2) -h_
            , closePath
            ]
    in
        pathToString path


{-| form a triangle path in the following shape:
       ---------------
       -------.-------
             . .
            .   .
           .     .
           .......
-}
upTrianglePath : Float -> Float -> Dim -> Point -> String
upTrianglePath stripHeight strokeWidth (Dim w_ h_) (Point x_ y_) =
    let
        path =
            [ moveTo (x_ + w_ / 2) (y_ + stripHeight)
            , lineTo (w_ / 2) h_
            , lineTo 0 (stripHeight - strokeWidth)
            , lineTo -w_ 0
            , lineTo 0 (-stripHeight + strokeWidth)
            , closePath
            ]
    in
        pathToString path
