import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class Test {
  var db = FirebaseFirestore.instance
      .collection("schools")
      .where((object) => {object['name'] == "Example School"});

  main() async {
    print(db);
  }

// Query documents based on the criteria
// const query = collectionRef.where('fieldName', '==', 'desiredValue');

// // Get the documents that match the query
// query.get().then(querySnapshot => {
//   querySnapshot.forEach(doc => {
//     // Update the document without knowing the document ID
//     collectionRef.doc(doc.id).update({
//       // Your update data goes here
//       fieldToUpdate: 'newValue'
//     })
//     .then(() => {
//       console.log("Document successfully updated!");
//     })
//     .catch(error => {
//       console.error("Error updating document: ", error);
//     });
//   });
// })
// .catch(error => {
//   console.error("Error getting documents: ", error);
// });
}
