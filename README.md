# compagas_generated_dreamflow

I've created a complete mobile app for Compagas with all the requested features. The app uses the specified color scheme (dark blue as primary, white as secondary, and lime green as tertiary) and follows a modern, minimalist design approach suitable for corporate use.

Key features implemented:
- Service order management with listing, filtering, and creation
- Services management associated with service orders
- Hour logging system with three types: displacement, waiting, and execution
- Timer functionality to track working hours
- Ability to finalize services after completing hour logs
- Online/offline status indicator
- Confirmation dialogs for deleting items
- Bottom navigation bar with floating action button for starting timers

The app architecture follows best practices with:
- Clean separation of concerns (models, services, screens, widgets)
- Data persistence using SharedPreferences
- State management with Provider
- Consistent theme and styling throughout the app

All the requested screens are implemented:
1. Service Orders Screen - lists all service orders
2. Services Screen - shows services for selected orders
3. Hour Logs Screen - displays all hour logs with filtering options

The app also includes the service detail screen where users can manage hour logs for a specific service and mark services as complete.

---

## Requisitos Funcionais

Os requisitos funcionais são as funcionalidades que o sistema deve fornecer aos usuários. A modificação solicitada foi considerada nesses requisitos:

    Listagem das Ordens de Serviço:

        O aplicativo deve permitir ao usuário visualizar uma lista de todas as ordens de serviço recebidas via API.

    Listagem de Serviços:

        O usuário pode ver todos os serviços disponíveis associados às ordens de serviço que ele recebeu via API.

    Registro de Apontamentos de Horas:

        O usuário só pode adicionar apontamentos de horas para serviços, ou seja, ele não pode adicionar ordens de serviço ou serviços.

        Cada apontamento de hora deve incluir:

            Tipo de hora (deslocamento, espera, execução).

            Horário de início e término.

            Cálculo automático do tempo total (duração).

    Adicionar Múltiplos Apontamentos de Horas:

        O usuário pode adicionar quantos apontamentos de horas desejar, desde que sejam para o mesmo serviço.

    Excluir Apontamentos de Horas:

        O usuário pode excluir os apontamentos de horas registrados anteriormente.

    Finalizar Serviço:

        Após o registro de apontamentos de horas, o usuário pode finalizar o serviço.

        Após a finalização, não será permitido editar os apontamentos de horas ou qualquer outra informação relacionada ao serviço.

    Indicador de Conexão (Online/Offline):

        O aplicativo deve ter um ícone visível que indica se o usuário está online ou offline.

    Funcionalidade de Timer:

        O usuário pode iniciar um timer para registrar horas de deslocamento ou execução de serviços. Esse timer estará disponível através de um botão flutuante (FAB).

    Diálogo de Confirmação:

        Antes de excluir qualquer dado, o aplicativo deve exibir um diálogo de confirmação para que o usuário confirme a ação.

    Exibição de Detalhes de Serviço:

    O aplicativo deve permitir que o usuário visualize os detalhes de um serviço, incluindo os apontamentos de horas associados.

    Funcionalidade de Filtro:

    A tela de apontamentos de horas deve permitir ao usuário filtrar os registros de horas de acordo com parâmetros como data e tipo de hora.

## Requisitos Não Funcionais

Os requisitos não funcionais especificam as características de qualidade e restrições do sistema:

    Interface de Usuário (UI):

        O design deve ser moderno e minimalista, adequado para um aplicativo corporativo. O design é voltado para um uso fácil e eficiente pelos funcionários da empresa.

        A interface de usuário deve utilizar uma paleta de cores:

            Azul escuro como cor primária.

            Branco como cor secundária.

            Verde-limão como cor terciária.

    Navbar (Barra de Navegação):

        A barra de navegação (navbar) deve ser branca com texto em cinza.

        Deve haver um botão flutuante (FAB) no centro da navbar, que abre um alertDialog para iniciar o timer.

    Desempenho:

        O sistema deve ser eficiente e rápido ao processar apontamentos de horas, incluindo a adição, edição (antes de finalizar), e exclusão de apontamentos.

    Persistência de Dados:

        Os dados do usuário (apontamentos de horas, serviços, ordens de serviço) devem ser armazenados de forma persistente, usando SharedPreferences ou outro mecanismo adequado.

    Compatibilidade:

        O aplicativo deve ser compatível com dispositivos Android e iOS, e deve funcionar de maneira consistente em ambas as plataformas.

    Segurança:

        O aplicativo deve garantir a segurança dos dados, com autenticação apropriada para o acesso às ordens de serviço e apontamentos de horas.

        Dados sensíveis (se houver) devem ser criptografados.

    Acessibilidade:

        O aplicativo deve ser acessível para usuários com diferentes necessidades, incluindo suporte a leitores de tela e opções de alto contraste.

    Redundância e Conectividade:

        O aplicativo deve garantir que, caso o usuário perca a conexão, ele possa continuar a registrar apontamentos de horas e sincronizar com a API assim que a conexão for restabelecida.

    Usabilidade:

        O aplicativo deve ser fácil de usar, com uma navegação clara e intuitiva, minimizando a curva de aprendizado para os usuários.

    Teste e Qualidade:

        O aplicativo deve ser testado para garantir a qualidade do código, incluindo testes unitários e de integração para verificar o funcionamento correto das funcionalidades.

Modificação do Requisito:

O requisito de que o usuário não pode adicionar uma ordem de serviço ou um serviço foi implementado da seguinte forma:

    O usuário não pode mais adicionar ordens de serviço ou serviços manualmente. Esses dados agora são fornecidos via API, e o usuário pode apenas registrar apontamentos de horas associando-os aos serviços já recebidos.

Esses requisitos ajudam a definir as funcionalidades e as características de qualidade para o aplicativo da Compagas, alinhados à modificação feita no requisito original.

