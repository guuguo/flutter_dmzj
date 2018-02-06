import 'package:flutter/rendering.dart';
import 'package:flutter_demo/type/comicDetail.dart';
import 'package:meta/meta.dart';

class ChaptersGridLayout extends SliverGridLayout {
  ChaptersGridLayout({
    @required this.rowStride,
    @required this.columnStride,
    @required this.tileHeight,
    @required this.tileWidth,
    @required this.chapterNums,
    this.allColumns = 4,
  });

  final double rowStride;
  final double columnStride;
  final double tileHeight;
  final double tileWidth;
  final List<int> chapterNums;
  int allColumns;

  int getMinChildIndexAtRow(int rowIndex) {
    var row = 0;
    var index = 0;
    for (int h = 0; h < chapterNums.length; h++) {
      if (rowIndex == row) {
        return index;
      }
      index++;
      row++;
      var rows =( chapterNums[h]-1) ~/ allColumns + 1;
      if (rowIndex < row + rows) {
        return (rowIndex - row) * allColumns + index;
      }
      row += rows;
      index += chapterNums[h];
    }
    return index;
  }

  int getMaxChildIndexAtRow(int rowIndex) {
    var row = 0;
    var index = 0;
    for (int h = 0; h < chapterNums.length; h++) {
      if (rowIndex == row) {
        return index;
      }
      index++;
      row++;
      var rows = (chapterNums[h]-1) ~/ allColumns + 1;
      if (rowIndex < row + rows - 1) {
        return (rowIndex - row) * allColumns + index + 3;
      } else if (rowIndex == row + rows - 1) {
        return index + chapterNums[h] - 1;
      }
      row += rows;
      index += chapterNums[h];
    }
    return index;
  }

  int rowAtIndex(int index) {
    var row = 0;
    var cIndex = 0;
    for (int h = 0; h < chapterNums.length; h++) {
      if (index == cIndex) {
        return row;
      }
      cIndex++;
      row++;
      var rows = (chapterNums[h] - 1) ~/ allColumns + 1;
      if (cIndex + chapterNums[h] - 1 < index) {
        row += rows;
        cIndex += chapterNums[h];
      } else {
        return (index - cIndex) ~/ allColumns + row;
      }
    }
    return row;
  }

  int columnAtIndex(int index) {
    var cIndex = 0;
    var result = 0;
    for (int h = 0; h < chapterNums.length; h++) {
      if (index == cIndex) {
        result = 0;
        break;
      }
      cIndex++;
      if (cIndex + chapterNums[h] - 1 < index) {
        cIndex += chapterNums[h];
      } else {
        result = (index - cIndex) % allColumns;
        break;
      }
    }
    return result;
  }

  int columnSpanAtIndex(int index) {
    var cIndex = 0;
    for (int h = 0; h < chapterNums.length; h++) {
      if (index == cIndex) {
        return allColumns;
      }
      cIndex++;
      if (cIndex + chapterNums[h] - 1 < index) {
        cIndex += chapterNums[h];
      } else {
        return 1;
      }
    }
    return 0;
  }


  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return getMinChildIndexAtRow(scrollOffset ~/ rowStride);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    return getMaxChildIndexAtRow(scrollOffset ~/ rowStride+1);
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int row = rowAtIndex(index);
    final int column = columnAtIndex(index);
    final int columnSpan = columnSpanAtIndex(index);
    return new SliverGridGeometry(
      scrollOffset: row * rowStride,
      crossAxisOffset: column * columnStride,
      mainAxisExtent: tileHeight,
      crossAxisExtent: tileWidth + (columnSpan - 1) * columnStride,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == null)
      return null;
    if (childCount == 0)
      return 0.0;
    final int rowCount = rowAtIndex(childCount - 1) + 1;
    final double rowSpacing = rowStride - tileHeight;
    var height = rowStride * rowCount - rowSpacing;
    return height;
  }
}

class ChapterGridDelegate extends SliverGridDelegate {
  static const double _kSpacing = 8.0;

  ChapterGridDelegate(
      {this.concise = false, @required this.chapters, this.allColumns = 4,
      }) :super();
  final bool concise;
  final List<ChapterSectionBean> chapters;
  int allColumns;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent + _kSpacing) /
        allColumns - _kSpacing;
    final double tileHeight = 40.0;
    var mapIndex = 0;
    return new ChaptersGridLayout(
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        rowStride: tileHeight + _kSpacing,
        columnStride: tileWidth + _kSpacing,
        allColumns: allColumns,
        chapterNums: concise ? chapters.map((c) {
          var length = c.data.length;
          if (mapIndex == 0) {
            mapIndex++;
            return allColumns * 2 >= length ? length : allColumns * 2;
          }
          else {
            return allColumns >= length ? length : allColumns;
          }
        }).toList() : chapters.map((c) {
          return c.data.length;
        }).toList()
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) => false;
}
