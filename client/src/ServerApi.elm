module ServerApi exposing (..)

import Http exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Model.Shared exposing (..)
import Decoders exposing (..)
import Encoders exposing (..)


-- WebSocket


gameSocket : String -> String -> String
gameSocket host id =
    "ws://" ++ host ++ "/ws/trackPlayer/" ++ id


timeTrialSocket : String -> String
timeTrialSocket host =
    "ws://" ++ host ++ "/ws/timeTrialPlayer"


activitySocket : String -> String
activitySocket host =
    "ws://" ++ host ++ "/ws/activity"



-- GET


type alias GetJsonTask a =
    Task Never (Result () a)


getPlayer : String -> Request Player
getPlayer handle =
    get ("/api/players/" ++ handle) playerDecoder


getLiveStatus : Request LiveStatus
getLiveStatus =
    get "/api/live" liveStatusDecoder


getRaceReports : Maybe String -> Request (List RaceReport)
getRaceReports maybeTrackId =
    let
        path =
            Maybe.map (\id -> "/api/live/" ++ id ++ "/reports") maybeTrackId
                |> Maybe.withDefault "/api/live/reports"
    in
        Http.get path (Json.list raceReportDecoder)


getTrack : String -> Request Track
getTrack id =
    get ("/api/tracks/" ++ id) trackDecoder


getCourse : String -> Request Course
getCourse id =
    Http.get ("/api/tracks/" ++ id ++ "/course") courseDecoder


getLiveTrack : String -> Request LiveTrack
getLiveTrack id =
    Http.get ("/api/live/" ++ id) liveTrackDecoder


getLiveTimeTrial : Maybe String -> Request LiveTimeTrial
getLiveTimeTrial maybeId =
    let
        params =
            maybeId
                |> Maybe.map (\id -> [ ( "id", id ) ])
                |> Maybe.withDefault []
    in
        get ("/api/live/time-trial" ++ (queryString params)) liveTimeTrialDecoder


getUserTracks : Request (List Track)
getUserTracks =
    get "/api/tracks/user" (Json.list trackDecoder)



-- POST


postHandle : String -> Request Player
postHandle handle =
    post "/api/setHandle"
        (jsonBody (JsEncode.object [ ( "handle", JsEncode.string handle ) ]))
        playerDecoder


postRegister : String -> String -> String -> Request Player
postRegister email handle password =
    let
        body =
            JsEncode.object
                [ ( "email", JsEncode.string email )
                , ( "handle", JsEncode.string handle )
                , ( "password", JsEncode.string password )
                ]
    in
        post "/api/register" (jsonBody body) playerDecoder


postLogin : String -> String -> Request Player
postLogin email password =
    let
        body =
            JsEncode.object
                [ ( "email", JsEncode.string email )
                , ( "password", JsEncode.string password )
                ]
    in
        post "/api/login" (jsonBody body) playerDecoder


postLogout : Request Player
postLogout =
    post "/api/logout" Http.emptyBody playerDecoder


createTrack : String -> Request Track
createTrack name =
    let
        body =
            JsEncode.object [ ( "name", JsEncode.string name ) ]
    in
        post "/api/tracks" (jsonBody body) trackDecoder


saveTrack : String -> String -> Course -> Request Track
saveTrack id name course =
    let
        body =
            JsEncode.object
                [ ( "course", courseEncoder course )
                , ( "name", JsEncode.string name )
                ]
    in
        post ("/api/tracks/" ++ id) (jsonBody body) trackDecoder


publishTrack : String -> Request Track
publishTrack id =
    post ("/api/tracks/" ++ id ++ "/publish") Http.emptyBody trackDecoder


deleteDraft : String -> Request String
deleteDraft id =
    post ("/api/tracks/" ++ id ++ "/delete") Http.emptyBody (Json.succeed id)


deleteTimeTrial : String -> Request String
deleteTimeTrial id =
    post ("/api/time-trials/" ++ id ++ "/delete") Http.emptyBody (Json.succeed id)



-- Tooling


sendForm : (FormResult a -> msg) -> Request a -> Cmd msg
sendForm toMsg request =
    toFormTask request
        |> Task.perform toMsg


toFormTask : Request a -> Task Never (FormResult a)
toFormTask request =
    toTask request
        |> Task.map Ok
        |> Task.onError recoverFormError


recoverFormError : Error -> Task Never (FormResult a)
recoverFormError error =
    case error of
        BadStatus response ->
            case Json.decodeString errorsDecoder response.body of
                Ok errors ->
                    Task.succeed (Err errors)

                Err _ ->
                    Task.succeed (Err serverError)

        _ ->
            Task.succeed (Err serverError)


errorsDecoder : Json.Decoder FormErrors
errorsDecoder =
    Json.dict (Json.list Json.string)


serverError : FormErrors
serverError =
    Dict.singleton "global" [ "Unexpected server response." ]


queryString : List ( String, String ) -> String
queryString params =
    if List.isEmpty params then
        ""
    else
        "?" ++ (List.map (\( k, v ) -> k ++ "=" ++ v) params |> String.join "&")
