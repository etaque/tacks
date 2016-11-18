module Page.Forum.ShowTopic.View exposing (..)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Date
import Date.Format as DateFormat
import Model.Shared exposing (Context, asPlayer)
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)
import View.Utils as Utils
import View.Layout as Layout


view : Context -> Model -> List (Html Msg)
view ctx model =
    case model.currentTopic of
        Nothing ->
            [ header ctx "Loading..." ]

        Just { topic, postsWithUsers } ->
            [ header ctx topic.title
            , Layout.section
                [ class "white" ]
                [ div
                    [ class "forum-topic-posts" ]
                    (List.map renderPost postsWithUsers)
                , case model.newPostContent of
                    Just content ->
                        newPost content model.loading

                    Nothing ->
                        button
                            [ class "btn-floating btn-primary toggle-new-post"
                            , onClick ToggleNewPost
                            ]
                            [ Utils.mIcon "add" [] ]
                ]
            ]


header : Context -> String -> Html Msg
header ctx title =
    Layout.header
        ctx
        []
        [ Utils.linkTo
            (Route.Forum Index)
            [ class "msg-title"
            , Html.Attributes.title "Back to forum index"
            ]
            [ Utils.mIcon "arrow_back" []
            , h1 [] [ text title ]
            ]
        ]


renderPost : PostWithUser -> Html Msg
renderPost { post, user } =
    div
        [ class "forum-post" ]
        [ div
            [ class "post-meta" ]
            [ Utils.playerWithAvatar (asPlayer user)
            , div [ class "time" ] [ text (DateFormat.format "%d %B %Y - %H:%I" (Date.fromTime post.creationTime)) ]
            ]
        , div
            [ class "post-content" ]
            [ Markdown.toHtml [] post.content ]
        ]


newPost : String -> Bool -> Html Msg
newPost content loading =
    div
        [ class "form-sheet" ]
        [ div
            [ class "form-header" ]
            [ div
                [ class "cancel-new-post"
                , onClick ToggleNewPost
                ]
                [ Utils.mIcon "close" [] ]
            , h3 [] [ text "New message" ]
            ]
        , div
            [ class "form-group" ]
            [ input
                [ type_ "hidden"
                , id "new-post-body"
                , value content
                , onInput SetContent
                ]
                []
            , node
                "trix-editor"
                [ attribute "input" "new-post-body" ]
                []
            ]
        , div
            [ class "form-msgs" ]
            [ button
                [ class "btn-flat"
                , disabled (loading || String.isEmpty content)
                , onClick Submit
                ]
                [ text "Submit" ]
            ]
        ]
