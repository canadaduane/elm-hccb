module Hccb.Path exposing (..)

import Hccb.Segment exposing (Segment(..), segmentToString)


type alias Path =
    List Segment


pathToString : Path -> String
pathToString path =
    path |> List.map segmentToString |> String.join " "
