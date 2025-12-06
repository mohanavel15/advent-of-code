const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day05.txt");

pub fn Solution() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, ",\n");

    var in_range: bool = true;

    var ids_range: [200][2]usize = undefined;
    var ids_range_len: usize = 0;

    var fresh_ids: usize = 0;

    while (lines.next()) |line| {
        var nums = std.mem.tokenizeAny(u8, line, "-");

        const n1 = try std.fmt.parseInt(usize, nums.next().?, 10);

        if (in_range) {
            if (nums.next()) |num2_str| {
                const n2 = try std.fmt.parseInt(usize, num2_str, 10);
                ids_range[ids_range_len][0] = n1;
                ids_range[ids_range_len][1] = n2;
                ids_range_len += 1;
            } else if (in_range) {
                in_range = false;
            }
        }

        if (in_range) continue;
        if (checkWithInRange(&ids_range, ids_range_len, n1)) fresh_ids += 1;
    }

    std.debug.print("Day 5 - Solution 1: {d}\n", .{fresh_ids});
}

fn checkWithInRange(ids_range: [][2]usize, ids_range_len: usize, id: usize) bool {
    for (0..ids_range_len) |i| {
        if (id >= ids_range[i][0] and id <= ids_range[i][1]) {
            return true;
        }
    }

    return false;
}
