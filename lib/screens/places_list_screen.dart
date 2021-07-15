import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:lottie/lottie.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';
import '../adaptive_widgets/custom_circular_progress_indicator.dart';
import '../adaptive_widgets/empty_data.dart';
import './place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: AdaptiveCircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    child: EmptyData(
                      'Not added any places yet.',
                      'Start adding some!',
                    ),
                    builder: (ctx, greatPlaces, ch) {
                      if (greatPlaces.items.length <= 0) {
                        return Container(child: ch);
                      }
                      return ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: Hero(
                            tag: '${greatPlaces.items[i].id}',
                            child: CircleAvatar(
                              backgroundImage: FileImage(
                                greatPlaces.items[i].image,
                              ),
                            ),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(
                              greatPlaces.items[i].location!.address as String),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[i].id,
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

/*
ListView.builder(
                itemCount: greatPlaces.items.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(
                      greatPlaces.items[i].image,
                    ),
                  ),
                  title: Text(greatPlaces.items[i].title),
                  onTap: () {
                    //Go to detail page...
                  },
                ),
              )
*/

/*
(ctx, greatPlaces, ch) => (greatPlaces.items.length <= 0)
            ? (ch)
            : ListView.builder(
                itemCount: greatPlaces.items.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(
                      greatPlaces.items[i].image,
                    ),
                  ),
                  title: Text(greatPlaces.items[i].title),
                  onTap: () {
                    //Go to detail page...
                  },
                ),
              ),
*/