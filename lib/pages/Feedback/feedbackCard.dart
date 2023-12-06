import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackCard extends StatelessWidget {
  final List<Map<String, dynamic>> feedbackList;

  FeedbackCard({required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 158, 158, 158).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Feedbacks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    _showAllFeedbacks(context);
                  },
                  child: const Text(
                    'Mostrar Todos',
                    style: TextStyle(
                      color: Color.fromARGB(255, 59, 59, 59),
                      fontSize: 14,
                      fontFamily: 'inter',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              height: 25,
              thickness: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            if (feedbackList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: feedbackList.map((feedback) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 3, left: 20, right: 20),
                    child: FutureBuilder<String?>(
                      future: getNameUser(feedback['userId']),
                      builder: (context, snapshot) {
                        String? usuarioNome = snapshot.data;

                        return Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(176, 233, 70, 20),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${usuarioNome ?? ''}', // Trate o valor nulo aqui
                                    style: const TextStyle(
                                      color: Color.fromARGB(207, 248, 246, 246),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 243, 160, 51),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${feedback['nota'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(207, 248, 246, 246),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${feedback['conteudo']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  color: Color.fromARGB(207, 248, 246, 246),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showAllFeedbacks(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Todos os Feedbacks'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: getNameUser(feedback['userId']),
                        builder: (context, snapshot) {
                          String? usuarioNome = snapshot.data;

                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(176, 233, 70, 20),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${usuarioNome ?? ''}',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(207, 248, 246, 246),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 243, 160, 51),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${feedback['nota'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(207, 248, 246, 246),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${feedback['conteudo']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    color: Color.fromARGB(207, 248, 246, 246),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar',
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  Future<String?> getNameUser(String idUser) async {
    String nomeUsuario;

    if (idUser.isNotEmpty) {
      final userDocRef =
          FirebaseFirestore.instance.collection('user').doc(idUser);
      DocumentSnapshot userSnapshot = await userDocRef.get();
      Map<String, dynamic> userCont =
          userSnapshot.data() as Map<String, dynamic>;
      nomeUsuario = userCont['nome'];
      return nomeUsuario;
    } else {
      return null;
    }
  }
}
