library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:shamand/parsejson/json_parsing.dart';

part 'serializers.g.dart';

@SerializersFor([
  Article,
])
Serializers serializers = _$serializers;

Serializers serializersStandard =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
