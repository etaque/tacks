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
import Dialog
import Html.Lazy as Lazy


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
    , touchbar : List (Html msg)
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
            Lazy.lazy HexBg.render ctx.layout.size
    in
        div
            [ classList
                [ ( "layout layout-site", True )
                , ( "show-menu", ctx.layout.showMenu )
                ]
            , id layout.id
            , catchNavigationClicks Navigate
            ]
            [ tiledBackground
            , aside
                [ class "menu" ]
                (sideMenu ctx.player layout.maybeNav)
            , div
                [ class "menu-backdrop"
                , onClick (ToggleSidebar False)
                ]
                []
            , appbar
                ctx.player
                []
            , main_
                []
                [ div
                    [ class "content"
                    , style transitStyle
                    ]
                    (List.map (Html.map (pageTagger >> PageMsg)) layout.content)
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
            [ classList
                [ ( "layout layout-game with-context", True )
                , ( "show-menu", ctx.layout.showMenu )
                ]
            , id layout.id
            , catchNavigationClicks Navigate
            ]
            [ aside
                [ class "menu" ]
                (sideMenu ctx.player Nothing)
            , appbar
                ctx.player
                (tag layout.nav)
            , aside
                [ class "context" ]
                (brand (ToggleSidebar True) :: (tag layout.side))
            , main_
                []
                (tag layout.main)
            , if List.isEmpty layout.touchbar then
                text ""
              else
                footer [ class "touchbar" ] (tag layout.touchbar)
            ]


brand : Msg -> Html Msg
brand clickMsg =
    a
        [ class "brand"
        , onClick clickMsg
        ]
        [ Logo.renderMenu
        , span [] [ text "tacks" ]
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


appbar : Player -> List (Html Msg) -> Html Msg
appbar player content =
    nav
        [ class "appbar" ]
    <|
        brand (ToggleSidebar True)
            :: content
            ++ [ appbarPlayer player ]


appbarPlayer : Player -> Html Msg
appbarPlayer player =
    div
        [ classList
            [ ( "appbar-player", True )
            , ( "guest", player.guest )
            ]
        ]
        [ div [ class "player-avatar" ]
            [ Utils.avatarImg 24 player
            , span [ class "handle" ] [ text (Utils.playerHandle player) ]
            ]
        ]


sideMenu : Player -> Maybe Nav -> List (Html Msg)
sideMenu player maybeCurrent =
    [ brand (ToggleSidebar False)
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
    , if player.guest then
        div
            [ class "menu" ]
            [ sideMenuItem Route.Login "account_circle" "Login" (maybeCurrent == Just Login)
            , sideMenuItem Route.Register "add_circle" "Register" (maybeCurrent == Just Register)
            ]
      else
        div
            [ class "menu" ]
            [ div
                [ class "menu-item"
                ]
                [ a
                    [ onClick Logout ]
                    [ Utils.mIcon "flight_takeoff" []
                    , text "Logout"
                    ]
                ]
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
