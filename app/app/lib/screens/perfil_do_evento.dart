import 'package:flutter/material.dart';

class PerfilEvent extends StatefulWidget {
  const PerfilEvent({Key? key});

  @override
  State<StatefulWidget> createState() => _PerfilEventState();
}

class _PerfilEventState extends State<PerfilEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 241, 238),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Parte superior: Foto do evento
              Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Defina a altura com base na altura da tela
                child: Stack(
                  children: [
                    Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          'URL_DA_IMAGEM_DO_EVENTO',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.all(16.0),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Perfil do usuário que criou o evento
                              Row(
                                children: [
                                  CircleAvatar(
                                    // Aqui você pode adicionar a foto do perfil do usuário
                                    backgroundColor:
                                        Colors.grey, // Placeholder para a foto
                                    radius: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Nome do Usuário'), // Nome do usuário
                                      Text('Data do Evento'), // Data do evento
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Descrição do evento
                              Text(
                                'Descrição do Evento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Outras informações sobre o evento
                              Text('Outras informações sobre o evento'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
