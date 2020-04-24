module Hccb.Point exposing (Point(..), pointToString)


type Point
    = Point Float Float


pointToString : Point -> String
pointToString (Point x_ y_) =
    (Debug.toString x_) ++ " " ++ (Debug.toString y_)
