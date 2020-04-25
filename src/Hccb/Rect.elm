module Hccb.Rect exposing (Rect(..), rect, pointOf, dimOf, map)

import Hccb.Point exposing (Point(..))
import Hccb.Dim exposing (Dim(..))


type Rect
    = Rect Point Dim


rect : Float -> Float -> Float -> Float -> Rect
rect x y w h =
    Rect (Point x y) (Dim w h)


-- fromRect : Rect -> ( Float, Float, Float, Float )
-- fromRect (Rect (Point x y) (Dim w h)) =
--     ( x, y, w, h )


pointOf : Rect -> Point
pointOf (Rect pt _) =
    pt


dimOf : Rect -> Dim
dimOf (Rect _ dm) =
    dm


map : (Float -> Float) -> Rect -> Rect
map fn (Rect (Point x y) (Dim w h)) =
    rect (fn x) (fn y) (fn w) (fn h)
