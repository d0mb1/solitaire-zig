// ---SOLITAIRE--- //

// For running this game you'll need to have a nerd font installed
// and set up in your terminal. If you're using windows you'll also need to
// run "chcp 65001" command to enable unicode in your terminal.
// Also for some reason it only works when using the Command Prompt
// and not Windows PowerShell. Why? IDK. Maybe cuz Windows is shit.
// Haven't tried any other Windows shell.

// importing standard library
const std = @import("std");
// importing file with card print functions
const cp = @import("cardPrint.zig");
const hf = @import("helpFn.zig");
const gs = @import("gameSetup.zig");

// creating a card struct
// I'd like to give the different properties the type of enums
// but I've run in to a problem when I wanted to generate the deck
// but since you can't iterate over enums as far as I know
// I had to do it this way
pub const Card = struct { val: u4, shp: u2, vis: u1 };

// creating enums so we can easily check card properties in if statements
pub const Val = enum(u4) {
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
pub const Shp = enum(u2) { hearts, spades, diamonds, clubs };
pub const Vis = enum(u1) { covered, uncovered };

// sets how many cards are shown per row
pub const cards_per_row = 13;
// defines the number of cards in a standard card deck
pub const num_of_cards = 52;
// there can only be 13 cards in a stack in the bottom field. The last card
// always has to be the joker so there's 14 rows
pub const bottom_field_rows = 14;
// there are 7 stacks in the bottom filed in solitaire
pub const bottom_field_columns = 7;
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
    // setting up the game
    gs.fillDeck();
    try gs.shuffle();
    gs.fillFields();
    gs.uncoverCards();

    hf.topLabels();
    cp.printTopField();
    hf.bottomLabels();
    cp.printBottomField();
    std.debug.print("\n", .{});
}
