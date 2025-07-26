import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:ride_link_carpooling/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class CreateRideStartRideWidget extends StatefulWidget {
  final String rideId;

  const CreateRideStartRideWidget({
    Key? key,
    required this.rideId,
  }) : super(key: key);

  static String routeName = 'createRideStartRide';
  static String routePath = '/createRideStartRide';

  @override
  State<CreateRideStartRideWidget> createState() =>
      _CreateRideStartRideWidgetState();
}

class _CreateRideStartRideWidgetState extends State<CreateRideStartRideWidget> {
  Map<String, dynamic>? tripData;
  List<Map<String, dynamic>> passengersData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrip();
  }

  Future<void> fetchTrip() async {
    final tripDoc =
        FirebaseFirestore.instance.collection('trips').doc(widget.rideId);
    final docSnapshot = await tripDoc.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      final passengers = data['passengers'] as List<dynamic>? ?? [];
      List<Map<String, dynamic>> passengersList = [];

      for (var p in passengers) {
        if (p['status'] == 'accepted') {
          final passengerId = p['passengerId'];
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(passengerId)
              .get();
          final userData = userDoc.exists ? userDoc.data() : null;
          passengersList.add({
            'passenger': p,
            'user': userData,
          });
        }
      }

      setState(() {
        tripData = data;
        passengersData = passengersList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00275C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Start Ride'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (tripData != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00275C).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Origin: ${tripData!['origin']}'),
                    Text('Destination: ${tripData!['destination']}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...passengersData.map((p) {
                final user = p['user'] as Map<String, dynamic>?;
                final name = user?['name'] ?? 'Unknown';
                final phone = user?['phone'] ?? 'Unknown';
                final gender = user?['gender'] ?? 'Male';
                final userId = user?['uid'] ?? '';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 20, color: Color(0xFF00275C)),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 120,
                              child:
                                  Text(name, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              gender == 'Female' ? Icons.female : Icons.male,
                              color: gender == 'Female'
                                  ? Colors.pink
                                  : const Color(0xFF00275C),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chat,
                                  size: 20, color: Color(0xFF00275C)),
                              onPressed: () async {
                                String chatId;
                                final String? _existingChatId = await context
                                    .read<ChatProvider>()
                                    .searchChatByReceiverAndSenderId(
                                        senderId: tripData!['creatorId'],
                                        receiverId: userId);
                                if (_existingChatId == null) {
                                  chatId = await context
                                      .read<ChatProvider>()
                                      .createChat(
                                          senderId: tripData!['creatorId'],
                                          receiverId: userId,
                                          isAdmin: false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MessageDetailsWidget(
                                        senderId: tripData!['creatorId'],
                                        chatId: chatId,
                                        receiverId: userId,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MessageDetailsWidget(
                                        senderId: tripData!['creatorId'],
                                        chatId: _existingChatId,
                                        receiverId: userId,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const Icon(Icons.phone,
                                size: 20, color: Color(0xFF00275C)),
                            const SizedBox(width: 6),
                            Text(phone),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00275C),
                ),
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('trips')
                        .doc(widget.rideId)
                        .update({
                      'status': 'ongoing',
                    });
                  } catch (e) {
                    // Handle any errors during the update
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to update trip status: $e'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  context.pushNamed(
                    SearchRideWaitingDriverWidget.routeName,
                    queryParameters: {
                      'rideId': widget.rideId,
                      'senderId': '',
                      'receiverId': '',
                    },
                  );
                },
                child: const Text('Start Ride'),
              ),
            ] else ...[
              const Text('Trip not found.'),
            ],
          ],
        ),
      ),
    );
  }
}
