const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day07.txt");

fn mat_index(width: usize, row: usize, col: usize) usize {
    return width * row + col;
}

pub fn Solution() !void {
    const width = comptime std.mem.indexOf(u8, DATA, &.{'\n'}).? + 1;
    const height = comptime DATA.len / width + 1;

    const start = std.mem.indexOf(u8, DATA, &.{'S'}).?;

    var prev_beam_loc: [width]u1 = undefined;
    @memset(&prev_beam_loc, 0);
    prev_beam_loc[start] = 1;

    var total_split: usize = 0;

    for (1..height) |r| {
        var new_beam_loc: [width]u1 = undefined;
        @memset(&new_beam_loc, 0);

        for (0..width - 1) |c| {
            if (prev_beam_loc[c] == 1) {
                if (DATA[mat_index(width, r, c)] == '.') {
                    new_beam_loc[c] = 1;
                    continue;
                }

                total_split += 1;
                new_beam_loc[c - 1] = 1;
                new_beam_loc[c + 1] = 1;
            }
        }

        @memcpy(&prev_beam_loc, &new_beam_loc);
    }

    std.debug.print("Day 7 - Solution 1: {d}\n", .{total_split});
}
