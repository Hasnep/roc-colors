interface Utils
    exposes [trimLeft, parseHexDigit, scaleFrom255, unwrap, approxEq]
    imports []

scaleFrom255 : U8 -> Frac *
scaleFrom255 = \c -> c |> Num.toFrac |> Num.div 255

scaleTo255 : Frac * -> U8
scaleTo255 = \c -> c |> Num.mul 255 |> Num.round |> Num.toU8

expect
    out = List.range { start: At 0, end: At 255 } |> List.map scaleFrom255 |> List.map scaleTo255
    out == List.range { start: At 0, end: At 255 }

unwrap : [Ok a, Err _] -> a
unwrap = \x ->
    when x is
        Ok v -> v
        Err _ -> crash "Oh no!"

trimLeft = \s, toRemove ->
    if Str.startsWith s toRemove then
        (s |> Str.splitFirst toRemove |> Result.withDefault { before: "", after: s }).after
    else
        s

expect
    out = trimLeft "Hello, Roc." "Hello"
    out == ", Roc."

parseHexDigit = \hexDigitStr ->
    when hexDigitStr is
        "0" -> Ok 0
        "1" -> Ok 1
        "2" -> Ok 2
        "3" -> Ok 3
        "4" -> Ok 4
        "5" -> Ok 5
        "6" -> Ok 6
        "7" -> Ok 7
        "8" -> Ok 8
        "9" -> Ok 9
        "A" | "a" -> Ok 10
        "B" | "b" -> Ok 11
        "C" | "c" -> Ok 12
        "D" | "d" -> Ok 13
        "E" | "e" -> Ok 14
        "F" | "f" -> Ok 15
        _ -> Err InvalidHexDigit

expect
    out = "0123456789ABCDEF" |> Str.graphemes |> List.map parseHexDigit
    out == (List.range { start: At 0, end: At 15 } |> List.map (\i -> Ok i))

approxEq = \a, b -> (Num.abs (a - b)) < 0.00001
