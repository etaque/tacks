module Page.EditTrack.GridUpdate exposing (..)

import Dict
import Constants exposing (sidebarWidth, toolbarHeight, hexRadius)
import Model.Shared exposing (..)
import CoreExtra exposing (..)
import Page.EditTrack.Model exposing (..)
import Hexagons
import Mouse exposing (Position)


updateMouse : MouseMsg -> Dims -> Editor -> Editor
updateMouse msg dims ({ course } as editor) =
    let
        courseDims =
            getCourseDims dims

        newDrag =
            getDrag msg editor.drag

        newEditor =
            case realMode editor of
                CreateTile kind ->
                    updateTile kind msg courseDims editor

                Erase ->
                    deleteTile msg courseDims editor

                Watch ->
                    updateCenter msg courseDims editor
    in
        { newEditor | drag = newDrag }


deleteTile : MouseMsg -> Dims -> Editor -> Editor
deleteTile msg courseDims editor =
    let
        coordsList =
            getMouseEventTiles editor courseDims msg

        newGrid =
            List.foldl Dict.remove editor.course.grid coordsList
    in
        withGrid newGrid editor


updateTile : TileKind -> MouseMsg -> Dims -> Editor -> Editor
updateTile kind msg courseDims editor =
    let
        coordsList =
            getMouseEventTiles editor courseDims msg

        newGrid =
            List.foldl (\c -> Dict.insert c kind) editor.course.grid coordsList
    in
        withGrid newGrid editor


withGrid : Grid -> Editor -> Editor
withGrid grid ({ course } as editor) =
    let
        newCourse =
            { course | grid = grid }
    in
        { editor | course = newCourse }


getMouseEventTiles : Editor -> Dims -> MouseMsg -> List Coords
getMouseEventTiles editor courseDims event =
    let
        tileCoords =
            (clickPoint editor courseDims) >> (Maybe.map (Hexagons.pointToAxial hexRadius))
    in
        case event of
            DragStart p ->
                case tileCoords ( p.x, p.y ) of
                    Just c ->
                        [ c ]

                    Nothing ->
                        []

            DragAt p_ ->
                case editor.drag of
                    Just p ->
                        case ( tileCoords ( p.x, p.y ), tileCoords ( p_.x, p_.y ) ) of
                            ( Just c1, Just c2 ) ->
                                if c1 == c2 then
                                    [ c1 ]
                                else
                                    Hexagons.axialLine c1 c2

                            _ ->
                                []

                    Nothing ->
                        []

            DragEnd _ ->
                []


clickPoint : Editor -> Dims -> ( Int, Int ) -> Maybe Point
clickPoint { center } courseDims ( x, y ) =
    if withinWindow courseDims ( x, y ) then
        let
            ( w, h ) =
                courseDims

            ( cx, cy ) =
                center

            x_ =
                toFloat (x - sidebarWidth) - cx - toFloat w / 2

            y_ =
                toFloat -(y - toolbarHeight) - cy + toFloat h / 2
        in
            Just ( x_, y_ )
    else
        Nothing


getDrag : MouseMsg -> Maybe Position -> Maybe Position
getDrag msg previous =
    case ( msg, previous ) of
        ( DragStart p, _ ) ->
            Just p

        ( DragAt p, Just _ ) ->
            Just p

        _ ->
            Nothing


updateCenter : MouseMsg -> Dims -> Editor -> Editor
updateCenter msg courseDims ({ center } as editor) =
    let
        ( dx, dy ) =
            case msg of
                DragStart p ->
                    ( 0, 0 )

                DragAt p_ ->
                    case editor.drag of
                        Just p ->
                            if withinWindow courseDims ( p_.x, p_.y ) then
                                ( p_.x - p.x, p.y - p_.y )
                            else
                                ( 0, 0 )

                        Nothing ->
                            ( 0, 0 )

                DragEnd _ ->
                    ( 0, 0 )

        newCenter =
            ( Tuple.first center + toFloat dx, Tuple.second center + toFloat dy )
    in
        { editor | center = newCenter }


withinWindow : Dims -> ( Int, Int ) -> Bool
withinWindow ( w, h ) ( x, y ) =
    let
        xWindow =
            ( sidebarWidth, w + sidebarWidth )

        yWindow =
            ( toolbarHeight, y + toolbarHeight )
    in
        within xWindow x && within yWindow y
