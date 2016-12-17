module App exposing (..)

import Json.Decode as Decode exposing (Decoder, field, succeed, at)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Time exposing (Time)


--Models


type alias Model =
    { links : List Link, user : Maybe User, alert : Maybe String }


type alias User =
    { email : String, realname : String, id : Int, username : String }


type alias Link =
    { id : Int, url : String, created : String, blurb : String }


initialModel =
    Model [] Nothing Nothing



--update


type Msg
    = Login
    | Logout
    | MkLink
    | LinkCreated
    | MkUser
    | UserCreated
    | NewLinks (Result Http.Error (List Link))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewLinks (Ok e) ->
            ( { model | links = e, alert = Nothing }, Cmd.none )

        NewLinks (Err err) ->
            ( { model | alert = Just (toString err) }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "maid" ]
        [ viewAlert model.alert
        , viewLinks model.links
        , viewLoginBox model
        ]


loginBox : Html Msg
loginBox =
    div [ class "box" ]
        [ text "you should login"
        ]


loggedInBox : User -> Html Msg
loggedInBox user =
    div [ class "box" ]
        [ p [] [ text ("logged in as " ++ user.realname) ]
        ]


viewLoginBox : Model -> Html Msg
viewLoginBox model =
    case model.user of
        Nothing ->
            loginBox

        Just u ->
            loggedInBox u



-- Decoders


viewAlert : Maybe String -> Html Msg
viewAlert a =
    case a of
        Nothing ->
            text ""

        Just x ->
            div [ class "alert" ] [ text x ]


viewLink : Link -> Html Msg
viewLink link =
    li [ class "dinkle" ]
        [ a [ href link.url, target "_shank" ] [ text link.blurb ]
        ]


viewLinks : List Link -> Html Msg
viewLinks ll =
    List.map viewLink ll
        |> ul []


linkDecoder : Decoder Link
linkDecoder =
    Decode.map4 Link
        (field "id" Decode.int)
        (field "url" Decode.string)
        (field "inserted_at" Decode.string)
        (field "blurb" Decode.string)


getUrl : String -> String
getUrl str =
    "http://localhost:4000/api/" ++ str


getLinks : Cmd Msg
getLinks =
    at [ "links" ]
        (Decode.list linkDecoder)
        |> Http.get (getUrl "links/")
        |> Http.send NewLinks


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getLinks )
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
