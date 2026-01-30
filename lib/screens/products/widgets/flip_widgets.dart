import 'package:flutter/material.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';


typedef OnEdit = void Function();
typedef OnDelete = void Function();
class FlipCard extends StatefulWidget {
  final String? image;

  final OnEdit onEdit;
  final OnDelete onDelete;

  const FlipCard({super.key, required this.image, required this.onEdit, required this.onDelete});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  bool _showFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.1416; // π for 180°
          final isFront = angle < 1.57; // < 90 degrees

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(angle),
            child:
                isFront
                    ? _buildFront()
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.1416),
                      child: _buildBack(),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      width: double.infinity,
      height: 100,

      decoration: BoxDecoration(
        color: HexColor.fromHex("#E8E5E5"),
        border: Border(
          bottom: BorderSide(color: HexColor.fromHex(AppTheme.filledBox2)),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child:widget.image==null?Container(
          child: Center(child: Icon(Icons.image),),
        ): Image.network(
          "${baseUrlImage}${widget.image}",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      width: double.infinity,
      height: 100,

      decoration: BoxDecoration(
        color: HexColor.fromHex("#E8E5E5"),
        border: Border(
          bottom: BorderSide(color: HexColor.fromHex(AppTheme.borderGrey)),
        ),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(3.1416),
              child: widget.image==null?Container(
                child: Center(child: Icon(Icons.image),),
              ):Image.network(
                "${baseUrlImage}${widget.image}",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    widget.onEdit();
                  },
                  child: Container(

                    padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,),

                      child: Icon(Icons.edit,color: HexColor.fromHex(AppTheme.primaryColor),)),
                ),
                InkWell(
                  onTap: (){
                    widget.onDelete();
                  },
                  child: Container(

                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,),
                      child: Icon(Icons.delete,color:Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
