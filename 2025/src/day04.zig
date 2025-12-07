const std = @import("std");

const DATA = @embedFile("inputs/day04.txt");
const WIDTH = std.mem.indexOf(u8, DATA, &.{'\n'}).?;
const HEIGHT = DATA.len / WIDTH;

fn mat_index(row: usize, col: usize) usize {
    return (WIDTH + 1) * row + col;
}

pub fn Solution() !void {
    var accessible: usize = 0;

    for (0..HEIGHT) |r| {
        for (0..WIDTH) |c| {
            const curr_idx = mat_index(r, c);
            if (DATA[curr_idx] == '.') continue;

            var sround: usize = 0;

            for ([_]isize{ -1, 0, 1 }) |r1| {
                for ([_]isize{ -1, 0, 1 }) |c1| {
                    if (r1 == -1 and r == 0) continue;
                    if (c1 == -1 and c == 0) continue;
                    if (r1 == 1 and r >= HEIGHT - 1) continue;
                    if (c1 == 1 and c >= WIDTH - 1) continue;

                    const idx = mat_index(@intCast(@as(isize, @intCast(r)) + r1), @intCast(@as(isize, @intCast(c)) + c1));

                    if (curr_idx == idx) continue;

                    if (DATA[idx] == '@') sround += 1;
                }
            }

            if (sround < 4) {
                accessible += 1;
            }
        }
    }

    std.debug.print("Day 4 - Solution 1: {d}\n", .{accessible});

    var copy: [DATA.len]u8 = undefined;
    @memcpy(&copy, DATA);

    accessible = 0;

    while (true) {
        var accessible_it: usize = 0;

        for (0..HEIGHT) |r| {
            for (0..WIDTH) |c| {
                const curr_idx = mat_index(r, c);
                if (copy[curr_idx] == '.') continue;

                var sround: usize = 0;

                for ([_]isize{ -1, 0, 1 }) |r1| {
                    for ([_]isize{ -1, 0, 1 }) |c1| {
                        if (r1 == -1 and r == 0) continue;
                        if (c1 == -1 and c == 0) continue;
                        if (r1 == 1 and r >= HEIGHT - 1) continue;
                        if (c1 == 1 and c >= WIDTH - 1) continue;

                        const idx = mat_index(@intCast(@as(isize, @intCast(r)) + r1), @intCast(@as(isize, @intCast(c)) + c1));

                        if (curr_idx == idx) continue;

                        if (copy[idx] == '@') sround += 1;
                    }
                }

                if (sround < 4) {
                    accessible_it += 1;
                    copy[curr_idx] = '.';
                }
            }
        }

        if (accessible_it == 0) break;

        accessible += accessible_it;
    }

    std.debug.print("Day 4 - Solution 2: {d}\n", .{accessible});
}
