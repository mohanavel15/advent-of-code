const day01 = @import("./day01.zig");
const day02 = @import("./day02.zig");
const day03 = @import("./day03.zig");
const day05 = @import("./day05.zig");
const day06 = @import("./day06.zig");
const day07 = @import("./day07.zig");

pub fn main() !void {
    try day01.Solution();
    try day02.Solution();
    try day03.Solution();
    try day05.Solution();
    try day06.Solution();
    try day07.Solution();
}
