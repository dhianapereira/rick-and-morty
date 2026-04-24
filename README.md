# Rick and Morty

O foco deste projeto é demonstrar organização arquitetural, performance, testes automatizados, navegação escalável, cache local e boas práticas de UI em um catálogo que consome a API do Rick and Morty.

## Observação Importante

No momento, o projeto foi desenvolvido e validado em um PC Linux.

Por isso, a execução local está preparada apenas para Android. Não houve configuração nem validação para iOS.

## Funcionalidades Atuais

- Lista paginada de episódios, carregando 10 episódios por vez
- Busca de episódios por nome ou código, com prioridade para dados em cache
- Detalhes de episódio com lista de personagens clicável
- Detalhes de personagem
- Troca de tema `system`, `light` e `dark`

## Stack

- Flutter
- `go_router`
- `dio`
- `get_it`
- `sembast`
- `shared_preferences`
- `alchemist`
- `very_good_cli`
- `integration_test`

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
- A inicialização global foi mantida enxuta. Apenas dependências essenciais sobem no startup; dependências de feature são registradas sob demanda por rota para reduzir custo antes da primeira renderização.
- A busca de episódios prioriza páginas já armazenadas localmente antes de consultar a API, reduzindo requisições desnecessárias e melhorando a resposta percebida.

## Testes

O projeto possui:

- testes unitários
- testes de widget
- golden tests com `alchemist`
- teste de integração para o fluxo principal do app

Os testes seguem o padrão de nomenclatura:

```text
Should ... When
```

A estratégia atual prioriza:

- validação de regras da controller
- validação de repository e cache
- validação de interações de UI, como taps em botões e navegação
- validação visual das páginas principais com golden tests
- validação ponta a ponta do fluxo principal com `integration_test`

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
dart pub global activate very_good_cli 1.1.1
```

```bash
very_good test --test-randomize-ordering-seed random
```

### 5. Atualizar goldens

```bash
very_good test --update-goldens
```

### 6. Rodar teste de integração

```bash
flutter test integration_test/app_flow_test.dart \
  --dart-define-from-file=env/development.json \
  -d <device-id>
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
