import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/services/search/controller/search_controller.dart';
import 'package:twichat/services/search/widgets/search_tile.dart';
import 'package:twichat/widgets/loading.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchtextController = TextEditingController();
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchtextController,
            onSubmitted: (value) {
              setState(() {
                isSearching = true;
              });
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.searchBarColor,
                alignLabelWithHint: true,
                hintText: "Search user , #hashtags",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppColors.searchBarColor,
                    ))),
          ),
        ),
      ),
      body: isSearching
          ? ref
              .watch(searchUserControllerProvider(searchtextController.text))
              .when(data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = data[index];
                  return SearchTile(user: user);
                },
              );
            }, error: (e, st) {
              return ErrorWidget(e);
            }, loading: () {
              return const Loader();
            })
          : const SizedBox(
              height: 100,
            ),
    );
  }
}
