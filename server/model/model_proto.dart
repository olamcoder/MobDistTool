// Copyright (c) 2016, the Dart project authors.
// All rights reserved. Use of this source code is governed by a
// MIT-style license that can be found in the LICENSE file.

library MDT_model_proto;
import '../../packages/objectory/src/domain_model_generator.dart';

//typedef UUID  = String;
//type UUID = String;
/*
class MDTBaseObject {
  String objectType;
  String uuid;
}
*/
class MDTUser/* extends MDTBaseObject*/ {
  String name;
  String email;
  String password;
 // String externalTokenId;
  String activationToken;
  bool isSystemAdmin;
  bool isActivated;
}

//enum platformType { IOS, ANDROID }
class MDTApplication /*extends MDTBaseObject */{
  String uuid;
  String apiKey;
  String base64IconData;
  String name;
  String platform;
  String description;
  List<MDTUser> adminUsers;
  //List<MDTArtifact> lastVersion;
}

class MDTArtifact/* extends MDTBaseObject*/ {
  String uuid;
  String branch;
  String name;
  String contentType;
  String filename;
  DateTime creationDate;
  int size;
  MDTApplication application;
  String version;
  String sortIdentifier;
  String storageInfos;
  String metaDataTags;
}

main() {
  new ModelGenerator(#MDT_model_proto).generateTo('bin/model/model_generated.dart');
}