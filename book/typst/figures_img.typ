// Figuras do livro — imagens originais do scan de 1982
// Cada função renderiza a imagem original com legenda

#let fig(path, caption) = {
  figure(
    image(path, width: 85%),
    caption: caption,
  )
}

#let figura-1()  = fig("figures/fig_page_044.jpg", [Classificação Arbitrária de Stafford Beer])
#let figura-2()  = fig("figures/fig_page_047.jpg", [Organograma de uma pequena empresa])
#let figura-3()  = fig("figures/fig_page_059.jpg", [Organograma da Empresa com órgão de Pesquisa])
#let figura-4()  = fig("figures/fig_page_062.jpg", [Praxeograma Operatório])
#let figura-5()  = fig("figures/fig_page_067.jpg", [Praxeograma Operatório do Novo Sistema])
#let figura-6()  = fig("figures/fig_page_072.jpg", [Entropia × Energia / Ordem × Desordem])
#let figura-7()  = fig("figures/fig_page_075.jpg", [Modelo isomórfico do sistema fechado — Condição inicial C₁])
#let figura-8()  = fig("figures/fig_page_076.jpg", [Sequência de transições C₂ → C₃ → C₄ → C₅])
#let figura-9()  = fig("figures/fig_page_080.jpg", [Quadro de Operações Lógicas do Sistema])
#let figura-10() = fig("figures/fig_page_082.jpg", [Praxeograma Operatório do Sistema — Decisões Binárias])
#let figura-11() = fig("figures/fig_page_093.jpg", [Modelo Cibernético (simplificado) de Administração Industrial])
#let figura-12() = fig("figures/fig_page_111.jpg", [1º Nível de Pilotagem — OPERAÇÃO])
#let figura-13() = fig("figures/fig_page_115.jpg", [2º Nível de Pilotagem — GESTÃO])
#let figura-14() = fig("figures/fig_page_117.jpg", [Organograma da Empresa com CONTROLLER])
#let figura-15() = fig("figures/fig_page_121.jpg", [Modelo Departamental de Gestão])
#let figura-16() = fig("figures/fig_page_126.jpg", [Curva do Conhecimento Humano])
#let figura-17() = fig("figures/fig_page_128.jpg", [Quadro de Fayol — Capacidades do pessoal técnico])
#let figura-18() = fig("figures/fig_page_130.jpg", [O Modelo Evoluído])
#let figura-19() = fig("figures/fig_page_133.jpg", [3º Nível de Pilotagem — EVOLUÇÃO])
#let figura-20() = fig("figures/fig_page_139.jpg", [Sensório Cibernético])
#let figura-21() = fig("figures/fig_page_145.jpg", [Esquema de ultra-estabilidade de Ashby])
#let figura-22() = fig("figures/fig_page_149.jpg", [4º Nível de Pilotagem — MUTAÇÃO])
#let figura-23() = fig("figures/fig_page_157.jpg", [Modelo Neurofisiológico Cibernético])
#let figura-24() = fig("figures/fig_page_165.jpg", [Correspondência: Modelo Neurofisiológico × Empresa])
#let figura-25() = fig("figures/fig_page_199.jpg", [Organograma simplificado da ALPHA])
#let figura-26() = fig("figures/fig_page_202.jpg", [Grafo das atividades de Planejamento da Produção])
#let figura-27() = fig("figures/fig_page_212.jpg", [Grafo das atividades de Programação e Controle da Produção])
#let figura-28() = fig("figures/fig_page_217.jpg", [Orçamento colunar flexível da ALPHA])
#let figura-29() = fig("figures/fig_page_219.jpg", [Gráfico de sinergia e oscilação])
