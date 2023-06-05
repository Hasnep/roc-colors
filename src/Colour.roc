interface Colour
    exposes [
        Colour,
        rgba,
        rgb,
        rgb255,
        rgba255,
        fromRgba,
        fromRgb,
        fromRgba255,
        fromRgb255,
        fromHex,
        toRgba,
        toRgb,
    ] imports [
        Utils,
    ]

Colour := { red : F64, green : F64, blue : F64, alpha : F64 }

# Basic constructors

## rgba
rgba : Num *, Num *, Num *, Num * -> Colour
rgba = \red, green, blue, alpha ->
    @Colour { red: Num.toF64 red, green: Num.toF64 green, blue: Num.toF64 blue, alpha: Num.toF64 alpha }

## rgb
rgb : Num *, Num *, Num * -> Colour
rgb = \red, green, blue -> rgba red green blue 1.0

## rgba255
rgba255 : U8, U8, U8, U8 -> Colour
rgba255 = \red, green, blue, alpha ->
    rgba (Utils.scaleFrom255 red) (Utils.scaleFrom255 green) (Utils.scaleFrom255 blue) (Utils.scaleFrom255 alpha)

## rgb255
rgb255 : U8, U8, U8 -> Colour
rgb255 = \red, green, blue ->
    rgb (Utils.scaleFrom255 red) (Utils.scaleFrom255 green) (Utils.scaleFrom255 blue)

# Constructors from records

## fromRgba
fromRgba : { red : Num *, green : Num *, blue : Num *, alpha : Num * } -> Colour
fromRgba = \{ red, green, blue, alpha } -> rgba red green blue alpha

## fromRgb
fromRgb : { red : Num *, green : Num *, blue : Num * } -> Colour
fromRgb = \{ red, green, blue } -> rgb red green blue

## fromRgba255
fromRgba255 : { red : U8, green : U8, blue : U8, alpha : U8 } -> Colour
fromRgba255 = \{ red, green, blue, alpha } -> rgba255 red green blue alpha

## fromRgb255
fromRgb255 : { red : U8, green : U8, blue : U8 } -> Colour
fromRgb255 = \{ red, green, blue } -> rgb255 red green blue

# # Constructors from hex

## fromHex
fromHex : Str -> [Ok Colour, Err [InvalidHexColour]]
fromHex = \hex ->
    hexDigits = hex |> Utils.trimLeft "#" |> Str.graphemes |> List.map Utils.parseHexDigit
    when hexDigits is
        # Four digit hex colour
        [Ok r, Ok g, Ok b, Ok a] -> Ok (rgba (17 * r) (17 * g) (17 * b) (17 * a))
        # Eight digit hex colour
        [Ok rSixteens, Ok rUnits, Ok gSixteens, Ok gUnits, Ok bSixteens, Ok bUnits, Ok aSixteens, Ok aUnits] ->
            red = 16 * rSixteens + rUnits
            green = 16 * gSixteens + gUnits
            blue = 16 * bSixteens + bUnits
            alpha = 16 * aSixteens + aUnits
            Ok (rgba red green blue alpha)

        # Three digit hex colour
        [Ok r, Ok g, Ok b] -> Ok (rgb (17 * r) (17 * g) (17 * b))
        # Six digit hex colout
        [Ok rSixteens, Ok rUnits, Ok gSixteens, Ok gUnits, Ok bSixteens, Ok bUnits] ->
            red = 16 * rSixteens + rUnits
            green = 16 * gSixteens + gUnits
            blue = 16 * bSixteens + bUnits
            Ok (rgb red green blue)

        _ -> Err InvalidHexColour

# expect
#     (@Colour { red: outRed
# green: outGreen, blue: outBlue, alpha: outAlpha
#  }) = fromHex "F0FF" |> Utils.unwrap
#     (outRed - 1.0) < 0.001
# Utils.approxEq
# (Utils.approxEq outRed 1) && (Utils.approxEq outGreen 0) && (Utils.approxEq outBlue 1) && (Utils.approxEq outAlpha 1)

# expect
#     (@Colour out) = fromHex "FF00FFFF" |> Utils.unwrap
#     out == { red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0 }

# expect
#     (@Colour out) = fromHex "F0F" |> Utils.unwrap
#     out == { red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0 }

# expect
#     (@Colour out) = fromHex "#FF00FF" |> Utils.unwrap
#     out == { red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0 }

# expect
#     (@Colour out) = fromHex "FF00FF" |> Utils.unwrap
#     out == { red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0 }

# Serialise to a record

## toRgba
toRgba : Colour -> { red : F64, green : F64, blue : F64, alpha : F64 }
toRgba = \@Colour { red, green, blue, alpha } -> { red, green, blue, alpha }

expect
    { red, green, blue, alpha } = toRgba (@Colour { red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 })
    Utils.approxEq red 1.0 && Utils.approxEq green 1.0 && Utils.approxEq blue 1.0 && Utils.approxEq alpha 1.0

## toRgb
toRgb : Colour -> { red : F64, green : F64, blue : F64 }
toRgb = \@Colour { red, green, blue } -> { red, green, blue }

expect
    { red, green, blue } = toRgb (@Colour { red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 })
    Utils.approxEq red 1.0 && Utils.approxEq green 1.0 && Utils.approxEq blue 1.0
