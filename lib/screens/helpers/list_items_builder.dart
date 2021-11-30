import 'package:flutter/material.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.context,
    required this.snapshot,
    required this.itemBuilder,
    required this.scrollController,
  }) : super(key: key);

  final BuildContext context;
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data!;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Container();
  }

  Widget _buildList(List<T> items) {
    // Using ListView.separated instead of regular ListView makes it more efficient (builder is also like this)
    // builder only builds the items that are visible on screen instead of everything
    // We use more indexes than exist because normally no dividers are placed before and after the list
    return ListView.separated(
      controller: scrollController,
      itemCount: items.length + 2,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(height: 5.0);
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
