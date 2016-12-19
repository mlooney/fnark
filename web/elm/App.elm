module App exposing (..)

import Json.Decode as Decode exposing (Decoder, field, succeed, at)
import Html exposing (..)
import Json.Encode as Encode
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.Attributes exposing (..)
import Http
import String
import Time exposing (Time)


--Models


type alias Model =
    { links : List Link, user : Maybe User, alert : Maybe String, login : Login, token : Maybe String }


type alias User =
    { email : String, realname : String, id : Int, username : String }


type alias Link =
    { id : Int, url : String, created : String, blurb : String }


type alias Login =
    { username : String, password : String }


initialModel =
    Model [] Nothing Nothing (Login "" "") Nothing



--update


type Msg
    = GotLinks (Result Http.Error (List Link))
    | DoLogin
    | LoggedIn (Result Http.Error String)
    | UsernameChange String
    | PassChange String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PassChange x ->
            ( { model | login = (Login model.login.username x) }, Cmd.none )

        UsernameChange x ->
            ( { model | login = (Login x model.login.password) }, Cmd.none )

        GotLinks (Ok e) ->
            ( { model | links = e, alert = Nothing }, Cmd.none )

        GotLinks (Err err) ->
            ( { model | alert = Just (toString err) }, Cmd.none )

        DoLogin ->
            ( model, doLogin model.login )

        LoggedIn (Ok tok) ->
            ( { model | token = Just tok, login = Login "" "" }, Cmd.none )

        LoggedIn (Err err) ->
            ( { model | alert = Just (toString err), login = Login "" "" }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "maid" ]
        [ viewAlert model.alert
        , viewLinks model.links
        , viewLoginBox model
        ]


loginBox : Html Msg
loginBox =
    Html.form [ onSubmit DoLogin, id "login-form" ]
        [ p [] [ text "Login" ]
        , label [ for "username-field" ] [ text "username: " ]
        , input [ onInput UsernameChange, id "username-field", placeholder "username", type_ "text" ] []
        , label [ for "password" ] [ text "password: " ]
        , input [ onInput PassChange, id "password-field", placeholder "password", type_ "password" ] []
        , button [] [ text "login" ]
        ]


loggedInBox : String -> Html Msg
loggedInBox user =
    div [ class "box" ]
        [ p [] [ text ("logged in as " ++ user) ]
        ]


viewLoginBox : Model -> Html Msg
viewLoginBox model =
    case model.token of
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



-- Actions


encodeLogin : Login -> Encode.Value
encodeLogin login =
    Encode.object
        [ ( "username", Encode.string login.username )
        , ( "password", Encode.string login.password )
        ]


jwtDecoder : Decoder String
jwtDecoder =
    Decode.field "jwt" Decode.string


doLogin : Login -> Cmd Msg
doLogin login =
    let
        url =
            getUrl "session/"

        body =
            encodeLogin login
                |> Http.jsonBody

        request =
            Http.post url body jwtDecoder
    in
        Http.send LoggedIn request


getLinks : Cmd Msg
getLinks =
    at [ "links" ]
        (Decode.list linkDecoder)
        |> Http.get (getUrl "links/")
        |> Http.send GotLinks


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getLinks )
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
