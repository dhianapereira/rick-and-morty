# Rick and Morty

O foco deste projeto é demonstrar organização arquitetural, preocupação com performance, testes automatizados, navegação escalável, cache local e boas práticas de UI.

## Observação Importante

No momento, o projeto foi desenvolvido e validado em um PC Linux.

Por isso, a execução local está preparada apenas para Android. Não houve configuração nem validação para iOS.

## Funcionalidades Atuais

- Lista paginada de episódios, carregando 10 episódios por vez
- Troca de tema `system`, `light` e `dark`

## Stack

- Flutter
- `go_router`
- `dio`
- `get_it`
- `sembast`
- `shared_preferences`

### Estrutura

```text
lib/
  application/  responsável por configuração global do app, DI, router, ambiente e tema.
  features/ responsável pelas features de negócio, separadas em módulos como `episodes`, `characters` e `home`.
  l10n/ responsável pelos arquivos de localização e código gerado.
  shared/ responsável por recursos compartilhados, como tema, extensões e infraestrutura HTTP.
```

## Decisões

- `ValueNotifier` foi utilizado para gerenciamento de estado por ser suficiente para a complexidade atual, leve e com baixo custo de rebuild.
- `sembast` foi escolhido como banco NoSQL local para cache, evitando carregar dados já obtidos da API.
- Strings não ficam chumbadas na UI; o projeto já está preparado com `l10n`, mesmo tendo suporte apenas para `en` neste momento.

## Testes

O projeto possui:

- testes unitários
- testes de widget

Os testes seguem o padrão de nomenclatura:

```text
Should ... When
```

A estratégia atual prioriza:

- validação de regras da controller
- validação de repository e cache
- validação de interações de UI, como taps em botões e navegação

## Como Rodar

### Pré-requisitos

- Flutter instalado
- Android SDK configurado
- Emulador Android ou dispositivo Android

### 1. Instalar dependências

```bash
flutter pub get
```

### 2. Rodar o projeto com variáveis de ambiente

```bash
flutter run --dart-define-from-file=env/development.json
```

### 3. Rodar análise estática

```bash
flutter analyze
```

### 4. Rodar testes

```bash
flutter test
```

## Variáveis de Ambiente

O projeto utiliza:

- `env/development.json`

Atualmente, esse arquivo contém a configuração da URL base da API.

## API

O app consome a API pública de Rick and Morty:

- https://rickandmortyapi.com/documentation

## Milestones e Issues

- Issues: [github.com/dhianapereira/rick-and-morty/issues](https://github.com/dhianapereira/rick-and-morty/issues)
- Milestones: [github.com/dhianapereira/rick-and-morty/milestones](https://github.com/dhianapereira/rick-and-morty/milestones)
