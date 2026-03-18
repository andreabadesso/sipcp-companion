#import "figures_img.typ": *

#pagebreak()
== CAPÍTULO III — PILOTAGEM DOS SISTEMAS

=== INTRODUÇÃO

O propósito dos sistemas de gestão é, genericamente, operar os sistemas físicos, orientando-os para os propósitos que os condicionam.

A operação dos sistemas físicos dá-se, em cibernética, o nome de pilotagem.

Vejamos a semântica da palavra pilotagem, em sua acepção cibernética.

"Kubernetes", em grego, é o que governa, pilota, a embarcação. Transposto para o latim, deu "gubernator", que significa governador, tendo sido a palavra empregada, mais, em seu sentido político, pelos romanos.

Os "kubernetes", empunhando com firmeza e perícia o leme de suas naus, conduziram Ulisses pelos mares ignotos para as aventuras da Ilíada e da Odisséia, proporcionando-lhe o retorno, vitorioso, à pátria saudosa.

Os "gubernatores", agindo sempre com astúcia, sutileza de espírito e devotamento à causa do Estado — virtudes peculiares aos patrícios — conseguiram realizar um feito admirável: manter incólume e coeso, por mais de um milênio, espalhado "ubi et orbi", um império verdadeiramente cosmopolita.

Todos esses cibernetas do passado aplicaram, sem que o soubessem, princípios da ciência da comunicação e do controle, na "pilotagem" de seus sistemas.

O propósito deste capítulo é explicitar, à luz da cibernética, aquilo que nossos antepassados souberam intuir com tanta argúcia.

=== 3.1. Modelo Cibernético — (simplificado) de Administração Industrial

A figura 11 apresenta um modelo, propositalmente simplificado, que utilizaremos para o nosso primeiro exercício de pilotagem. Os blocos que o constituem (trata-se de um sistema artificialmente criado, uma empresa) já nos são, de certa forma, familiares. Há dois conceitos, entretanto, novos, sobre os quais faremos ligeira abordagem: variável de ação (VA) e variável essencial (VE), também conhecida como variável crítica.

A dona de casa abre seu livro de receitas e lê, com atenção:

Bolo econômico: Ingredientes: 3 xícaras de açúcar, 3 ovos, 1 colher de sopa de fermento, 2 colheres de manteiga, 1 copo de leite, preferentemente "in natura"; bater as claras, em neve, até que atinjam o máximo volume; colocar os ingredientes na seguinte ordem: açúcar e manteiga (bem misturados), gemas, demais ingredientes, reservando as claras em neve para o último lugar. Forno bem quente; vigiar, entretanto, para que não queime a massa. O bolo deverá apresentar-se corado por fora e cozido internamente. Teste com um palito. Deve estar, ainda, fofo, aceitando o corte sem esfarelar.

#figura-11()

As instruções relativas à manipulação dos ingredientes constituem variáveis de ação; os padrões de qualidade, variáveis essenciais.

Passemos, agora, à arquitetura de SG.

O sistema de gestão comporta dois blocos — REGULAÇÃO (Rg) e CONTROLE (Ct) — que constituem subsistemas em interação.

SG recebe informação do universo exterior (UE) através de Ct e a sua interação com SF se faz através de Rg.

Rg tem entradas e saídas conectando-o a SF. Através das entradas "regula" SF (mais adiante veremos como essa função se exerce) e através das saídas (que são entradas em SF), impõe-lhe as variáveis de ação ditadas por Ct.

Ct está sempre informado a respeito do comportamento das variáveis essenciais, através da seta no marcador O. Além de detectar os desvios, para acionar o mecanismo de auto-regulação, tem entradas para o marcador, visando à fixação de novos objetivos quando a homeostase do sistema o sugerir ou exigir.

SF, por sua vez, mantém-se em interação, também, com UE, através de entradas (por exemplo, encomendas de clientes) e saídas (por exemplo, as entregas nos prazos estabelecidos).

O sistema, globalmente considerado (SG / SF), comporta-se da seguinte maneira:

Ct, baseado nos propósitos do sistema, seleciona a alternativa mais viável (nisso, considera as condições atuais do universo exterior, ao qual está conectado por informações), estabelece planos de ação e programas, e os implementa em SF, através de Rg, sob a forma de VA. A partir daí, Rg, SF e UE interagem, sob a ação catalítica de Ct, que somente intervirá caso ocorram desvios dos objetivos cuja correção tenha excedido à capacidade operativa de Rg.

Suponhamos, agora, que uma perturbação, não contida por Rg, tenha impelido a seta do marcador para uma zona de perigo.

Ct, advertido dos desvios, certifica-se, através de Rg, das condições de entrada das VA, em SF, corrigindo, em tempo real, eventuais distorções detectadas.

A perturbação continua?...

Ct revê os programas e sua compatibilização com os planos de ação, podendo alterar as VA (algumas, ou mesmo todas), pois, sendo métodos, podem não estar conduzindo, com a eficiência esperada, aos fins colimados.

Persistindo a perturbação, Ct revê as alternativas, pesando-as, de novo, entre si, num processo crítico que tem, como foco, a alternativa anteriormente eleita e os resultados alcançados, de que resultam novos planos de ação e novos programas. Persistindo, ainda, a perturbação, Ct, numa última tentativa, modificará os propósitos atuais do sistema.

Falhou?...

É chegada a hora de tomar uma decisão ao mesmo tempo corajosa e sensata. O momento não é de alimentar paixões para satisfazer o amor próprio ofendido. É de avaliar, com a frieza do tecnicismo, o potencial sistêmico, pois há sintomas, claros, de que a entropia do sistema físico excede a capacidade instalada de gestão.

No caso da empresa, a concordata talvez seja a única terapia jurídico-institucional cabível!

=== 3.2. O Dimensionamento da Gestão

Considerando que, no projeto do modelo, SG, pelo menos em tese, teria sido dimensionado em função da variedade de SF, como, agora, acusá-lo de incompetente? Teria sido subavaliada a variedade de SF?

São questões que merecem exame acurado. O destino da empresa, recuperação ou capitulação com honra, irá depender dos procedimentos adotados durante a crise.

Examinemos o aspecto relativo à variedade de SF. Sabemos que, em grande parte, SF depende do universo exterior. Este, por sua vez, é considerado determinístico, dentro de certos limites, excluídos, é claro, os fenômenos imponderáveis, tais como catástrofes e outras fatalidades. Séries históricas, estatisticamente processadas, servirão de base para a determinação das tendências comportamentais de UE que irão influir à guisa de decidendos#footnote[_Decidendo: neologismo cibernético = fator decisório._], na fixação de um "quantum" de variedade a atribuir-se a SF em função de UE.

A dimensão de SG, no projeto do modelo, baseou-se, portanto, em um conjunto afim de variáveis#footnote[_Embora a expressão variável seja mais comum em sua acepção matemática, o conceito de conjunto afim de variáveis provém da fisiologia. A cibernética, que desconhece limites entre os campos do saber, foi buscá-lo. Assim, por exemplo, pressão sanguínea, ritmo cardíaco, dosagem de adrenalina e atividade no seio carotídeo constitui um conjunto afim de variáveis que diz respeito às condições da função circulatória de um organismo animal em dado instante. "Mutatis Mutandis", pressão e temperatura são variáveis afins cujo conjunto define as condições atuais de um gás; tal como preço de venda, qualidade do produto, poder aquisitivo e tendência ao consumismo definem um modelo de mercado em função desse conjunto afim de variáveis._], situadas dentro de limites determinísticos, estatisticamente fixados, nos quais SF atuará.

Ocorre-nos, como exemplo bastante ilustrativo, o que se passa na aviação.

As aeronaves são projetadas, em termos de estrutura física, para operar sob condições atmosféricas consideradas normais dentro de certos limites. Para tanto, os engenheiros aeronáuticos dispõem de tabelas que lhes dão, sob a forma de coeficientes, (atrito por exemplo) os fatores adversos que normalmente deverão ser suportados pela aeronave.

As tripulações são treinadas, não apenas, para operar os equipamentos de controle do vôo, mas, também, para responder, automaticamente, a eventuais desvios, bruscos, da aeronave, causados por mudanças repentinas nas condições de vôo. Tudo, sob certos limites, como frisamos há pouco. Nem SG (tripulação), nem SF (aeronave), foram projetados para enfrentar tufões, tempestades de granizo ou quejandas coisas...

Outro exemplo, bastante ilustrativo, extrai-se de uma loja de departamentos.

O projeto da loja tem, como principal variável, o modelo de mercado. O papel da gerência (SG) consiste em, baseando-se nos indicadores do modelo (decidendos), manter a loja suprida dos artigos de forma a que não falte nem sobre mercadoria. Uma crise econômica, afetando drasticamente as condições de UE, poderá fazer com que, virtualmente, SG mostre-se incompetente.

Do exposto, infere-se que o ideal seria que os sistemas de gestão fossem projetados com uma reserva de capacidade que lhes facultasse fazer face a quaisquer perturbações ambientais, mas, por outro lado, já vimos que, na prática, isto não é aconselhável, por ser, economicamente, inviável.#footnote[_Tanto os sistemas artificialmente criados, como os sistemas naturais, por razões de economicidade, são projetados admitindo-se a sujeição a um risco calculado. Tal é a razão pela qual todos os sistemas são dotados de mecanismos sensórios destinados à captação, o mais aprioristicamente possível, de estímulos aferentes nociceptivos, os quais têm de ser analisados em tempo útil para a formulação de estratégias e a deflagração de ações de defesa do sistema._]

Há, ainda, uma importante consideração a ser feita, desta vez, quanto a SF.

Recordemos que a variedade de SF condiciona a variedade requerida de SG, e que, nos dois exemplos dados, ficou claro que ela pode alterar-se para mais, isto é, que a variedade requerida é, em última análise, uma variável, pois função de um conjunto afim de variáveis. Isso indica que os sistemas físicos apresentam tendência à variedade proliferante, absorvida de UE na medida em que, este, passa por modificações que extrapolem dos níveis tidos como normais.

