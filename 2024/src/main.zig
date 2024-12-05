const std = @import("std");
const day01 = @import("./day01.zig");
const day02 = @import("./day02.zig");
const day03 = @import("./day03.zig");
const day04 = @import("./day04.zig");

pub fn main() !void {
    try day01.Solution();
    try day02.Solution();
    try day03.Solution();
    try day04.Solution();
}
