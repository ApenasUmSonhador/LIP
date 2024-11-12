/* Autor: Arthur Vinicius Carneiro Nunes */

/* (1.1) 
    Ele inicia o texto explicando como inicializar pelo cmd nosso ambiente de desenvolvimento,
    confesso ainda estar confuso sobre comoo utilizar outros editores de código para rodar o oz,
    mas, sinceramente, por enquanto, não vejo necessidade de mudar Emacs.

    Nos é introduzido a palavra reservada "Browse" que é utilizada para visualizar o valor de uma variável.
*/
{Browse 9999* 9999} /* -> 99980001 */

/* Como não sou bobo nem nada, corri para realizar o famoso "Hello World" e, para minha surpresa, obtive erros. */
{Browse "Hello World"} /* -> [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100] */

/* Aparentemente, o Browse não é capaz de imprimir strings, mas sim, seus valores ASCII.
    Mudei de aspas duplas para aspas simples e obtive o "resultado esperado": */
{Browse 'Hello World'} /* -> 'Hello World' */

/*  Aparentemente ao utilizar as aspas duplas eu transformo a "string" em uma cadeia de chars que serão lidos como ASCII...
    Apenas estou chutando isso, não vou me aprofundar no momento, há muito a ser lido.
    
    Algo interessante, a utilização de {...} é feita ao chamar funções e procedimentos
*/

/* (1.2)
    A declaração de variáveis deve ser realizada da seguinte maneira:
*/
declare /*(avisa que irá declarar algo) */
V = 9999 * 9999 /*(LETRA INICIAL MAIÚSCULA, se não há erro) */
{Browse V * V} /*-> 9996000599960001 */
/*  A variável fica armazenada em uma memoria do sistema que apelidaremos de "store"
    PS: Por já ter contato com o framework Vue.js, esse conceito já me soa familiar
        e será interessante explorá-lo
*/


/* (1.3) 
    Funções! Até  que enfim!
    Ele introduz  a palavra reservada "fun" e como utilizá-la, e o conceito de recursão, muito bacana!
    Declarei portanto minha primeira função em oz:
*/
declare
fun {Fact N} /* Iniciando sempre com maiúscula e logo em seguida seu parâmetro */
    if N == 0 then 1 else N* {Fact N-1} end
end
{Browse {Fact 10}} /* -> 3628800 */

/*  E aqui meu ambiente deu pau... não entendi o que estava fazendo de errado, afinal segui o livro
    Então reiniciei o ambiente e... foi...
    Que estressante kkk 
    
    Fiz os casos maiores e até mesmo a função de combinação:*/
declare
fun {Comb N K}
    {Fact N} div ({Fact K} * {Fact N-K})
end
{Browse {Comb 10 3}} /* -> 120 */

/* Por último, se é comentado muito por cima sobre funções abstratas... Nada de mais a acrescentar */

/* (1.4)
    Listas, achei interessante a abordagem de começar a contagem do 1, e pensei no seguinte quando me foi apresentado a "figure 1.1":
        Em Oz as listas funcionam como uma lista simplesmente encadeada, de maneira que, cada "nó" tem a informação de si e para quem liga, como a ideia de "cabeça e cauda":
            L = [ 1 2 3 4]
            L.1 -> Head: 1; Tail: [2 3 4]
            L.2 -> Head: 2; Tail: [3 4]
            L.3 -> Head: 3; Tail: [4]
            L.4 -> Head: 4; Tail: Null

        Lista vazia não é [], mas Null e suas separações não são feitas por virgula, mas por simples espaço.
*/

{Browse [5 6 7 8]} /* -> [5 6 7 8] */

/*
    Logo após, o próprio livro deixa claro que minha percepção está correta.
        "The notation [5 6 7 8] is a shortcut.A list is actually a chain of links, where each
        link contains two things: one list element and a reference to the rest of the chain.
        Lists are always created one element at a time, starting with nil and adding links"
*/
declare
    H=5
    T=[6 7 8]
{Browse H|T} /* -> [5 6 7 8] */