Parece-nos que a questão, agora, põe-se da seguinte forma: "se SG tivesse sido projetado (a referência diz respeito, ainda, aos exemplos dados) com reserva ilimitada de variedade, seria capaz de pilotar SF, qualquer que fosse a variedade proliferante absorvida, por este, do universo exterior?...

A resposta é, intuitivamente, não! Voltemos a pensar no exemplo da aeronave e sua tripulação...

O tempo apresenta-se bom, as condições de funcionamento da aeronave são normais, os passageiros estão tranquilos. O comandante liga o piloto automático e refestela-se em sua poltrona para ler o jornal do dia. A campainha de alerta soa na cabine: o radar — mecanismo sensório de captação de estímulos aferentes nociceptivos — detecta a ocorrência de turbulências na aerovia, a alguns minutos de vôo. O navegador, analisando o sinal de alerta, informa o comandante sobre a impossibilidade de passar por cima ou por baixo da turbulência. Ela tem que ser atravessada! O comandante retoma os controles da aeronave, pois sabe que o piloto-automático, sob condições meteorológicas mais severas, é ineficiente.

A aeronave atinge a região de turbulência. A tripulação empenha-se, fazendo uso de toda a perícia, habilidade e sangue frio de que é dotada, em neutralizar os efeitos desestabilizadores das fortes correntes ascendentes e descendentes, e da excessiva umidade da atmosfera. Em dado momento, entretanto, não obstante os esforços quase sobre-humanos empreendidos, o conjunto de ações que, simultaneamente, têm que ser exercidas para manter a aeronave em equilíbrio, supera a capacidade de pronta resposta da tripulação. O controle não se opera, mais, em tempo real. As oscilações ampliam-se e a fuselagem não resiste ao esforço, partindo-se.

A dramática narrativa, que a caixa negra de muitos aviões sinistrados registrou com idêntica fidelidade, ressalta o ponto fulcral da questão: o problema da aeronave, não foi, apenas, o de sua fuselagem não ter sido capaz de mantê-la em vôo. O que vale dizer, tanto o sistema físico (a aeronave) quanto o sistema de gestão (a tripulação) teriam de ser redimensionados para que pudessem fazer face à variedade proliferante, que produz efeitos sobre ambos. Em outras palavras, o sistema, globalmente considerado (SF/SG), precisa adaptar-se às novas condições ambientais...

=== 3.3. Adaptação Cibernética ao Contexto

Adaptação#footnote[_Os biólogos consideram-se satisfeitos com as evidências — já tornadas certeza científica — de que todas as atividades fisiológicas no reino animal cumprem a função subsidiária de preparar o organismo para ir aceitando, cada vez com maior automatismo no ajustamento sinérgico, as condições ambientais cujas modificações se tornam repetitivas e sistemáticas. Este mecanismo — adaptação — segundo Alexis Carrel (O Homem, esse Desconhecido, p. 229), pode agrupar-se em duas categorias: — Adaptação Intra-Orgânica: determina a constância do meio interno e das relações dos tecidos e dos humores, e garante a sinergia entre os órgãos; produz, ainda, a separação automática dos tecidos e a cura das doenças; — Adaptação Extra-Orgânica: ajusta o indivíduo ao meio físico, psicológico e econômico, permitindo-lhe sobreviver apesar das condições desfavoráveis do meio._], evolução e mutação constituem um conjunto afim de variáveis que define a trajetória de um sistema, em seu contexto. A essa trajetória não qualificaremos, apenas, de evolutiva, pois, se o fizermos, estaremos deixando de considerar a mutação, como um passo mais avante, que realmente é, embora ambas — evolução e mutação — sejam, a um só tempo, causa e efeito.

Novamente recorreremos à analogia entre os sistemas orgânicos, vivos, e os não orgânicos, para situar a adaptação em um contexto cibernético.

Dissemos, anteriormente, que "o instinto, e este é um fato repetitivo, motivado pelo desejo insatisfeito, orienta o organismo para a evolução contínua das formas de vida, evolução que se processa 'pari passu' e que se consubstantia na modelagem dos órgãos incumbidos de exercer, na economia orgânica, a plenitude das funções reclamadas pelo psiquismo ontogenético, sempre pronto a fazer novas exigências"#footnote[_A resposta atual do organismo ao desejo insatisfeito, que somente com a criação do órgão sentir-se-á saciado plenamente — uma espécie de paliativo — consiste na metergia, isto é, adaptação de um órgão a novas funções._]. Em outras palavras, a evolução consubstancia-se na mutação, processo contínuo, porém, lento e demorado, orientado pelo instinto, que se transmite de geração em geração.

Antes de prosseguir, é necessário que se explique melhor o por quê considerar-se a mutação como um passo mais à frente.

Coloquemos ambas — evolução e mutação — numa mesma escala temporal. A unidade de medida da evolução pode muito bem basear-se numa geração. Cada um de nós considera-se testemunha ocular daquilo que, metaforicamente, chamamos de "sinal dos tempos": a rápida evolução dos usos e costumes. Mas, nenhum de nós presenciou ou presenciará, com toda a certeza, qualquer tipo de mutação (excluídas as causadas por acidentes genéticos). Isto porque a evolução se faz sentir diretamente sobre o comportamento da espécie (variável de SG), enquanto que a mutação se faz sentir sobre o arcabouço físico da espécie (variável de SF).

A História Universal costuma ser escrita tendo como enfoque a evolução do pensamento humano, mas a História Natural, de que o transformismo é uma das concorrentes mais respeitáveis, baseia-se nas mutações genéticas para descrever a cadeia evolutiva. Os arquivos da História Universal registram ocorrências que distam, na escala temporal, não mais de meia centena de séculos; os da História Natural escondem-se sob a poeira de dezenas de milhões de anos.

Toda esta digressão foi feita para ressaltar uma importante condição dos sistemas artificiais — especialmente a EMPRESA — que contrasta, nesse particular, com os sistemas orgânicos: as perturbações ambientais, salvo os grandes cataclismos, não afetam, drasticamente, as espécies; antes, mesmo, excitam-lhes o funcionamento do mecanismo adaptativo, queimando algumas etapas da consecução, a longo prazo, do binômio evolução-mutação. O mesmo não ocorre, entretanto, com a empresa, pois, dela, quer-se adaptação a curto prazo, com respostas, às vezes, até mesmo antecipativas. Isto é, não podem mudar com a serenidade e a fleuma dos organismos vivos; têm de projetar, na tela do presente, a sua resposta — mutação rigorosamente certa — sob pena de se verem alijadas do painel do futuro.

Agora, estamos mais capacitados para diagnosticar a "causa mortis" de nosso modelo cibernético de administração industrial: "disfunção de SG, caracterizada por uma manifesta incapacidade de adaptar-se às condições ambientais adversas, sucumbindo à entropia alimentada pela variedade proliferante"....

O termo "disfunção" está empregado em sua acepção genuinamente médica, mas, mesmo assim, reveste-se de grande propriedade verbal, do ponto de vista cibernético. Ao atuar em apenas dois níveis — regulação e controle — quando era, imperiosa, a necessidade de fazer com que o modelo evoluísse e mudasse segundo as exigências do contexto, SG somente teve condições de exercer, parcialmente, sua função. Com isso, comprometeu-se a estabilidade do organismo, que, enfraquecido, sucumbiu à entropia.

Resta, finalmente, uma única dúvida: tinha SG, implícita em sua estrutura, a instrumentação necessária ao cabal exercício da função?

Quando falamos da pequena empresa, anatomicamente carente, mas que, não obstante, apresentava bom desempenho, expendemos o seguinte juízo: "no âmago desse sistema pulsando com o frêmito de um coração insatisfeito, a estrutura invisível, ao mesmo tempo em que suplementa o desempenho da estrutura formal, cria as motivações que irão suscitar o interesse pelo aperfeiçoamento da organização".

A "estrutura invisível" não é um fantasma shakespeareano, a serviço da cibernética; é manifestação, senciente, de metergia, que, como vimos, consiste na adaptação de órgãos para o exercício de funções novas. Dessarte, estruturado ou não — este aspecto, portanto, é de certa forma irrelevante — SG conta, metergicamente, com recursos para exercer suas funções vitais. É preciso, entretanto, que esteja alertado a respeito das responsabilidades que lhe pesam sobre os ombros, situadas em quatro níveis de pilotagem, ascendentes, que apresentam as seguintes correlações:

#table(
  columns: 3,
  [*NÍVEL*], [*TIPO DE ATUAÇÃO*], [*FORMA DE COMANDO*],
  [1º], [regulação], [autônomo],
  [2º], [controle], [autônomo-consciente],
  [3º], [evolução], [consciente (+) intuitivo (-)],
  [4º], [mutação], [intuitivo (+) consciente (-)],
)

A título de ilustração, examinaremos os níveis de pilotagem dos sistemas, um a um, embora deva estar bem claro que a compartimentação é apenas para efeito didático, uma vez que os sistemas de gestão, como qualquer sistema, operam sempre como um todo.

=== 3.4. Os Níveis de Pilotagem

==== 1º nível — OPERAÇÃO

Em nosso primeiro modelo cibernético de administração (Fig. 11), SG foi idealizado para conter, estruturalmente, dois subsistemas: regulação e controle.

Vimos que controle é de mais alta hierarquia que regulação, concluindo-se, portanto, que este último é o primeiro nível de pilotagem.

A fim de fixar uma terminologia uniforme#footnote[_"As propriedades atribuídas a qualquer objeto são, em última análise, nomes para seu comportamento"_ (Robert Herrick, poeta inglês).], que, ao mesmo tempo, contribua para que não se confunda causa com efeito, passaremos, doravante, a chamar de OPERAÇÃO as ações que visam à regulação dos sistemas físicos, e, de GESTÃO, as ações que visam de forma imediata a operar a Operação.

