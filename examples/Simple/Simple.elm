module Simple.Simple exposing (..)

import Browser exposing (sandbox)
import Html exposing (Html, h1, h2, div, text)
import Html.Attributes exposing (style)

-- Project Imports

import Hccb exposing (barcode, standardSpec)


type alias Model =
    ()


type Msg
    = NoOp


main : Program () ( Model, Cmd Msg ) Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
--         , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )


-- update : Msg -> Model -> ( Model, Cmd Msg )
update : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update msg arg2 =
    case msg of
        NoOp ->
            ( Tuple.first arg2 , Cmd.none )


totalBytes : Int
totalBytes =
    ((standardSpec.size.cols
        * standardSpec.size.rows
     )
        - 16
    )
        * 3
        // 8


view : ( Model, Cmd Msg ) -> Html Msg
view model =
    div []
        [ h1 [] [ text "High Capacity Color Barcode" ]
        , h2 [] [ text "Simple Example" ]
        , div []
            [ barcode standardSpec 250 250 sampleData ]
        , h2 [] [ text "This is a 250 x 250 pixel 8-color (3-bit) HCCB" ]
        , h2 []
            [ text <|
                "It stores "
                    ++ (Debug.toString totalBytes)
                    ++ " bytes of non-error-corrected data."
            ]
        , h2 []
            [ text <|
                "It has "
                    ++ (Debug.toString standardSpec.size.cols)
                    ++ " columns and "
                    ++ (Debug.toString standardSpec.size.rows)
                    ++ " rows."
            ]
        ]


sampleData : List Int
sampleData =
    List.range 1 255
