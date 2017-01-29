module Hccb.Point exposing (Point(Point), pointToString)


type Point
    = Point Float Float


pointToString : Point -> String
pointToString (Point x_ y_) =
    (toString x_) ++ " " ++ (toString y_)
