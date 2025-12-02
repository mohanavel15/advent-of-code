const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day02.txt");

pub fn Solution() !void {
    var ranges = std.mem.tokenizeAny(u8, DATA, ",\n");

    var invalidIds: usize = 0;
    var invalidIds2: usize = 0;

    while (ranges.next()) |range| {
        var nums = std.mem.tokenizeAny(u8, range, "-");

        const n1 = try std.fmt.parseInt(usize, nums.next().?, 10);
        const n2 = try std.fmt.parseInt(usize, nums.next().?, 10);

        for (n1..n2 + 1) |id| {
            if (checkInvalidId(id)) {
                invalidIds += id;
            }

            if (checkInvalidId2(id)) {
                // std.debug.print("{d}\n", .{id});
                invalidIds2 += id;
            }
        }
    }

    std.debug.print("Day 2 - Solution 1: {d}\n", .{invalidIds});
    std.debug.print("Day 2 - Solution 2: {d}\n", .{invalidIds2});
}

fn checkInvalidId(id: usize) bool {
    var id1: usize = id;
    var id2: usize = 0;

    var m: usize = 1;

    while (id1 != 0) {
        if (id1 == id2 and id2 >= m / 10) return true;

        id2 += @mod(id1, 10) * m;
        id1 /= 10;
        m *= 10;
    }

    return false;
}

fn checkInvalidId2(id: usize) bool {
    var buf: [32]u8 = undefined;

    var id_str = std.fmt.bufPrint(&buf, "{d}", .{id}) catch unreachable;

    var n = id_str.len / 2;

    while (n > 0) : (n -= 1) {
        if ((id_str.len % n) != 0) continue;

        const str1 = id_str[0..n];
        var repeat: bool = true;

        for (0..(id_str.len / n)) |r| {
            const str2 = id_str[r * n .. (r + 1) * n];

            if (!std.mem.eql(u8, str1, str2)) repeat = false;
        }

        if (repeat) return true;
    }

    return false;
}
