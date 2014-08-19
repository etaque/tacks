module Drag where

{-| Drag'n'drop support in Elm. Now only works with Mouse, but can be extended
to Touches.

The events in the signals are all in Maybe, so they can be easily sampled by
other signals.

# During the Drag
@docs lastPosition, start

# When Dropped
@docs drop
-}

import Maybe
import Mouse
import Time

justWhen : Signal Bool -> Signal a -> Signal (Maybe a)
justWhen b s = (\ b x -> if b then Just x else Nothing) <~ b ~ s

joinMaybe : Maybe (Maybe a) -> Maybe a
joinMaybe = Maybe.maybe Nothing id

{-| The last position of the mouse during this drag. If it's Nothing, then there
is no drag. The first argument is the delay between now and when the last
position was sampled.

Can be used to make dragging based controls, say for mobile games.

    -- x is X of current mouse position
    let direction = Drag.lastPosition (40 * Time.millisecond)
                    |> (<~) (\ p -> case p of
                                      Just (x', y') -> if x - x' < 0
                                                       then Left
                                                       else Right
                                      _             -> StandStill
-}
lastPosition : Time.Time -> Signal (Maybe (Int, Int))
lastPosition delay = Mouse.position |> justWhen Mouse.isDown
                                    |> Time.delay delay
                                    |> justWhen Mouse.isDown
                                    |> ((<~) joinMaybe)

{-| The start position of this drag. If it's Nothing, then there is no drag.
-}
start : Signal (Maybe (Int, Int))
start = Mouse.position |> sampleOn (dropRepeats Mouse.isDown)
                       |> justWhen Mouse.isDown

{-| The start position of the drag, and the drop position, triggered on drop.
If it's Nothing, then there was no drag.

The start position is included, because when dropped, the start function returns
Nothing, and thus cannot be used to compare with the drop position.
-}
drop : Signal (Maybe ((Int, Int), (Int, Int)))
drop = let start = Mouse.position |> sampleOn (dropRepeats Mouse.isDown)
                                  |> keepWhen Mouse.isDown (0, 0)
           stop  = Mouse.position
       in (,) <~ start ~ stop |> sampleOn (dropRepeats Mouse.isDown)
                              |> justWhen (not <~ Mouse.isDown)