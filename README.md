# OBD Inmetro

A implementação dos aplicativo mobile, utiliza o framework Flutter, que por sua vez utiliza a linguagem de programação Dart, a qual é orientada a objetos, baseada em classes e possui uma sintaxe similar à linguagem C. Inicialmente, o aplicativo foi concebido para coletar exclusivamente informações da interface OBD e armazená-las em um banco de dados Firebase. Firebase é um conjunto de serviços de back-end de computação em nuvem e plataformas de desenvolvimento de aplicativos fornecidos pelo Google. Dart, Flutter e Firebase foram desenvolvidos pela empresa Google LLC. Entretanto, o Firebase apresentou algumas limitações em termos de quantidade de leitura e escrita de informações.

Os testes iniciais revelaram que, para um volume significativo de informações, o experimento poderia ser prejudicado, pois quando o limite de operações permitidas é atingido, o banco de dados bloqueia as operações, as quais só podem ser recuperadas após um determinado período de tempo. Como a plataforma blockchain ainda está em desenvolvimento, foi decidido utilizar bibliotecas e plugins que auxiliem no armazenamento de dados internos do aplicativo. Inicialmente, realizamos a modelagem dos dados que serão recebidos. 

A Figura 1 ilustra a divisão dos casos de uso. A primeira etapa para capturar os dados veiculares envolve a conexão com o OBD é um dispositivo móvel via Bluetooth. Inicialmente, o condutor precisa conectar o scanner à interface do veículo e ligar o veículo para estabelecer a conexão e adquirir as informações necessárias. A segunda ação que um condutor pode realizar é visualizar os dados capturados pela aplicação em seu dispositivo. Para o armazenamento de dados, foi inicialmente utilizado um banco de dados chamado HiveDB, onde todos os dados são organizados em "caixas". Uma caixa pode ser comparada a uma tabela em SQL, mas não possui uma estrutura rígida e pode conter qualquer tipo de dado.

A terceira ação consiste em simular aleatoriamente os comandos que o OBD pode enviar, seguindo as normas estabelecidas para a quantidade mínima e máxima de comandos que o OBD pode transmitir. A quarta ação envolve a recuperação das informações armazenadas, inicialmente utilizando o formato JavaScript Object Notation (JSON). O JSON é um formato de arquivo de padrão aberto utilizado para armazenar e transmitir objetos de dados que consistem em pares de atributo-valor e matrizes. Esses arquivos são salvos na pasta do projeto e podem ser acessados pelo desenvolvedor que deseja recuperar as rotas geradas pelo aplicativo


Figura 1: Ações do usuário no sistema Mobile

![condutor](condutor.png)

A Figura 2 representa a interação do condutor com o aplicativo. O processo começa quando o condutor solicita que o aplicativo inicie o experimento. Neste momento, o aplicativo  inicia uma solicitação de conexão Bluetooth com o scanner OBD. O scanner, por sua vez, solicita as informações à interface OBD do veículo, que envia esses dados ao aplicativo através do scanner

Figura 2: Ações do usuário no sistema aplicativo mobile

![fluxo](fluxodeintera%C3%A7%C3%A3o.png)

## Modulos do Projeto 

Pelo fato de o aplicativo ser composto por diversos módulos como captura de dados veiculares, conexão com a blockchain, monetização dos dados e configurações, esses componentes foram desenvolvidos de forma independente, visando maior modularidade, manutenção e escalabilidade do sistema.

O primeiro módulo é responsável pela coleta de dados veiculares e está localizado na tela de corrida. Nessa interface, é possível adicionar novos PIDs, conectar um dispositivo OBD e iniciar a captura de dados. Além disso, na tela de configurações, o usuário pode ativar o modo de simulação, que permite simular a captura de dados veiculares sem a necessidade de um dispositivo físico conectado.

O segundo módulo opera de forma oculta e é ativado somente quando o botão de blockchain é habilitado. Esse módulo exibe todos os trajetos que podem ser monetizados, bem como a pontuação do condutor registrada na blockchain. Os trajetos são classificados em abertos e fechados. O condutor pode manter apenas um trajeto aberto por vez; ao encerrá-lo, o trajeto passa para o estado fechado, compondo o histórico e os ganhos obtidos no processo de monetização. A interface permite fechar um trajeto e definir o valor a ser monetizado. As moedas geradas podem ser resgatadas por meio de um botão que solicita o número de moedas a que o condutor tem direito. Como o valor depende da pontuação obtida, o servidor reserva um montante monetário como bonificação; caso o condutor não receba o valor total, a diferença é transferida para a carteira mãe.

O terceiro módulo trata dos trajetos monetizados por outros condutores. Esses trajetos podem ser adquiridos mediante pagamento de um valor definido, que é transferido para a carteira mãe. O módulo também disponibiliza botões para receber uma determinada quantidade de cripto-créditos e para realizar transferências para outras carteiras, sendo essas operações executadas por meio de contratos inteligentes. Além disso, o condutor pode visualizar quais contratos já adquiriu. Contudo, devido à dinâmica de testes da plataforma, esses dados não são persistidos: eles permanecem apenas em memória RAM e são perdidos sempre que o aplicativo é reiniciado.

O quarto módulo é responsável por diversas configurações que influenciam diretamente o funcionamento e a ativação dos demais módulos. Nele, são definidos o nome do condutor, a velocidade desejada para a captura de dados, além das configurações de conexão com a blockchain, que exigem a informação do IP do servidor, do VIN do veículo e do nível do tanque de combustível. O módulo também oferece opções para utilização de sensores internos do aplicativo, como a captura de dados do acelerômetro do celular, bem como uma funcionalidade em fase de testes para integração com um relógio inteligente. Adicionalmente, é possível utilizar o GPS do celular para medir a distância percorrida, assim como escolher entre a captura de dados via OBD ou por meio do simulador, que disponibiliza alguns PIDs para testes. Por fim, a interface apresenta botões para salvar as configurações e para identificar automaticamente os PIDs disponíveis.

## Execução do Projeto 

Para executar o projeto, é necessário ter o Flutter devidamente configurado no ambiente de desenvolvimento. No tutorial, é utilizado o Visual Studio Code (VS Code) para a execução do aplicativo, porém também é possível realizar a execução diretamente pelo terminal, caso desejado. A execução pelo VS Code é bastante simples. Primeiramente, é necessário ativar o modo desenvolvedor no dispositivo Android ou iOS. Em seguida, com o dispositivo conectado ou um emulador em execução, basta pressionar F5 ou acessar o menu Run → Start Debugging para compilar e instalar o aplicativo no dispositivo.