A representação espacial dos níveis de pilotagem utilizada por Jacques Melese#footnote[_"A Gestão pelos Sistemas"_ (ver bibliografia).] — círculos concêntricos — parece-nos a mais sugestiva. Nesse modelo geométrico o primeiro nível — Operação, apresentar-se-á como na figura 12, abaixo.

#figura-12()

Um bom exemplo de pilotagem neste nível envolve um ônibus (SF) e seu motorista (SG).

Itinerário, locais de parada, velocidade máxima, constituem variáveis de ação. Cumprimento dos horários, obediência às regras de trânsito, utilização econômica do motor, são variáveis essenciais.

É evidente que o comportamento ótimo do sistema depende, praticamente, da consciência profissional do motorista, mas ele pode ser iludido pela própria consciência, acionando mecanismos subconscientes de racionalização, pois, neste nível, inexiste fator de coerção capaz de impor, a Op, em tempo real, a correção de eventuais desvios.

A natureza oferece, também, interessante exemplo de pilotagem em um só nível: a ameba. Este pequenino ser, unicelular, dotado de rudimentar sistema nervoso, tem sua capacidade de regulação adstrita a acanhados limites. Por tal motivo, é extremamente sensível às perturbações ambientais. De personalidade ativa, porém, muito cautelosa e desconfiada, a qualquer indício de perigo — por exemplo, a adição de uma gota de iodo no caldo de cultura onde se encontra — recolhe imediatamente os pseudópodes e adota uma postura externamente adinâmica, permanecendo assim enquistada até que seu mecanismo sensório acuse o restabelecimento das condições ambientais pré-existentes. A sua permanência no contexto biológico — por que não falar da imortalidade da ameba, a que os poetas aludem, com inveja e admiração? — seria, de todo, impossível, não fora a capacidade, de que é dotada, de subdividir-se em duas novas células, funcionalmente idênticas, quando atinge determinado tamanho. Resposta inconsciente, porém, urdida por uma inteligência misteriosa e que dá mostras de conhecer a lei da variedade requerida...

É fruto da intuição da ameba que, quanto maior o seu arcabouço físico, maior quantidade de recursos terão que ser absorvidos para seu sustento, além de tornar-se mais vulnerável à ação nociceptiva do ambiente. Parecendo conhecer suas próprias limitações, em termos de capacidade de regulação, a ameba jamais permite que a variedade de seu sistema físico, cuja maior condicionante é o tamanho, exceda a variedade de seu rudimentar sistema de gestão.

A microempresa, representada pelo pipoqueiro, com sua carrocinha, tem muito a aprender com a ameba, seu modelo isomórfico de regulação. Da mesma forma, o sapateiro, para quem há uma advertência especial: "não vá além da sola!"...

Se o sistema de gestão da microempresa for rudimentar, como o da ameba, não lhe propiciando pilotagem além do nível de operação, que é a forma mais elementar de regulação, seu crescimento, por mais favorável que se apresente a conjuntura, não poderá exceder um volume, máximo, que a ameba sabe intuir, com precisão e oportunidade. Por isso que muitos pequenos negócios, excepcionalmente prósperos, transformaram-se em fracassos retumbantes, quando cresceram além da capacidade operativa de seus titulares.

==== 2º nível — GESTÃO

Vimos que a gestão visa ao controle e sentimos ser intuitivo que a existência de um poder controlador implica a existência de um elemento controlado. Tal é a razão pela qual, no modelo circular de pilotagem (Fig. 13), gestão envolve operação.

#figura-13()

O matrimônio feliz, de operação com gestão, decorre de um importante princípio de cibernética: o subsistema controlador e o subsistema controlado têm de pertencer ao mesmo sistema de gestão, isto é, viver sob o mesmo teto. Chamá-lo-emos de "Princípio da Gestão".

O princípio da gestão, não obstante a importância de que se reveste, sofre constantes violações, no campo da administração de empresas, por ser pouco conhecido, mal interpretado ou, até mesmo, totalmente ignorado. Os efeitos, negativos, que essa violação produz fazem-se sentir sobre toda a organização. Vejamos, através de um exemplo, como isso pode ocorrer, bem como a natureza e a extensão do dano provocado.

A empresa do organograma (Figura 14) consiste, ciberneticamente, de um conjunto de subsistemas em interação, os departamentos, cada qual exercendo uma função específica em proveito do sistema global, a empresa. A sinergia — efeitos interativos e cooperativos — entre os componentes do sistema constitui a principal preocupação da hierarquia superior (a presidência), que, a fim de assegurar a obediência à "lei do valor ótimo"#footnote[_Ver nota 2, Cap. I da 2ª parte._], institui um órgão de assessoria, "controller", que a ela se reporta diretamente e que não tem canais diretos de comunicação com os departamentos.

#figura-14()

Controller desfruta de elevado status na empresa, dada a proximidade da presidência e por ter acesso, direto, a ela, o que lhe confere prestígio, poder e respeitabilidade. O desejo de auto-afirmação, inerente ao espírito humano, exacerba-se em controller, por sentir-se superdotado para sua plena realização. Nessas condições, é comum ocorrer uma disfunção do órgão: extrapolando da missão para a qual fora instituído — obtenção de sinergia — controller desloca sua preocupação para o comportamento das VE departamentais, assunto que não lhe diz respeito diretamente, pois eventuais desvios seriam causas, apenas mediatas, de violação da lei do valor ótimo. Além disso, os departamentos, na hierarquia da gestão, contam com elementos específicos de controle, sem qualquer ligação com controller, mesmo porque, como vimos, este não tem canais de comunicação direta com os departamentos.

O apetite legiferante de controller parece insaciável! Memorandos descem constantemente da presidência cobrando medidas de desempenho financeiro, comercial, contábil, metas de produção e outros aspectos departamentais, de que resultam recomendações, advertências, instruções normativas, enfim, uma enxurrada de papéis, tudo devidamente respaldado pela respeitável chancela da presidência...

O pior é que todo esse esforço, as mais das vezes inútil, cria, inevitavelmente, um clima de tensão e de desconfiança recíprocos entre os departamentos e a alta hierarquia da empresa. Inútil; porque controller, no exercício da disfunção, não pertence ao sistema controlador/controlado, e, consequentemente, não pode agir, em tempo real, sobre as causas de eventuais rupturas das VE departamentais. Ademais, problemas que, de outra forma, poderiam ser solucionados (e, certamente, sê-lo-ão) nos níveis departamentais, irão sobrecarregar, inoportunamente e desnecessariamente, a agenda da presidência.

Qual seria, então, a fórmula para resolver, de outra forma, os problemas, a fim de que a hierarquia superior do sistema não fique sobrecarregada com questões que, até prova em contrário, dispensam sua gestão direta?

O que vimos, até agora, sobre pilotagem dos sistemas é suficiente para a formulação de uma terapêutica adequada ao caso:

1º — fazer com que cesse, imediatamente, a ingerência de controller em questões referentes a VE departamentais;

2º — conceder o maior grau possível de autonomia aos subsistemas de que se compõe a empresa, os quais, para isso, contam com seus próprios níveis de pilotagem, estruturados, isomorficamente, com relação ao sistema globalmente considerado. Assim, embora o organograma não o demonstre, cada departamento terá, ciberneticamente, a estrutura da figura 15.

O funcionamento do modelo departamental de gestão, nos dois níveis de pilotagem, não apresenta nada de novo, mas oferece um aspecto, importante, a ressaltar: a especificidade da gestão.

#figura-15()

Se é fato notório que a gestão se faz sobre a operação, infere-se, naturalmente, que o poder controlador precisa conhecer, perfeitamente bem, o elemento controlado. Daí decorre o princípio da especificidade da gestão, ou da especialização do controle. É certo, portanto, falar em controle contábil, financeiro, de qualidade (aspectos técnicos, da operação), administrativo, etc. Infere-se, também, que o elemento controlador (o regulador) precisa conhecer, igualmente bem, o elemento operado (sistema físico).

Chegamos, finalmente, à figura do especialista, tão mal compreendido e injustiçado, que deu a Chaplin a inspiração de sua obra prima, "Tempos Modernos", que contribuiu, ainda mais, para confundir e disseminar a injustiça em torno do comportamento desse produto aristotélico da cultura ortodoxa.

Pretendemos contribuir, através destas considerações, para colocar o especialista em sua exata posição e para lhe conceder a dimensão que deve possuir, sem excesso nem falta, no contexto das ciências aplicadas.

Por força do princípio da gestão — controlador e controlado devem pertencer ao mesmo sistema — o especialista situa-se intra-sistema. E a recíproca, é verdadeira? Isto é, fora do sistema situar-se-á o generalista?

O assunto merece exame cuidadoso. Voltemos à discussão em torno do papel de controller e da disfunção que costuma ocorrer por sua atuação fora dos limites que lhe são inerentes, pois, aí, encontraremos exemplo sugestivo de aplicação do princípio da especialização do controle.

Familiarizados, que estamos, com o papel a ser desempenhado por controller, sabemos que o dever funcional lhe impõe a obrigação de conhecer, com exatidão, as possibilidades e limitações de todos os departamentos da empresa, mas não exige, dele, nem seria necessário exigir, profundo conhecimento da dinâmica operativa de cada departamento. Controller é, portanto, um generalista. Vejamos, agora, sua posição, relativa, no sistema empresarial, e, também, a relatividade de sua condição de generalista...

