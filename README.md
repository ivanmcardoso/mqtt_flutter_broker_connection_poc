# PoC Mqtt com Flutter

O projeto é uma prova de conceito (PoC) da conexão com broker mqtt usando flutter.

A aplicação é simples, possui um unico botão que conecta com um broker, se inscreve em um tópico e publica uma mensagem neste mesmo tópico.

Ao receber uma mensagem no tópico a aplicação atualiza o texto localizado acima do botão.

## Configurações Básicas

- as configurações básicas do broker ficam no arquivo [mqtt_constans.dart](https://github.com/ivanmcardoso/mqtt_flutter_broker_connection_poc/blob/main/lib/network/mqtt_constants.dart).
- o projeto usa observables para notificar os widgets da última mensagem recebida no tópico, uma evolução da ideia seria criar um observable para cada tópico subscrito.

## Dependências do projeto
- [mqtt_client](https://pub.dev/documentation/mqtt_client/latest/): usado para conectar com o broker mqtt (nos meus testes usei um broker do [hive.mq](https://console.hivemq.cloud/clients/mqtt-dart?uuid=7fb9404100074ba2a95e41ece4d81ff3)).
- [mobx](https://mobx.js.org/README.html): usado para notificar os widgets das mensagens que chegam no tópico.
