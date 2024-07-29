import 'package:book_tracker/core/utils/padding_extension.dart';
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
        title: const Text('Search Books',
            style: TextStyle(fontWeight: FontWeight.w300)),
        scrolledUnderElevation: 0.0,
      ),
      body: Center(
        child: ChangeNotifierProvider<VolumeListModel>(
          create: (context) =>
              VolumeListModel(context.read<DisplayVolumesUseCase>()),
          child: Consumer<VolumeListModel>(
            builder: (context, volumeListModel, child) {
              return Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search for books',
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) => query = value,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (query.isNotEmpty) {
                              volumeListModel.loadVolumes(query);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please enter a search query');
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 40,
                            color: Colors.white,
                          ),
                        ).addPadding(const EdgeInsets.only(left: 10)),
                      ],
                    ).addPadding(
                      const EdgeInsets.only(
                          top: 20, bottom: 20, left: 10, right: 10),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: volumeListModel.volumes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(right: 5, left: 5),
                            visualDensity: const VisualDensity(vertical: 2),
                            title: Text(
                              volumeListModel.volumes[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            subtitle: Text(
                              volumeListModel.volumes[index].authors,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add, size: 35),
                              color: Colors.white,
                              onPressed: () {
                                var routeArgs = ModalRoute.of(context)!
                                    .settings
                                    .arguments as Map<String, dynamic>;
                                var newBookModel = routeArgs['bookModel']
                                    as ModifyBookStateModel;
                                newBookModel.fromGoogleBooksVolume(
                                    volumeListModel.volumes[index]);
                                Navigator.pop(context);
                              },
                            ),
                            leading: Builder(
                              builder: (context) {
                                if (volumeListModel
                                    .volumes[index].thumbnail.isNotEmpty) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      volumeListModel.volumes[index].thumbnail,
                                      fit: BoxFit.cover,
                                    )
                                  );
                                } else {
                                  return const Icon(
                                    Icons.book,
                                    size: 45,
                                  );
                                }
                              },
                            ).addPadding(const EdgeInsets.only(left: 5)),
                          ),
                        ).addPadding(
                            const EdgeInsets.symmetric(horizontal: 10));
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