Ligado, como vimos, diretamente à Presidência, hierarquia superior do sistema de gestão do sistema-global-empresa, dentro do qual os departamentos constituem o sistema físico, controller é uma peça do mecanismo de gestão, e interage com os demais elementos, a nível presidência, que exercem a operação do sistema, globalmente#footnote[_Este elemento está omitido no organograma, mas, normalmente, tratar-se-ia do vice-presidente executivo e seu staff._]. No exercício normal, de suas funções, controller satisfaz o princípio da gestão, pois se situa no interior do sistema que acabamos de explicitar. Embora seja um generalista, no que diz respeito à dinâmica operativa dos departamentos, controller é um especialista na obtenção de sinergia inter-sistêmica. Portanto, como especialista, situa-se dentro do sistema-global-empresa, e, como generalista, fora do sistema físico. Qualquer troca de posição trará, em consequência, a disfunção do órgão.

Como se vê, o relacionamento entre os especialistas, os generalistas e os sistemas é de capital importância. Com base no que temos sentido, até agora, em torno da pilotagem dos sistemas, tentemos ordenar algumas idéias a respeito do assunto:

1º — todo especialista é, em certa dose, um generalista, e reciprocamente;

2º — o Índice de especialização aumenta, da periferia para o centro, no modelo circular de pilotagem; e, reciprocamente, o Índice de generalização diminui, no mesmo sentido.

==== A Curva do Conhecimento Humano

Existe, dessarte, uma relação funcional explícita, decrescente, entre as variáveis que representam, no mesmo processo de medida do conhecimento humano, os Índices de contribuição do que é específico e do que é geral. Tal relação é passível de representação matemática através de um modelo da forma Y = f (X), de imagem cartesiana como a da figura 16, na qual a envolvente pode ser tomada como a Curva do Conhecimento Humano.

#figura-16()

Examinando-se a natureza dessa curva, especialmente quanto à existência de duas assíntotas, verifica-se que para cada acréscimo dx ocorre uma redução dy, e que, para valores infinitos de X e de Y, a especialização e a generalização assumem, respectivamente, valores absolutos. Em consequência, é de se admitir que:

1º — a partir de certo ponto, a horizontalização do conhecimento se faça em detrimento da visão global do processo. O especialista, em tal índice de saturação, enxergará as árvores sem ver a floresta;

2º — a verticalização do conhecimento, reciprocamente, induzirá o generalista a enxergar a floresta sem ver as árvores.

A importante ilação que se extrai de tudo isso é que, para cada tipo de atividade, há-de existir uma dosagem ideal entre os vetores que definem o conhecimento geral e o conhecimento especializado requeridos.

Enquanto não se destruiu o mito da especialização exacerbada — etiologia da síndrome antiprogresso — não se retomou a trajetória do verdadeiro desenvolvimento científico.

Para encerrar, apresentamos, na figura 17, o quadro elaborado por Fayol#footnote[_Henry Fayol, Administração Industrial e Geral, p. 24._] para mostrar a importância, relativa, da especialização no exercício de função técnica em uma empresa industrial.

#figura-17()

A correlação entre a concepção de Fayol, os níveis de pilotagem e a dosagem especialista/generalista aparece nitidamente, ao mais superficial exame. Deixamos por conta do leitor um exame mais acurado, sob os três enfoques citados, certo de que há, ainda, muita inferência interessante a ser extraída.

==== 3º nível — EVOLUÇÃO

A aplicação dos princípios de pilotagem até agora estudados — operação e gestão — se fez sobre o modelo cibernético da figura 10, reconhecidamente incompleto. Recordemos que este modelo, não sendo capaz de deter os efeitos de uma perturbação, inusitada, no universo exterior, sucumbiu à entropia alimentada pela variedade proliferante.

Consideremos, agora, para efeito didático, que o modelo teria, através da evolução, superado a dificuldade, apresentando-se com a estrutura da figura 18, a que daremos o nome de "modelo evoluído".

#figura-18()

O "modus faciendi" da evolução do modelo constituirá objeto da análise que faremos do 3º nível de pilotagem.

Recordemos, ainda, que, anteriormente, assim nos referimos à preocupação do modelo quanto à formulação de possíveis estratégias de proteção: "o ideal seria que os sistemas de gestão fossem projetados com uma reserva de capacidade que lhes permitisse fazer face a quaisquer perturbações ambientais, mas já vimos que, na prática, isto é impossível por não ser economicamente viável. Tanto os sistemas artificialmente criados, como os sistemas naturais, são arquitetados para correr um risco calculado; tal é a razão pela qual, todos eles, naturais e artificiais, desenvolvem mecanismos sensórios de captação, o mais aprioristicamente possível, de estímulos aferentes nociceptivos, os quais serão analisados, em tempo útil, para a formulação de estratégias destinadas à proteção do sistema"...

Examinando o modelo evoluído (Fig. 18), vemos que sua estrutura conta, agora, com um novo bloco, EVOLUÇÃO (Ev), cuja função é atuar sobre Ge deflagrando duas formas de ação: supletiva, que consiste em corrigir os eventuais desvios das VE que terão excedido a capacidade de regulação e controle de Ge#footnote[_A ação supletiva de Ev tem, em certos casos, caráter didático, no sentido de reciclar os conhecimentos de Ge._]; complementar, que consiste em estabelecer parâmetros de desempenho, cada vez otimizantes, na medida em que o sistema vai-se tornando mais apto, pelo aprendizado, e, consequentemente, passa a apresentar capacidade ociosa.

O modelo circular de pilotagem em três níveis apresenta-se conforme a figura 19.

Do modelo depreende-se, imediatamente, que Ev envolve Ge e Op, isto é, da mesma forma que não pode haver gestão sem operação, também não pode haver evolução sem gestão.

Voltemos à ameba — a eterna ameba! — exemplo de pilotagem no nível único, operação.

Dos primeiros organismos vivos que habitaram a face da terra, a ameba continua apresentando, até hoje, a mesma constituição física e o mesmo desempenho fisiológico de seus ancestrais primevos. Em termos de evolução biológica, nada, absolutamente nada! A razão de continuar presente no contexto ecológico, perante o qual se apresenta, aparentemente, inerme e desprotegida, deve-se, como vimos, ao dom, que possui, de ir-se subdividindo toda vez que atinge a maturidade física.

#figura-19()

Tais protozoários constituem o único exemplo de ser vivo, e a exceção confirma a regra, capaz de perdurar, eternamente, sem evoluir, e, não evoluem, pela simples razão de não possuírem ponte de ligação entre o primeiro e o terceiro nível de pilotagem. A inexistência de sistema nervoso, organizado, na estrutura física desses seres unicelulares não lhes propicia ir além do nível elementar, operação.

Sem intenção de polemizar, mas por contrariar, frontalmente, princípios de cibernética, não podemos deixar de expender algumas considerações a respeito do seguinte trecho, extraído da obra de Jacques Monod, "O Acaso e a Necessidade", por sinal inserto no capítulo intitulado "Cibernética Microscópica".

Diz Monod#footnote[_Op. cit, p. 93_]: É sobre tais bases (o acaso e a necessidade#footnote[_A observação entre parênteses é nossa, não consta do original._]), e não sobre uma vaga "teoria geral dos sistemas", que se nos torna possível compreender em que sentido bastante real, o organismo, com efeito, transcende, observando-as, as leis físicas para ser mais que demanda e realização de seu próprio projeto.

Em primeiro lugar, sem a "vaga teoria geral dos sistemas" (sic) inexistiria a cibernética, adjetivada de microscópica, com que Monod entendeu batizar o capítulo citado. Mas o mérito da questão não é defender Bertalanffy, "malgré ceci" consagrado mundialmente, inclusive na própria França, de Monod; é, sim, refutar a prevalência do acaso, que implica total detrimento do desejo insatisfeito da espécie na realização de seu próprio projeto.

A prevalecer a tese de Monod — já que a necessidade de evoluir é inerente a todas as espécies — por que razão misteriosa a ameba estaria, até hoje, condenada a um injusto conservantismo, causado pela teimosia do acaso em não contemplá-la com a loteria do progresso biológico? Por outro lado, por que não considerar a evolução como uma resposta inteligente da espécie — que não despreza a ajuda do acaso — aos reclamos do desejo, insatisfeito, exacerbado pela necessidade de se opor às agressões e de aproveitar as motivações positivas do contexto ecológico? O leitor já pensou no fato de os sistemas artificialmente criados — dentre eles a empresa — que a observação demonstra serem bem sucedidos na medida em que imitam os sistemas orgânicos, vivos,#footnote[_Bertalanffy, TEORIA GERAL DOS SISTEMAS. Ver bibliografia._] confiarem a sua evolução ao acaso e à necessidade, cruzando os braços para a pesquisa e o desenvolvimento?

Retomemos o fio da meada...

Outro aspecto que se depreende do modelo circular de pilotagem é que Ev somente poderá atingir SF depois de atravessar Ge e Op. Esta é uma característica, do modelo, imposta pela lei da escassez, pois, sendo escassos os recursos da natureza, a economicidade torna-se um imperativo de sobrevivência. Enquanto o sistema físico for capaz de exercer seu papel, vegetativamente, não há porque investir em mudança. O fator necessidade é preponderante.

Ev atingirá SF sempre que necessário, mas passo a passo, nunca por saltos ("natura non facit saltus", diziam os romanos). Ao atuar sobre Ge, alterando planos de ação e programas, modificando VA, enfim, na medida em que submete Ge a um exame crítico, Ev vai criando na organização as motivações que irão suscitar o interesse pelo desenvolvimento organizacional, que é, em última análise, o princípio motor e inteligente da evolução. Pouco, muito pouco, é obra do acaso.

Para o completo entendimento do "modus faciendi" da evolução, resta, finalmente, examinar aquilo que denominamos de mecanismo sensório de captação de estímulos aferentes nociceptivos, e que, como dissemos, faz parte da constituição de Ev.

Examinemos, inicialmente, o sensório, que, em biologia, constitui a parte do córtex que recebe e coordena todas as impressões transmitidas aos centros nervosos inferiores. Esta definição satisfaz, plenamente, à cibernética, "mutatis mutandis": córtex por Ev; Op e Ge por centros nervosos inferiores.

