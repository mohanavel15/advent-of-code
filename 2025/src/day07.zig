const std = @import("std");

const DATA = @embedFile("inputs/day07.txt");
const WIDTH = std.mem.indexOf(u8, DATA, &.{'\n'}).?;
const HEIGHT = DATA.len / (WIDTH + 1);

fn mat_index(row: usize, col: usize) usize {
    return (WIDTH + 1) * row + col;
}

pub fn Solution() !void {
    var copy: [DATA.len]u8 = undefined;
    @memcpy(&copy, DATA);

    var split_cal: [DATA.len]usize = undefined;
    @memset(&split_cal, 0);

    var total_split: usize = 0;

    for (1..HEIGHT) |r| {
        for (0..WIDTH) |c| {
            const prev_idx = mat_index(r - 1, c);
            const idx = mat_index(r, c);

            if (copy[prev_idx] == '|' or copy[prev_idx] == 'S') {
                if (DATA[idx] == '.') {
                    copy[idx] = '|';
                    if (split_cal[prev_idx] == 0) split_cal[prev_idx] = 1;
                    split_cal[idx] += split_cal[prev_idx];
                    continue;
                }

                total_split += 1;

                const left_idx = mat_index(r, c - 1);
                const right_idx = mat_index(r, c + 1);

                split_cal[left_idx] += split_cal[prev_idx];
                split_cal[right_idx] += split_cal[prev_idx];

                copy[left_idx] = '|';
                copy[right_idx] = '|';
            }
        }

        // std.debug.print("\x1b[2J\x1b[H{s}", .{copy});
        // std.Thread.sleep(std.time.ns_per_s / 24);
    }

    std.debug.print("Day 7 - Solution 1: {d}\n", .{total_split});

    var total_timeline: usize = 0;
    for (0..WIDTH) |idx| {
        total_timeline += split_cal[mat_index(HEIGHT - 1, idx)];
    }

    std.debug.print("Day 7 - Solution 2: {d}\n", .{total_timeline});
}