declare
L=[5 6 7 8]
{Browse L.1} /* -> 5 */
{Browse L.2} /* -> [6 7 8] */

declare
L=[5 6 7 8]
case L of H|T then {Browse H} {Browse T} end /* -> 5 [6 7 8] */

/*
    Aqui aprendi que o "case" é uma estrutura de controle que permite a execução de um bloco de código dependendo do valor de uma variável.
    A sintaxe é a seguinte:
        case <variável> of <valor> then <bloco de código> end
    E que o "|" é utilizado para separar a cabeça da cauda de uma lista
    Enfim temos o suficiente para fazer o triangulo de Pascal!
*/
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
    if N==1 then [1]
    else
    {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
    end
end

fun {ShiftLeft L}
    case L of H|T then
    H|{ShiftLeft T}
    else [0] end
end
fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2}
        end
        else nil end
end

{Browse{Pascal 20}} /* -> [1 19 171 969 3876 11628 27132
                            50388 75582 92378 92378
                            75582 50388 27132 11628 
                            3876 969 171 19 1]
                    */
/* Algo tão simples mas com uma sintaxe tão confusa que me levou tempo até entender o que eu mesmo estava fazendo */

/* (1.6 e 1.7)
    Otimizando!
*/
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
    if N < 1 then nil
    else
    if N==1 then [1]
    else L in
    L = {Pascal N-1} /* Não fazer a mesma operação 2 vezes! */
    {AddList {ShiftLeft L} {ShiftRight L}}
    end
end

fun {ShiftLeft L}
    case L of H|T then
    H|{ShiftLeft T}
    else [0] end
end
fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2}
        end
        else nil end
end

{Browse{Pascal 20}} /* -> [1 19 171 969 3876 11628 27132
                            50388 75582 92378 92378
                            75582 50388 27132 11628 
                            3876 969 171 19 1]
                    */
/* (1.9 e 1.10) 
    Nos é introduzido o conceito de Concorrencia, o que é muito bacana pois nos permite realizar tarefas simultaneamente:
*/

thread P in
    P={Pascal 30}
    {Browse P}
end
{Browse 99*99} /* Primeiro será printado 99*99 que é muito mais rapido que calcular pascal de 30, sendo as operações feitas simultaneamente */

/* (1.11)
    O livro nos introduz a um novo conceito, dataflow, que é uma forma de programação concorrente que permite a execução de tarefas simultaneamente porém ligadas por um fluxo de dados.
    A ideia de delay é introduzida, que é uma forma de atrasar a execução de um bloco de código.
*/
declare X in
    thread {Delay 10000} X=99 end
    {Browse start} {Browse X*X}

declare X in
    thread {Browse start} {Browse X*X} end
    {Delay 10000} X=99

/* Ele aguarda a variavel estar pronta para apresentar o resultado de X*X -> 99*99 
    Mas não dissecarei mais, terei mais calma para quando estivermos no capítulo 4
*/

/* (1.12) 
    Conceito bem básico...
    Não vi nada de mais nessa sessão, mas é importante para conhecer a sintaxe de celulas
*/
declare
C={NewCell 0}
    C:=@C+1 
{Browse @C}
/* A unica coisa interessante é que agora percebo que é impossivel "mexer na variavel" como 
    em algumas linguagens com o famoso C = C + 1... Ok*/
declare
C={NewCell 0}
fun {FastPascal N}
    C:=@C+1
    {GenericPascal Add N}
end
/* Achei interessante pois isso me deu uma epifania sobre armazernar esses conteúdos em uma lista,
    para que eu possa acessar depois sem ter que refazer calculos, exemplo, caso eu ja tenha
    feito o N = 10, vou buscar armazenar do 1 ao 10 num array e depois quando for fazer N superiores
    eu não começo o algoritmo do 1, mas do último feito (10) e continuo, melhorando a velocidade. */

