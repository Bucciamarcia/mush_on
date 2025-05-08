import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';
import 'package:mush_on/services/error_handling.dart';

import 'services/models.dart'; // Assuming BasicLogger is here

// Initialize logger globally or ensure it's accessible
// Ensure BasicLogger has info, warning, and error methods.
final BasicLogger logger = BasicLogger();

class DbIdChanger extends StatelessWidget {
  const DbIdChanger({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // --- Get data from provider ONCE using READ ---
        // This safely reads the current state of the provider without listening
        final dogProvider = context.read<DogProvider>();
        // Create a defensive copy of the map to avoid potential issues if the
        // provider's map were to change unexpectedly during the script's run.
        final Map<String, Dog> dogsMapFromProvider =
            Map.from(dogProvider.dogsById);

        if (dogsMapFromProvider.isEmpty) {
          logger.error(
              "DogProvider has no dog data. Cannot proceed with ID conversion.");
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar('Error: DogProvider is empty!'),
          );
          return; // Stop if there are no dogs to map from
        }

        // Show confirmation dialog before running
        showDialog(
          context: context,
          barrierDismissible: false, // User must explicitly choose an action
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text('Confirm Data Modification'),
              content: const Text(
                  'This script will read team history, attempt to replace dog names with IDs based on the current DogProvider data, and log the results.\n\n'
                  'IMPORTANT: Database uploads are COMMENTED OUT for safety. Review logs carefully before enabling uploads.\n\n'
                  'Proceed?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: const Text('Proceed'),
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close the dialog first
                    // --- Pass the snapshot of the dogs map into the processing function ---
                    logger.info("Starting script execution...");
                    _processTeamHistory(dogsMapFromProvider).then((_) {
                      logger.info("Script execution finished.");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Processing complete. Check logs.')),
                        );
                      }
                    }).catchError((e, s) {
                      logger.error('Unhandled error during processing',
                          error: e, stackTrace: s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          ErrorSnackbar(
                              'An critical error occurred: $e. Check logs.'),
                        );
                      }
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text("Process Team History (Log Only)"),
    );
  }

