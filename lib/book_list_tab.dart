import 'package:flutter/material.dart';
import 'book_list_item.dart';

class BookListTab extends StatelessWidget {
  const BookListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        Expanded(child: 
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
                return BookListItem(title: 'Title $index', author: 'Author $index');
            },
          )
        ,)
      ]
    );
  }
}