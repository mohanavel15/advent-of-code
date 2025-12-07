const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day05.txt");

pub fn Solution() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, ",\n");

    var in_range: bool = true;

    var ids: [200][2]usize = undefined;
    var ids_len: usize = 0;

    var fresh_ids: usize = 0;

    while (lines.next()) |line| {
        var nums = std.mem.tokenizeAny(u8, line, "-");

        const n1 = try std.fmt.parseInt(usize, nums.next().?, 10);

        if (in_range) {
            if (nums.next()) |num2_str| {
                const n2 = try std.fmt.parseInt(usize, num2_str, 10);
                ids[ids_len][0] = n1;
                ids[ids_len][1] = n2;
                ids_len += 1;
            } else if (in_range) {
                in_range = false;
            }
        }

        if (in_range) continue;
        if (IsValid(IndexOf(ids[0..ids_len], n1))) fresh_ids += 1;
    }

    std.debug.print("Day 5 - Solution 1: {d}\n", .{fresh_ids});

    std.mem.sort([2]usize, ids[0..ids_len], {}, range_sort);

    var sorted_ids: [200][2]usize = undefined;
    var sorted_ids_len: usize = 0;

    for (0..ids_len) |i| {
        const n1 = ids[i][0];
        const n2 = ids[i][1];

        const n1_idx = IndexOf(sorted_ids[0..sorted_ids_len], n1);
        const n2_idx = IndexOf(sorted_ids[0..sorted_ids_len], n2);

        if (IsValid(n1_idx)) {
            if (IsValid(n2_idx)) {
                sorted_ids[n2_idx][0] = @min(sorted_ids[n1_idx][1], sorted_ids[n2_idx][0]);
            }

            sorted_ids[n1_idx][1] = @max(n2, sorted_ids[n1_idx][1]);
            continue;
        }

        if (IsValid(n2_idx)) {
            if (IsValid(n1_idx)) {
                sorted_ids[n1_idx][1] = @max(sorted_ids[n2_idx][0], sorted_ids[n1_idx][1]);
            }

            sorted_ids[n2_idx][0] = @min(n1, sorted_ids[n2_idx][0]);
            continue;
        }

        sorted_ids[sorted_ids_len][0] = n1;
        sorted_ids[sorted_ids_len][1] = n2;
        sorted_ids_len += 1;
    }

    var total_fresh_ids: usize = 0;

    for (0..sorted_ids_len) |i| {
        total_fresh_ids += sorted_ids[i][1] - sorted_ids[i][0] + 1;
    }

    std.debug.print("Day 5 - Solution 2: {d}\n", .{total_fresh_ids});
}

pub fn range_sort(_: void, a: [2]usize, b: [2]usize) bool {
    return a[0] < b[0];
}

fn IndexOf(ids: [][2]usize, id: usize) usize {
    for (0..ids.len) |i| {
        if (id >= ids[i][0] and id <= ids[i][1]) {
            return i;
        }
    }

    return std.math.maxInt(usize);
}

fn IsValid(idx: usize) bool {
    return idx < std.math.maxInt(usize);
}