A constituição anatômica de um sensório cibernético#footnote[_O modelo de sensório cibernético é de Stafford Beer, em CIBERNÉTICA NA ADMINISTRAÇÃO. Ver bibliografia._] está representada na figura 20. Como se vê, trata-se de um sistema orientado para o propósito de receber e coordenar impulsos, melhor dizendo, a máquina sensória.

Examinemos, em detalhe, os transdutores e o retículo anastomótico, os dois principais dispositivos da máquina sensória.

#figura-20()

===== Transdutor

Etimologicamente a palavra é composta do prefixo latino "trans", que significa, ao mesmo tempo, "para trás" e "para além de"; e do radical "ducto", que significa "conduto", "canal".

A origem da palavra propicia o seu emprego com os dois significados distintos que a fisiologia exige:

1º — os transdutores de entrada, ou sensores, têm a finalidade de receber e de empurrar para trás os impulsos aferentes, fazendo-os percorrer o SIC em direção à placa sensitiva;

2º — os transdutores de saída, ou efetores, têm a finalidade de receber, vindos da placa motora, pelo MOC, os impulsos eferentes, e de empurrá-los para além desse canal, isto é, para os centros nervosos inferiores.

A fisiologia indica que os transdutores são elementos dotados de especialização, isto é, treinados para separar os impulsos por conjuntos afins de variáveis, indicando-lhes condutos específicos de trânsito pelo SIC e pelo MOC. O número de transdutores que a máquina sensória deve possuir é, logicamente, função da variedade do sistema a ser operado.

Suponhamos um sistema capaz de assumir 1.024 estados diferentes. Sendo V=1.024, o logarítmo na base dois de V, que é igual a 10, indica a quantidade de informação#footnote[_A quantidade de informação Log₂V é medida em BINARY DIGIT (dígitos binários), abreviadamente "BIT". A origem da expressão decorre da lógica de decisões binárias desenvolvida pela teoria da informação._] que Ev deverá ser capaz de processar para que possa controlar o sistema. Como vimos, as informações chegam ao sensório através dos transdutores de entrada, sendo encaminhadas à placa sensitiva; em seguida, atravessam o retículo anastomótico e são impulsionadas, pela placa motora, até os transdutores de saída. Cada placa, portanto, deverá ter capacidade para acolher 5 bits de informação, exigindo, a seu serviço, respectivamente, 5 efetores e 5 sensores.

Os transdutores são, em última análise, redutores de variedade.

===== Retículo Anastomótico

Etimologicamente o significado é de "pequena rede que liga dois espaços ou órgãos distintos", evidentemente que as placas sensitiva e motora.

No interior do retículo anastomótico, que, como vimos, exerce função análoga à do córtex cerebral, as informações que viajam no bojo dos impulsos aferentes são processadas e, em seguida, encaminhadas, através do MOC, para fora de Ev. A este trabalho — processar informações — se dá, em cibernética, o nome de "função de transferência".

O "modus faciendi" da transferência das informações brutas, que entram no retículo anastomótico, em informações processadas que saem, tanto é um relativo mistério em se tratando de sistemas orgânicos (referimo-nos ao cérebro, neste caso), quanto em se tratando de sistemas artificialmente criados, especificamente a empresa. O que se passa na cabeça de seus diretores? O que entra, conhece-se; o que sai, também. Mas a função de transferência é um mistério insondável.

Em decorrência disso criou-se, em cibernética, o conceito de "caixa negra". A caixa negra é um dispositivo do qual se conhecem as entradas e as saídas correspondentes, de forma que se pode estabelecer uma relação ou mesmo um modelo matemático, que permita, conhecidas as entradas, prever-se as saídas. Acoplando-se à caixa negra um mecanismo de feedback obter-se-á a auto-regulação do sistema.

Resta, finalmente, esclarecer a razão do termo "anastomótico", cuja acepção está ligada à palavra rede. Ele indica que o caminho do impulso, no interior do retículo jamais poderá ser recomposto, pois a rede de condutos, de possível trânsito, forma uma combinação de número praticamente infinito de termos. Mais uma razão para que se considere o retículo anastomótico uma caixa negra.

===== Fisiologia da Evolução

Podemos, já, passar à fisiologia da evolução. Observemos a figura 21 (Esquema de ultra-estabilidade).

Os objetivos fixados por SG em SF (variáveis essenciais) são aferidos no marcador, "0", que comunica eventuais desvios (desempenhos altamente positivos são considerados, também, desvios servindo para alertar que o sistema está subempregado) a Ct e a Ev, este último por intermédio de seu próprio marcador, "OE".

A ação de Ev sobre o sistema operado se faz em tempo real, injetando, neste, através de Ge, objetivos de evolução (OE), os quais são, permanentemente, aferidos, processados e transferidos, por intermédio do sensório, para os centros inferiores, que deles devam conhecer. É importante notar que tudo isto se faz sem limitar a autonomia de que é dotado SG: as ações de Ev são, assim, supletivas e complementares, como vimos.

Iniciemos o ciclo operativo de Ev no instante em que impulsos, provindos de O, são aferidos por OE. Se estes impulsos tiverem intensidade suficiente para excitar OE#footnote[_OE é dotado de uma espécie de relê, que somente se arma quando o impulso é capaz de posicionar a seta em região anormal. O valor mínimo do impulso mede a autonomia de Ge._], serão passados aos sensores, que irão transduzí-los, para, em seguida, encaminhá-los, pelo SIC, à placa sensitiva, que é uma espécie de ante-sala onde uma zelosa e vigilante secretária registra, em seus arquivos#footnote[_Este arquivo é de capital importância para Ev, pois faz parte de sua memória, sendo fator fundamental para que o sistema "aprenda", sem o quê não haverá evolução._], as variáveis afins que chegam e aguarda ordem do sensório para sua introdução no retículo anastomótico.

Processada a função de transferência, a placa motora deflagra a ação, através do MOC, pelos efetores, que são homólogos aos sensores em termos de especialidade.

A ação deflagrada atua, sobre o sistema operado, sob a forma de objetivos de evolução, os quais são, permanentemente, controlados, num processo de auto-regulação por feedback. Recordemos que Ge (2º nível) vale-se, também, do mecanismo de feedback em busca de auto-regulação. Agora, entretanto, o processo de auto-regulação é muito mais eficiente, pois tem o caráter de supletividade e complementaridade a que nos referimos antecipadamente. Dessarte é de esperar-se que a estabilidade do sistema seja atingida quaisquer que sejam as condições adversas sob as quais se apresente o universo exterior, pois, na medida em que ele, paulatinamente, vai-se adaptando às condições mutantes de UE, aprende e se torna cada vez mais apto para enfrentar a variedade proliferante.

#figura-21()

A este homeostato cibernético dá-se o nome de "ESQUEMA ULTRA-ESTÁVEL DE ASHBY", em homenagem ao grande ciberneta inglês, William Ross Ashby. (Ver Fig. 21).

==== 4º nível — MUTAÇÃO

Já terá sido notado, a esta altura, que as ações de pilotagem vão-se tornando cada vez mais intuitivas — sem que percam, logicamente, a racionalidade — na medida em que se caminha do centro para a periferia do modelo (Figura 22).

O entendimento do mecanismo de mutação implica aspectos de evolução que convêm recordar, antes de prosseguir.

Dissemos que, "ao atuar sobre Ge, alterando planos de ação e programas, modificando VA, enfim, na medida em que submete Ge a um exame crítico, profundo, Ev vai criando na organização as motivações que irão suscitar o interesse pelo desenvolvimento organizacional, que é, em última análise, o princípio motor e inteligente da evolução".

Por envolver Ev, Mt sofre influência da atuação deste último sobre Ge, atuação que, não apenas, fiscaliza, mas, também, e principalmente, utiliza como base para seus prognósticos a respeito de futuro do sistema. Para tanto, o mero exercício da razão, dedutiva ou indutivamente, será insuficiente. Há necessidade de uma óptica mais profunda, que somente a intuição pode proporcionar.

#figura-22()

Mas, é lícito indagar, o exercício do 4º nível de pilotagem é condição imprescindível à sobrevivência do sistema?...

Tomemos alguns exemplos, abrangendo sistemas orgânicos, vivos e sistemas artificialmente criados.

A ameba, nossa velha conhecida como exemplo mais frisante de conservantismo biológico, existe, ainda, por obra e graça de seu misterioso dom de subdividir-se, embora seja incapaz de intuir, inteligentemente, a natureza das mutações que a necessidade lhe sugere e com as quais o acaso lhe acena, em vão, "per omnia secula seculorum"...

O mamute é, hoje, apenas uma preciosidade arqueológica, banido que foi do nicho ecológico. Grande demais, extremamente vulnerável, o simples faro não foi suficiente para guiá-lo pelos tortuosos caminhos da mudança.

E o homem? Inegavelmente é o animal que mais mudou no contexto biológico. Vive sob todos os quadrantes, sob o frio e o calor escaldante. Dotado de intuição inteligente (o pleonasmo é para reforçar a idéia!), dirige, inconscientemente, segundo os reclamos do contexto em que vive, seus mecanismos próprios de adaptação, evoluindo, a curto e a médio prazo, no plano ontogenético, sem se descuidar, todavia, de projetar, no arcabouço filogenético da espécie, todas as conquistas feitas.

E a empresa? Enquanto o homem é uma unidade biológica no habitáculo da espécie, a empresa é uma unidade microeconômica em um universo macroeconômico. A sua capacidade de mudar, no momento oportuno e de acordo com as injunções, presentes e futuras, é, talvez, a única garantia de sua sobrevivência, e repousa na visão, quase profética — intuição — de seus dirigentes.

=== 3.5. Anatomia da Pilotagem

Este capítulo — Pilotagem dos Sistemas — não poderá encerrar-se sem que se diga alguma coisa a respeito de uma suposta anatomia da pilotagem.

