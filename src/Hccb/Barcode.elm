module Hccb.Barcode exposing (..)

import Svg exposing (Svg, rect, path)
import Svg.Attributes exposing (d, fill, height, stroke, strokeWidth, width, x, y)
import Array


-- Project Imports

import Hccb.Dim exposing (Dim(..), heightOf, square, widthOf)
import Hccb.Pad exposing (Pad, equalPad, zeroPad)
import Hccb.Point exposing (Point(..))
import Hccb.Rect exposing (Rect(..), pointOf)
import Hccb.Triangle exposing (TriangleDir(..), drawTriangle)
import Hccb.Specification exposing (Specification, Size)
import Hccb.SpecDim exposing (triangleRowDim, barcodeDim)
import Hccb.ColorData exposing (ColorData)


type alias RowSpec =
    { width : Float
    , inset : Float
    , stripHeight : Float
    , spaceHeight : Float
    }


getRowSpec : Specification -> RowSpec
getRowSpec spec =
    let
        rowDim =
            triangleRowDim spec
    in
        { width = widthOf rowDim
        , inset = spec.rowInset
        , stripHeight = spec.whiteStripHeight
        , spaceHeight = heightOf spec.triangleDim
        }


black : String
black =
    "#000000"


white : String
white =
    "#FFFFFF"


drawTriangles : Specification -> Point -> ColorData -> List (Svg msg)
drawTriangles spec (Point corner_x corner_y) data =
    let
        rowSpec =
            getRowSpec spec

        rowRange =
            List.range 0 (spec.size.rows - 1)

        colRange =
            List.range 0 (spec.size.cols - 1)

        rung i =
            (toFloat i) * (rowSpec.stripHeight + rowSpec.spaceHeight)

        arrayData =
            Array.fromList data

        drawTriangleAt : Int -> Int -> Svg msg
        drawTriangleAt i j =
            let
                triangleDir =
                    case j % 2 of
                        0 ->
                            TriangleUp

                        _ ->
                            TriangleDown

                triangleColor =
                    case Array.get (i * spec.size.cols + j) arrayData of
                        Just color ->
                            color

                        Nothing ->
                            "#000000"

                x =
                    corner_x + (toFloat (spec.size.cols - j - 1)) * (widthOf spec.triangleDim / 2)

                y =
                    corner_y + rung (spec.size.rows - i - 1)
            in
                drawTriangle triangleDir triangleColor spec.whiteStripHeight spec.triangleDim (Point x y)

        drawTriangleRow i =
            List.map (drawTriangleAt i) colRange
    in
        List.concatMap drawTriangleRow rowRange


drawStrips : RowSpec -> Point -> Size -> List (Svg msg)
drawStrips rowSpec (Point corner_x corner_y) size =
    let
        extraPad =
            { zeroPad | left = 1.3, right = 1.8 }

        rowRange =
            List.range 0 size.rows

        rung row =
            corner_y + (toFloat row) * (rowSpec.stripHeight + rowSpec.spaceHeight)

        stripDim =
            Dim (rowSpec.width + rowSpec.inset * 2 + extraPad.left + extraPad.right) rowSpec.stripHeight

        strip row =
            Rect (Point (corner_x - extraPad.left) (rung row)) stripDim
    in
        List.map (\i -> drawRect white (strip i)) rowRange


drawFrame : Rect -> Rect -> List (Svg msg)
drawFrame outside inside =
    [ drawRect white outside
    , drawRect black inside
    ]


drawRect : String -> Rect -> Svg msg
drawRect fill_ (Rect (Point x_ y_) (Dim w_ h_)) =
    rect
        [ toString x_ |> x
        , toString y_ |> y
        , toString w_ |> width
        , toString h_ |> height
        , fill fill_
        ]
        []
