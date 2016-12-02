module View.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import Json.Decode as Json
import Markdown
import View.HexBg as HexBg
import View.Logo as Logo
import View.Utils as Utils
import Model exposing (..)
import Model.Shared exposing (Context, Player, isAdmin)
import Route
import Page.Forum.Route as Forum
import Page.Admin.Route as Admin
import TransitStyle
import Constants
import Dialog


type Nav
    = Home
    | Explore
    | Build
    | Discuss
    | Login
    | Register
    | Admin


type alias Site msg =
    { id : String
    , maybeNav : Maybe Nav
    , content : List (Html msg)
    , dialog : Maybe (Dialog.View msg)
    }


site : String -> Maybe Nav -> List (Html msg) -> Site msg
site id maybeNav content =
    { id = id
    , maybeNav = maybeNav
    , content = content
    , dialog = Nothing
    }


type alias Game msg =
    { id : String
    , nav : List (Html msg)
    , side : List (Html msg)
    , main : List (Html msg)
    }


renderSite : Context -> (msg -> PageMsg) -> Site msg -> Html Msg
renderSite ctx pageTagger layout =
    let
        transitStyle =
            case ctx.routeJump of
                Route.ForMain ->
                    (TransitStyle.fade ctx.transition)

                _ ->
                    []

        tiledBackground =
            Html.Lazy.lazy HexBg.render ( Tuple.first ctx.dims - Constants.sidebarWidth, Tuple.second ctx.dims )
    in
        div
            [ class "layout-game layout-site"
            , id layout.id
            , catchNavigationClicks Navigate
            ]
            [ aside
                [ class "dark" ]
                (logo :: (sideMenu ctx.player layout.maybeNav))
            , main_
                []
                [ tiledBackground
                , div
                    [ class "scrollable" ]
                    [ div
                        [ class "content"
                        , style transitStyle
                        ]
                        (List.map (Html.map (pageTagger >> PageMsg)) layout.content)
                    ]
                ]
            , case layout.dialog of
                Just dialog ->
                    Html.map (pageTagger >> PageMsg) dialog.content

                Nothing ->
                    text ""
            ]


renderGame : Context -> (msg -> PageMsg) -> Game msg -> Html Msg
renderGame ctx pageTagger layout =
    let
        tag =
            List.map (Html.map (pageTagger >> PageMsg))
    in
        div
            [ class "layout-game"
            , id layout.id
            , catchNavigationClicks Navigate
            ]
            [ aside
                []
                (logo :: (tag layout.side))
            , subHeader
                ctx.player
                (tag layout.nav)
            , main_
                []
                (tag layout.main)
            ]


logo : Html Msg
logo =
    Utils.linkTo
        Route.Home
        [ class "logo" ]
        [ Logo.render
        , span [] [ text "Tacks" ]
        ]


section : List (Attribute msg) -> List (Html msg) -> Html msg
section attrs content =
    Html.section
        attrs
        [ div [ class "container" ] content
        ]


header : Context -> List (Attribute msg) -> List (Html msg) -> Html msg
header ctx attrs content =
    Html.header
        attrs
        [ div
            [ class "container" ]
            content
        ]


subHeader : Player -> List (Html msg) -> Html msg
subHeader player content =
    nav
        [ class "toolbar" ]
        content


sideMenu : Player -> Maybe Nav -> List (Html Msg)
sideMenu player maybeCurrent =
    [ if player.guest then
        div
            [ class "guest" ]
            [ div
                [ class "player" ]
                [ text "Guest session" ]
            , div
                [ class "menu" ]
                [ sideMenuItem Route.Login "face" "Login" (maybeCurrent == Just Login)
                , sideMenuItem Route.Register "person_add" "Register" (maybeCurrent == Just Register)
                ]
            , hr [] []
            ]
      else
        div
            [ class "player" ]
            [ Utils.avatarImg 32 player
            , span [ class "handle" ] [ text (Utils.playerHandle player) ]
            , a
                [ class "logout"
                , title "Logout"
                , onClick Logout
                ]
                [ Utils.mIcon "exit_to_app" [] ]
            ]
    , div
        [ class "menu" ]
        [ sideMenuItem Route.Home "home" "Home" (maybeCurrent == Just Home)
        , sideMenuItem Route.Explore "explore" "Explore" (maybeCurrent == Just Explore)
        , if player.guest then
            text ""
          else
            sideMenuItem Route.ListDrafts "palette" "Build" (maybeCurrent == Just Build)
        , if player.guest then
            text ""
          else
            sideMenuItem (Route.Forum Forum.Index) "face" "Discuss" (maybeCurrent == Just Discuss)
        , if isAdmin player then
            sideMenuItem (Route.Admin Admin.Dashboard) "dashboard" "Admin" (maybeCurrent == Just Admin)
          else
            text ""
        ]
    , hr [] []
    , div
        [ class "made-by" ]
        [ Markdown.toHtml [] """
An [open source](http://github.com/etaque/tacks) game crafted with love
by [@etaque](http://twitter.com/etaque).

Written in [Elm](http://elm-lang.org).
        """
        ]
    ]


sideMenuItem : Route.Route -> String -> String -> Bool -> Html Msg
sideMenuItem route icon label current =
    div
        [ classList
            [ ( "menu-item", True )
            , ( "current", current )
            ]
        ]
        [ Utils.linkTo
            route
            []
            [ Utils.mIcon icon []
            , text label
            ]
        ]


catchNavigationClicks : (String -> msg) -> Attribute msg
catchNavigationClicks tagger =
    onWithOptions
        "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.map tagger (Json.at [ "target" ] pathDecoder))


pathDecoder : Json.Decoder String
pathDecoder =
    Json.oneOf
        [ Json.at [ "dataset", "navigate" ] Json.string
        , Json.at [ "data-navigate" ] Json.string
        , Json.at [ "parentElement" ] (Json.lazy (\_ -> pathDecoder))
        , Json.fail "no path found for click"
        ]
