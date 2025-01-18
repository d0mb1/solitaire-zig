const std = @import("std");
const main = @import("main.zig");

// prototyping a funciton that will move cards between decks
pub fn moveCard(stackFrom: usize, stackTo: usize) void {
    switch (stackFrom) {
        0 => switch (stackTo) {
            0 => {
                std.debug.print("From top to top\n", .{});
            },
            1 => {
                std.debug.print("From top to bottom\n", .{});
            },
        },
        1 => switch (stackTo) {
            0 => {
                std.debug.print("From bottom to top\n", .{});
            },
            1 => {
                std.debug.print("From bottom to bottom\n", .{});
            },
        },
    }
}
