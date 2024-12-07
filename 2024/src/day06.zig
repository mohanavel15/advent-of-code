const std = @import("std");
const parseInt = std.fmt.parseInt;

pub fn Solution() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        switch (gpa.deinit()) {
            .leak => std.log.err("Memory Leak!", .{}),
            .ok => {},
        }
    }

    var allocator = gpa.allocator();

    const content = try std.fs.cwd().readFileAlloc(allocator, "inputs/day06.txt", std.math.maxInt(u16));
    defer allocator.free(content);

    var map = std.ArrayList(u8).init(allocator);
    defer map.deinit();

    var rows: usize = 0;

    var initialpoint = [2]usize{ 0, 0 };

    var rowlines = std.mem.tokenizeAny(u8, content, "\n");
    while (rowlines.next()) |row| {
        try map.appendSlice(row);
        for (0..row.len) |idx| {
            if (row[idx] == '^') {
                initialpoint[0] = rows;
                initialpoint[1] = idx;
            }
        }

        rows += 1;
    }

    var pos = initialpoint;

    var outOfMap = false;
    var mapCopy1 = try map.clone();
    defer mapCopy1.deinit();
    while (!outOfMap) {
        if (pos[0] >= rows - 1 or pos[1] >= rows - 1 or pos[0] <= 0 or pos[1] <= 0) {
            outOfMap = true;
            break;
        }

        const idx = coords(rows, pos[0], pos[1]);

        switch (mapCopy1.items[idx]) {
            '^' => moveUp(mapCopy1.items, rows, &pos),
            '>' => moveRight(mapCopy1.items, rows, &pos),
            'v' => moveDown(mapCopy1.items, rows, &pos),
            '<' => moveLeft(mapCopy1.items, rows, &pos),
            else => unreachable,
        }
    }

    std.log.info("Solution 1: Total Unique Moves: {}", .{std.mem.count(u8, mapCopy1.items, "X") + 1}); // Plus one for current location & X for previous location.

    // var totalLoopable: usize = 0;
    // for (0..map.items.len) |idx| {
    //     std.debug.print("idx: {}\n", .{idx});
    //     var mapCopy2 = try map.clone();
    //     defer mapCopy2.deinit();

    //     if (mapCopy2.items[idx] == '#') {
    //         continue;
    //     }

    //     mapCopy2.items[idx] = '#';

    //     var outOfMap2 = false;
    //     while (!outOfMap2) {
    //         std.debug.print("In loop print 1!\n", .{});

    //         if (pos[0] >= rows - 1 or pos[1] >= rows - 1 or pos[0] <= 0 or pos[1] <= 0) {
    //             outOfMap2 = true;
    //             std.debug.print("while break: {} - {any}!\n", .{ idx, pos });
    //             break;
    //         }

    //         std.debug.print("In loop print 2!\n", .{});
    //         printMatrix(mapCopy2.items, rows);

    //         const idx1 = coords(rows, pos[0], pos[1]);

    //         switch (mapCopy2.items[idx1]) {
    //             '^' => {
    //                 const loop = moveUpWithLoopCheck(mapCopy2.items, rows, &pos);
    //                 if (loop) {
    //                     totalLoopable += 1;
    //                     outOfMap2 = true;
    //                 }
    //             },
    //             '>' => {
    //                 const loop = moveRightWithLoopCheck(mapCopy2.items, rows, &pos);
    //                 if (loop) {
    //                     totalLoopable += 1;
    //                     outOfMap2 = true;
    //                 }
    //             },
    //             'v' => {
    //                 const loop = moveDownWithLoopCheck(mapCopy2.items, rows, &pos);
    //                 if (loop) {
    //                     totalLoopable += 1;
    //                     outOfMap2 = true;
    //                 }
    //             },
    //             '<' => {
    //                 const loop = moveLeftWithLoopCheck(mapCopy2.items, rows, &pos);
    //                 if (loop) {
    //                     totalLoopable += 1;
    //                     outOfMap2 = true;
    //                 }
    //             },
    //             else => unreachable,
    //         }
    //     }
    // }

    // std.log.info("Solution 2: Total Loopable Positions: {}", .{totalLoopable});
}