/*(1.13)
    OBJETOS! ENFIM!
    Estava ansioso para ver como o Oz trabalha com esse paradigma e... Não me surpreendeu nem um pouco kk
    realmente faz todo o sentido a maneira com que ele trabalha, sendo até possível de ser previsto!
    Gostei bastante!
*/

declare
local C in
    C={NewCell 0}
    fun {Bump}
        C:=@C+1
        @C
    end
    fun {Read}
        @C
    end
end
{Browse {Bump}}
{Browse {Bump}}

/* Olha que lindo! Decidi brincar um pouco e fazer uma Estrutura de dados simples: */

declare
local Stack in
    Stack = {NewCell 0}
    fun 
    {Push X}
        Stack := X|@Stack
    end
    fun {Pop}
        case @Stack of H|T then
            Stack := T
            H
        else
            raise stack_is_empty end /* Aqui tive que caçar como lançar excessões, 
                                        mas muito simples também */
        end
    end
    fun {Top}
        case @Stack of H|T then
            H
        else
            raise stack_is_empty end
        end
    end
    fun {IsEmpty}
        @Stack == nil
    end
end

/* Sinto que brincarei mais em oz para implementar EDs (uma vez que estou fazendo
    essa disciplina este semestre) */
/* Os algoritmos dessa sessão continuam muito redundantes e chatos, mas mesmo assim necessários */
declare
    fun {FastPascal N}
    {Browse {Bump}}
    {GenericPascal Add N}
end

/*(1.14)
    CLASSES!
*/
declare
fun {NewCounter}
    C Bump Read in
        C={NewCell 0}
        fun {Bump}
            C:=@C+1
            @C
        end
        fun {Read}
            @C
    end
    counter(bump:Bump read:Read)
end

declare
Ctr1={NewCounter}
Ctr2={NewCounter}
{Browse {Ctr1.bump}}

/* Função que retorna funções... Pensei dessa maneira sobre o que li, achei interessante a abordagem
    embora não minta sentir saudades das simplicidades que o Java e afins me oferecem, sobre classes.
    Mas não vou julgar tão cedo, no capítulo 7 abordaremos melhor sobre */

/*(1.15)
    Bacana, estava refletindo sobre isso após a sessão (1.11) pois como eu iria garantir que
    tal thread terminará antes ou depois de uma outra? */
declare
C={NewCell 0}
thread
    C:=1
end
thread
    C:=2
end
/* Esse código é péssimo para o caso em que estou pensando pois, como garanto qual será o resultado 
    final?
    Para isso vem o Dataflow inclusive*/
declare
C={NewCell 0}
thread I in
    I=@C
    C:=I+1
end
thread J in
    J=@C
    C:=J+1
end
/* A pergunta feita, inclusive é repetida nos exercícios e já foi respondida por lá:
    o motivo é que por puro destino (sorte ou azar) ambas J e I puxaram o valor de C quando este era igual a 0, portanto 0+1 = 1 em ambos os casos atribuindo 1
*/
/* Portanto, essa sessão foi muito bacana por me dar um alerta de sobre o quanto devo me precaver
    com o caso de concorrências... Terei cuidado! */

/* (1.16) */
declare
C={NewCell 0}
L={NewLock}
thread
    lock L then I in
        I=@C
        C:=I+1
    end
end
thread
    lock L then J in
        J=@C
        C:=J+1
    end
end
/* Essa, enfim é uma das soluções para o problema anterior.
    Resposta para a pergunta:
    Se você não usar o mesmo bloqueio para ambos os threads, a intercalação entre suas operações em C
    poderá fazer com que ambos os threads leiam o mesmo valor e o incrementem de maneira não 
    coordenada, resultando em um resultado incorreto. Portanto, proteger ambos os corpos de thread com
    o mesmo bloqueio é crucial para evitar tal intercalação e garantir a sincronização correta. 
*/
/* Nessa sessão basicamente fiquei quieto e absorvi conhecimento... apenas... wow... */

/*(1.17) 
    Enfim chegamos ao fim, esse é um apanhado de o que ainda poderá ser visto no futuro... Nada
    de interessante que eu possa acrescentar.
*/