Em que órgãos, dotados de que constituição anatômica, apoia-se a pilotagem?...#footnote[_Os organogramas omitem totalmente os aspectos relativos à pilotagem, enquanto os fluxogramas, mas, quando muito, servem para explicitar as variáveis de ação (Ver nota 5, p. 20)._]

A quantidade, inumerável, de sistemas de que a cibernética se ocupa e a extrema diversidade dos conjuntos constituintes desses sistemas torna, se não desaconselhável, por certo destituída de interesse prático a formulação de estereótipos de pilotagem para cada família de sistemas, de per si. A universalidade do campo de atuação desta ciência oferece, entretanto, a chave para a escolha de modelo anatômico de pilotagem que se preste para uso geral. E esse modelo é o neurofisiológico, conforme se infere da própria definição de cibernética.#footnote[_No discurso que pronunciou, em 23 de junho de 1900, na sessão de encerramento do Congresso Internacional de Minas e Metalurgia, em Paris, Fayol teve a antevisão (ou melhor, a intuição...) do modelo animal e sua analogia com a estrutura organizacional das empresas. É, exatamente aí, o marco inicial da administração científica._]

==== Os Pródromos do Modelo

A analogia, entre a empresa e o organismo, é tão flagrante que as teorias que, no passado, tentaram desvendar o mistério da mente humana parecem ter sido as mesmas que os administradores da fase pré-científica usaram para explicar a localização do poder decisório, e o seu funcionamento, na estrutura empresarial.

Abriremos uma concessão à natural curiosidade do leitor para ingressar, de novo, no campo da história e da filosofia.

O mistério da mente humana foi causa de grandes controvérsias no passado, e como não poderia ter deixado de acontecer, colocou Platão e Aristóteles em campos opostos.

Para Platão, a alma — sede da mente — relacionava-se, apenas, com as idéias puras e não tinha função senciente, apesar de residir no cérebro e constituir a parte racional da dicotomia corpo e alma. As outras duas partes, com função senciente mas não dotadas de racionalidade, destinadas a ligar o corpo às coisas terrenas, seriam a "irascível", situada no peito, e a "apetitiva", situada nas entranhas.

Aristóteles, por sua vez, achava que a atividade mental do homem localizava-se no coração, órgão a um só tempo senciente e inteligente, capaz, por isso mesmo, de exercer a faculdade da razão tendo o sentimento como inspirador de todo processo.

A estrutura da empresa medieval — o feudo — inspirou-se na dicotomia corpo/alma de Platão.#footnote[_Embora aristotélica nas questões escolásticas, a igreja sempre se mostrou platônica em assuntos seculares. Daí, o "direito divino dos reis"..._]

O corpo — espaço geográfico — era habitado pela alma, composta de:

— nobreza e clero, parte racional;
— intendentes e guerreiros, parte irascível;
— lacaios, servos e camponeses, parte apetitiva.

A realidade socioeconômica da época medieval apresentou-se, em decorrência de tal modelo, extremamente injusta, pois a parte pretensamente racional, detentora da propriedade material, por sua natureza não senciente voltava-se, apenas, para a contemplação de Deus, o gozo e a fruição de um paraíso terreno consentido pelo direito divino dos reis. Assim, o clero e a nobreza mantinham-se numa cômoda posição, de alheamento ante as privações que acometiam os servos, lacaios e camponeses, jugulados pelo poder irascível, este, insaciável em colher resultados materiais e implacável em punir os descontentes e os reformistas.

A Revolução Industrial, ao multiplicar os fatores de produção, causando o deslocamento, do campo para a cidade, do centro da atividade econômica, tornou perigosa e, logo em seguida, inviável, a atitude meramente contemplativa e de eterna fruição, dos detentores da riqueza, que, ou passaram à administração direta de seus bens, ou perderam-nos, para sempre.#footnote[_Sob o regime feudal o capital era representado, na sua maior parte, por bens imóveis: as terras agricultuáveis e os recursos naturais, pertencentes ao clero e à nobreza. Com a revolução industrial o capital distribuiu-se, necessariamente, por máquinas, equipamentos, estoques, etc. Estes, são bens móveis, suscetíveis de serem mudados de lugar, e, consequentemente, mais sujeitos ao roubo e à dilapidação._]

O racional tornou-se, assim, senciente, abrindo-se uma via direta de comunicação entre a força de trabalho e o capital. O resultado, mais imediato, desse novo tipo de relacionamento foi a erradicação do trabalho escravo e o início de uma era de conquistas sociais por parte das classes menos favorecidas.

==== Neurofisiologia Cibernética

Recordemos que a cibernética adotou, como modelo de comunicação e controle, o organismo animal (mais especificamente o sistema nervoso humano). Não foi, então, sem um propósito definido que, em inúmeras oportunidades, tenhamo-nos valido da analogia entre os sistemas orgânicos e os outros sistemas onde essa analogia existisse. E foi, precisamente, em termos de comunicação e controle, que a analogia se fez efetiva, surgindo, daí, a neurofisiologia cibernética.

Indo, de forma direta, ao propósito de recolher a maior quantidade possível de ensinamento, tendo como base o modelo neurofisiológico, façamos coincidir, sobre um corte vertical do sistema nervoso, os quatro níveis de pilotagem, conforme mostra a figura 23.

#figura-23()

Observe-se que há um eixo de comando central, que vai do córtex à base da medula, e um eixo de comando lateral, que se articula, funcionalmente, com o bulbo e a extensão medular, através de interoceptores.

O eixo de comando lateral é constituído pelo sistema nervoso vago-simpático, que se desdobra no simpático e no parassimpático, ambos representados, na figura 23, com linhas pontilhadas.

O eixo de comando central trabalha com informação volitiva, de comando; o eixo de comando lateral, informação servomotora autônoma.

No primeiro nível, operação, preponderaram as ações do vago-simpático, excitando e inibindo a dinâmica das partes componentes do sistema físico em busca do equilíbrio homeostático. Mas Op tem, à sua disposição, no eixo de comando central, canais para o trânsito de informações ascendentes/descendentes, podendo deflagrar ações motoras, volitivas, em decorrência de estímulos nociceptivos aferidos através dos interoceptores. Qualquer estímulo nociceptivo, aferido em Op, passará pelo seguinte processamento#footnote[_As três ações são, praticamente, simultâneas, mesmo porque o sistema precisa operar em tempo real._]:

— em primeiro lugar, será objeto de filtragem, nos sensores, a fim de ser enquadrado no respectivo conjunto afim de variáveis; dessa filtragem resultará substancial redução de variedade;

— em segundo lugar, ensejará a resposta, volitiva, que deflagrará a ação motora, corretiva, através dos efetores;

— em terceiro e último lugar, será objeto de registro na "memória" de Op, enviando-se breve notícia da ocorrência a Ge. Este registro é que faculta a absorção de experiência.

No segundo nível, gestão, as intervenções, apesar de contarem, ainda, com certa autonomia, são, em sua maior parte, deflagradas a nível de consciência. A intervenção, volitiva, de Ge sobre Op ocorre quando estímulos nociceptivos, apesar de reduzidos em sua variedade, conseguem romper o bloqueio sofrido no primeiro nível, atingindo o segundo nível não apenas como informação processada, mas, como ameaça à estabilidade do sistema. Este baluarte deve resistir o mais que puder. Os problemas, internos, de regulação e controle, precisam ser esgotados neste nível, a fim de que Ev possa dedicar a maior parte de seu tempo ao pleno exercício de sua atividade precípua, que é vital para o sistema.

Suponhamos que, em dado instante, o centro de controle bulbar, responsável pela auto-regulação, autônoma, do sistema vago-simpático, entre em crise, causada pelo estado de um feedback positivo ingovernável#footnote[_Os feedback corretivos de erro são, pela natureza do próprio mecanismo, negativos. Os feedback positivos atuam num efeito multiplicador de aumento do erro tornando-se ingovernáveis e conduzindo o sistema à autodestruição. Ver ao final apêndice intitulado feedback._]. O segundo nível dispõe, ainda, de uma reserva estratégica, para ser empregada em situações realmente críticas, como a que acabamos de, hipoteticamente, criar. Esta reserva é constituída pelo diencéfalo e os gânglios basais, uma espécie de "assessoria especial", do terceiro nível, voltada, também, para problemas do segundo nível, a respeito dos quais tem poder decisório, podendo deflagrar ações volitivas, de comando, com caráter corretivo.

A ponte filtra as informações que chegam ao centro de controle bulbar, provindas das vias laterais e central, e as repassa aos gânglios basais, já agrupadas por conjuntos afins de variáveis, o que terá propiciado considerável redução de variedade. Neste instante o controle é avocado, ao nível da consciência, pela assessoria especial, que, pelo eixo de comando central, responde, via descendente, com os necessários comandos corretivos. E isto se faz, na maior parte das vezes, sem intervenção direta do córtex, que, apenas, registra a ocorrência.

A atuação da faixa cortical, do terceiro nível, evolução, em questões "interna corporis" é, portanto, reduzida. O papel de Ev é garantir a homeostase externa do sistema, num esquema de permanente ultra-estabilidade, que requer, como vimos, contínua adaptação às condições, muitas vezes, extremamente mutantes, do Universo exterior. E é para perscrutá-lo, recolhendo dados fidedignos para a formulação de estratégias de proteção, à médio e longo prazo, consubstanciadas em objetivos de evolução fixados com estrita observância do potencial sistêmico e das injunções "externa corporis", que Ev é dotado de exteroceptores — doze pares de nervos cranianos, aferentes e eferentes — que transmitem suas impressões ao córtex, via gânglios basais e diencéfalo, sua assessoria especial. Esta assessoria constitui, portanto, uma espécie de computador central, com terminais espalhados por todo o sistema, e servido por computadores menores, especializados, admiravelmente localizados ao longo do eixo de comando central.

