module Simple.Simple exposing (..)

import Html exposing (Html, h1, h2, div, text)
import Html.Attributes exposing (style)


-- Project Imports

import Hccb exposing (barcode, standardSpec)


type alias Model =
    ()


type Msg
    = NoOp


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


totalBytes : Int
totalBytes =
    ((standardSpec.size.cols
        * standardSpec.size.rows
     )
        - 16
    )
        * 3
        // 8


view : Model -> Html Msg
view model =
    div [ style [ ( "text-align", "center" ) ] ]
        [ h1 [] [ text "High Capacity Color Barcode" ]
        , h2 [] [ text "Simple Example" ]
        , div
            [ style
                [ ( "background-color", "#eee" )
                , ( "padding", "1em" )
                , ( "margin-bottom", "1em" )
                ]
            ]
            [ barcode standardSpec 250 250 sampleData ]
        , h2 [] [ text "This is a 250 x 250 pixel 8-color (3-bit) HCCB" ]
        , h2 []
            [ text <|
                "It stores "
                    ++ (toString totalBytes)
                    ++ " bytes of non-error-corrected data."
            ]
        , h2 []
            [ text <|
                "It has "
                    ++ (toString standardSpec.size.cols)
                    ++ " columns and "
                    ++ (toString standardSpec.size.rows)
                    ++ " rows."
            ]
        ]


sampleData : List Int
sampleData =
    List.range 1 255
