import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:dxf/dxf.dart';
import 'package:path_provider/path_provider.dart';
import 'custom_widgets/drawing_painter.dart';
import 'custom_widgets/menu_options.dart';
import '../data/rectangle.dart';

class ConvasScreen extends StatefulWidget {
  const ConvasScreen({Key? key}) : super(key: key);

  @override
  _ConvasScreenState createState() => _ConvasScreenState();
}

class _ConvasScreenState extends State<ConvasScreen> {
  List<Rectangle> rectangles = [];
  Offset? startPoint;
  Offset? pivotPoint;
  Rectangle? currentRectangle;
  Rectangle? connectingRectangle;
  String currentMode = 'kitchen_countertop';
  bool? isHorizontalSwipe;
  double fixedDimension = 0;
  bool isPivotSet = false;
  List<Rectangle>? draggingShape;

  @override
  void initState() {
    super.initState();
    fixedDimension = currentMode == 'kitchen_countertop' ? 25.5 : 30.0;
  }
  bool loading = false;
  void exportToDXF(List<Rectangle> rectangles) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/drawing.dxf';
      final dxf = await DXF.create(path);
      for (var rect in rectangles) {
        var line1 = AcDbLine(
          dxf.nextHandle,
          x: rect.rect.left,
          y: rect.rect.top,
          x1: rect.rect.right,
          y1: rect.rect.top,
        );

        var line2 = AcDbLine(
          dxf.nextHandle,
          x: rect.rect.right,
          y: rect.rect.top,
          x1: rect.rect.right,
          y1: rect.rect.bottom,
        );

        var line3 = AcDbLine(
          dxf.nextHandle,
          x: rect.rect.right,
          y: rect.rect.bottom,
          x1: rect.rect.left,
          y1: rect.rect.bottom,
        );

        var line4 = AcDbLine(
          dxf.nextHandle,
          x: rect.rect.left,
          y: rect.rect.bottom,
          x1: rect.rect.left,
          y1: rect.rect.top,
        );

        dxf.addEntities(line1);
        dxf.addEntities(line2);
        dxf.addEntities(line3);
        dxf.addEntities(line4);
      }
      await dxf.save();
      await Share.shareFiles(
        [path],
        text: 'Here is your DXF file',
        subject: 'DXF File',
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0),
        mimeTypes: ['application/octet-stream'],
      );
      setState(() {
        loading= false;
      });
    } catch (e) {
      setState(() {
        loading= false;
      });
      Fluttertoast.showToast(msg: 'Something went wrong while sharing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        //color: Colors.grey[200],
        height: 100,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 20,),
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  draggingShape = [Rectangle(
                    Rect.fromLTWH(details.localPosition.dx,
                        details.localPosition.dy, 80, 30),
                    80,
                    30,
                    isConnecting: false,
                    fixedDimension: 30,
                  ),
                    Rectangle(
                      Rect.fromLTWH(details.localPosition.dx,
                          details.localPosition.dy, 30, 80),
                      30,
                      80,
                      isConnecting: false,
                      fixedDimension: 30,
                    )
                  ];
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  if (draggingShape != null) {
                    draggingShape = [Rectangle(
                      Rect.fromLTWH(details.localPosition.dx,
                          details.localPosition.dy + 500, 80, 30),
                      80,
                      30,
                      isConnecting: false,
                      fixedDimension: 30,
                    ),
                      Rectangle(
                        Rect.fromLTWH(details.localPosition.dx+75,
                            details.localPosition.dy +500, 30, 80),
                        30,
                        80,
                        isConnecting: false,
                        fixedDimension: 30,
                      )
                    ];
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  if (draggingShape != null) {
                    rectangles.addAll(draggingShape!);
                    draggingShape = null;
                  }
                });
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffBBDEFD)
                ),
                child: Center(
                  child: Stack(
                    children: [
                      const SizedBox(height: 60,width: 60,),
                      Container(
                        width: 60,
                        height: 25.5,
                        decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.black),
                          color: Colors.grey[600],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 25.5,
                          height: 60,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30,),
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  draggingShape = [
                    Rectangle(
                      Rect.fromLTWH(details.localPosition.dx,
                          details.localPosition.dy, 30, 80),
                      30,
                      80,
                      isConnecting: false,
                      fixedDimension: 30,
                    ),
                    Rectangle(
                      Rect.fromLTWH(details.localPosition.dx,
                          details.localPosition.dy, 80, 30),
                      80,
                      30,
                      isConnecting: false,
                      fixedDimension: 30,
                    )
                  ];
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  if (draggingShape != null) {
                    draggingShape = [Rectangle(
                      Rect.fromLTWH(details.localPosition.dx,
                          details.localPosition.dy +500, 30, 80),
                      30,
                      80,
                      isConnecting: false,
                      fixedDimension: 30,
                    ),
                      Rectangle(
                        Rect.fromLTWH(details.localPosition.dx,
                            details.localPosition.dy+500, 80, 30),
                        80,
                        30,
                        isConnecting: false,
                        fixedDimension: 30,
                      )
                    ];
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  if (draggingShape != null) {
                    rectangles.addAll(draggingShape!);
                    draggingShape = null;
                  }
                });
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffBBDEFD)
                ),
                child: Center(
                  child: Stack(
                    children: [
                      const SizedBox(height: 60, width: 60,),
                      Container(
                        width: 25.50,
                        height: 60,
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black),
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 25.50,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  print('data is ::');
                  if (rectangles.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    exportToDXF(rectangles);
                  } else {
                    Fluttertoast.showToast(msg: 'First Draw A shape');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20,),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xffBBDEFD)
                  ),
                  child: loading?const Center(child: CircularProgressIndicator()):const Center(
                    child: Icon(Icons.send, size: 20,),
                  ),
                ),
              ),
            ),),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Drawing App'),
        actions: [
          MenuOptions((String result) {
            setState(() {
              // if (result == 'export') {
              //   if (rectangles.isNotEmpty) {
              //   } else {
              //     Fluttertoast.showToast(msg: 'First Draw A shape');
              //   }
              // } else
              //{
                currentMode = result;
                fixedDimension =
                currentMode == 'kitchen_countertop' ? 25.5 : 30.0;
             // }
            });
          }),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                startPoint = details.localPosition;
                double width = fixedDimension;
                currentRectangle = Rectangle(
                  Rect.fromLTWH(startPoint!.dx, startPoint!.dy, width, 0),
                  width,
                  0,
                  isConnecting: false,
                  fixedDimension: fixedDimension,
                );
                rectangles.add(currentRectangle!);
                isHorizontalSwipe = null; // Reset swipe direction
                isPivotSet = false; // Reset pivot point
                connectingRectangle = null;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (startPoint != null && currentRectangle != null) {
                  var currentPoint = details.localPosition;
                  if (isHorizontalSwipe == null) {
                    if ((currentPoint - startPoint!).dx.abs() >
                        (currentPoint - startPoint!).dy.abs()) {
                      isHorizontalSwipe = true;
                    } else {
                      isHorizontalSwipe = false;
                    }
                  }

                  if (!isPivotSet) {
                    if (isHorizontalSwipe!) {
                      double width = currentPoint.dx - startPoint!.dx;
                      currentRectangle!.rect = Rect.fromLTWH(
                        startPoint!.dx,
                        startPoint!.dy,
                        width,
                        fixedDimension,
                      );
                      currentRectangle!.width = width;
                      currentRectangle!.height = fixedDimension;

                      if ((currentPoint.dy - startPoint!.dy).abs() > 10) {
                        isPivotSet = true;
                        pivotPoint =
                            Offset(startPoint!.dx + width, startPoint!.dy);
                      }
                    } else {
                      double height = currentPoint.dy - startPoint!.dy;
                      currentRectangle!.rect = Rect.fromLTWH(
                        startPoint!.dx,
                        startPoint!.dy,
                        fixedDimension,
                        height,
                      );
                      currentRectangle!.width = fixedDimension;
                      currentRectangle!.height = height;

                      if ((currentPoint.dx - startPoint!.dx).abs() > 10) {
                        isPivotSet = true;
                        pivotPoint =
                            Offset(startPoint!.dx, startPoint!.dy + height);
                      }
                    }
                  } else {
                    if (isHorizontalSwipe!) {
                      double height = currentPoint.dy - pivotPoint!.dy;
                      if (connectingRectangle == null) {
                        connectingRectangle = Rectangle(
                          Rect.fromLTWH(
                            pivotPoint!.dx,
                            pivotPoint!.dy,
                            fixedDimension,
                            height,
                          ),
                          fixedDimension,
                          height,
                          isConnecting: true,
                          fixedDimension: fixedDimension,
                        );
                        rectangles.add(connectingRectangle!);
                      } else {
                        connectingRectangle!.rect = Rect.fromLTWH(
                          pivotPoint!.dx,
                          pivotPoint!.dy,
                          fixedDimension,
                          height,
                        );
                        connectingRectangle!.height = height;
                      }
                    } else {
                      double width = currentPoint.dx - pivotPoint!.dx;
                      if (connectingRectangle == null) {
                        connectingRectangle = Rectangle(
                          Rect.fromLTWH(
                            pivotPoint!.dx,
                            pivotPoint!.dy,
                            width,
                            fixedDimension,
                          ),
                          width,
                          fixedDimension,
                          isConnecting: true,
                          fixedDimension: fixedDimension,
                        );
                        rectangles.add(connectingRectangle!);
                      } else {
                        connectingRectangle!.rect = Rect.fromLTWH(
                          pivotPoint!.dx,
                          pivotPoint!.dy,
                          width,
                          fixedDimension,
                        );
                        connectingRectangle!.width = width;
                      }
                    }
                  }
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                startPoint = null;
                currentRectangle = null;
                connectingRectangle = null;
                isHorizontalSwipe = null;
                isPivotSet = false;
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(rectangles),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child:
          // ),
          if (draggingShape != null)
            Positioned(
              left: draggingShape![0].rect.left,
              top: draggingShape![0].rect.top,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    draggingShape![0].rect = Rect.fromLTWH(
                      draggingShape![0].rect.left + details.delta.dx,
                      draggingShape![0].rect.top + details.delta.dy,
                      draggingShape![0].rect.width,
                      draggingShape![0].rect.height,
                    );
                  });
                },
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: draggingShape![0].rect.width,
                          height: draggingShape![0].rect.height,
                          color: draggingShape![0].rect.width > draggingShape![0].rect.height
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5),
                        ),
                        Container(
                          width: draggingShape![1].rect.height,
                          height: draggingShape![1].rect.width+40,
                          color: draggingShape![1].rect.width > draggingShape![1].rect.height
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ...rectangles.map((rect) {
            if (rect.rect.width <= 0 || rect.rect.height <= 0) {
              return const SizedBox(); // or any other placeholder
            }
            return Positioned(
              left: rect.rect.left,
              top: rect.rect.top,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (rect.rect.width > rect.rect.height) {
                      // Horizontal shape
                      if (details.delta.dx > 0) {
                        // Dragging right
                        rect.rect = Rect.fromLTWH(
                          rect.rect.left,
                          rect.rect.top,
                          rect.rect.width + details.delta.dx,
                          rect.rect.height,
                        );
                      } else {
                        // Dragging left
                        rect.rect = Rect.fromLTWH(
                          rect.rect.left + details.delta.dx,
                          rect.rect.top,
                          rect.rect.width - details.delta.dx,
                          rect.rect.height,
                        );
                        // Limit the minimum width
                        if (rect.rect.width < 10) {
                          rect.rect = Rect.fromLTWH(
                            rect.rect.left + rect.rect.width - 10,
                            rect.rect.top,
                            10,
                            rect.rect.height,
                          );
                        }
                      }
                    }
                    else {
                      // Vertical shape
                      if (details.delta.dy > 0) {
                        // Dragging down
                        rect.rect = Rect.fromLTWH(
                          rect.rect.left,
                          rect.rect.top,
                          rect.rect.width,
                          rect.rect.height + details.delta.dy,
                        );
                      } else {
                        // Dragging up
                        rect.rect = Rect.fromLTWH(
                          rect.rect.left,
                          rect.rect.top + details.delta.dy,
                          rect.rect.width,
                          rect.rect.height - details.delta.dy,
                        );
                        // Limit the minimum height
                        if (rect.rect.height < 10) {
                          rect.rect = Rect.fromLTWH(
                            rect.rect.left,
                            rect.rect.top + rect.rect.height - 10,
                            rect.rect.width,
                            10,
                          );
                        }
                      }
                    }
                  });
                },
                child: draggingShape != null?
                Stack(
                  children: [
                    Container(
                      width: rect.rect.width,
                      height: rect.rect.height,
                      decoration: BoxDecoration(
                       // border: Border.all(color: Colors.black),
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      width: rect.rect.height,
                      height: rect.rect.width+50,
                      decoration: BoxDecoration(
                       // border: Border.all(color: Colors.black,),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ):
                Container(
                  width: rect.rect.width,
                  height: rect.rect.height,
                  decoration: BoxDecoration(
                  //  border: Border.all(color: Colors.black),
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          }),
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (details) {
                for (var rect in rectangles) {
                  if (rect.rect.contains(details.localPosition)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController _controller =
                        TextEditingController();
                        return AlertDialog(
                          title: const Text('Change Dimensions'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (rect.rect.width > rect.rect.height)
                              // Horizontal line
                                TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter new height",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              if (rect.rect.width <= rect.rect.height)
                              // Vertical line
                                TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter new width",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Submit'),
                              onPressed: () {
                                setState(() {
                                  if (rect.rect.width > rect.rect.height) {
                                    double newHeight =
                                        double.tryParse(_controller.text) ??
                                            rect.rect.height;
                                    rect.rect = Rect.fromLTWH(
                                      rect.rect.left,
                                      rect.rect.top,
                                      rect.rect.width,
                                      newHeight,
                                    );
                                    rect.height = newHeight;
                                  } else {
                                    double newWidth =
                                        double.tryParse(_controller.text) ??
                                            rect.rect.width;
                                    rect.rect = Rect.fromLTWH(
                                      rect.rect.left,
                                      rect.rect.top,
                                      newWidth,
                                      rect.rect.height,
                                    );
                                    rect.width = newWidth;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  }
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if(rectangles.isNotEmpty){
              rectangles.remove(rectangles.last);
            }
          });
        },
        child: const Icon(Icons.refresh,),
      ),
    );
  }
}
