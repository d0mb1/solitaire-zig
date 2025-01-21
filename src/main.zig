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
const printCard = @import("printCard.zig");
const helpFn = @import("helpFn.zig");
const gameSetup = @import("gameSetup.zig");
const moveCard = @import("moveCard.zig");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

// creating a card struct
// I'd like to give the different properties the type of enums
// but I've run in to a problem when I wanted to generate the deck
// but since you can't iterate over enums as far as I know
// I had to do it this way
pub const Card = struct { value: u4, shape: u2, visivility: u1 };

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

// defines the number of cards in a standard card deck
pub const num_of_cards = 52;

// there can only be 13 cards in a stack in the bottom field. The last card
// always has to be the joker so there's 14 rows
pub const num_of_bot_field_rows = 20;

// there are 7 stacks in the bottom filed in solitaire
pub const num_of_bot_field_columns = 7;

// after dealing cards to the bottom field there will be 24 cards left
// that will placed in to one stack. The last card
// always has to be the joker so there's 14 rows
const num_of_top_field_rows = 25;

// there are 6 stacks in the top filed in solitaire
const num_of_top_field_columns = 6;

// creating an array that will represent a card deck
pub var deck: [num_of_cards]Card = undefined;
pub var bottom_field: [num_of_bot_field_rows][num_of_bot_field_columns]Card = undefined;
pub var top_field: [num_of_top_field_rows][num_of_top_field_columns]Card = undefined;

// --- MAIN FUNCTION --- //
pub fn main() !void {

    // setting up the game
    gameSetup.fillDeck();
    try gameSetup.shuffleDeck();
    gameSetup.fillFields();
    gameSetup.uncoverCards();

    while (true) {
        helpFn.topLabels();
        printCard.printTopField();
        helpFn.bottomLabels();
        printCard.printBottomField();

        std.debug.print("FROM: ", .{});
        const from = try helpFn.getNum();

        // switch cases that hadel game logic. All posibilities should be
        // handeled here
        switch (from) {

            // from one of the finishing stacks
            0 => {
                std.debug.print("FROM: ", .{});
                const from_final = try helpFn.getNum();
                switch (from_final) {

                    // which finishing stack
                    1...4 => {
                        std.debug.print("TO: ", .{});
                        const to = try helpFn.getNum();

                        // where to move the card
                        switch (to) {
                            1...7 => moveCard.moveCardTestPrint(),
                            else => std.debug.print("Invalid Stack\n", .{}),
                        }
                    },
                    else => std.debug.print("Invalid Stack\n", .{}),
                }
            },

            // from one of the game board stacks
            1...7 => {
                std.debug.print("WHAT: ", .{});
                const what = try helpFn.getNum();

                // what card is being picked
                switch (what) {
                    1...13 => {
                        const row = moveCard.findExactCardBottom(from - 1, what);

                        // if the card isn't found the loop starts from the
                        // begining
                        if (row == 13) continue;

                        std.debug.print("TO: ", .{});
                        const to = try helpFn.getNum();

                        // where to move the card
                        switch (to) {
                            1...7 => {
                                moveCard.moveCardTestPrint();
                                moveCard.b2bMove(row, from - 1, to - 1);
                            },
                            0 => moveCard.moveCardTestPrint(),
                            else => std.debug.print("Invalid Stack\n", .{}),
                        }
                    },
                    else => std.debug.print("Invalid Card Value\n", .{}),
                }
            },

            // flips cards between stack 8 and 9
            8 => {
                moveCard.flipCard();
                moveCard.moveCardTestPrint();
            },

            // from the "discard" stack
            9 => {
                std.debug.print("TO: ", .{});
                const to = try helpFn.getNum();

                // where to move card
                switch (to) {
                    1...7 => {
                        moveCard.moveCardTestPrint();
                        // column labels aren't the same as array indexes
                        moveCard.t2bMove(from - 8, to - 1);
                    },
                    0 => moveCard.moveCardTestPrint(),
                    else => std.debug.print("Invalid Stack\n", .{}),
                }
            },
            else => std.debug.print("Invalid Stack\n", .{}),
        }
    }
}
