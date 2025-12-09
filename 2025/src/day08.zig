const std = @import("std");

const allocator = std.heap.page_allocator;

const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day08.txt");

pub fn Solution() !void {
    const ROWS = std.mem.count(u8, DATA, &.{'\n'});

    var coords_strs = std.mem.tokenizeAny(u8, DATA, "\n");

    var coords = try allocator.alloc([3]f64, ROWS);
    defer allocator.free(coords);

    var circuits = try allocator.alloc(usize, ROWS);
    defer allocator.free(circuits);

    var junction_boxes = try allocator.alloc(usize, ROWS);
    defer allocator.free(junction_boxes);

    @memset(junction_boxes, 0);

    var dist_mat = try allocator.alloc([]f64, ROWS);
    for (0..ROWS) |i| {
        dist_mat[i] = try allocator.alloc(f64, ROWS - i + 1);
    }

    defer {
        for (0..ROWS) |i| {
            allocator.free(dist_mat[i]);
        }

        allocator.free(dist_mat);
    }

    for (0..ROWS) |i| {
        @memset(dist_mat[i], -1);
    }

    for (0..ROWS) |i| {
        const coords_str = coords_strs.next().?;
        var coord = std.mem.tokenizeAny(u8, coords_str, ",");

        for (0..3) |j| {
            coords[i][j] = @floatFromInt(try std.fmt.parseInt(usize, coord.next().?, 10));
        }

        circuits[i] = i;
    }

    for (0..ROWS) |i| {
        for (i + 1..ROWS) |j| {
            dist_mat[i][ROWS - (j + 1)] = EuclideanDist(&coords[i], &coords[j]);
        }
    }

    for (0..1000) |_| {
        var min_dist: f64 = std.math.floatMax(f64);
        var min_pos1: usize = 0;
        var min_pos2: usize = 0;

        for (0..ROWS) |i| {
            for (i + 1..ROWS) |j| {
                const dist = dist_mat[i][ROWS - (j + 1)];
                if (dist < min_dist) {
                    min_dist = dist;
                    min_pos1 = i;
                    min_pos2 = j;
                }
            }
        }

        dist_mat[min_pos1][ROWS - (min_pos2 + 1)] = std.math.floatMax(f64);

        if (circuits[min_pos1] == circuits[min_pos2]) continue;

        const circuit2 = circuits[min_pos2];

        // std.debug.print("========================================\n", .{});
        for (0..ROWS) |idx| {
            if (circuits[idx] == circuit2) {
                // std.debug.print("{any} <---------------> {any} - {d}\n", .{ &coords[min_pos1], &coords[idx], circuits[min_pos1] });
                circuits[idx] = circuits[min_pos1];
            }
        }
    }

    for (0..ROWS) |idx| {
        // std.debug.print("{d}\n", .{circuits[idx]});
        const j_idx = circuits[idx];
        junction_boxes[j_idx] += 1;
    }

    std.mem.sort(usize, junction_boxes, {}, std.sort.desc(usize));

    var total_wires: usize = 1;
    for (0..3) |idx| {
        std.debug.print("{d}\n", .{junction_boxes[idx]});
        total_wires *= junction_boxes[idx];
    }

    std.debug.print("Day 8 - Solution 1: {d}\n", .{total_wires});
}

fn EuclideanDist(src: []const f64, dst: []const f64) f64 {
    var dist: f64 = 0;
    for (0..3) |i| {
        dist += std.math.pow(f64, src[i] - dst[i], 2);
    }

    return @sqrt(dist);
}
