import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/util/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/Member.dart';
import 'my_gradient.dart';

class HeaderPost extends InkWell {
  HeaderPost({Key? key,
    required String? urlString,
    required VoidCallback onPressed,
    required context,
    required Member? member,
    required date,
    double imageSize = 45})
    : super(key: key,
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: imageSize),
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageSize),
                  color: ColorTheme().background(),
                  image: DecorationImage(
                    image: (urlString != null && urlString != "")
                        ? CachedNetworkImageProvider(urlString)
                        : AssetImage(avatar) as ImageProvider
                  )
                ),
              ),
            )
          ),
          const SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${member!.name} ${member.surname}", style: TextStyle(color: ColorTheme().text()),),
              Text("$date", style: TextStyle(color: ColorTheme().textGrey()),)
            ],
          )
        ],
      )
  );
}
