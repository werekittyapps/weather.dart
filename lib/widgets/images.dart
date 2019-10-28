import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

cachedImageLoader(String icon){
  return CachedNetworkImage(
    imageUrl: "https://openweathermap.org/img/wn/$icon@2x.png",
    width: 60.0, height: 60.0, fit: BoxFit.cover,
    placeholder: (context, url) => Container(width: 60.0, height: 60.0, child: CircularProgressIndicator(),),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}