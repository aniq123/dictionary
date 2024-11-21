// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:freedictionaryapi/APIS/dictonaryapi.dart';
import 'package:get/get.dart';

class Dictnoryscreen extends StatelessWidget {
  final dictonaryController = Get.put(dictonaryapi()); // Bind the controller
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Trigger API call when search field is submitted
    void triggerSearch() {
      final query = searchController.text.trim();
      if (query.isNotEmpty) {
        dictonaryController
            .featchapi(query); // Pass the search term to API call
      }
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.purple,
                Colors.deepPurpleAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'DICT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              TextSpan(
                text: 'ION',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              TextSpan(
                text: 'ARY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.purple.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.purple.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: searchController,
                  onFieldSubmitted: (value) {
                    triggerSearch(); // Call search when submit is pressed
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.deepPurpleAccent,
                    ),
                    hintText: 'Search here',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (dictonaryController.isloading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (dictonaryController.items.isEmpty) {
                  return Center(
                    child: Text(
                      'No results found. Please search again.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: dictonaryController.items.length,
                  itemBuilder: (context, index) {
                    final word = dictonaryController.items[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Word Title
                            Text(
                              word.word,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 4),
                            // Phonetic
                            if (word.phonetic.isNotEmpty)
                              Text(
                                'Phonetic: ${word.phonetic}',
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                            SizedBox(height: 8),

                            // Meanings
                            Text(
                              'Meanings:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            ...word.meanings.map((meaning) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '- Part of Speech: ${meaning.partOfSpeech}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // Definitions
                                    ...meaning.definitions.map((definition) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Definition: ${definition.definition}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            if (definition.synonyms.isNotEmpty)
                                              Text(
                                                'Synonyms: ${definition.synonyms.join(", ")}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue),
                                              ),
                                            if (definition.antonyms.isNotEmpty)
                                              Text(
                                                'Antonyms: ${definition.antonyms.join(", ")}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              );
                            }).toList(),

                            // Source URLs
                            if (word.sourceUrls.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Source: ${word.sourceUrls.join(", ")}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