O córtex, servido por este prodigioso dispositivo informático#footnote[_Entendemos por Informática a relação entre as informações, os computadores e os sistemas. Esta expressão — informática — tem sido empregada, frequentemente, num sentido estrito, como se devesse referir-se, unicamente, ao processamento de dados, o que é uma meia verdade. Voltaremos ao assunto, mais adiante._], orgulhosamente cônscio de sua condição de "brain-trust" de todo o sistema, reserva-se para a tomada das grandes decisões, e o faz, sempre, com invulgar sabedoria, oportunidade e determinação.

O quarto nível, mutação, conforme evidenciado na figura 23, conta com reduzido substrato anatômico, nele preponderando espaço extra-cortical, palco das grandes "revelações"... o sentido único, descendente, da seta, diz, muito, da fisiologia da intuição, que já foi objeto de amplas considerações anteriores.

Para encerrar este tópico, relativo à Anatomia da Pilotagem, apresentamos a figura 24, que nos parece ser a imbricação do modelo neurofisiológico com a organização empresarial. As conclusões — e há muitas, a serem extraídas — deixamos por conta do leitor.

#figura-24()

==== Os Críticos do Modelo

Os críticos do modelo neurofisiológico — evidentemente que não os há entre os cibernetas — reagem à ideia de que a empresa, tal como o organismo, deva aproveitar-se, ao máximo, da faculdade de agir autonomamente, e que a cada nível da hierarquia de controle deva corresponder um grau, equivalente, de autonomia. Estes, postulam uma administração altamente centralizada, e pensam que o computador tornará isto possível, como uma máquina milagrosa, capaz de lhes proporcionar recursos técnicos para a resolução de todos os problemas em qualquer nível.

A principal desculpa, engendrada pelos críticos do modelo, que, no fundo, nada mais são que misonéistas empedernidos, seria uma inevitável perda, pela alta administração da empresa, da autoridade hierárquica, perigosamente adjudicada a comandos inferiores. Parece configurar-se uma reação, inconsciente, causada por temor, infundado, de que o autômato venha a substituir o homem#footnote[_Tem-se, como real, o seguinte diálogo, travado entre Henry Ford e Edgar Reuter; o primeiro, que dispensa apresentação, e, o outro, temido e respeitado líder sindical americano dos anos 50. Ford teria convidado Reuter para conhecer a nova linha de montagem de sua fábrica de automóveis, em Detroit. De uma galeria, de onde se divisava imenso parque fabril, em intensa atividade, porém semi-deserto, Ford dirigiu-se ironicamente, a Reuter: — "Neste departamento substitui mil operários por 50 robots. Já pensou quantos dólares de contribuição o seu sindicato deixará de arrecadar?"... Resposta de Reuter, imperturbável: — É verdade. E você, já pensou para que vai vender seus carros?"..._], em todas as funções, e de que, assim, possa vir a se tornar realidade a "Revolta dos Robôs", da ficção de H. G. Wells.

A melhor maneira de fazer com que estes céticos mudem de opinião, é, em primeiro lugar, dar-lhes a conhecer o modelo, pois, se ouviram falar dele, com toda certeza não chegaram a entendê-lo. Em seguida, é preciso desfazer algumas falácias, fruto de uma visão distorcida do que sejam os novos horizontes, abertos para o homem, em todos os campos do saber, pela cibernética.

==== A Falácia do Robô

A primeira noção, falsa, a ser afastada é a de que autonomia, automatismo e automação constituem a mesma coisa, e que implicam, consequentemente, robotização, quaisquer que sejam os disfarces sob os quais se apresentem.

É bem verdade que o simples tratamento etimológico será insuficiente para estabelecer a distinção cabal entre estes termos, quanto à acepção segundo a qual devem ser empregados, mas, um exercício de semântica, em que sejam observados os princípios básicos da cibernética, lançará forte luz sobre as trevas da falácia.

Autônomo é o que traça suas próprias leis. Todo autômato é programado aprioristicamente (voz passiva); não possui, portanto, autonomia. Mas possui automatismo. Novamente, em auxílio da semântica, a sugestiva frase de Herrick: "As propriedades atribuídas a qualquer objeto são, em última análise, nomes para seu comportamento". Automatismo, propriedade; autômato, nome... Como propriedade, estende-se a qualquer mecanismo (não apenas aos autômatos) que seja dotado de uma ou mais funções de transferência. Exemplo: o feedback, que corrige, automaticamente, o erro, e não é um autômato, nem é autônomo (é programado pela função de transferência).

É preciso considerar, ainda, que, em cibernética, não existe autonomia absoluta, pois a cada nível da hierarquia de controle corresponde um grau equivalente de autonomia. Nem mesmo o mais alto grau hierárquico da empresa é totalmente autônomo; é o que possui maior autonomia, mas sujeita a restrições, impostas pelo sistema maior, cujos componentes, básicos, são a sociedade política, econômica e institucionalmente organizada e os recursos naturais.

A robotização do homem jamais ocorrerá, por maior que seja a autonomia da empresa, o automatismo de suas máquinas e de seus mecanismos de feedback, e a automação de seus bens de produção.

Por outro lado, não há razão lógica para se pensar que somente a máquina é totalmente determinada, e que a instabilidade do homem, quanto aos seus desígnios, é uma razão a mais para que se lhe cerceie, ao máximo, a autonomia, ao longo das hierarquias de controle.

Injusta "capitis diminutio" para o espírito humano! É verdade que a máquina (e especificamente como sistema mecânico), mercê do mecanismo de auto-regulação por feedback, é perfeitamente determinada, mas o grau de incerteza do homem somente é elevado quando as variáveis de seu comportamento emanam do livre arbítrio, isto é, do direito, que lhe é assegurado, de decidir a respeito de seu próprio destino. O "Homo faber", como um fator de produção, é perfeitamente determinado, ou, pelo menos, determinável dentro de limites compatíveis. E apresenta uma grande vantagem com relação à máquina: dotado de juízo de valor#footnote[_Eis aí a grande vantagem do homem sobre a máquina: embora ambos sejam dotados da propriedade teleonômica, isto é, o seu projeto tem como variáveis dependentes métodos, meios e fins adrede e aprioristicamente definidos, o homem é capaz de adaptar o seu projeto às condições mutantes do Universo exterior em função do juízo de valor, atributo que lhe é, e somente a ele, inerente._] — senso estético, para ser mais específico — que a máquina não é capaz de discernir, o seu produto "in natura", artesanal, tem prevalência, para o gosto requintado, sobre o mais burilado artefacto.

A máquina não é mais que uma eficiente ferramenta, criada pelo homem, para explorar, segundo uma destinação inteligente, que é fruto da sabedoria da espécie, os recursos que a natureza prodigamente lhe concede. No binômio homem/máquina, ao primeiro caberá, sempre, a primazia.

==== Uma Falácia da Informática

A segunda falácia, que precisa ser desfeita, refere-se à informática, ou melhor, aos usos e abusos do computador na empresa.

Quando, no capítulo segundo, falávamos de energia, entropia e informação, com ênfase na lógica de decisões binárias, estávamos assentando, de propósito, as bases teóricas do emprego dos computadores como máquinas cibernéticas. Ao abordarmos, já no capítulo terceiro, a anatomia e a fisiologia do sensório a serviço de Ev, dávamos as linhas gerais o fundamento científico da mecânica do computador. Ainda no terceiro capítulo, no tópico Neurofisiologia Cibernética, foi pintado um quadro em que a informática, em sua verdadeira acepção, aparece em plano privilegiado, como o principal instrumento de tomada de decisões por parte do "brain-trust" da empresa, metaforicamente comparado ao córtex cerebral. Mas, observe-se, referimo-nos à informática em sua verdadeira acepção, que envolve, necessariamente, o conjunto afim de variáveis informação-computador-sistema#footnote[_Convém que o leitor se recorde do conceito de informática: trata da relação entre a informação, o computador e o sistema._].

A falácia da informática, sobre cuja natureza passaremos a tecer considerações dentro em pouco, decorre, precisamente, do fato de ser, ela encarada, "stricto sensu", como o emprego do computador, quando a informática é, na realidade, muito mais do que isto. A ênfase no computador gera um enfoque sob o qual o analista de sistemas exorbita de sua vocação, inata, de analista do computador como um sistema-em-si, para o de analista das informações que transitam no interior do sistema empresarial, o que é coisa muito diferente#footnote[_É preciso que dois aspectos fiquem bem esclarecidos: 1º — que o emprego, indevido, do analista de sistemas — cuja função deve restringir-se aos sistemas de computação — não é culpa sua e sim de quem lhe impõe uma missão própria, que deve ser confiada a um informático que conheça a natureza e as particularidades do sistema a ser beneficiado com processamento de dados; 2º — que a falácia da informática se refere à administração industrial. É inegável que o setor terciário da economia brasileira tem-se beneficiado, enormemente, da contribuição da informática, que, no caso, vem cumprindo judiciosamente sua missão. O porquê do êxito em um setor e do fracasso em outro é assunto que escapa aos propósitos desta obra, mas o leitor já dispõe de dados para aferi-lo._]. Dotar de computadores uma empresa pensando que assim ela passará, automaticamente, a desfrutar dos benefícios da informática, é o mesmo que distribuir armas para milhares de indivíduos, com o propósito de constituir um exército, sem tê-los submetido, previamente, aos condicionamentos necessários à formação do espírito militar.

A informática constitui um dos principais campos da cibernética aplicada, por isso o informático deve ser, antes de tudo, um ciberneta. E, para atuar na administração industrial, ele precisa ter pleno domínio sobre as informações brutas, ainda não processadas, que transitam "interna corporis". Sem isso — lembremo-nos de que o "brain-trust" do modelo neurofisiológico exerce esse domínio, em toda sua magnitude — quebrar-se-ão, fatalmente, os elos da cadeia informática, surgindo a disfunção que tem caracterizado os usos e abusos do computador nas empresas industriais.

