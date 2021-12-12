import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';

class PictureField extends StatefulWidget {
  const PictureField({
    Key key,
    this.onChanged,
  }) : super(key: key);
  final Function onChanged;

  @override
  _PictureFieldState createState() => _PictureFieldState();
}

class _PictureFieldState extends State<PictureField> {
  final ImagePicker _picker = ImagePicker();
  Uint8List _imageBytes;

  _takePicture() async {
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final picture = 'data:image/jpeg;base64,${base64.encode(bytes)}';

      widget.onChanged(picture);

      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Widget emptyPicture() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget picturePreview() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        shape: BoxShape.circle,
        image: _imageBytes != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(_imageBytes),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FormField(builder: (FormFieldState state) {
          print(state);
          return null;

          // return _imageBytes != null ? picturePreview() : emptyPicture();
        }),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: _takePicture,
          child: Text(
            translate('button.take_photo'),
          ),
        )
      ],
    );
  }
}
