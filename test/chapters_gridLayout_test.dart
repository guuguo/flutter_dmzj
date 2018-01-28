import 'package:flutter_demo/chapterGridDelegate.dart';
import 'package:test/test.dart';

void main() {
  test('Test ', () {
    var layout= new ChaptersGridLayout(rowStride: 0.0, chapterNums: <int>[8,4,4], columnStride: null, tileWidth: null,tileHeight: null);
    expect(layout.getMinChildIndexAtRow(0), equals(0));
    expect(layout.getMinChildIndexAtRow(1), equals(1));
    expect(layout.getMinChildIndexAtRow(2), equals(5));
    expect(layout.getMinChildIndexAtRow(3), equals(9));
    expect(layout.getMinChildIndexAtRow(4), equals(10));
    expect(layout.getMinChildIndexAtRow(5), equals(14));
    expect(layout.getMinChildIndexAtRow(6), equals(15));

  });

  test('Test ', () {
    var layout= new ChaptersGridLayout(rowStride: 0.0, chapterNums: <int>[8,4,4], columnStride: null, tileWidth: null,tileHeight: null);
    expect(layout.getMaxChildIndexAtRow(0), equals(0));
    expect(layout.getMaxChildIndexAtRow(1), equals(4));
    expect(layout.getMaxChildIndexAtRow(2), equals(8));
    expect(layout.getMaxChildIndexAtRow(3), equals(9));
    expect(layout.getMaxChildIndexAtRow(4), equals(13));
    expect(layout.getMaxChildIndexAtRow(5), equals(14));
    expect(layout.getMaxChildIndexAtRow(6), equals(18));
  });
  test('Test rowAtIndex', () {
    var layout= new ChaptersGridLayout(rowStride: 0.0, chapterNums: <int>[1, 1, 1, 4, 1, 4, 3], columnStride: null, tileWidth: null,tileHeight: null);
    expect(layout.rowAtIndex(0), equals(0));
    expect(layout.rowAtIndex(1), equals(1));
    expect(layout.rowAtIndex(2), equals(2));
    expect(layout.rowAtIndex(3), equals(3));
    expect(layout.rowAtIndex(4), equals(4));
    expect(layout.rowAtIndex(5), equals(5));
  });
  test('Test columnAtIndex', () {
    var layout= new ChaptersGridLayout(rowStride: 0.0, chapterNums: <int>[2,5,4], columnStride: null, tileWidth: null,tileHeight: null);
    expect(layout.columnAtIndex(0), equals(0));
    expect(layout.columnAtIndex(1), equals(0));
    expect(layout.columnAtIndex(2), equals(1));
    expect(layout.columnAtIndex(3), equals(0));
    expect(layout.columnAtIndex(4), equals(0));
    expect(layout.columnAtIndex(6), equals(2));
    expect(layout.columnAtIndex(8), equals(0));
  });
  test('Test columnSpanAtIndex', () {
    var layout= new ChaptersGridLayout(rowStride: 0.0, chapterNums: <int>[2,5,4], columnStride: null, tileWidth: null,tileHeight: null);
    expect(layout.columnSpanAtIndex(0), equals(4));
    expect(layout.columnSpanAtIndex(1), equals(1));
    expect(layout.columnSpanAtIndex(2), equals(1));
    expect(layout.columnSpanAtIndex(3), equals(4));
    expect(layout.columnSpanAtIndex(4), equals(1));
  });
}