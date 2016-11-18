module Page.Forum.View exposing (..)

import Html
import Model.Shared exposing (Context)
import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Index.View as Index
import Page.Forum.ShowTopic.View as ShowTopic
import Page.Forum.NewTopic.View as NewTopic
import View.Layout as Layout


view : Context -> Route -> Model -> Layout.Site Msg
view ctx route model =
    let
        subView =
            case route of
                Index ->
                    List.map (Html.map IndexMsg) (Index.view ctx model.index)

                ShowTopic _ ->
                    List.map (Html.map ShowTopicMsg) (ShowTopic.view ctx model.showTopic)

                NewTopic ->
                    List.map (Html.map NewTopicMsg) (NewTopic.view ctx model.newTopic)
    in
        Layout.Site "forum" (Just Layout.Discuss) subView Nothing
