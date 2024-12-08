import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');
  DateTime? _lastMessageDate;
  final _formKey = GlobalKey<FormState>(); // Добавили GlobalKey для формы

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      if (_controller.text.isNotEmpty) {
        try {
          await _messagesCollection.add({
            'text': _controller.text,
            'createdAt': Timestamp.now(),
            'sender': 'user',
          });
          _clearTextFieldAndDismissKeyboard(); // Вызываем отдельный метод
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сообщение отправлено')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка отправки: $e')),
          );
        }
      }
    }
  }

  void _clearTextFieldAndDismissKeyboard() {
    setState(() {
      _controller.clear();
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чат с продавцом'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isUserMessage = message['sender'] == 'user';
                    final messageColor =
                    isUserMessage ? Colors.green : Colors.grey[300];
                    final alignment =
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft;

                    return Align(
                      alignment: alignment,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: messageColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(message['text']),
                            Text(
                              _timeFormat.format((message['createdAt'] as Timestamp).toDate()),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form( // Обернули TextField формой
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField( // Заменили TextField на TextFormField
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Введите сообщение'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле не может быть пустым';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}