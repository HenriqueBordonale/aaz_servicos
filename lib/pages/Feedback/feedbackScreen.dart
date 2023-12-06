import 'package:aaz_servicos/models/feedback.dart';
import 'package:aaz_servicos/pages/Chat/conversas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreen extends StatefulWidget {
  final String idChat;
  FeedbackScreen({required this.idChat});
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(221, 249, 74, 16),
                Color.fromARGB(226, 236, 55, 45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Realize uma avaliação do serviço contratado',
              style: TextStyle(
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 25,
                  color: Color.fromARGB(161, 53, 53, 53)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Conte um pouco de sua experiência a respeito do serviço contratado',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'inter',
                            color: const Color.fromARGB(255, 88, 88, 87),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _feedbackController,
                          maxLength: 280,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Digite sua opinião aqui...',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(226, 236, 55, 45),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'De 1 a 5 qual seu nível de satisfação com o serviço contratado?',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'inter',
                            color: const Color.fromARGB(255, 88, 88, 87),
                          ),
                        ),
                        const SizedBox(height: 15),
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 45,
              width: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(221, 249, 74, 16),
                  Color.fromARGB(226, 236, 55, 45),
                ]),
              ),
              child: TextButton(
                child: const Text(
                  'Enviar Feedback',
                  style: TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  _showConfirmationDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content:
              const Text('Tem certeza de que deseja enviar esse feedback?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                FeedbackM().createFeedback(
                    widget.idChat, _rating, _feedbackController.text);
                Navigator.pop(context);
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
