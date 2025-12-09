const std = @import("std");

const allocator = std.heap.page_allocator;

const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day08.txt");

fn mat_index(WIDTH: usize, row: usize, col: usize) usize {
    return (WIDTH + 1) * row + col;
}

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

    var dist_mat = try allocator.alloc(f64, ROWS * ROWS);
    defer allocator.free(dist_mat);

    @memset(dist_mat, std.math.floatMax(f64));

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
            dist_mat[mat_index(ROWS, i, j)] = EuclideanDist(&coords[i], &coords[j]);
        }
    }

    for (0..1000) |_| {
        const min_idx = std.mem.indexOfMin(f64, dist_mat);
        const min_pos2: usize = min_idx % (ROWS + 1);
        const min_pos1: usize = ((min_idx - min_pos2) / (ROWS + 1));

        dist_mat[min_idx] = std.math.floatMax(f64);

        if (circuits[min_pos1] == circuits[min_pos2]) continue;

        std.mem.replaceScalar(usize, circuits, circuits[min_pos2], circuits[min_pos1]);
    }

    for (0..ROWS) |idx| {
        junction_boxes[circuits[idx]] += 1;
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
