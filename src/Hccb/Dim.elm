module Hccb.Dim exposing (Dim(..), widthOf, heightOf, square, map)


type Dim
    = Dim Float Float


widthOf : Dim -> Float
widthOf (Dim width _) =
    width


heightOf : Dim -> Float
heightOf (Dim _ height) =
    height


square : Float -> Dim
square side =
    Dim side side


map : (Float -> Float) -> Dim -> Dim
map fn (Dim w h) =
    Dim (fn w) (fn h)
