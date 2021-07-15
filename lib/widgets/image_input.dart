import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum AddPicture { TakePicture, ChoosePicture }

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storeImage;
  var messageOnImageInput = 'Choose an image for the place!';
  var textWidgetForImageInput = Text(
    'Choose an image for the place!',
    textAlign: TextAlign.center,
  );

  Future<void> _addPicture(AddPicture pictureMode) async {
    final _picker = ImagePicker();
    final imageFile = (pictureMode == AddPicture.ChoosePicture)
        ? await _picker.getImage(
            source: ImageSource.gallery,
            maxWidth: 600,
          )
        : await _picker.getImage(
            source: ImageSource.camera,
            maxWidth: 600,
          );
    if (imageFile != null) {
      setState(() {
        _storeImage = File(imageFile.path);
      });
      final appDir = await syspaths
          .getApplicationDocumentsDirectory(); //directory reserved for app data.
      final fileName = path.basename(imageFile.path);
      final savedImage = await File(imageFile.path).copy(
        '${appDir.path}/${fileName}',
      ); //this can take a while. so we are awaiting here.

      // File(imageFile.path).copy(appDir.path);

      widget.onSelectImage(savedImage,true);
    } else {
      setState(() {
        textWidgetForImageInput = Text(
          'No image taken.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        );
      });
      widget.onSelectImage(null,false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            // borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  _addPicture(AddPicture.TakePicture);
                },
                label: Text('Take Picture'),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.photo),
                onPressed: () => _addPicture(AddPicture.ChoosePicture),
                label: Text('Choose Picture'),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue),
              ),
          child: (_storeImage == null)
              ? textWidgetForImageInput
              // ? Text(
              //     messageOnImageInput,
              //     textAlign: TextAlign.center,
              //   )
              : Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1, //forcing image to square shape
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _storeImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        width: 150,
                        child: Text(
                          'Preview',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    )
                  ],
                ),
        )
      ],
    );
  }
}

/*
//Older ui : 
Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                // borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: TextFormField(
                                initialValue: _initValues['imageUrl'],
                                // style: TextStyle(color: Colors.white),
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  // checkURL(value!);

                                  if (value!.isEmpty) {
                                    return 'Please provide an image URL.';
                                  } else {
                                    // return 'Please enter a valid image URL.';
                                    return null;
                                  }
                                  // if (!value.startsWith('http') &
                                  //     !value.startsWith('https')) {
                                  //   return 'Please enter a valid URL.';
                                  // }
                                  // if (!value.endsWith('.png') &&
                                  //     !value.endsWith('.jpg') &&
                                  //     !value.endsWith('.jpeg')) {
                                  //   return 'Please enter a valid image URL.';
                                  // }
                                },
                                onFieldSubmitted: (_) {
                                  final id = 'p${items.length + 1}';
                                  // print('id generated is $id');
                                  _saveForm(id);
                                },
                                // controller: _imageUrlController,
                                focusNode:
                                    _imageUrlFocusNode, //when user unselect this focus then we will show the preview.
                                onChanged: (value) {
                                  setState(() {
                                    imageUrlInputValue = value;
                                    // print('new value is $imageUrlInputValue');
                                  });
                                },
                                onEditingComplete: () {
                                  setState(() {});
                                  FocusScope.of(context)
                                      .unfocus(); //hide on-screen keyboard.
                                },
                                onSaved: (value) {
                                  if (value!.length == 0) {
                                    showSnackBarMessage(context,
                                        'Enter Image URL.', Choice.imageUrl);
                                    return;
                                  }
                                  _editedProduct =
                                      _editedProduct.copyWith(imageUrl: value);
                                  _initValues['imageUrl'] = value;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 2, color: Colors.blue),
                                  ),
                              child: (imageUrlInputValue.length == 0)
                                  ? Text('Enter URL to see the preview!')
                                  : Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio:
                                              1, //forcing image to square shape
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), //applied circular border radius to the image.
                                            child: FadeInImage.assetNetwork(
                                              image: imageUrlInputValue,
                                              placeholder:
                                                  'assets/images/product-placeholder.png',
                                              imageErrorBuilder: (context,
                                                      error, stackTrace) =>
                                                  Column(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/error-placeholder.png'),
                                                  Text(
                                                      'Entered URL is broken!'),
                                                ],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.black54,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black,
                                                  Colors.black.withOpacity(0.1)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                            width: 150,
                                            child: Text(
                                              'Preview',
                                              style: TextStyle(
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
*/

/*
//ORIGINAL SIMPLE CONTAINER : 
Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storeImage != null
              ? Image.file(
                  _storeImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image taken.',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            icon: Icon(Icons.camera),
            onPressed: () {},
            label: Text('Take Picture'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    )
*/