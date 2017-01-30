module Hccb.ColorData exposing (..)

import Array exposing (Array(..))
import Bitwise exposing (shiftLeftBy, shiftRightZfBy, or, and)


-- Project Imports

import Hccb.Bits exposing (Bits(..), bitsPerByte)


type alias ColorData =
    List String


fourColorMap : ColorData
fourColorMap =
    [ -- black
      "#000000"
      -- yellow
    , "#FFFF45"
      -- green
    , "#12FF0E"
      -- red
    , "#FF1400"
    ]


eightColorMap : ColorData
eightColorMap =
    [ -- black
      "#000000"
      -- yellow
    , "#FAFD28"
      -- green
    , "#1CEC12"
      -- red
    , "#DF0203"
      -- white
    , "#FAFAFA"
      -- cyan
    , "#1EF6EE"
      -- pink
    , "#F38BED"
      -- blue
    , "#1833DE"
    ]


{-| Given a Two-bits-per-triangle or Four-bits-per-triangle configuration and
    a list of bytes, create an array of colors (to use as triangle colors)
-}
dataToColors : Bits -> List Int -> ColorData
dataToColors bits ints =
    let
        ( nbits, colorMap ) =
            case bits of
                TwoBits ->
                    ( 2, fourColorMap )

                ThreeBits ->
                    ( 3, eightColorMap )

        takeBits atIndex value =
            let
                ( shift, mask ) =
                    case bits of
                        TwoBits ->
                            ( atIndex * 2, 3 )

                        ThreeBits ->
                            ( atIndex * 3, 7 )

                shiftedMask =
                    shiftLeftBy shift mask
            in
                and value shiftedMask |> shiftRightZfBy shift

        intToList value =
            let
                numberOfElments =
                    bitsPerByte // nbits
            in
                List.repeat numberOfElments value |> List.indexedMap takeBits

        lookupColor value =
            Array.get value (Array.fromList colorMap) |> Maybe.withDefault "#000000"
    in
        ints |> List.concatMap intToList |> List.map lookupColor


{-| The HCCB always includes a "legend" that shows each of the available colors
    for the rest of the data. `colorsPrefix` creates the legend.
-}
colorsPrefix : Bits -> ColorData
colorsPrefix bits =
    let
        doubleColors : ColorData -> ColorData
        doubleColors colors =
            List.concatMap (\c -> [ c, c ]) colors
    in
        case bits of
            TwoBits ->
                doubleColors fourColorMap

            ThreeBits ->
                doubleColors eightColorMap
