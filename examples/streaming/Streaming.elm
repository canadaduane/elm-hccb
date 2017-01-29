module Streaming exposing (..)

import Html exposing (Html, h1, div, span, button, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http exposing (Request, Error, send, getString)
import Time exposing (Time, millisecond)
import Char


-- Project Imports

import Hccb exposing (barcode, standardSpec)


{-| Configuration parameter: number of milliseconds to show each page of data
-}
millisPerPage : Float
millisPerPage =
    400


barcodeSize : Float
barcodeSize =
    200


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type LoadStatus
    = LoadInit
    | Loading
    | LoadSuccess
    | LoadFailure String


type alias Model =
    { data : Maybe String
    , page : Int
    , transmitting : Bool
    , loading : LoadStatus
    }


initialModel : Model
initialModel =
    { data = Nothing
    , page = 0
    , transmitting = False
    , loading = LoadInit
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, send LoadData getData )


getData : Request String
getData =
    getString "arduino_blink.hex"



-- UPDATE


type Msg
    = NoOp
    | LoadData (Result Error String)
    | NextPage Time
    | ToggleTransmitting
    | StopTransmitting



-- toggleTransmit :


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newModel =
            case msg of
                LoadData (Ok data) ->
                    { model | data = Just data, page = 0, loading = LoadSuccess }

                LoadData (Err msg) ->
                    { model | loading = LoadFailure (toString msg) }

                NextPage time ->
                    let
                        nextPage =
                            model.page + 1
                    in
                        if nextPage <= pageTotal model then
                            { model | page = nextPage }
                        else
                            { model | transmitting = False }

                ToggleTransmitting ->
                    case model.transmitting of
                        True ->
                            { model | transmitting = False }

                        False ->
                            { model | transmitting = True, page = 0 }

                StopTransmitting ->
                    case model.transmitting of
                        True ->
                            { model | transmitting = False }

                        False ->
                            { model | transmitting = False, page = 0 }

                NoOp ->
                    model
    in
        ( newModel, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.transmitting then
        Time.every (millisPerPage * millisecond) NextPage
    else
        Sub.none



-- VIEW


buttonStyles : List ( String, String )
buttonStyles =
    [ ( "font-size", "18px" )
    , ( "margin", "0 0.5em" )
    , ( "padding", "0.2em 0.5em 0.24em 0.5em" )
    ]


view : Model -> Html Msg
view model =
    div [ style [ ( "text-align", "center" ) ] ]
        [ h1 [] [ text "High Capacity Color Barcode" ]
        , div
            [ style
                [ ( "background-color", "#eee" )
                , ( "padding", "1em" )
                , ( "margin-bottom", "1em" )
                ]
            ]
            [ barcode standardSpec barcodeSize barcodeSize (currentPageData model) ]
        , progressBar ( model.page, pageTotal model )
        , div [ style [ ( "margin", "1em 0" ) ] ]
            [ if model.transmitting then
                text "Transmitting"
              else
                button
                    [ style buttonStyles
                    , onClick ToggleTransmitting
                    ]
                    [ text "Transmit" ]
            , button
                [ style buttonStyles
                , onClick StopTransmitting
                ]
                [ if model.transmitting then
                    text "Stop"
                  else
                    text "Reset"
                ]
            ]
        , div [ style [ ( "border", "2px solid #dddddd" ), ( "border-radius", "4px" ) ] ]
            [ text (loadStatus model.loading)
            ]
        ]


loadStatus : LoadStatus -> String
loadStatus status =
    case status of
        LoadInit ->
            "starting"

        Loading ->
            "loading"

        LoadSuccess ->
            "done"

        LoadFailure str ->
            "error: " ++ str ++ " (try loading this with 'elm reactor' to allow AJAX requests)"


progressBar : ( Int, Int ) -> Html Msg
progressBar ( page, total ) =
    let
        barColor =
            "#3370EE"

        ratioComplete =
            (toFloat page) / (toFloat total)

        percentComplete =
            ratioComplete * 100 |> ceiling

        maxWidth =
            300

        progressWidth =
            (toFloat maxWidth) * ratioComplete
    in
        div
            [ style
                [ ( "width", (toString maxWidth) ++ "px" )
                , ( "height", "20px" )
                , ( "border", "1px solid " ++ barColor )
                , ( "border-radius", "3px" )
                , ( "display", "-webkit-inline-box" )
                ]
            ]
            [ div
                [ style
                    [ ( "width", (toString progressWidth) ++ "px" )
                    , ( "height", "20px" )
                    , ( "background-color", barColor )
                    ]
                ]
                []
            , span [ style [ ( "padding-left", "0.5em" ) ] ]
                [ if total > 0 then
                    text <| (toString percentComplete) ++ "%"
                  else
                    text ""
                ]
            ]


pageSize : Int
pageSize =
    standardSpec.size.rows * standardSpec.size.cols


pageTotal : Model -> Int
pageTotal model =
    case model.data of
        Just string ->
            let
                totalSize =
                    String.length string |> toFloat

                pageSizeF =
                    pageSize |> toFloat
            in
                totalSize / pageSizeF |> ceiling

        Nothing ->
            0


currentPageData : Model -> List Int
currentPageData model =
    let
        startSlice =
            model.page * pageSize

        endSlice =
            startSlice + pageSize - 1

        theSlice : String
        theSlice =
            case model.data of
                Just string ->
                    String.slice startSlice endSlice string

                Nothing ->
                    ""
    in
        theSlice |> String.toList |> List.map Char.toCode
