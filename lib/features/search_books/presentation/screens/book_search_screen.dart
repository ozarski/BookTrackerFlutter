import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_state_model.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:book_tracker/features/search_books/domain/usecases/display_volumes.dart';
import 'package:book_tracker/features/search_books/presentation/state/volume_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BookSearchScreen extends StatelessWidget {
  const BookSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var query = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        scrolledUnderElevation: 0.0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            color: Colors.black,
            height: 4.0,
            thickness: 0.5,
            indent: 10.0,
            endIndent: 10.0,
          ),
        ),
      ),
      body: Center(
        child: ChangeNotifierProvider<VolumeListModel>(
          create: (context) =>
              VolumeListModel(context.read<DisplayVolumesUseCase>()),
          child: Consumer<VolumeListModel>(
            builder: (context, volumeListModel, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search for books',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            ),
                          ),
                          onChanged: (value) => query = value,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (query.isNotEmpty) {
                            volumeListModel.loadVolumes(query);
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Please enter a search query');
                          }
                        },
                        icon: const Icon(Icons.search, size: 40),
                      ).addPadding(const EdgeInsets.only(left: 10)),
                    ],
                  ).addPadding(
                    const EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: volumeListModel.volumes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(volumeListModel.volumes[index].title, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          subtitle: Text(volumeListModel.volumes[index].authors, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              var routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                              var newBookModel = routeArgs['bookModel'] as ModifyBookStateModel;
                              newBookModel.fromGoogleBooksVolume(volumeListModel.volumes[index]);
                              Navigator.pop(context);
                            },
                          ),
                          leading: Builder(
                            builder: (context) {
                              if (volumeListModel.volumes[index].thumbnail.isNotEmpty) {
                                return Image.network(
                                  volumeListModel.volumes[index].thumbnail,
                                  width: 50,
                                  height: 50,
                                );
                              } else {
                                return const Icon(Icons.book, size: 50,);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
