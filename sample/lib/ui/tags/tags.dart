import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:sample/logger/logger.dart';

class TagsView extends StatefulWidget {
  const TagsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tags'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: _onFetchTagsClicked,
                child: const Text("Fetch User Tags"),
              ),
              const Divider(height: 0),
              TextButton(
                onPressed: _onAddTagsClicked,
                child: const Text("Add Tags"),
              ),
              const Divider(height: 0),
              TextButton(
                onPressed: _onRemoveTagsClicked,
                child: const Text("Remove Tag"),
              ),
              const Divider(height: 0),
              TextButton(
                onPressed: _onClearTagsClicked,
                child: const Text("Clear Tags"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info dialogue

  Future<void> _tagsInfo(List<String> tags) async {
    try {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Wrap(
              runSpacing: 12,
              children: [
                Row(
                  children: [
                    Text("Fetched Tags", style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                Row(
                  children: [
                    Text(tags.toString()),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      logger.e(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchTagsClicked() async {
    try {
      logger.i('Fetch tags clicked.');
      final tags = await Notificare.device().fetchTags();

      logger.i('Fetched tags successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetched tags successfully.'),
        ),
      );

      _tagsInfo(tags);
    } catch (error) {
      logger.e('Fetch tags failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onAddTagsClicked() async {
    try {
      logger.i('Add tags clicked.');
      await Notificare.device().addTags(['flutter', 'hpinhal', 'remove-me']);

      logger.i('Added tags successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added tags successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Add tags failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveTagsClicked() async {
    try {
      logger.i('Remove tag clicked.');
      await Notificare.device().removeTag('remove-me');

      logger.i('Removed tag successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed tag successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Remove tag failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onClearTagsClicked() async {
    try {
      logger.i('Clear tags clicked.');
      await Notificare.device().clearTags();

      logger.i('Cleared tags successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cleared tags successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Clear tags failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
