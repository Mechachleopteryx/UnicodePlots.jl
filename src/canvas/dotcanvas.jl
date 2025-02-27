const dot_signs = [0b10 0b01]

const n_dot = 4
const dot_decode = Array{Char}(undef, typemax(UInt16))
dot_decode[0b00 + 1] = ' '
dot_decode[0b01 + 1] = '.'
dot_decode[0b10 + 1] = '\''
dot_decode[0b11 + 1] = ':'
dot_decode[(n_dot+1):typemax(UInt16)] = unicode_table[1:(typemax(UInt16)-n_dot)]

"""
Similar to the `AsciiCanvas`, the `DotCanvas` only uses
ASCII characters to draw it's content. Naturally,
it doesn't look quite as nice as the Unicode-based
ones. However, in some situations it might yield
better results. Printing plots to a file is one
of those situations.

The DotCanvas is best utilized in combination
with `scatterplot`.
For `lineplot` we suggest to use the `AsciiCanvas`
instead.
"""
struct DotCanvas <: LookupCanvas
    grid::Array{UInt16,2}
    colors::Array{ColorType,2}
    pixel_width::Int
    pixel_height::Int
    origin_x::Float64
    origin_y::Float64
    width::Float64
    height::Float64
    xscale::Union{Symbol,Function}
    yscale::Union{Symbol,Function}
end

@inline x_pixel_per_char(::Type{DotCanvas}) = 1
@inline y_pixel_per_char(::Type{DotCanvas}) = 2

@inline lookup_encode(c::DotCanvas) = dot_signs
@inline lookup_decode(c::DotCanvas) = dot_decode

DotCanvas(args...; nargs...) = CreateLookupCanvas(DotCanvas, args...; nargs...)

function char_point!(c::DotCanvas, char_x::Int, char_y::Int, char::Char, color::UserColorType)
    if checkbounds(Bool, c.grid, char_x, char_y)
        c.grid[char_x,char_y] = n_dot + char
        set_color!(c.colors, char_x, char_y, crayon_256_color(color))
    end
    c
end
