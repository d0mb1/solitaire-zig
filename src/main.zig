// ---SOLITAIRE--- //

// For running this program you'll need to have a nerd font installed
// and set up for your terminal. If you're using windows you'll also need to
// run "chcp 65001" command to enable unicode in your terminal.
// Also for some reason it only works when using the Command Prompt
// and not Windows PowerShell. Haven't tried any other Windows shell.

// importing standard library
const std = @import("std");
// importing file with card print functions
const cp = @import("cardPrint.zig");
const hf = @import("helpFn.zig");

// creating a card struct
// I'd like to give the different properties the type of enums
// but I've run in to a problem when I wanted to generate the deck
// but since you can't iterate over enums as far as I know
// I had to do it this way
pub const Card = struct { val: u4, shp: u2, vis: u1 };

// creating enums so we can easily check card properties in if statements
pub const Value = enum(u4) {
    joker,
    ace,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    jack,
    queen,
    king,
};
// reds are even and blacks are odd for easier checking when placing on a stack
pub const Shape = enum(u2) { hearts, spades, diamonds, clubs };
pub const Visibility = enum(u1) { covered, uncovered };

// sets how many cards are shown per row
pub const cards_per_row = 13;
// defines the number of cards in a standard card deck
const num_of_cards = 52;
// there can only be 13 cards in a stack in the bottom field. The last card
// always has to be the joker so there's 14 rows
const bottom_field_rows = 14;
// there are 7 stacks in the bottom filed in solitaire
const bottom_field_columns = 7;
// after dealing cards to the bottom field there will be 24 cards left
// that will placed in to one stack. The last card
// always has to be the joker so there's 14 rows
const top_field_rows = 25;
// there are 6 stacks in the top filed in solitaire
const top_field_columns = 6;

// creating an array that will represent a card deck
pub var deck: [num_of_cards]Card = undefined;
pub var bottom_field: [bottom_field_rows][bottom_field_columns]Card = undefined;
pub var top_field: [top_field_rows][top_field_columns]Card = undefined;

// --- MAIN FUNCTION --- //
pub fn main() !void {
    fillDeck();
    // cp.printDeck();
    try shuffle();
    // std.debug.print("\n", .{});
    // cp.printDeck();
    fillBottomField();
    // std.debug.print("\n", .{});
    printField();
    std.debug.print("\n", .{});
}

// generates all possible cards and places them in a deck
fn fillDeck() void {
    var index: usize = 0;

    for (0..4) |shape| {
        // 0 reserved for an empty card that represents empty space
        // it also moves the index up so it matches card numbering
        for (1..14) |value| {
            deck[index] = Card{
                .val = @intCast(value),
                .shp = @intCast(shape),
                .vis = @intFromEnum(Visibility.uncovered),
            };
            index += 1;
        }
    }
}

// shuffle magic done by the Fisher–Yates algorithm
fn shuffle() !void {
    var index: usize = num_of_cards - 1;
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    while (index > 0) : (index -= 1) {
        const j = prng.random().intRangeAtMost(usize, 0, index);
        const temp = deck[index];
        deck[index] = deck[j];
        deck[j] = temp;
    }
}

// this fills the bottom playing field with cards placed in the deck
fn fillBottomField() void {
    var index: usize = 0;
    var column: usize = 0;
    var row: usize = 0;
    var row_start: usize = 0;
    while (row < 7) : (row += 1) {
        while (column < bottom_field_columns) : (column += 1) {
            bottom_field[row][column] = deck[index];
            index += 1;
        }
        row_start += 1;
        column = row_start;
    }
    fillTopField(index);
}

fn fillTopField(index: usize) void {
    const num_of_rem_cards: usize = num_of_cards - index;
    for (0..num_of_rem_cards) |row| {
        top_field[row][5] = deck[index];
    }
}

// prints the bottom field
fn printField() void {
    var count_down: usize = 0;
    // iterates over rows in a field
    for (0..bottom_field.len) |row| {
        var empty_cards: usize = 0;
        for (0..bottom_field[row].len) |column| {
            if (bottom_field[row][column].val != @intFromEnum(Value.joker)) {
                cp.topCardPrint();
            } else {
                cp.restOfCardPrint(row, column, false);
                empty_cards += 1;
            }
        }
        // checks if the row is empty / there's only empty cards
        if (empty_cards == bottom_field_columns) {
            // if the whole row is empty adds 1 to a count down
            count_down += 1;
            if (count_down == 3) {
                // if count-down gets to 3 it breaks the loop preventing
                // the function from printing unnecessary rows
                break;
            }
        }
        std.debug.print("\n", .{});
        for (0..bottom_field[row].len) |column| {
            if (bottom_field[row][column].val != @intFromEnum(Value.joker)) {
                cp.topCardPrintSymbols(bottom_field[row][column]);
            } else {
                cp.restOfCardPrint(row, column, true);
            }
        }
        std.debug.print("\n", .{});
    }
}

// ╭─────────╮
// │ 󰣑 󰣏 󰣐 󰣎 │
// ╰─────────╯
// ╭─  ───  ─╮
//   ∷∷∷∷∷∷∷
// │ ∷∷∷∷∷∷∷ │
//   ∷∷∷∷∷∷∷
// │ ∷∷∷∷∷∷∷ │
//   ∷∷∷∷∷∷∷
// ╰─  ───  ─╯
// ╭─────────╮
// │         │
// │         │
// │         │
// │         │
// ╰─────────╯