  // --- Main Processing Logic (accepts the dogs map) ---
  Future<void> _processTeamHistory(Map<String, Dog> dogsMap) async {
    logger.info("Starting team history data processing...");
    var db = FirebaseFirestore.instance;
    // Ensure this path is correct
    String path = "accounts/maglelin-experience/data/teams/history";
    var collectionRef = db.collection(path);

    // --- Build the efficient Name -> ID lookup map ONCE ---
    logger.info("Building name-to-ID lookup map from DogProvider data...");
    Map<String, String> nameToIdMap = {};
    int duplicateCount = 0;
    dogsMap.forEach((id, dog) {
      // Basic check for null or empty names, adjust as needed
      if (dog.name.trim().isEmpty) {
        logger.warning(
            "Dog with ID '$id' has an empty name. It cannot be mapped.");
        return; // Skip this dog
      }
      if (nameToIdMap.containsKey(dog.name)) {
        logger.warning(
            "Duplicate dog name found: '${dog.name}'. ID '$id' will overwrite mapping for previously found ID '${nameToIdMap[dog.name]}'.");
        // Consider your strategy for duplicates: keep first, keep last (current), error out, store list?
        duplicateCount++;
      }
      nameToIdMap[dog.name] = id;
    });

    if (duplicateCount > 0) {
      logger.warning(
          "Processed $duplicateCount duplicate dog name(s). The last encountered ID for each name was kept.");
    }
    if (nameToIdMap.isEmpty && dogsMap.isNotEmpty) {
      logger.error(
          "Failed to build a usable name-to-ID map, though dogs exist in provider. Check dog names.");
      // Depending on severity, you might want to return or throw here.
    } else {
      logger.info(
          "Name-to-ID map built successfully with ${nameToIdMap.length} unique names.");
      logger.debug("Complete map:\n\n$nameToIdMap");
    }
    // --- End of lookup map building ---

    WriteBatch batch = db.batch();
    bool batchHasOperations = false; // Track if we add anything to the batch

    try {
      var snapshot = await collectionRef.get();
      var docs = snapshot.docs;

      if (docs.isEmpty) {
        logger.warning("No documents found in the collection: $path");
        return;
      }

      logger.info("Found ${docs.length} documents to process in '$path'.");

      for (var doc in docs) {
        logger.info("Processing document ID: ${doc.id}");
        Map<String, dynamic> originalData = doc.data();
        // Create a modifiable copy
        Map<String, dynamic> dataToModify =
            Map<String, dynamic>.from(originalData);

        // --- Safely access and process the 'teams' list ---
        if (dataToModify['teams'] is! List) {
          logger.warning(
              "Document ${doc.id}: 'teams' field is missing or not a List. Skipping document's team processing.");
          continue;
        }

        List<dynamic> teamsDynamic = dataToModify['teams'];
        List<Map<String, dynamic>> teams = [];
        try {
          // Ensure each item in the list is actually a map before casting
          teams = teamsDynamic.map((team) {
            if (team is Map) {
              return Map<String, dynamic>.from(team);
            } else {
              throw FormatException("Item in 'teams' list is not a Map: $team");
            }
          }).toList();
        } catch (e) {
          logger.error(
              "Document ${doc.id}: Error casting elements within 'teams' list. Skipping document's team processing. Error: $e");
          continue;
        }

        bool docModified = false; // Flag specific to this document

        // --- Iterate through teams ---
        for (int teamIndex = 0; teamIndex < teams.length; teamIndex++) {
          Map<String, dynamic> teamMap =
              teams[teamIndex]; // Work with the item from the new list

          if (teamMap['dogs'] is! Map) {
            logger.warning(
                "Document ${doc.id}, Team index $teamIndex: Missing 'dogs' map or not a Map. Skipping this team.");
            continue;
          }
          Map<String, dynamic> dogsMap =
              Map<String, dynamic>.from(teamMap['dogs'] as Map);

          // --- Iterate through rows (e.g., "row_0", "row_1") ---
          List<String> rowKeys =
              dogsMap.keys.toList(); // Iterate over keys safely
          for (var rowKey in rowKeys) {
            if (dogsMap[rowKey] is! Map) {
              logger.warning(
                  "Document ${doc.id}, Team index $teamIndex, Row '$rowKey': Value is not a Map. Skipping row.");
              continue;
            }
            Map<String, dynamic> rowMap =
                Map<String, dynamic>.from(dogsMap[rowKey] as Map);

            // --- Iterate through positions (e.g., "position_1", "position_2") ---
            List<String> positionKeys =
                rowMap.keys.toList(); // Iterate over keys safely
            for (var positionKey in positionKeys) {
              var dogValue = rowMap[positionKey]; // Get value before check

              if (dogValue is String) {
                String originalDogName = dogValue;
                if (originalDogName.trim().isEmpty) {
                  logger.warning(
                      "Document ${doc.id}, Team $teamIndex, $rowKey.$positionKey: Found empty dog name string. Skipping conversion.");
                  continue;
                }

                // --- Perform the lookup using the pre-built map ---
                String newDogId = _lookupDogId(originalDogName, nameToIdMap);

                // --- Update the value in the map ONLY if found ---
                if (newDogId != "UNKNOWN_ID") {
                  rowMap[positionKey] = newDogId; // Update the copied row map
                  docModified =
                      true; // Mark that a change occurred in this document
                  //  logger.info(
                  //     "Document ${doc.id}: Replaced '$originalDogName' with '$newDogId' at Team $teamIndex -> $rowKey.$positionKey");
                } else {
                  // Log error if ID wasn't found, but continue processing other dogs
                  logger.error(
                      "Document ${doc.id}: Could not find ID for dog name '$originalDogName' at Team $teamIndex -> $rowKey.$positionKey. VALUE NOT CHANGED.");
                  // Consider if you need to handle this case differently (e.g., set to null, stop script)
                }
              } else {
                // Log if the value wasn't a string as expected
                logger.warning(
                    "Document ${doc.id}, Team $teamIndex, $rowKey.$positionKey: Expected String but found ${dogValue?.runtimeType ?? 'null'}. Skipping conversion.");
              }
            } // End position loop
            // Update the dogsMap with the potentially modified rowMap
            dogsMap[rowKey] = rowMap;
          } // End row loop
          // Update the teamMap with the potentially modified dogsMap
          teamMap['dogs'] = dogsMap;
          // Update the main 'teams' list with the modified teamMap
          teams[teamIndex] = teamMap;
        } // End team loop

        // --- Update the main data map only if modifications occurred ---
        if (docModified) {
          dataToModify['teams'] = teams; // Put the modified list back

          logger.info("-----------------------------------------");
          logger.info("MODIFIED Document ID: ${doc.id}");
          logger.debug(
              "Original Data for doc ${doc.id}:"); // Optional: Log original for comparison
          logger.debug(originalData.toString());
          logger.info(
              "Modified Data for doc ${doc.id} (Upload is Commented Out):");
          logger.info(dataToModify.toString());
          logger.info("-----------------------------------------");

          // Option 2: Batch Update (All or nothing)
          batch.update(collectionRef.doc(doc.id),
              {'teams': dataToModify['teams']}); // Update only 'teams'
          batchHasOperations = true; // Mark that the batch should be committed
          logger.info(
              "Added update for document ${doc.id} to batch (Commit is commented out).");
          // --- !!! END OF DANGER ZONE !!! ---
        } else {
          logger.info(
              "Document ${doc.id}: No modifications were needed or possible.");
        }
      } // End of document loop

      // --- !!! COMMIT BATCH (COMMENTED OUT) !!! ---
      if (batchHasOperations) {
        logger.info("Attempting to commit batch update...");
        try {
          await batch.commit();
          logger.info("Batch update complete.");
        } catch (e, s) {
          logger.error("!!! FAILED TO COMMIT BATCH UPDATE !!!",
              error: e, stackTrace: s);
          // Handle batch commit failure (all operations in the batch failed)
        }
      } else {
        logger.info("No documents were modified, skipping batch commit.");
      }
      // --- !!! END OF BATCH COMMIT !!! ---
    } catch (e, s) {
      logger.error(
          "An error occurred during the Firestore operation or main processing loop:",
          error: e,
          stackTrace: s);
      rethrow;
    }
  }

  // --- Helper function for efficient lookup (no BuildContext needed) ---
  String _lookupDogId(String dogName, Map<String, String> nameMap) {
    // Trim the input name just in case there's leading/trailing whitespace
    String cleanedName = dogName.trim();
    if (cleanedName.isEmpty) {
      logger.warning("Attempted to look up an empty dog name.");
      return "UNKNOWN_ID";
    }

    // logger.info("Looking up ID for dog name: '$cleanedName'");
    String? id = nameMap[cleanedName]; // O(1) average lookup time

    if (id == null) {
      logger.warning(
          "Dog name '$cleanedName' not found in the pre-built name-to-ID map.");
      return "UNKNOWN_ID"; // Explicit placeholder for not found
    }
    // logger.info("Found ID '$id' for name '$cleanedName'.");
    return id;
  }
}
