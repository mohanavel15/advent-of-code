const std = @import("std");
const day01 = @import("./day01.zig");
const day02 = @import("./day02.zig");

pub fn main() !void {
    try day01.Solution();
    try day02.Solution();
}