fn coords(cols: usize, row: usize, col: usize) usize {
    return (row * cols) + col;
}

fn moveUp(map: []u8, rowlen: usize, pos: []usize) void {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0] - 1, pos[1]);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (pos[0] < 0) {
            break;
        }

        map[currPos] = 'X';
        pos[0] -= 1;
        currPos = nextPos;
        map[currPos] = '^';
        nextPos = coords(rowlen, pos[0] - 1, pos[1]);
    }

    map[currPos] = '>';
}

fn moveDown(map: []u8, rowlen: usize, pos: []usize) void {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0] + 1, pos[1]);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (pos[0] >= rowlen) {
            break;
        }

        map[currPos] = 'X';
        pos[0] += 1;
        currPos = nextPos;
        map[currPos] = 'v';
        nextPos = coords(rowlen, pos[0] + 1, pos[1]);
    }

    map[currPos] = '<';
}

fn moveRight(map: []u8, rowlen: usize, pos: []usize) void {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0], pos[1] + 1);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (pos[1] >= rowlen) {
            break;
        }

        map[currPos] = 'X';
        pos[1] += 1;
        currPos = nextPos;
        map[currPos] = '>';
        nextPos = coords(rowlen, pos[0], pos[1] + 1);
    }

    map[currPos] = 'v';
}

fn moveLeft(map: []u8, rowlen: usize, pos: []usize) void {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0], pos[1] - 1);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (pos[1] <= 0) {
            break;
        }

        map[currPos] = 'X';
        pos[1] -= 1;
        currPos = nextPos;
        map[currPos] = '<';
        nextPos = coords(rowlen, pos[0], pos[1] - 1);
    }

    map[currPos] = '^';
}

fn moveUpWithLoopCheck(map: []u8, rowlen: usize, pos: []usize) bool {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0] - 1, pos[1]);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (map[nextPos] == '^') {
            std.debug.print("loop detected!\n", .{});
            return true;
        }

        if (pos[0] < 0) {
            break;
        }

        pos[0] -= 1;
        currPos = nextPos;
        map[currPos] = '^';
        nextPos = coords(rowlen, pos[0] - 1, pos[1]);
    }

    map[currPos] = '>';
    return false;
}

fn moveDownWithLoopCheck(map: []u8, rowlen: usize, pos: []usize) bool {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0] + 1, pos[1]);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (map[nextPos] == 'v') {
            std.debug.print("loop detected!\n", .{});
            return true;
        }
        if (pos[0] >= rowlen) {
            break;
        }

        pos[0] += 1;
        currPos = nextPos;
        map[currPos] = 'v';
        nextPos = coords(rowlen, pos[0] + 1, pos[1]);
    }

    map[currPos] = '<';
    return false;
}

fn moveRightWithLoopCheck(map: []u8, rowlen: usize, pos: []usize) bool {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0], pos[1] + 1);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (map[nextPos] == '>') {
            std.debug.print("loop detected!\n", .{});
            return true;
        }
        if (pos[1] >= rowlen) {
            break;
        }

        pos[1] += 1;
        currPos = nextPos;
        map[currPos] = '>';
        nextPos = coords(rowlen, pos[0], pos[1] + 1);
    }

    map[currPos] = 'v';
    return false;
}

fn moveLeftWithLoopCheck(map: []u8, rowlen: usize, pos: []usize) bool {
    var currPos: usize = coords(rowlen, pos[0], pos[1]);
    var nextPos: usize = coords(rowlen, pos[0], pos[1] - 1);
    while (nextPos < map.len and map[nextPos] != '#') {
        if (map[nextPos] == '<') {
            std.debug.print("loop detected!\n", .{});
            return true;
        }
        if (pos[1] <= 0) {
            break;
        }

        pos[1] -= 1;
        currPos = nextPos;
        map[currPos] = '<';
        nextPos = coords(rowlen, pos[0], pos[1] - 1);
    }

    map[currPos] = '^';
    return false;
}

fn printMatrix(mat: []u8, len: usize) void {
    for (0..mat.len) |idx| {
        std.debug.print("{s}", .{mat[idx .. idx + 1]});
        if ((idx + 1) % len == 0) {
            std.debug.print("\n", .{});
        }
    }
    std.debug.print("\n", .{});
}