Valer-nos-emos de um exemplo real para ilustrar a natureza do que definimos como uma falácia da informática.

O exemplo reporta-se a um curso de extensão universitária, versando sobre o tema: "A Informática no Campo da Administração de Empresas", distribuído, pelo MEC, dentro de seu programa de aperfeiçoamento do ensino superior,#footnote[_A crítica é apenas ao enfoque dado ao assunto, em que pese a qualidade da matéria, excelente, e os elevados propósitos do tele-ensino._] sistema de tele-ensino (audio-visual).

Após uma introdução, muito bem feita, em que se mostrou com clareza a concepção mecânica do computador e o emprego da lógica de decisões binárias na função de transferência, passou-se ao objeto central do tema: a substituição, pelo computador, do pessoal empenhado nas tarefas tradicionais de elaboração da folha de pagamentos e do controle das contas correntes de terceiros...

Os futuros administradores de empresa sentiram-se frustrados, tal como, certamente, ter-se-iam comportado os empresários a quem, pelos altos custos do processamento de dados, fossem oferecidos tais serviços. Depois de tanta expectativa em torno da maior concepção do homem no século da ciência e da tecnologia, o cérebro eletrônico#footnote[_A metáfora "cérebro eletrônico" aplicada ao computador é de uma impropriedade absoluta. Observe-se que, no modelo neurofisiológico, o computador é um instrumento a serviço do "brain-trust", o córtex cerebral, com o qual não se confunde._] teve muito pouco a oferecer!

Mas, o que seria possível esperar-se, então?

Procuremos extrair algumas conclusões baseadas num exemplo de emprego do computador, pelos americanos, há trinta anos passados, em uma atividade de administração industrial. Poderiam ter sido escolhidos exemplos recentes, mas retroagimos três décadas, propositalmente, para ressaltar o atraso em que nos encontramos no campo da informática.

Os Estados Unidos iniciaram os anos 50 engajados numa intensa corrida armamentista com os russos. Estudos estratégicos de alta confiabilidade deram, como imperativo da manutenção da "pax romana", o lançamento, ao mar, no prazo de dez anos, de um protótipo de submarino nuclear, da classe polaris, o George Washington. Constituíam, por si sós, um grande desafio, agravado pelo relativamente curto espaço de tempo disponível:

— propulsão nuclear;

— combustível sólido para os mísseis de bordo;

— sistema de navegação submarina, a grande profundidade, sem referenciais de superfície;

— sistema portátil de orientação de inércia para os mísseis;

— ogivas nucleares, de efeito limitado, para emprego tático.

A satisfação de todos esses requisitos técnicos implicava a utilização de 10 milhões de itens, a serem encomendados a 11 mil fornecedores, cujas entregas deveriam obedecer, rigidamente, aos prazos sequenciais do projeto. A coordenação de tantos fornecedores, itens e prazos, era a maior dificuldade a ser superada.

Desenvolveu-se um método que se mostrou, teoricamente, capaz de controlar toda essa gama de atividades, com flexibilidade, inclusive, para a rocada de recursos de uma atividade, prejudicada pela eventual inadimplência de fornecedores, para outra atividade com folga em seu cronograma físico. Este método ficou conhecido como PERT ( Program Evaluation and Review Technic = Técnica de Revisão e Avaliação de Projetos). A rede PERT do polaris continha centenas de milhares de eventos, e consumira alguns quilômetros de papel embobinado.

Todas as atividades e eventos do PERT eram controlados por computador. A teoria, na prática, funcionou, e o George Washington foi lançado ao mar com uma folga de 40 dias sobre o prazo fatal.

Pode-se afirmar que o pleno êxito do Projeto Polaris deveu-se ao PERT, e que este método, dada a magnitude da tarefa global programada, só teve condições de aplicação devido ao computador. Outra coisa que se pode afirmar, ainda que intuitivamente pois não há dados a respeito, é que nenhum dos problemas a seguir mereceu preocupações maiores por parte dos pesquisadores e dos executores do projeto: elaboração das folhas de pagamento do pessoal do projeto e controle de contas a pagar!

O projeto Polaris consistiu, ciberneticamente, na concepção de um sistema de gestão dotado de variedade suficiente para operar um sistema físico extremamente complexo e cujas restrições ao estabelecimento de um permanente estado de ultra-estabilidade decorriam das probabilidades, acumuladas, de inadimplência por parte de onze mil fornecedores, responsáveis pela entrega de dez milhões de itens a serem aplicados no decurso de prazos sequenciais necessariamente rígidos e apertados. A descrição do sistema através de uma rede PERT que continha informações detalhadas sobre o desdobramento das suas sucessivas condições, no tempo e no espaço, possibilitou o emprego do computador como um instrumento, eficaz, de controle do projeto. Com isto, fechou-se o circuito informático — computador-informação-sistema — bastando que se acionasse o interruptor para que a máquina cibernética, movida com o audacioso propósito de construir o mais sofisticado engenho bélico do século XX, iniciasse, segura de si, sua marcha, inexorável, para a conquista do ambicionado objetivo.

O importante a ressaltar, do exemplo dado, é o abismo que separa o empresário brasileiro de seu colega americano no uso da informática. Aqui, a preocupação se concentra em questões de contabilidade financeira, que vêm ocupando, impropriamente, em detrimento de assuntos mais complexos, terminais de computadores. Nos Estados Unidos (há inúmeros exemplos, fiquemos, entretanto, com este, relativo à função contábil no campo da administração, por guardar relação com o tema do Curso) a informática é um valioso instrumento, a serviço da contabilidade gerencial,#footnote[_A informática contribuiu para que se desenvolvesse este segundo ramo da contabilidade, agora dividida em financeira e gerencial. Por financeira deve-se entender a que, tradicionalmente, cuida do registro sistemático dos atos e fatos administrativos, visando em última análise à determinação do crédito e à exata quantificação do patrimônio das fazendas. A principal característica da contabilidade financeira é a realização de registros "a posteriori", isto é, os lançamentos contábeis são feitos depois de ocorrido o fato gerador. Além disto, ela tem o caráter de obrigatoriedade, pois é através dela que o poder público e o corpo social controlam a situação dos negócios com relação, respectivamente, aos tributos a recolher e aos lucros a distribuir. A outra forma de contabilidade não tem caráter de obrigatoriedade, existindo até mesmo aqueles que consideram ser melhor administrar, empiricamente, ignorando os princípios da contabilidade gerencial. O principal objetivo desta é o controle, que tem como meta permanente a eficácia, pois propicia ao empresário o estabelecimento de alicientes e de incentivos à produtividade, baseados em fatores reais de desempenho, aferidos sob critérios objetivos e justos. Fixando aprioristicamente metas de desempenho-padrão, o controle é feito em tempo real, através de gráficos e listagens emitidos pelo computador, que mostra o desdobramento das sucessivas condições do sistema, segundo a relação custo/efetividade. Os eventuais desvios são corrigidos num processo de auto regulação por feedback, ao mesmo tempo em que são detectados os agentes que contribuem para o bom desempenho da empresa e os que atuam em sentido contrário, aos quais é aplicada a política de alicientes e incentivos, que prevê, também, sanções corretivas._] voltada para a otimização da performance empresarial. Lá, o emprego dos computadores como instrumento da contabilidade gerencial é tão efetivo que não sobram terminais ociosos em quaisquer das vinte quatro horas do dia. Os usuários que contam com folgas alugam os computadores a outras empresas, todas elas sequiosas por obter melhores níveis de desempenho operacional.

Não seria exagero afirmar que, dentro do elenco dos grandes problemas brasileiros, o do uso e abuso dos computadores — a falácia da informática — se insere forçosamente.

No mundo de hoje, em que as fronteiras políticas foram subrepticiamente transpostas pelas corporações multinacionais, a soberania das nações não se garante, mais, unicamente, pelas normas do direito internacional; precisa ser reconquistada de fato, diuturnamente, através de uma luta que se trava no campo de batalha da economia, contra exércitos cujas principais armas são a ciência e a tecnologia.

No Brasil, a ciência — cibernética — e a tecnologia — informática — estão atrasadas pelo menos três décadas com relação aos países do chamado primeiro mundo, que são, virtualmente, nossos inimigos nesta guerra "sui generis" do século XX.

Parece que a solução deste problema depende, em grande parte, de uma conscientização nacional a respeito das reais possibilidades da ciência cibernética e de sua tecnologia informática.

Para encerrar a primeira parte desta obra — à qual se seguirá um exemplo de como a cibernética aplicada poderá contribuir para reduzir a profundidade do fosso tecnológico#footnote[_O leitor deve estar lembrado da dramática advertência de Servan Shriber em "O Desafio Americano", feita há quase duas décadas. O "technological gap" brasileiro, no campo da informática, aprofundou-se mais ainda!_] que nos separa dos países do primeiro mundo no campo da administração industrial — repetimos palavras contidas na sua apresentação, por considerar que, neste momento, a mensagem que elas pretendem transmitir é muito oportuna.

O primeiro congresso internacional de cibernética realizou-se em Estocolmo, há pouco mais de duas décadas. Apesar de ser, como já dissemos, uma ciência nova, seus efeitos práticos, particularmente no campo da administração industrial, são, inegavelmente, notáveis. Infelizmente, no Brasil, a cibernética tem pouca divulgação, não faz parte das disciplinas curriculares de cursos de administração, economia, ciências contábeis ou engenharia. Talvez, por essa razão, aliada a uma certa dose de resistência à mudança, alguns céticos das possibilidades da cibernética objetem, ao concluir a leitura desta obra, tratar-se-á de mais um "sonho de uma noite de verão".

A estes, respondo com as palavras do mercenário idealista de Laterguy: "há muito sonho no homem de ação, e muita ação no homem que sonha..."
