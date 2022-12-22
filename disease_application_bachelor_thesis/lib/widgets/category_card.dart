import 'package:disease_application_bachelor_thesis/routing/categories/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final void Function()? onPress;

  const CategoryCard(
    this.category, {
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final itemHeight = constrains.maxHeight;
        final itemWidth = constrains.maxWidth;
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: _Shadows(color: category.color, width: itemWidth * 0.82),
            ),
            Material(
              color: category.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                onTap: onPress,
                child: Stack(
                  children: [
                    _buildDecoration(height: itemHeight),
                    _CardContent(category.name),
                    _buildDecorationBottom(height: itemHeight),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDecoration({required double height}) {
    return Positioned(
      top: -50 * 0.4,
      left: -50 * 0.2,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white.withOpacity(0.14),
      ),
    );
  }

  
  Widget _buildDecorationBottom({required double height}) {
    return Positioned(
      bottom: -50 * 0.7,
      right: -50 * 0.2,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white.withOpacity(0.14),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Shadows extends StatelessWidget {
  const _Shadows({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.5,
      height: 15,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            offset: Offset(0, 3),
            blurRadius: 23,
          ),
        ],
      ),
    );
  }
}
