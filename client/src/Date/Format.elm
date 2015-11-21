module Date.Format (format) where
{-|Format strings for dates.

@docs format
-}

import Date
import Regex
import String exposing (padLeft)
import Maybe exposing (andThen, withDefault)
import List exposing (head, tail)

re : Regex.Regex
re = Regex.regex "(^|[^%])%(Y|m|B|b|d|e|a|A|H|k|I|l|p|P|M|S)"

{-| Use a format string to format a date. See the
[README](https://github.com/mgold/Elm-Format-String/blob/master/README.md) for a
list of accepted formatters.
-}
format : String -> Date.Date -> String
format s d = Regex.replace Regex.All re (formatToken d) s

formatToken : Date.Date -> Regex.Match -> String
formatToken d m = let
    prefix = head m.submatches |> collapse |> Maybe.withDefault " "
    symbol = tail m.submatches `andThen` head |> collapse |> Maybe.withDefault " "
        in prefix ++ case symbol of
            "Y" -> d |> Date.year |> toString
            "m" -> d |> Date.month |> monthToInt |> toString |> padLeft 2 '0'
            "B" -> d |> Date.month |> monthToFullName
            "b" -> d |> Date.month |> toString
            "d" -> d |> Date.day |> padWith '0'
            "e" -> d |> Date.day |> padWith ' '
            "a" -> d |> Date.dayOfWeek |> toString
            "A" -> d |> Date.dayOfWeek |> fullDayOfWeek
            "H" -> d |> Date.hour |> padWith '0'
            "k" -> d |> Date.hour |> padWith ' '
            "I" -> d |> Date.hour |> mod12 |> padWith '0'
            "l" -> d |> Date.hour |> mod12 |> padWith ' '
            "p" -> if Date.hour d < 13 then "AM" else "PM"
            "P" -> if Date.hour d < 13 then "am" else "pm"
            "M" -> d |> Date.minute |> padWith '0'
            "S" -> d |> Date.second |> padWith '0'
            _ -> ""

collapse m = andThen m identity

monthToInt m = case m of
    Date.Jan -> 1
    Date.Feb -> 2
    Date.Mar -> 3
    Date.Apr -> 4
    Date.May -> 5
    Date.Jun -> 6
    Date.Jul -> 7
    Date.Aug -> 8
    Date.Sep -> 9
    Date.Oct -> 10
    Date.Nov -> 11
    Date.Dec -> 12

monthToFullName m = case m of
    Date.Jan -> "January"
    Date.Feb -> "February"
    Date.Mar -> "March"
    Date.Apr -> "April"
    Date.May -> "May"
    Date.Jun -> "June"
    Date.Jul -> "July"
    Date.Aug -> "August"
    Date.Sep -> "September"
    Date.Oct -> "October"
    Date.Nov -> "November"
    Date.Dec -> "December"

fullDayOfWeek dow = case dow of
    Date.Mon -> "Monday"
    Date.Tue -> "Tuesday"
    Date.Wed -> "Wednesday"
    Date.Thu -> "Thursday"
    Date.Fri -> "Friday"
    Date.Sat -> "Saturday"
    Date.Sun -> "Sunday"

mod12 h = h % 12

padWith : Char -> a -> String
padWith c = padLeft 2 c << toString
