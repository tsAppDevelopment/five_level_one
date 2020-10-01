import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class DatabaseService{
  // collection reference
  final CollectionReference glossaryCollection = FirebaseFirestore.instance.collection('glossary');
  final CollectionReference aircraftCollection = FirebaseFirestore.instance.collection('mds');


  // brew list from snapshot
  List<Glossary> _glossarylistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Glossary(doc.get('title'), doc.get('body'));
    }).toList();
  }

  // List<Aircraft> _aircraftlistFromSnapshot(QuerySnapshot snapshot){
  //   return snapshot.docs.map((doc){
  //     return Aircraft(
  //       doc.get('name'),doc.get('weight0'),doc.get('weight1'),
  //       doc.get('moment0'),doc.get('moment1'),doc.get('fs0'),
  //       doc.get('fs1'),doc.data()); 
  //   }).toList(); do
  // }


  // get brews stream
  Stream<List<Glossary>> get glossary {
    return glossaryCollection.snapshots()
        .map(_glossarylistFromSnapshot);
  }

  //   Stream<List<Aircraft>> get aircraft {
  //   return aircraftCollection.snapshots()
  //       .map(_aircraftlistFromSnapshot);
  // }



//  Future<void> updateUserData(String sugars, String name, int strength) async {
//    return await brewCollection.document(uid).setData({
//      'sugars': sugars,
//      'name': name,
//      'strength': strength,
//    });
//  }


}