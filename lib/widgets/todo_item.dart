import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/color.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.todo.isDone
                  ? Colors.black.withOpacity(0.05)
                  : Colors.black.withOpacity(0.08),
              offset: Offset(0, 4),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              _controller.forward().then((_) => _controller.reverse());
              widget.onToDoChanged(widget.todo);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.todo.isDone
                          ? LinearGradient(
                              colors: [tdBlue, Color(0xFF7C6FEE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: widget.todo.isDone
                          ? null
                          : Border.all(
                              color: tdGrey.withOpacity(0.3),
                              width: 2,
                            ),
                    ),
                    child: widget.todo.isDone
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.todo.todoText!,
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.todo.isDone
                            ? tdGrey.withOpacity(0.5)
                            : tdBlack,
                        fontWeight: FontWeight.w500,
                        decoration: widget.todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: tdGrey.withOpacity(0.5),
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tdRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (widget.todo.id != null) {
                            widget.onDeleteItem(widget.todo.id!);
                          }
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: tdRed,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}